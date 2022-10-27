#!/usr/env/bash

# This quick script preps a RHEL environment for a podman and docker-compose use case of elastic

# configure vm.max_map_count for elastic
sudo sysctl -w vm.max_map_count=262144

#add vm.max_map_count=262144 to /etc/sysctl.conf to persist after a reboot
sudo echo "vm.max_map_count=262144" >> /etc/sysctl.conf

sudo dnf update -y
sudo dnf install yum-utils docker-ce containerd.io docker-ce-cli -y
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

#start docker

sudo systemctl enable docker
sudo systemctl start docker


# Open ports for Kibana and Elasticsearch in firewall
sudo firewall-cmd --add-port=5601/tcp --perma
sudo firewall-cmd --add-port=9200/tcp --perma
sudo firewall-cmd --add-port=8220/tcp --perma
sudo firewall-cmd --reload


