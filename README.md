# Home Server <!-- omit in toc -->

Collection of self hosted services for my home server setup.

## Table of Contents <!-- omit in toc -->

- [Pre-requisites](#pre-requisites)
- [Getting Started](#getting-started)
- [Hardware](#hardware)
- [RAID](#raid)
- [Domain Name](#domain-name)
- [Port Mapping](#port-mapping)
- [Operating System](#operating-system)
- [Services](#services)
- [Secrets Management](#secrets-management)
- [Observability](#observability)
  - [Metrics](#metrics)
    - [Docker](#docker)
    - [Telegraf](#telegraf)
    - [Prometheus](#prometheus)
    - [Other](#other)
  - [Logs](#logs)
  - [Visualization](#visualization)
    - [Grafana](#grafana)
    - [Monitor your server from your phone](#monitor-your-server-from-your-phone)
## Pre-requisites

Here is a non-exhaustive list of tasks to perform prior deploying the stack:

- Purchase the server hardware (refer to the [Hardware](#hardware) section more details)
- Purchase a domain (refer to the [Domain Name](#domain-name) section for more details)
- Build the server, optionally with RAID support (refer to the [RAID](#raid) section for more details)
- Configure port forwarding on your router (refer to the [Port Mapping](#port-mapping) section for more details)
- Install the operating system of your choice on your server (refer to the [Operating System](#operating-system) section for more details)

Create the account below:

- AWS account (see [AWS set up tutorial](https://docs.aws.amazon.com/streams/latest/dev/setting-up.html) for more details)

I use the below AWS services:

- **S3**: perform regular off-site backups of my services to a dedicated bucket
- **SES**: send services-related emails to my users

## Getting Started

1. Export required environment variables:

```bash
export GITHUB_USERNAME=clement-deltel
export SERVER_ROOT='/opt'
```

2. Install dependencies and run installation script:

```bash
sudo apt update -y && sudo apt install -y curl
curl -fLSs https://raw.githubusercontent.com/${GITHUB_USERNAME}/home-server/refs/heads/main/docker/install.sh | bash
```

3. After pulling and configuring the home-server, the script install ansible, and then run playbooks.
4. Ansible playbooks automatically install and configure the tools listed below:
    - Packages Managers
      - apt
        - [argon2](https://github.com/P-H-C/phc-winner-argon2)
        - [htop](https://github.com/htop-dev/htop): interactive process viewer.
        - [lm-sensors](https://github.com/lm-sensors/lm-sensors)
        - [nvme-cli](https://github.com/linux-nvme/nvme-cli)
        - pwgen
        - [smartmontools](https://github.com/smartmontools/smartmontools)
        - [vim](https://github.com/vim/vim)
        - [wireguard](https://github.com/WireGuard/wireguard-linux)
      - [homebrew](https://github.com/Homebrew/brew): the missing package manager for Linux.
        - [btop](https://github.com/aristocratos/btop): monitor of resources.
        - [lazydocker](https://github.com/jesseduffield/lazydocker): lazier way to manage everything Docker.
        - [lazygit](https://github.com/jesseduffield/lazygit): simple terminal UI for git commands.
        - [lnav](https://github.com/tstack/lnav): log file navigator.
        - [tldr](https://github.com/tldr-pages/tlrc): tldr client written in Rust.
    - Languages
      - Python
    - Orchestration
      - Docker
    - Infrastructure as Code (IaC)
      - [Terraform](https://github.com/hashicorp/terraform): safely and predictably create, change, and improve infrastructure.
    - Cloud
      - [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

5. Log in as the docker user and edit the configuration files:

- ansible/vars/main_template.yml
- env/.env.secret

Here are some guidelines on how to fill those configuration files:

- use pwgen for most of the credentials: `pwgen -cns 25 1`
  - **-c**: Include at least one capital letter in the password
  - **-n**: Include at least one number in the password
  - **-s**: Generate completely random passwords
  - **25**: password length
  - **1**: number of password generated
- specific use cases:
  - main_template.yml
  - .env.secret
    - **BYTESTASH_JWT_TOKEN**: use [jwt.io](https://jwt.io).
    - **BYTESTASH_JWT_SECRET**: run `pwgen -Ans 512 1`.
    - **ENCLOSED_JWT_SECRET**: run `pwgen -Ans 512 1`.
    - **ENCLOSED_USER_PASSWORD**: use [User Authentication Key Generator](https://docs.enclosed.cc/self-hosting/users-authentication-key-generator).
    - **FIREFLY_APP_KEY**: string of exactly 32 chars.
    - **FIREFLY_CRON_TOKEN**: string of exactly 32 chars.
    - **NAVIDROME_SPOTIFY_CLIENT_ID**: create a [Spotify](accounts.spotify.com/en/login) account and generate API credentials.
    - **NAVIDROME_SPOTIFY_CLIENT_SECRET**: create a [Spotify](accounts.spotify.com/en/login) account and generate API credentials.
    - **OPEN_WEBUI_OPENAI_API_KEY**: create a [Open AI](auth.openai.com/authorize) account and generate API credentials.
    - **RUSTDESK_PRIVATE_KEY**: run `openssl genpkey -algorithm Ed25519 -out private.key`.
    - **RUSTDESK_PUBLIC_KEY**: run `openssl pkey -in private.key -pubout -out public.key`.
    - **VAULTWARDEN_ADMIN_TOKEN**: run the command `echo -n "${VAULTWARDEN_ADMIN_PASSWORD}" | argon2 "$(openssl rand -base64 32)" -e -id -k 65540 -t 3 -p 4`.
    - **VAULTWARDEN_PUSH_ID**: follow guidelines [here](https://github.com/dani-garcia/vaultwarden/wiki/Enabling-Mobile-Client-push-notification).
    - **VAULTWARDEN_PUSH_KEY**: follow guidelines [here](https://github.com/dani-garcia/vaultwarden/wiki/Enabling-Mobile-Client-push-notification).
    - **WG_EASY_PASSWORD**: follow guidelines [here](https://github.com/wg-easy/wg-easy/blob/master/How_to_generate_an_bcrypt_hash.md).
    - **WG_WASY_PROMETHEUS_METRICS_PASSWORD**: follow guidelines [here](https://github.com/wg-easy/wg-easy/blob/master/How_to_generate_an_bcrypt_hash.md).

6. Configure Docker user and services:

```bash
mv ansible/vars/main_template.yml ansible/vars/main.yml
mv env/.env.template env/.env
ansible-playbook --connection local --inventory "localhost," --tags docker docker.yml
```

7. Start services:

```bash
# Possible tags: up, restart, stop, down
ansible-playbook --connection local --inventory "localhost," --tags up docker.yml
```

If you want to test this setup, you need to have Docker installed and then you can run the commands below:

```bash
# Use option --progress=plain to see steps in more details
docker build --build-arg GITHUB_USERNAME --build-arg SERVER_ROOT --file docker/Dockerfile --tag home-server docker
docker run --interactive --name home-server --tty --rm home-server
```

## Hardware

This section covers the detail of the hardware I chose to build my home server.

- **CPU**
  - Brand: AMD
  - Model: Ryzen 5 3600
  - Cores: 6
  - Threads: 12
- **RAM Memory**
  - Brand: Corsair
  - Model: Vengeance LPX Black
  - Quantity: 16GB (2x8GB)
  - Technology: DDR4 DRAM
  - Frequency: 3200MHz
  - CAS: C16
- **GPU**
  - Brand: NVIDIA
  - Model: GTX 980
  - Video Memory: 4GB
- **Storage**
  - Disk 0:
    - Brand: Crucial
    - Model: MX300
    - Capacity: 1TB
    - Type: M.2 SSD SATA III (would be nice to upgrade for a NVMe SSD)
    - Size: 2280 (22mm x 80mm)
    - Sequential Speed: reads/writes up to 530 / 510 MB/s
    - Random Speed: reads/writes up to 92K / 83K
    - Use Case: Operating System
  - Disks 1&2:
    - Brand: Seagate
    - Model: IronWolf
    - Capacity: 4TB
    - Type: NAS Hard Drive HDD
    - Size: 3.5 inches
    - Speed: SATA 6Gb/s 5900 RPM
    - Cache: 64MB
    - Use Case: RAID
- **Motherboard**
  - Brand: Asus
  - Model: Prime B450M-A/CSM
  - Chipset: B450
  - CPU socket: AMD Ryzen 2 AM4
  - Memory compatibility: DDR4
  - Ports: HDMI, DVI, VGA, M.2, USB 3.1 Gen2
  - Format: mATX
- **Power Supply**
  - Brand: Corsair
  - Model: RM 550x
  - Power: 550W
  - Rating: 80 Plus Gold
- **Water Liquid Cooling**
  - Brand: Corsair
  - Model: H105
  - Size: 240mm
- **Fans**
  - Brand: beQuiet!
  - Model: Shadow Wings
  - Quantity: 2, 3
  - Size: 120mm, 140mm
- **Case**
  - Brand: darkFlash
  - Model: DLM21 White Mini Tower
  - ATX Compatibility: Micro ATX, Mini ITX

## RAID

Disks 1 and 2 are in RAID 1 for better fault tolerance and to avoid any data loss.

More information available at: [Wikipedia - Standard RAID Levels](https://en.wikipedia.org/wiki/Standard_RAID_levels).

## Domain Name

Recommended registrars:

- [CloudFlare](https://www.cloudflare.com/products/registrar/)
- [OVH](https://www.ovhcloud.com/en/domains/)

## Port Mapping

This section covers all the ports exposed to internet. Those are the ports that must be forwarded on the router to the server hosting all services.

- **TCP**
  - **53**: Pihole
  - **80**: Traefik HTTP
  - **443**: Traefik HTTPS
  - **1514**: Wazuh
  - **1515**: Wazuh
  - **9200**: Wazuh Indexer
  - **21115**: ID Server - NAT type test
  - **21116**: ID Server - TCP hole punching
  - **21117**: Relay Server - Relay services
  - **21118**: RustDesk ID Server - Web client
  - **21119**: RustDesk Relay Server - Web client
  - **25565**: Minecraft
  - **55000**: Wazuh API
- **UDP**
  - **53**: Pihole
  - **514**: Wazuh
  - **21116**: ID Server - ID registration and heartbeat
  - **25565**: Minecraft
  - **51820**: Wireguard

## Operating System

- **Name**: Ubuntu
- **Version**: 22.04 LTS (Jammy Jellyfish)
- **LTS standard security maintenance**: until April 2027
- **Expanded security maintenance**: until April 2032
- **Legacy support**: until April 2034

## Services

This section covers all the supported services of the stack. It categorizes the services and provides the URL to access them (if any), URL that depends on the root domain name.

- **Reverse Proxy**
  - [Traefik](https://traefik.io/traefik/): `https://traefik.${DOMAIN}/dashboard`
- **Dashboard**
  - [Homarr](https://homarr.dev/): `https://home.${DOMAIN}`
- **Remote Access**
  - VPN
    - [Wireguard](https://www.wireguard.com/): `vpn.${DOMAIN}`
    - [Wireguard Easy](https://github.com/wg-easy/wg-easy): `vpn.${DOMAIN}`
  - Clientless Remote Desktop Gateway (SSH, RDP...)
    - [Apache Guacamole](https://guacamole.apache.org/): `https://guacamole.${DOMAIN}`
  - Remote Control Server
    - [RustDesk](https://rustdesk.com): `rustdesk.${DOMAIN}`
- **DNS**
  - Ad-blocker
    - [Pi-hole](https://pi-hole.net/): `https://pihole.${DOMAIN}`
  - Recursive DNS
    - [Unbound](https://www.nlnetlabs.nl/projects/unbound/about/)
- **Monitoring**
  - Visualization Tool
    - [Grafana](https://grafana.com/): `https://grafana.${DOMAIN}`
  - Push Notifications
    - [ntfy](https://ntfy.sh/): `https://ntfy.${DOMAIN}`
  - Website Change Detection
    - [changedetection.io](https://changedetection.io/): `https://detection.${DOMAIN}`
  - Flight Tracking
    - [Jetlog](https://github.com/pbogre/jetlog): `https://fly.${DOMAIN}`
- **Backup**
  - [Kopia](https://kopia.io/): `https://kopia.${DOMAIN}`
- **Security**
  - [Wazuh](https://wazuh.com): `https://seim.${DOMAIN}`
  - [Enclosed](https://github.com/CorentinTh/enclosed): `https://notes.${DOMAIN}`
- **Media Storage**
  - Documents
    - [NextCloud](https://nextcloud.com/): `https://nextcloud.${DOMAIN}`
    - [Paperless](https://docs.paperless-ngx.com/): `https://paperless.${DOMAIN}`
  - Books
    - [Kavita](https://www.kavitareader.com): `https://books.${DOMAIN}`
    - [Librum](https://librumreader.com/) (no web-interface, need to install the desktop app as well)
  - Photos
    - [Immich](https://immich.app/): `https://pictures.${DOMAIN}`
    - [Photoprism](https://www.photoprism.app/): `https://photoprism.${DOMAIN}`
  - Music
    - [Navidrome](https://www.navidrome.org/): `https://music.${DOMAIN}`
  - Videos
    - [Jellyfin](https://jellyfin.org/): `https://jellyfin.${DOMAIN}`
- **Media Sharing**
  - [Gokapi](https://github.com/Forceu/Gokapi): `https://share.${DOMAIN}`
- **Management**
  - Bookmarks
    - [Linkace](https://www.linkace.org/): `https://linkace.${DOMAIN}`
  - Code
    - [ByteStash](https://github.com/jordan-dalby/ByteStash): `https://snippets.${DOMAIN}`
    - [IT-Tools](https://github.com/CorentinTh/it-tools): `https://it-tools.${DOMAIN}`
  - Passwords
    - [Vaultwarden](https://github.com/dani-garcia/vaultwarden)
      - Administration dashboard: `https://vault.${DOMAIN}/admin`
      - Instance: `https://vault.${DOMAIN}`
  - Personal Knowledge Management System (PKMS)
    - [Affine](https://affine.pro/): `https://affine.${DOMAIN}`
    - [Anytype](https://anytype.io/): `https://anytype.${DOMAIN}`
    - [Siyuan](https://b3log.org/siyuan/en/): `https://siyuan.${DOMAIN}`
- **Artificial Intelligence**
  - [Open WebUI](https://openwebui.com): `https://ai.${DOMAIN}`
- **Finances**
  - [Actual](https://actualbudget.com/): `https://finances.${DOMAIN}`
  - [Firefly-III](https://www.firefly-iii.org/): `https://firefly.${DOMAIN}`
  - [Maybe](https://github.com/maybe-finance/maybe): `https://maybe.${DOMAIN}`
- **Home Resources Planning**
  - [Grocy](https://grocy.info/): `https://grocy.${DOMAIN}`
  - [HortusFox](https://hortusfox.github.io): `https://plants.${DOMAIN}`
- **PDF Tools**
  - [Docuseal](https://www.docuseal.co/): `https://doc.${DOMAIN}`
  - [Stirling-PDF](https://stirlingtools.com): `https://pdf.${DOMAIN}`
- **Headless CMS**
  - [Directus](https://directus.io/): `https://directus.${DOMAIN}`
- **Survey Builder**
  - [Limesurvey](https://www.limesurvey.org/): `https://survey.${DOMAIN}`
- **Wishlist**
  - [Wishlist](https://github.com/cmintey/wishlist): `https://wish.${DOMAIN}`
- **Games**
  - [Minecraft Server](https://docker-minecraft-server.readthedocs.io/en/latest/): `<ip-address>:25565`

## Observability

This section covers all the tools and logic implemented to have maximum visibility on what is happening on the server at any given time.

### Metrics

List of tools being used to collect metrics on this stack:

- Docker health checks
- Telegraf data collector
- Prometheus data collector

> **Note**: it is necessary to create manually the UDP database named traefik in InfluxDB.

#### Docker

**Health checks**:

Services with built-in health checks:

- Guacamole Daemon (guacd)
- Vaultwarden

Other:

- InfluxDB

```yaml
healthcheck:
  test: ["CMD-SHELL", "curl -f http://localhost:8086/ping"]
  interval: 20s
  timeout: 15s
  retries: 3
  start_period: 60s
  start_interval: 5s
```

- Jellyfin

```yaml
healthcheck:
  test: ["CMD-SHELL", "curl -i http://localhost:8096/health"]
  interval: 20s
  timeout: 15s
  retries: 3
  start_period: 60s
  start_interval: 10s
```

- MariaDB

```yaml
healthcheck:
  test: ["CMD-SHELL", "mysqladmin ping -h localhost -u <user> -p<password>"]
  interval: 20s
  timeout: 15s
  retries: 3
  start_period: 60s
  start_interval: 5s
```

- Ntfy

```yaml
healthcheck:
  test: ["CMD-SHELL", "wget -q --tries=1 http://localhost:80/v1/health -O - | grep -Eo '\"healthy\"\\s*:\\s*true' || exit 1"]
  interval: 20s
  timeout: 15s
  retries: 3
  start_period: 60s
  start_interval: 5s
```

- Paperless

```yaml
healthcheck:
  test: ["CMD-SHELL", "curl -f http://localhost:8000"]
  interval: 20s
  timeout: 15s
  retries: 3
  start_period: 60s
  start_interval: 5s
```

- Postgres

```yaml
healthcheck:
  test: ["CMD-SHELL", "pg_isready -U <user>"]
  interval: 20s
  timeout: 15s
  retries: 3
  start_period: 60s
  start_interval: 5s
```

- Redis

```yaml
healthcheck:
  test: ["CMD-SHELL", "redis-cli --raw INCR PING"]
  interval: 20s
  timeout: 15s
  retries: 3
  start_period: 60s
  start_interval: 5s
```

#### Telegraf

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



#### Prometheus
### Logs

List of docker compose configuration blocks to specify the amount of logs being collected based on the type of service:

- Main service:

```yaml
logging:
  driver: json-file
  options:
    max-file: 5
    max-size: 10m
```

- Database (MariaDB, PostgreSQL...):

```yaml
logging:
  driver: json-file
  options:
    max-file: 2
    max-size: 5m
```

- Cache (Redis):

```yaml
logging:
  driver: json-file
  options:
    max-file: 2
    max-size: 2m
```

- Other:

```yaml
logging:
  driver: json-file
  options:
    max-file: 2
    max-size: 2m
```

### Visualization

List of tools being used to visualize metrics on this stack:

- Grafana
- iOs app

#### Grafana

#### Monitor your server from your phone

Since I am an iPhone user, this section covers the list of steps on iOS only.

1. Install the [Glimpse 2](https://apps.apple.com/us/app/glimpse-2/id1524217845) app from the App Store.
2. Wrap your Grafana instance website on your iOS screen via Widgets.

## Security notes
