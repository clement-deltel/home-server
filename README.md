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

This section covers how you can quickly get started with this stack and all the supported services.

Run the following commands:

```bash
cd /opt
sudo chown ubuntu:ubuntu .
sudo apt update -y && sudo apt install -y git vim
git clone https://github.com/clement-deltel/home-server.git
cd home-server
```

Edit the following files to your liking:

- ansible/playbooks/vars/main_template.yml
- env/template.env

Run the commands below to setup and install everything:

```bash
mv ansible/playbooks/vars/main_template.yml ansible/playbooks/vars/main.yml
mv env/.env.template env/.env
cd ansible
chmod +x install.sh run.sh
./install.sh
```

Run all services:

```bash
sudo su - docker
${SERVER_HOME}/ansible/run.sh
```

## 3. Hardware

This section covers the detail of the hardware I chose to build my home server.

- CPU
  - Brand: AMD
  - Model: Ryzen 5 3600
  - Cores: 6
  - Threads: 12
  - Type: Desktop Processor
- RAM Memory
  - Brand: Corsair
  - Model: Vengeance LPX Black
  - Quantity: 16GB (2x8GB)
  - Technology: DDR4 DRAM
  - Frequency: 3200MHz
  - CAS: C16
- GPU
  - Brand: NVIDIA
  - Model: GTX 980
  - Video Memory: 4GB
- Storage
  - SSD (would be nice to upgrade for a NVMe SSD):
    - Brand: Crucial
    - Model: MX300
    - Capacity: 1TB
    - Type: M.2 (2280) SATA III
  - Disks 1&2:
    - Brand: Seagate
    - Model: IronWolf
    - Capacity: 4TB
    - Type: NAS Internal Hard Drive HDD
    - Size: 3.5 Inch
    - Speed: SATA 6Gb/s 5900 RPM
    - Cache: 64MB
    - Use Case: RAID Network Attached Storage
- Motherboard
  - Brand: Asus
  - Model: Prime B450M-A/CSM
  - Chipset: B450
  - CPU socket: AMD Ryzen 2 AM4
  - Memory compatibility: DDR4
  - Ports: HDMI, DVI, VGA, M.2, USB 3.1 Gen2
  - Format: mATX
- Power Supply
  - Brand: Corsair
  - Model: RM 550x
  - Power: 550W
  - Rating: 80 Plus Gold
- Water Liquid Cooling
  - Brand: Corsair
  - Model: H105
  - Size: 240mm
- Fans
  - Brand: beQuiet!
  - Model: Shadow Wings
  - Size: 120mm, 140mm
- Case
  - Brand: darkFlash
  - Model: DLM21 White Mini Tower
  - ATX Compatibility: Micro ATX, Mini ITX


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
