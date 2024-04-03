# Home Server <!-- omit in toc -->

## Table of Contents <!-- omit in toc -->

- [1. Introduction](#1-introduction)
- [2. Getting started](#2-getting-started)
- [3. Hardware](#3-hardware)
- [4. RAID](#4-raid)
- [5. Domain Name](#5-domain-name)
- [6. Operating System](#6-operating-system)
- [7. Services](#7-services)
- [8. Port Mapping](#8-port-mapping)

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

## 4. RAID

Disks 1 and 2 are in RAID 1 for better fault tolerance and to avoid any data loss.

More information available at: [Wikipedia - Standard RAID Levels](https://en.wikipedia.org/wiki/Standard_RAID_levels).

## 5. Domain Name

Recommended registrars:
- [CloudFlare](https://www.cloudflare.com/products/registrar/)
- [OVH](https://www.ovhcloud.com/en/domains/)

## 6. Operating System

- Name: Ubuntu
- Version: 22.04 LTS

## 7. Services

This section covers all the supported services of the stack. It categorizes the services and provides the URL to access them, URL that depends on the root domain name.

- Reverse Proxy
  - Traefik: `https://traefik.${DOMAIN}/dashboard`
- Remote Access
  - VPN
    - Wireguard: `<ip-address>:51820`
  - Web-based Gateway (SSH, RDP...)
    - Apache Guacamole: `https://guacamole.${DOMAIN}`
- Monitoring
  - Ad-blocker
    - Pi-hole: `https://pihole.${DOMAIN}`
  - Visualization Tool
    - Grafana: `https://grafana.${DOMAIN}`
  - Notification Tool
    - ntfy: `https://ntfy.${DOMAIN}`
  - Website Change Detection
    - changedetection.io: `https://detection.${DOMAIN}`
- Cloud Storage
  - Documents
    - NextCloud: `https://nextcloud.${DOMAIN}`
    - Paperless: `https://paperless.${DOMAIN}`
    - Docuseal: `https://doc.${DOMAIN}`
  - Books
    - Librum (no web-interface, need to install the desktop app as well)
  - Photos
    - Immich: `https://pictures.${DOMAIN}`
    - Photoprism: `https://photoprism.${DOMAIN}`
  - Videos
    - Jellyfin: `https://jellyfin.${DOMAIN}`
- Password Manager
  - Vaultwarden
    - Administration dashboard: `https://vault.${DOMAIN}/admin`
    - Instance: `https://vault.${DOMAIN}`
  - Headless CMS
    - Directus: `https://directus.${DOMAIN}`
  - Backup solution
    - Kopia: `https://kopia.${DOMAIN}`
- Finances
  - Actual: `https://actual.${DOMAIN}`
  - Firefly-III: `https://firefly.${DOMAIN}`
  - Maybe: `https://maybe.${DOMAIN}`
- Home Resources Planning
  - Grocy: `https://grocy.${DOMAIN}`
- Survey Builder
  - Limesurvey: `https://survey.${DOMAIN}`
- Games
  - Minecraft Server: `<ip-address>:25565`

## 8. Port Mapping

This section covers all the ports exposed to internet. Those are the ports that must be forwarded on the router to the server hosting all services.

- TCP
  - 80: Traefik HTTP
  - 443: Traefik HTTPS
  - 25565: Minecraft
- UDP
  - 25565: Minecraft
  - 51820: Wireguard
