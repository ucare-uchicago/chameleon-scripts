#!/usr/bin/python


from blazarclient import client as blazar_client
from keystoneclient import client as keystone

import datetime
import logging
import os
import time
import yaml

CONFIG_FILE = 'reservation.yaml'

def lease_is_reusable(lease):
    return lease['action'] == 'START' or lease['action'] == 'CREATE'


def lease_is_running(lease):
    return lease['action'] == 'START' and lease['status'] == 'COMPLETE'


def lease_is_terminated(lease):
    return lease['action'] == 'STOP'


def lease_to_s(lease):
    return "[id=%s, name=%s, start=%s, end=%s, action=%s, status=%s]" % (
        lease['id'],
        lease['name'],
        lease['start_date'],
        lease['end_date'],
        lease['action'],
        lease['status'])


def create_blazar_client(config):
    """Check the reservation, creates a new one if nescessary."""

    kclient = keystone.Client(
        auth_url=os.environ["OS_AUTH_URL"],
        username=os.environ["OS_USERNAME"],
        password=os.environ["OS_PASSWORD"],
        tenant_id=os.environ["OS_TENANT_ID"])

    auth = kclient.authenticate()
    if auth:
        blazar_url = kclient.service_catalog.url_for(
            service_type='reservation')
    else:
        raise Exception("User *%s* is not authorized." %
                os.environ["OS_USERNAME"])

    # let the version by default
    return blazar_client.Client(blazar_url=blazar_url,
            auth_token=kclient.auth_token)


def get_reservation(bclient, config):
    leases = bclient.lease.list()
    lease_name = config['provider']['lease_name']
    leases = [l for l in leases if l["name"] == lease_name]
    if len(leases) >= 1:
        lease = leases[0]
        if lease_is_reusable(lease):
            logging.info("Reusing lease %s" % lease_to_s(lease))
            return lease
        elif lease_is_terminated(lease):
            logging.warning("%s is terminated, destroy it" % lease_to_s(lease))
            return lease
        else:
            logging.error("Error with %s" % lease_to_s(lease))
            raise Exception("lease_error")
    else:
        return None


def create_reservation(bclient, config):
    # NOTE(msimonin): This implies that
    #  * UTC is used
    #  * we don't support yet in advance reservation
    resources = config['resources']
    start_datetime = datetime.datetime.utcnow()
    w = config['provider']['walltime'].split(':')
    delta = datetime.timedelta(hours=int(w[0]),
                               minutes=int(w[1]),
                               seconds=int(w[2]))
    # Make sure we're not reserving in the past by adding 1 minute
    # This should be rare
    start_datetime = start_datetime + datetime.timedelta(minutes=1)
    end_datetime = start_datetime + delta
    start_date = start_datetime.strftime('%Y-%m-%d %H:%M')
    end_date = end_datetime.strftime('%Y-%m-%d %H:%M')
    logging.info("[blazar]: Claiming a lease start_date=%s, end_date=%s",
                 start_date,
                 end_date)

    reservations = []
    for host_type, roles in resources.items():
        total = sum(roles.values())
        resource_properties = "[\"=\", \"$node_type\", \"%s\"]" % host_type
        reservations.append({
            "min": total,
            "max": total,
            "resource_properties": resource_properties,
            "resource_type": "physical:host",
            "hypervisor_properties": ""
            })

    lease = bclient.lease.create(
        config['provider']['lease_name'],
        start_date,
        end_date,
        reservations,
        [])
    return lease


def wait_reservation(bclient, lease):
    logging.info("[blazar]: Waiting for %s to start" % lease_to_s(lease))
    l = bclient.lease.get(lease['id'])
    while(not lease_is_running(l)):
        time.sleep(10)
        l = bclient.lease.get(lease['id'])
        logging.info("[blazar]: Waiting for %s to start" % lease_to_s(l))
    logging.info("[blazar]: Starting %s" % lease_to_s(l))
    return l


def check_reservation(config):
    bclient = create_blazar_client(config)
    lease = get_reservation(bclient, config)
    if lease is None:
        lease = create_reservation(bclient, config)
    wait_reservation(bclient, lease)
    return lease


def main():
    config = None
    with open(CONFIG_FILE, 'r') as f:
        config = yaml.load(f)
#    print config['provider']
    lease = check_reservation(config)
    print lease


if __name__ == '__main__':
    logging.basicConfig(level=logging.DEBUG)
    main()
