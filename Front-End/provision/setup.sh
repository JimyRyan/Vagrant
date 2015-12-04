#!/bin/bash

echo "Fix bugs..."
sed -i 's/^tty -s \&\& mesg n$/mesg n/g' /root/.profile
sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

echo "Set locales..."
locale-gen fr_FR.UTF-8 > /dev/null 2>&1
update-locale LANG=fr_FR.UTF-8 LANGUAGE=fr_FR.UTF-8 LC_ALL=fr_FR.UTF-8 > /dev/null 2>&1
echo 'Europe/Paris' > /etc/timezone 
rm /etc/localtime > /dev/null 2>&1
ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime

echo "Disable IPv6..."
printf "# IPv6 disabled\nnet.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1\nnet.ipv6.conf.lo.disable_ipv6 = 1" > /etc/sysctl.d/10-disable-ipv6.conf

echo "Add apt repository..."
apt-get install python-software-properties -y > /dev/null 2>&1

echo "Update VM..."
apt-get update > /dev/null 2>&1
apt-get upgrade -y > /dev/null 2>&1
apt-get dist-upgrade -y > /dev/null 2>&1

echo "Install Git..."
apt-get install git -y > /dev/null 2>&1

echo "Install oh-my-zsh base..."
apt-get install zsh -y > /dev/null 2>&1
apt-get install python-pip -y > /dev/null 2>&1
pip install git+git://github.com/Lokaltog/powerline > /dev/null 2>&1

echo "Setup oh-my-zsh for root..."
curl -L http://install.ohmyz.sh | sh 
chsh -s $(which zsh) > /dev/null 2>&1
sed -i 's/^ZSH_THEME="robbyrussell"$/ZSH_THEME="agnoster"/g' ~/.zshrc > /dev/null 2>&1

echo "Install Java SDK..."
add-apt-repository ppa:webupd8team/java -y > /dev/null 2>&1
apt-get update > /dev/null 2>&1
echo 'debconf shared/accepted-oracle-license-v1-1 select true' | sudo debconf-set-selections
echo 'debconf shared/accepted-oracle-license-v1-1 seen true' | sudo debconf-set-selections
apt-get install oracle-java8-installer -y > /dev/null 2>&1
apt-get install oracle-java8-set-default -y > /dev/null 2>&1
sed -i '/^export JAVA_HOME="\/usr\/lib\/jvm\/java-8-oracle"$/d' ~/.zshrc > /dev/null 2>&1
echo 'export JAVA_HOME="/usr/lib/jvm/java-8-oracle"' >> ~/.zshrc
sed -i '/^export PATH=${PATH}:${JAVA_HOME}\/bin$/d' ~/.zshrc > /dev/null 2>&1
echo 'export PATH=${PATH}:${JAVA_HOME}/bin' >> ~/.zshrc
export JAVA_HOME="/usr/lib/jvm/java-8-oracle"
export PATH=${PATH}:${JAVA_HOME}

echo "Install node.js..."
apt-get install nodejs -y > /dev/null 2>&1
ln -s /usr/bin/nodejs /usr/bin/node > /dev/null 2>&1
apt-get install npm -y > /dev/null 2>&1