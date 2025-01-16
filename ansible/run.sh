#!/bin/bash

#==============================================================================#
#AUTHOR: Clement Deltel
#DATE: 2023/10/17
#DESCRIPTION: Run all services.
#USER: docker
#==============================================================================#

# Possible tags: up, restart, stop, down
ansible-playbook --ask-become-pass --become --connection local --inventory "localhost," --tags up docker.yml
