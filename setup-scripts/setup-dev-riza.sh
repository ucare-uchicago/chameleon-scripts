#!/bin/bash


### dev tools
sudo add-apt-repository ppa:openjdk-r/ppa -y
sudo apt-get update
sudo apt-get install -y git openjdk-7-jdk ant maven


### utillities
sudo apt-get install -y tmux htop colordiff iperf wget


### change shell to zsh
sudo apt-get install -y zsh
usermod --shell $(which zsh) cc


### setup environment
cat << EOF > /tmp/setup-dotfiles.sh
#!/usr/bin/env bash

cd ~/
git clone https://github.com/rizaon/dotfiles
cd dotfiles
git checkout emulab
./install
EOF
sudo -u cc bash /tmp/setup-dotfiles.sh


#### create local ssh key
cat << EOF > /tmp/install-ssh-key.sh
#!/usr/bin/env bash

cd ~/
mkdir .ssh
ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -P ""
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
EOF
sudo -u cc bash /tmp/install-ssh-key.sh

# disable host check for localhost
cat << EOF >> /home/cc/.ssh/config

Host localhost
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no

EOF
sudo chwon cc:cc /home/cc/.ssh/config

### install protobuf 2.5.0
cat << EOF > /tmp/install-protobuf.sh
#!/usr/bin/env bash

sudo apt-get install build-essential
git clone https://github.com/rizaon/protobuf.git /tmp/protobuf_install
cd /tmp/protobuf_install
git checkout 2.5.0-hadoop
./autogen.sh
./configure
make
make check
sudo make install
sudo ldconfig
protoc --version
EOF
sudo -u cc bash /tmp/install-protobuf.sh


### install Hadoop
cat << EOF > /tmp/install-hadoop.sh
#!/usr/bin/env bash

cd ~/
echo "Installing hadoop from ucare repository..."
mkdir hadoop-ucare
cd hadoop-ucare
git init
git config core.sparsecheckout true
git remote add ucare-github https://github.com/ucare-uchicago/hadoop.git
git pull ucare-github huanke210 --depth=10
git checkout huanke210

export MAVEN_OPTS="-Dhttps.protocols=TLSv1.2"
mvn clean package -Pdist -DskipTests

EOF
sudo -u cc bash /tmp/install-hadoop.sh

#### install psbin
cat << EOF > /tmp/install-psbin.sh
#!/usr/bin/env bash

cd ~/
git clone https://github.com/rizaon/psbin.git
cd psbin
git checkout dmck-cc
./install_scripts.sh

export PSBIN=\$(pwd)
source ./hadoop-rc.sh
cp \$PSBIN/hadoop-etc/templates/dmck-hack/* \$HADOOP_CONF_DIR/
./sed_replaceconf.sh
EOF
sudo -u cc bash /tmp/install-psbin.sh


#### misc
sudo -u cc mkdir /home/cc/jenkins

#### create backup user
sudo useradd -m -s /bin/bash riza
usermod -aG sudo riza
echo "riza ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers > /dev/null
sudo cp -r /home/cc/.ssh /home/riza/
sudo chown -R riza:riza /home/riza/.ssh

