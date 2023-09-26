sudo apt update -y
sudo apt install -y software-properties-common
sudo add-apt-repository -y --update ppa:ansible/ansible
sudo apt update -y
sudo apt install -y ansible

ansible-playbook -u ubuntu --ask-become-pass playbooks/ubuntu.yml
