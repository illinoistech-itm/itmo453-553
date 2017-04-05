#!/bin/bash

# Listing 5.3.1
sudo yum install -y epel-release

sudo yum install collectd protobuf-c collectd-write_riemann

#copy the provided collectd.conf file overwritting the default collectd.conf
sudo mv ./collectd.conf /etc

#creating default location for colelctd plugins to be loaded
sudo mkdir /etc/collectd.d 

sudo systemctl enable collectd
sudo service collectd start
