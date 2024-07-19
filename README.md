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
- [9. Monitoring](#9-monitoring)
  - [9.1 Telegraf plugins](#91-telegraf-plugins)
  - [9.4 Monitor your server from your phone](#94-monitor-your-server-from-your-phone)

## 1. Introduction

Collection of tools for self hosting.

## 2. Getting started

This section covers how you can quickly get started with this stack and all the supported services.

Run the below commands:

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

Run the below commands to setup and install everything:

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
  - [Traefik](https://traefik.io/traefik/): `https://traefik.${DOMAIN}/dashboard`
- Remote Access
  - VPN
    - [Wireguard](https://www.wireguard.com/): `<ip-address>:51820`
  - Clientless Remote Desktop Gateway (SSH, RDP...)
    - [Apache Guacamole](https://guacamole.apache.org/): `https://guacamole.${DOMAIN}`
- Monitoring
  - Ad-blocker
    - [Pi-hole](https://pi-hole.net/): `https://pihole.${DOMAIN}`
  - Visualization Tool
    - [Grafana](https://grafana.com/): `https://grafana.${DOMAIN}`
  - Push Notifications
    - [ntfy](https://ntfy.sh/): `https://ntfy.${DOMAIN}`
  - Website Change Detection
    - [changedetection.io](https://changedetection.io/): `https://detection.${DOMAIN}`
- Backup
  - [Kopia](https://kopia.io/): `https://kopia.${DOMAIN}`
- Cloud Storage
  - Documents
    - [NextCloud](https://nextcloud.com/): `https://nextcloud.${DOMAIN}`
    - [Paperless](https://docs.paperless-ngx.com/): `https://paperless.${DOMAIN}`
  - Books
    - [Kavita](https://www.kavitareader.com): `https://library.${DOMAIN}`
    - [Librum](https://librumreader.com/) (no web-interface, need to install the desktop app as well)
  - Photos
    - [Immich](https://immich.app/): `https://pictures.${DOMAIN}`
    - [Photoprism](https://www.photoprism.app/): `https://photoprism.${DOMAIN}`
  - Music
    - [Navidrome](https://www.navidrome.org/): `https://music.${DOMAIN}`
  - Videos
    - [Jellyfin](https://jellyfin.org/): `https://jellyfin.${DOMAIN}`
- Personal Knowledge Management System
  - [Affine](https://affine.pro/): `https://affine.${DOMAIN}`
  - [Anytype](https://anytype.io/): `https://anytype.${DOMAIN}`
  - [Siyuan](https://b3log.org/siyuan/en/): `https://siyuan.${DOMAIN}`
- Password Manager
  - [Vaultwarden](https://github.com/dani-garcia/vaultwarden)
    - Administration dashboard: `https://vault.${DOMAIN}/admin`
    - Instance: `https://vault.${DOMAIN}`
- Bookmark Manager
  - [Linkace](https://www.linkace.org/): `https://linkace.${DOMAIN}`
- Finances
  - [Actual](https://actualbudget.com/): `https://finances.${DOMAIN}`
  - [Firefly-III](https://www.firefly-iii.org/): `https://firefly.${DOMAIN}`
  - [Maybe](https://github.com/maybe-finance/maybe): `https://maybe.${DOMAIN}`
- Home Resources Planning
  - [Grocy](https://grocy.info/): `https://grocy.${DOMAIN}`
- PDF Tools
  - [Docuseal](https://www.docuseal.co/): `https://doc.${DOMAIN}`
- Headless CMS
  - [Directus](https://directus.io/): `https://directus.${DOMAIN}`
- Survey Builder
  - [Limesurvey](https://www.limesurvey.org/): `https://survey.${DOMAIN}`
- Games
  - [Minecraft Server](https://docker-minecraft-server.readthedocs.io/en/latest/): `<ip-address>:25565`

## 8. Port Mapping

This section covers all the ports exposed to internet. Those are the ports that must be forwarded on the router to the server hosting all services.

- TCP
  - 80: Traefik HTTP
  - 443: Traefik HTTPS
  - 25565: Minecraft
- UDP
  - 25565: Minecraft
  - 51820: Wireguard

## 9. Monitoring

List of Data Sources that are currently implemented in this stack:

- InfluxDB, with Telegraf as an input integration
- Prometheus

> **Note**: it is necessary to create manually the UDP database named traefik in InfluxDB.

### 9.1 Telegraf plugins

Run the below command to test your configuration:

```bash
telegraf --config /etc/telegraf/telegraf.conf --test
```

Telegraf plugins being used:

- Default
  - [CPU](https://github.com/influxdata/telegraf/blob/master/plugins/inputs/cpu/README.md)
  - [Disk](https://github.com/influxdata/telegraf/blob/master/plugins/inputs/disk/README.md)
  - [Disk IO](https://github.com/influxdata/telegraf/blob/master/plugins/inputs/diskio/README.md)
  - [Kernel](https://github.com/influxdata/telegraf/blob/master/plugins/inputs/kernel/README.md)
  - [Mem](https://github.com/influxdata/telegraf/blob/master/plugins/inputs/mem/README.md)
  - [Processes](https://github.com/influxdata/telegraf/blob/master/plugins/inputs/processes/README.md)
  - [Swap](https://github.com/influxdata/telegraf/blob/master/plugins/inputs/swap/README.md)
  - [System](https://github.com/influxdata/telegraf/blob/master/plugins/inputs/system/README.md)
- Additionally enabled
  - [Docker](https://github.com/influxdata/telegraf/blob/master/plugins/inputs/docker/README.md)
  - [Filecount](https://github.com/influxdata/telegraf/blob/master/plugins/inputs/filecount/README.md)
  - [Internet Speed Monitor](https://github.com/influxdata/telegraf/blob/master/plugins/inputs/internet_speed/README.md)
  - [Net](https://github.com/influxdata/telegraf/blob/master/plugins/inputs/net/README.md)
  - [Netstat](https://github.com/influxdata/telegraf/blob/master/plugins/inputs/netstat/README.md)
  - [OpenWeatherMap](https://github.com/influxdata/telegraf/blob/master/plugins/inputs/openweathermap/README.md)
  - [Telegraf itself](https://github.com/influxdata/telegraf/blob/master/plugins/inputs/internal/README.md)
  - [Wireguard](https://github.com/influxdata/telegraf/blob/master/plugins/inputs/wireguard/README.md)

### 9.4 Monitor your server from your phone

Since I am an iPhone user, this section covers the list of steps on iOS only.

1. Install the [Glimpse 2](https://apps.apple.com/us/app/glimpse-2/id1524217845) app from the App Store.
2. Wrap your Grafana instance website on your iOS screen via Widgets.

