#!/usr/env/bash

# This quick script preps a RHEL environment for a podman and docker-compose use case of elastic

# configure vm.max_map_count for elastic
sudo sysctl -w vm.max_map_count=262144

#add vm.max_map_count=262144 to /etc/sysctl.conf to persist after a reboot
sudo echo "vm.max_map_count=262144" >> /etc/sysctl.conf

sudo dnf update -y
sudo dnf install podman-docker podman git dnsmasq cmake go -y

sudo systemctl enable podman
sudo systemctl enable podman.socket
sudo systemctl start podman

# After ver 3.0 of podman the podman.sock is linked to /var/run/docker.sock which docker-compose requires to be present 
sudo systemctl start podman.socket

#Install dnsname plugin for podman container name resolution
cd ~
git clone https://github.com/containers/dnsname
cd dnsname/
make PREFIX=/usr
sudo make install PREFIX=/usr

# Open ports for Kibana and Elasticsearch in firewall
sudo firewall-cmd --add-port=5601/tcp --perma
sudo firewall-cmd --add-port=9200/tcp --perma
sudo firewall-cmd --add-port=8220/tcp --perma
sudo firewall-cmd --reload


