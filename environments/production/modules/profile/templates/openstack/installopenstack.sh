#!/bin/sh
sudo systemctl disable firewalld ; \
sudo systemctl stop firewalld ; \
sudo systemctl disable NetworkManager ; \
sudo systemctl stop NetworkManager ; \
sudo systemctl enable network ; \
sudo systemctl start network ; \
sudo yum -y  update ; \
sudo yum install yum-utils -y ; \
sudo yum install -y centos-release-openstack-queens ; \
sudo yum -y  update ; \
sudo yum install -y openstack-packstack ; \
packstack --allinone
