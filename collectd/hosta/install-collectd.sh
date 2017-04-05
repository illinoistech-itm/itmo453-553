#!/bin/bash
set +x
set +e

# Listing 5.3.1 
sudo sudo add-apt-repository ppa:collectd/collectd-5.5

sudo apt-get update
sudo apt-get -y install collectd

#copy the provided collectd.conf file overwritting the default collectd.conf
sudo cp ./collectd.conf /etc/collectd/

#Copying the provided and configured collectd.d default plugins to be loaded
sudo cp -r ./collectd.d /etc/

sudo update-rc.d collectd defaults
sudo service collectd start