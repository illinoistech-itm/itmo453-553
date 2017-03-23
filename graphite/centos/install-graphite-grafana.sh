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

#Listing 4.20: Yum repository definition for Grafana - this will out put this text and then insert it into  grafana.repo
cat << EOT >> ./grafana.repo
[grafana] 
name=grafana 
baseurl=https://packagecloud.io/grafana/stable/el/7/$basearch 
repo_gpgcheck=1 
enabled=1 
gpgcheck=1 
gpgkey=https://packagecloud.io/gpg.key https://grafanarel.s3.amazonaws.com/RPM-GPG-KEY-grafana 
sslverify=1 
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOT

sudo mv ./grafana.repo /etc/yum.repos.d/grafana.repo

