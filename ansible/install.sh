
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y software-properties-common
sudo add-apt-repository -y --update ppa:ansible/ansible
sudo apt update -y
sudo apt install -y ansible

# Possible tags: init, update, docker, up, restart, stop, down

ansible-playbook playbooks/ubuntu.yml --tags init --ask-become-pass
ansible-playbook playbooks/docker.yml --tags docker

# Boot all services
# Switching to the docker user is required to run the commands below
# ansible-playbook playbooks/docker.yml --tags up
