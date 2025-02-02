#!/bin/bash

#==============================================================================#
#DESCRIPTION: Initialize the system just with curl installed as a pre-requisite.
#==============================================================================#

#==============================================================================#
#FUNCTION: install_dependencies
#DESCRIPTION: Install pre-requisites on the system.
#==============================================================================#
function install_dependencies(){
  echo "[INFO] Installing dependencies: curl, git..."
  sudo apt update -y
  sudo apt install -y curl git
}

#==============================================================================#
#FUNCTION: install_ansible
#DESCRIPTION: Install ansible on the system.
#==============================================================================#
function install_ansible(){
  echo "[INFO] Installing Ansible..."
  sudo apt update -y
  sudo apt install -y software-properties-common
  sudo add-apt-repository -y --update ppa:ansible/ansible
  sudo apt install -y ansible
}

#==============================================================================#
#FUNCTION: clone_repository
#DESCRIPTION: Clone repository on the system.
#==============================================================================#
function clone_repository(){
  echo "[INFO] Cloning 'home-server' repository onto the system..."
  sudo chown ubuntu:ubuntu /opt
  git clone https://github.com/clement-deltel/home-server.git /opt/home-server
}

#==============================================================================#
#FUNCTION: run_playbooks
#DESCRIPTION: Run ansible playbooks on the system.
#==============================================================================#
function run_playbooks(){
  echo "[INFO] Running Ansible Playbooks..."
  cd /opt/home-server/ansible
  ansible-playbook --become --connection local --inventory "localhost," --tags init ubuntu.yml
  ansible-playbook --become --connection local --inventory "localhost," --tags clean ubuntu.yml
}

#==============================================================================#
#FUNCTION: main
#==============================================================================#
function main(){
  set -e # -e: exit on error

  install_dependencies
  install_ansible
  clone_repository
  # run_playbooks
}

main $@
