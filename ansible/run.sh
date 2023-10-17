#!/bin/bash

#==============================================================================#
#AUTHOR: Clement Deltel
#DATE: 2023/10/17
#DESCRIPTION: Run all services.
#USER: docker
#==============================================================================#

# Possible tags: up, restart, stop, down
ansible-playbook playbooks/docker.yml --tags up
