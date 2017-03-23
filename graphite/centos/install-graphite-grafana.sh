#!/bin/bash
set +x
set +e

# Listing 4.3 Setting up dependencies, stalling EPEL repo
sudo yum install -y epel-release
sudo yum install -y python-setuptools

# Listing 4.5 Installing Graphite Packages
sudo yum install -y python-whisper python-carbon

# Listing 4.6: Creating new Graphite user and group on RedHat
sudo groupadd _graphite
sudo useradd -c "Carbon daemons" -g _graphite -d /var/lib/graphite -M -s /sbin/nologin _graphite

# Listing 4.7: Moving the /var/lib/carbon directory
sudo mv /var/lib/carbon /var/lib/graphite
sudo chown -R _graphite:_graphite /var/lib/graphite

# Listing 4.8: Changing the ownership of /var/log/carbon
sudo chown -R _graphite:_graphite /var/log/carbon
# Listing 4.9: Removing the carbon user
sudo userdel carbon

# Listing 4.14: Install Graphite-API prerequisite packages on RedHat
sudo yum install -y python-pip gcc libffi-devel cairo-devel libtool libyaml-devel python-devel

# Listing 4.15: Installing Graphite-API via pip
sudo pip install -U six pyparsing websocket urllib3 
sudo pip install graphite-api gunicorn

