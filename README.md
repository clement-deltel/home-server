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
- [Security notes](#security-notes)
- [Future enhancements](#future-enhancements)

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
    - Security
      - [Bitwarden CLI](https://bitwarden.com/help/cli/)
    - Orchestration
      - Docker
    - Infrastructure as Code (IaC)
      - [Terraform](https://github.com/hashicorp/terraform): safely and predictably create, change, and improve infrastructure.
    - Cloud
      - [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

5. Log in as the Docker user and edit the configuration files:

- ansible/vars/secrets.yml
- env/secrets.env

Here are some guidelines on how to fill those configuration files:

- use pwgen for most of the credentials: `pwgen -cns 30 1`
  - **-c**: Include at least one capital letter in the password
  - **-n**: Include at least one number in the password
  - **-s**: Generate completely random passwords
  - **30**: password length
  - **1**: number of password generated
- specific use cases:
  - secrets.yml
    - **aws_\***: generate key pair for your AWS account.
    - **dyn_\***: enable dynamic DNS on your domain name registrar and retrieve the credentials.
    - **open_weather_map_api_key**: create an [OpenWeather](https://openweathermap.org) account and generate API credentials.
  - secrets.env
    - **BYTESTASH_JWT_TOKEN**: use [jwt.io](https://jwt.io).
    - **BYTESTASH_JWT_SECRET**: run `pwgen -Ans 512 1`.
    - **ENCLOSED_JWT_SECRET**: run `pwgen -Ans 512 1`.
    - **ENCLOSED_USER_PASSWORD**: use [User Authentication Key Generator](https://docs.enclosed.cc/self-hosting/users-authentication-key-generator).
    - **NAVIDROME_SPOTIFY_CLIENT_\***: create a [Spotify](accounts.spotify.com/en/login) account and generate API credentials.
    - **OPEN_WEBUI_OPENAI_API_KEY**: create a [Open AI](auth.openai.com/authorize) account and generate API credentials.
    - **RUSTDESK_PRIVATE_KEY**: run `openssl genpkey -algorithm Ed25519 -out private.key`.
    - **RUSTDESK_PUBLIC_KEY**: run `openssl pkey -in private.key -pubout -out public.key`.
    - **VAULTWARDEN_PUSH_\***: follow guidelines [here](https://github.com/dani-garcia/vaultwarden/wiki/Enabling-Mobile-Client-push-notification).
    - **WG_EASY\*_PASSWORD**: follow guidelines [here](https://github.com/wg-easy/wg-easy/blob/master/How_to_generate_an_bcrypt_hash.md).
  - cron.env
    - Variables in this env file should have the same value as in secrets.env, they are required for proper backup cronjobs execution

6. Run Docker user playbooks and apply Terraform configuration:

```bash
cd ${SERVER_HOME}
ansible-playbook --connection local --inventory "localhost," --tags docker ansible/docker.yml
terraform apply
```

7. Start services:

```bash
# Possible tags: up, restart, stop, down
ansible-playbook --connection local --inventory "localhost," --tags up docker.yml
```

8. After creating a Vaultwarden account, optionally move the secret files to the vault:

```bash
# bwload /path/to/file bw_item_name
bwc ${SERVER_HOME}/env/secrets.env home_sever_env
bwc ${SERVER_HOME}/ansible/vars/secrets.yml home_sever_yml
rm ${SERVER_HOME}/env/secrets.env
rm ${SERVER_HOME}/ansible/vars/secrets.yml
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
  - **80**: Traefik HTTP
  - **443**: Traefik HTTPS
  - **1514**: Wazuh
  - **1515**: Wazuh
  - **9200**: Wazuh Indexer
  - **21115**: ID Server - NAT type test
  - **21116**: ID Server - TCP hole punching
  - **21117**: Relay Server - Relay services
  - **25565**: Minecraft
  - **55000**: Wazuh API
- **UDP**
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
    - [Gitlab](https://gitlab.com/gitlab-org/gitlab)
      - Instance: `https://gitlab.${DOMAIN}`
      - Registry: `https://registry.gitlab.${DOMAIN}`
    - [IT-Tools](https://github.com/CorentinTh/it-tools): `https://it-tools.${DOMAIN}`
  - Passwords
    - [Vaultwarden](https://github.com/dani-garcia/vaultwarden)
      - Administration dashboard: `https://vault.${DOMAIN}/admin`
      - Instance: `https://vault.${DOMAIN}`
  - Personal Knowledge Management System (PKMS)
    - [Affine](https://affine.pro/): `https://affine.${DOMAIN}`
    - [Siyuan](https://b3log.org/siyuan/en/): `https://siyuan.${DOMAIN}`
- **Artificial Intelligence**
  - [Open WebUI](https://openwebui.com): `https://ai.${DOMAIN}`
- **Finances**
  - [Actual](https://actualbudget.com/): `https://finances.${DOMAIN}`
- **Inventory**
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

## Secrets Management

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

## Future enhancements

Here is a list of tools that could be interesting and further enhance the stack:

- **Containers**
  - [Any Sync Docker Compose](https://github.com/anyproto/any-sync-dockercompose): docker-compose for testing any-sync.
  - [CAdvisor](https://github.com/google/cadvisor): analyzes resource usage and performance characteristics of running containers.
  - [Dozzle](https://github.com/amir20/dozzle): realtime log viewer for docker containers.
- **Dashboard**
  - [Heimdall](https://github.com/linuxserver/Heimdall)
  - [Homer](https://github.com/bastienwirtz/homer): very simple static homepage for your server.
- **Finances**
  - [Firefly III](https://github.com/firefly-iii/firefly-iii)
  - [Invoice Ninja](https://github.com/invoiceninja/invoiceninja)
  - [Maybe](https://github.com/maybe-finance/maybe): the OS for your personal finances.
  - [Wallos](https://github.com/ellite/Wallos)
- **Health**
  - [Fasten Health](https://github.com/fastenhealth/fasten-onprem): Fasten is an open-source, self-hosted, personal/family electronic medical record aggregator, designed to integrate with 100,000's of insurances/hospitals/clinics.
- **Home Automation**
  - [Home Assistant](https://github.com/home-assistant/core)
- **Inventory**
  - [Homebox](https://github.com/sysadminsmedia/homebox): inventory and organization system built for the home user.
- **Management**
  - Bookmarks
    - [Hoarder](https://github.com/hoarder-app/hoarder): bookmark-everything app (links, notes and images) with AI-based automatic tagging and full text search.
    - [Linkwarden](https://github.com/linkwarden/linkwarden): collaborative bookmark manager to collect, organize, and preserve webpages, articles, and documents.
- **Media**
  - Management
    - [ConvertX](https://github.com/C4illin/ConvertX): Self-hosted online file converter. Supports 1000+ formats.
    - [Lidarr](https://github.com/Lidarr/Lidarr): Looks and smells like Sonarr but made for music.
    - [Organizr](https://github.com/causefx/Organizr): HTPC/Homelab Services Organizer - Written in PHP.
    - [Radarr](https://github.com/Radarr/Radarr): Movie organizer/manager for usenet and torrent users.
    - [Sonarr](https://github.com/Sonarr/Sonarr): Smart PVR for newsgroup and bittorrent users.
    - [Syncthing](https://github.com/syncthing/syncthing): open source continuous file synchronization.
  - Storage
    - Photos
      - [Photoview](https://github.com/photoview/photoview): photo gallery for self-hosted personal servers.
    - Music
      - [Ampache](https://github.com/ampache/ampache): web based audio/video streaming application and file manager allowing you to access your music & videos from anywhere, using almost any internet enabled device.
      - [Finamp (Jellyfin music client for mobile)](https://github.com/jmshrv/finamp)
      - [Koel](https://github.com/koel/koel): a personal music streaming server that works.
    - Videos
      - [Plex](https://github.com/plexinc/pms-docker): Plex Media Server Docker repo, for all your PMS docker needs.
- **Monitoring**
  - [Keep](https://github.com/keephq/keep): open-source AIOps and alert management platform.
  - [Uptime Kuma](https://github.com/louislam/uptime-kuma): fancy self-hosted monitoring tool.
- **PKMS**
  - [Anytype](https://anytype.io/)
  - [Joplin](https://github.com/laurent22/joplin): privacy-focused note taking app with sync capabilities for Windows, macOS, Linux, Android and iOS.
- **Trello alternative**
  - [Focalboard](https://github.com/mattermost-community/focalboard)
  - [Kanboard](https://github.com/kanboard/kanboard): Kanban project management software.
  - [Leantime](https://github.com/Leantime/leantime)
  - [Taiga](https://github.com/taigaio/taiga-docker)
  - [Vikunja](https://github.com/go-vikunja/vikunja)
  - [Wekan](https://github.com/wekan/wekan/tree/main)
- **Remote**
  - [Shadow SOCKS](https://github.com/shadowsocks/shadowsocks-rust)
- **Wishlist**
  - [Christmas Community](https://github.com/Wingysam/Christmas-Community): Christmas lists for families.
- **Other**
  - [Cluster-iPerf](https://github.com/Markbnj/cluster-iperf): Run iperf in client or server mode on kubernetes and ECS.
  - [Code Server](https://github.com/coder/code-server): VS Code in the browser.
  - [Garage](https://git.deuxfleurs.fr/Deuxfleurs/garage): S3-compatible distributed object storage service.
  - [Monica](https://github.com/monicahq/monica): Personal CRM. Remember everything about your friends, family and business relationships.
  - [Plausible](https://github.com/plausible/analytics): simple, open source, lightweight (< 1 KB) and privacy-friendly web analytics alternative to Google Analytics.
  - [Sentry](https://github.com/getsentry/self-hosted): feature-complete and packaged up for low-volume deployments and proofs-of-concept.
  - [Scrutiny](https://github.com/AnalogJ/scrutiny): hard drive S.M.A.R.T monitoring, historical trends & real world failure thresholds.
  - TunnelMole:
    - [Client](https://github.com/robbie-cahill/tunnelmole-client)
    - [Service](https://github.com/robbie-cahill/tunnelmole-service)
