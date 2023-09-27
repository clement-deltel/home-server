SERVER_HOME='/opt/home-server'
sudo apt install -y software-properties-common
sudo add-apt-repository -y --update ppa:ansible/ansible
sudo apt update -y
sudo apt install -y ansible

# Possible tags: init, update, docker

ansible-playbook -u ubuntu --ask-become-pass playbooks/ubuntu.yml --extra-vars server_home=${SERVER_HOME} --tags init

ansible-playbook -u docker --ask-become-pass playbooks/docker.yml --extra-vars server_home=${SERVER_HOME} --tags docker
