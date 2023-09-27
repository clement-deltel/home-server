# Home Server <!-- omit in toc -->

## Table of Contents <!-- omit in toc -->

- [1. Introduction](#1-introduction)
- [2. Getting started](#2-getting-started)
- [3. Hardware](#3-hardware)
- [4. Domain Name](#4-domain-name)
- [5. Operating System](#5-operating-system)
- [6. Services](#6-services)
- [7. Port Mapping](#7-port-mapping)
- [8. Security notes](#8-security-notes)

## 1. Introduction

Collection of tools for self hosting.

## 2. Getting started

Run the following commands:

```bash
cd /opt
sudo chown ubuntu:ubuntu .
sudo apt update -y && apt install -y git
git clone https://github.com/clement-deltel/home-server.git
```

Edit the following files to your liking:

- /home-server/ansible/install.sh: SERVER_HOME variable
- /home-server/ansible/playbooks/vars/main.yml
- /home-server/env/template.env

Run the commands below to setup and install everything:

```bash
mv ${SERVER_HOME}/ansible/playbooks/vars/main.yml ${SERVER_HOME}/ansible/playbooks/vars/aws-cli.yml
mv ${SERVER_HOME}/env/template.env ${SERVER_HOME}/env/server.env
./home-server/ansible/install.sh
```

## 3. Hardware

## 4. Domain Name

## 5. Operating System

- Name: Ubuntu
- Version: 22.04

## 6. Services

- Reverse Proxy
  - [Traefik](services/traefik/README.md)
    - `https://traefik.${DOMAIN_NAME}/dashboard`
- Password Manager
  - [Bitwarden](services/bitwarden/README.md)
    - `https://bitwarden.${DOMAIN_NAME}`

## 7. Port Mapping

- TCP
  - 53: Pihole
  - 80: Traefik HTTP
  - 443: Traefik HTTPS
  - 3012: Bitwarden WebSocket
  - 8080: Traefik Dashboard
- UDP
  - 53: Pihole
