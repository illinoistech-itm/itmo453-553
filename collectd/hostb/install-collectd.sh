#!/bin/bash
set +x
set +e

# Listing 5.3.1
sudo yum install -y epel-release

sudo yum install collectd protobuf-c collectd-write_riemann

#copy the provided collectd.conf file overwritting the default collectd.conf
sudo cp ./collectd.conf /etc/

#Copying the provided and configured collectd.d default plugins to be loaded
sudo cp -r ./collectd.d /etc/

sudo systemctl enable collectd
sudo service collectd start
