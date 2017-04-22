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

# Listing4.19: Creating the Grafana Yum repository
# This will be populated by us so we can add the Centos repo so we can install it via yum
sudo touch /etc/yum.repos.d/grafana.repo

# P.138 - Listing 4.20: Yum repository definition for Grafana
# http://superuser.com/questions/351193/echo-multiple-lines-of-text-to-a-file-in-bash
# http://docs.grafana.org/installation/rpm/
cat > grafana.repo <<'EOT'
[grafana]
name=grafana
baseurl=https://packagecloud.io/grafana/stable/el/6/$basearch
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packagecloud.io/gpg.key https://grafanarel.s3.amazonaws.com/RPM-GPG-KEY-grafana
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt  
EOT

# NOTE Repace the 6 above with your RedHat version, for example 7 for RHEL 7.
cat ./grafana.repo | sudo tee -a /etc/yum.repos.d/grafana.repo

# Listing 4.21: Installing Grafana via Yum
sudo yum install grafana

# P.153 - Listing 4-39 - Create empty conf file to avoid error
sudo cp -v carbon.conf /etc/carbon
sudo touch /etc/carbon/storage-aggregation.conf

sudo cp -v storage-schemas.conf /etc/carbon

# Listing 4.50 move the carbon cache demon systemd service file
sudo cp -v carbon-cache@.service /lib/systemd/system/carbon-cache@.service

# Listing 4.51: Enabling and starting the systemd Carbon Cache daemons
sudo systemctl enable carbon-cache@1.service 
sudo systemctl enable carbon-cache@2.service
sudo systemctl start carbon-cache@1.service
sudo systemctl start carbon-cache@2.service

# Listing 4.52 move carbon-relay systemd demon service definition
sudo cp -v carbon-relay@.service /lib/systemd/system/carbon-relay@.service

# Listing 4.53: Enabling and starting the systemd Carbon relay daemon
sudo systemctl enable carbon-relay@1.service
sudo systemctl start carbon-relay@1.service

# Listing 4.54: Remove the old systemd unit files for Carbon
sudo rm -f /lib/systemd/system/carbon-relay.service
sudo rm -f /lib/systemd/system/carbon-cache.service

# P. 162 Copy the default graphite-api.yaml file overwritting the default one installed
sudo cp -v graphite-api.yaml /etc/graphite-api.yaml

# Listing 4.56: Creating the /var/lib/graphite/api_search_indexfile
sudo touch /var/lib/graphite/api_search_index
sudo chown _graphite:_graphite /var/lib/graphite/api_search_index

# Listing 4.58: Systemd script for Graphite-API
sudo cp -v graphite-api.service /lib/systemd/system/graphite-api.service

# Listing 4.60: Enabling and starting the systemd Graphite-API daemons
sudo systemctl enable graphite-api.service
sudo systemctl start graphite-api.service

# Starting Grafana
sudo service grafana-server start