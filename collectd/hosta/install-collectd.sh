#!/bin/bash

# Listing 5.3.1 
sudo sudo add-apt-repository ppa:collectd/collectd-5.5

sudo apt-get update
sudo apt-get -y install collectd

sudo update-rc.d collectd defaults
sudo service collectd start