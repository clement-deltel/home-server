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
#FUNCTION: install_bitwarden
#DESCRIPTION: Install Bitwarden CLI on the system.
#==============================================================================#
function install_bitwarden(){
  echo "[INFO] Getting Bitwarden CLI latest version..."
  export BW_VERSION=$(curl -H "Accept: application/vnd.github+json" https://api.github.com/repos/bitwarden/clients/releases | jq  -r 'sort_by(.published_at) | reverse | .[].name | select( index("CLI") )' | sed "s:.*CLI v::" | head -n 1)

  echo "[INFO] Installing Bitwarden CLI ${BW_VERSION}..."
  curl -L --remote-name "https://github.com/bitwarden/clients/releases/download/cli-v${BW_VERSION}/bw-linux-${BW_VERSION}.zip"
  sudo unzip -d /usr/local/bin -o bw-linux-*.zip
  sudo chmod +x /usr/local/bin/bw
  echo "[INFO] Bitwarden CLI successfully installed"

  rm -f bw-linux-*.zip
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
  sudo chown ubuntu:ubuntu ${SERVER_ROOT}
  git clone https://github.com/${GITHUB_USERNAME}/home-server.git ${SERVER_ROOT}/home-server
}

#==============================================================================#
#FUNCTION: run_playbooks
#DESCRIPTION: Run ansible playbooks on the system.
#==============================================================================#
function run_playbooks(){
  echo "[INFO] Running Ansible Playbooks..."
  cd ${SERVER_ROOT}/home-server/ansible
  ansible-playbook --become --connection local --inventory "localhost," --tags init ubuntu.yml
  ansible-playbook --become --connection local --inventory "localhost," --tags clean ubuntu.yml
}

#==============================================================================#
#FUNCTION: main
#==============================================================================#
function main(){
  set -e # -e: exit on error

  install_dependencies
  install_bitwarden
  install_ansible
  clone_repository
  # run_playbooks
}

main $@
