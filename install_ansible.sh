#!/bin/bash
sudo su
apt-get update -y
apt-get install ansible -y
export ANSIBLE_HOST_KEY_CHECKING=False