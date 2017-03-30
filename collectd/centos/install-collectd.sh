#!/bin/bash

# Listing 5.3.1
sudo yum install -y epel-release

sudo yum install collectd protobuf-c collectd-write_riemann

sudo systemctl enable collectd
sudo service collectd start

