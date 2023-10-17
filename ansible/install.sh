#!/bin/bash

#==============================================================================#
#AUTHOR: Clement Deltel
#DATE: 2023/10/17
#DESCRIPTION: Install all services and their requirements to run properly.
#USER: ubuntu
#==============================================================================#

sudo apt update -y && sudo apt upgrade -y
sudo apt install -y software-properties-common
sudo add-apt-repository -y --update ppa:ansible/ansible
sudo apt update -y
sudo apt install -y ansible

# Possible tags: init, update, docker
ansible-playbook playbooks/ubuntu.yml --tags init --ask-become-pass
ansible-playbook playbooks/docker.yml --tags docker
