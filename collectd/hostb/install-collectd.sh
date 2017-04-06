#!/bin/bash
set +x
set +e

# Listing 5.3.1
sudo yum install -y epel-release
# http://serverfault.com/questions/791236/how-do-i-install-stress-no-a-centos7-server
wget https://dl.fedoraproject.org/pub/epel/6/x86_64/stress-1.0.4-4.el6.x86_64.rpm
sudo rpm -ivh stress-1.0.4-4.el6.x86_64.rpm

sudo yum install collectd protobuf-c collectd-write_riemann

#copy the provided collectd.conf file overwritting the default collectd.conf
sudo cp ./collectd.conf /etc/

#Copying the provided and configured collectd.d default plugins to be loaded
sudo cp -r ./collectd.d /etc/

sudo systemctl enable collectd
sudo service collectd start
