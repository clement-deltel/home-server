sudo apt update -y
sudo apt install -y software-properties-common
sudo add-apt-repository -y --update ppa:ansible/ansible
sudo apt update -y
sudo apt install -y ansible

# Possible tags: init, update, docker

ansible-playbook -u ubuntu --ask-become-pass playbooks/ubuntu.yml --tags init
ansible-playbook -u docker --ask-become-pass playbooks/docker.yml --tags docker
