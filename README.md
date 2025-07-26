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
  - [Traefik](https://traefik.io/traefik) - cloud native application proxy. Deployed on `https://traefik.${DOMAIN}/dashboard`. Source code available [here](https://github.com/traefik/traefik). `Go`
- **Dashboard**
  - [Homarr](https://homarr.dev) - modern and easy to use dashboard. Deployed on `https://home.${DOMAIN}`. Source code available [here](https://github.com/homarr-labs/homarr). `TypeScript`
  - [Homer](https://homer-demo.netlify.app) - very simple static homepage for your server. Deployed on `https://homer.${DOMAIN}`. Source code available [here](https://github.com/bastienwirtz/homer). `Vue` `JavaScript`
- **Home Automation**
  - [Home Assistant](https://www.home-assistant.io) - home automation that puts local control and privacy first. Deployed on `https://ha.${DOMAIN}`. Source code available [here](https://github.com/home-assistant/core). `Python`
  - [UpSnap](https://github.com/seriousm4x/UpSnap) - simple wake on lan web app. Deployed on `https://wol.${DOMAIN}`. Source code available [here](https://github.com/seriousm4x/UpSnap). `Svelte` `Go`
- **Remote Access**
  - **VPN**
    - [Wireguard](https://www.wireguard.com) - `vpn.${DOMAIN}`
    - [Wireguard Easy](https://github.com/wg-easy/wg-easy) - easiest way to run WireGuard VPN + Web-based Admin UI. Deployed on `vpn.${DOMAIN}`. Source code available [here](https://github.com/wg-easy/wg-easy). `TypeScript` `Vue`
  - **Clientless Remote Desktop Gateway (SSH, RDP...)**
    - [Apache Guacamole](https://guacamole.apache.org) - clientless remote desktop gateway. It supports standard protocols like VNC, RDP, and SSH. Deployed on `https://guacamole.${DOMAIN}`. Source code available [here](https://github.com/apache/guacamole-server). `C`
  - **Remote Control Server**
    - [RustDesk](https://rustdesk.com) - remote desktop application designed for self-hosting, as an alternative to TeamViewer. Deployed on `rustdesk.${DOMAIN}`. Source code available [here](https://github.com/rustdesk/rustdesk-server). `Rust`
- **DNS**
  - **Ad-blocker**
    - [Pi-hole](https://pi-hole.net) - a black hole for Internet advertisements. Deployed on `https://pihole.${DOMAIN}`. Source code available [here](https://github.com/pi-hole/pi-hole). `Shell` `Python`
  - **Recursive DNS**
    - [Unbound](https://www.nlnetlabs.nl/projects/unbound/about)
- **Monitoring**
  - [changedetection.io](https://changedetection.io) - web page change detection, website watcher, restock monitor and notification service. Deployed on `https://detection.${DOMAIN}`. Source code available [here](https://github.com/dgtlmoon/changedetection.io). `Python`
  - [Grafana](https://grafana.com) - open and composable observability and data visualization platform. Deployed on `https://grafana.${DOMAIN}`. Source code available [here](https://github.com/grafana/grafana). `TypeScript` `Go`
  - [ntfy](https://ntfy.sh) - send push notifications to your phone or desktop using PUT/POST. Deployed on `https://ntfy.${DOMAIN}`. Source code available [here](https://github.com/binwiederhier/ntfy). `Go` `JavaScript`
  - [Scrutiny](https://github.com/AnalogJ/scrutiny) - hard drive S.M.A.R.T monitoring, historical trends & real world failure thresholds. Deployed on `https://scrutiny.${DOMAIN}`. Source code available [here](https://github.com/AnalogJ/scrutiny). `Go`
- **Backup**
  - [Kopia](https://kopia.io) - cross-platform backup tool with fast, incremental backups, client-side end-to-end encryption, compression and data deduplication. CLI and GUI included. Deployed on `https://kopia.${DOMAIN}`. Source code available [here](https://github.com/kopia/kopia). `Go`
- **Security**
  - [Wazuh](https://wazuh.com) - open source security platform, unified XDR and SIEM protection for endpoints and cloud workloads. Deployed on `https://wazuh.${DOMAIN}`. Soruce code available [here](https://github.com/wazuh/wazuh). `C` `C++` `Python`
  - [Enclosed](https://enclosed.cc) - Minimalistic web app designed for sending private and secure notes. Deployed on `https://notes.${DOMAIN}`. Source code available [here](https://github.com/CorentinTh/enclosed). `TypeScript`
- **Media Storage**
  - **Documents**
    - [NextCloud](https://nextcloud.com) - a safe home for all your data. Deployed on `https://nextcloud.${DOMAIN}`. Source code available [here](https://github.com/nextcloud/server). `PHP` `JavaScript`
    - [Paperless](https://docs.paperless-ngx.com) - document management system: scan, index and archive all your documents. Deployed on `https://paperless.${DOMAIN}`. Source code available [here](https://github.com/paperless-ngx/paperless-ngx). `Python` `TypeScript`
  - **Books**
    - [Kavita](https://www.kavitareader.com) - fast, feature rich, cross platform reading server. Deployed on `https://books.${DOMAIN}`. Source code available [here](https://github.com/Kareadita/Kavita). `C#` `TypeScript`
    - [Librum](https://librumreader.com) - manage your own online library and access it from any device anytime, anywhere. No web-interface, need to install the desktop app as well. Source code available [here](https://github.com/Librum-Reader/Librum). `C++` `QML`
  - **Photos**
    - [Immich](https://immich.app) - high performance self-hosted photo and video management solution. Deployed on `https://pictures.${DOMAIN}`. Source code available [here](https://github.com/immich-app/immich). `TypeScript` `Dart` `Svelte`
    - [Meme Search](https://github.com/neonwatty/meme-search) - meme search engine and finder. Deployed on `https://memes.${DOMAIN}`. Source code available [here](https://github.com/neonwatty/meme-search). `Ruby` `Python`
    - [Photoprism](https://www.photoprism.app) - photos app for the decentralized web. Deployed on `https://photoprism.${DOMAIN}`. Source code available [here](https://github.com/photoprism/photoprism). `Go` `JavaScript`
    - [Pinry](https://github.com/pinry/pinry) - tiling image board system for people who want to save, tag, and share images, videos and webpages in an easy to skim through format. Deployed on `https://golden-book.${DOMAIN}`. Source code available [here](https://github.com/pinry/pinry). `Python`
  - **Music**
    - [Navidrome](https://www.navidrome.org) - personal streaming service. Deployed on `https://music.${DOMAIN}`. Source code available [here](https://github.com/navidrome/navidrome). `Go` `JavaScript`
  - **Videos**
    - [Jellyfin](https://jellyfin.org) - free software media system. Deployed on `https://jellyfin.${DOMAIN}`. Source code available [here](https://github.com/jellyfin/jellyfin). `C#`
- **Media Sharing**
  - [Gokapi](https://github.com/Forceu/Gokapi) - lightweight Firefox Send alternative without public upload. `https://share.${DOMAIN}`. Source code available [here](https://github.com/Forceu/Gokapi). `Go` `JavaScript`
- **Management**
  - **Bookmarks**
    - [Linkace](https://www.linkace.org) - archive to collect links of your favorite websites. Deployed on `https://linkace.${DOMAIN}`. Source code available [here](https://github.com/Kovah/LinkAce). `PHP` `Blade`
  - **Code**
    - [ByteStash](https://github.com/jordan-dalby/bytestash) - a code snippet storage solution written in React & node.js. Deployed on `https://snippets.${DOMAIN}`. Source code available [here](https://github.com/jordan-dalby/bytestash). `TypeScript`
    - [Gitlab](https://gitlab.com/gitlab-org/gitlab) `Ruby`
      - Instance: `https://gitlab.${DOMAIN}`
      - Registry: `https://registry.gitlab.${DOMAIN}`
    - [IT-Tools](https://it-tools.tech) - collection of handy online tools for developers, with great UX. Deployed on `https://it-tools.${DOMAIN}`. Source code available [here](https://github.com/corentinth/it-tools). `Vue` `TypeScript`
    - [Wakapi](https://wakapi.dev) - minimalist, self-hosted WakaTime-compatible backend for coding statistics. Deployed on `https://wakapi.${DOMAIN}`. Source code available [here](https://github.com/muety/wakapi). `Go`
  - **Passwords**
    - [Vaultwarden](https://github.com/dani-garcia/vaultwarden) - unofficial Bitwarden compatible server, formerly known as bitwarden_rs. Source code available [here](https://github.com/dani-garcia/vaultwarden). `Rust`
      - Administration dashboard: `https://vault.${DOMAIN}/admin`
      - Instance: `https://vault.${DOMAIN}`
  - **Personal Knowledge Management System (PKMS)**
    - [Affine](https://affine.pro) - knowledge base that brings planning, sorting, creating all together. Privacy first and open-source. Deployed on `https://affine.${DOMAIN}`. Source code available [here](https://github.com/toeverything/AFFiNE). `TypeScript`
    - [Mathesar](https://mathesar.org) - spreadsheet-like interface that lets users of all technical skill levels view, edit, query, and collaborate on Postgres data directly. Deployed on `https://mathesar.${DOMAIN}`. Source code available [here](https://github.com/mathesar-foundation/mathesar). `Svelte` `TypeScript` `Python`
    - [Siyuan](https://b3log.org/siyuan/en) - privacy-first, self-hosted, fully open source personal knowledge management software. Deployed on `https://siyuan.${DOMAIN}`. Source code available [here](https://github.com/siyuan-note/siyuan). `TypeScript` `Go`
- **Artificial Intelligence**
  - [LiteLLM](https://www.litellm.ai) - Python SDK, proxy server (LLM gateway) to call 100+ LLM APIs in OpenAI format. Deployed on `https://llm.${DOMAIN}`. Source code available [here](https://github.com/BerriAI/litellm). `Python`
  - [Ollama](https://ollama.com) - get up and running with Llama 3.3, DeepSeek-R1, Phi-4, Gemma 3, and other large language models. Source code available [here](https://github.com/ollama/ollama). `Go`
  - [Open WebUI](https://openwebui.com) - user-friendly AI Interface (supports Ollama, OpenAI API, ...). Deployed on `https://ai.${DOMAIN}`. Source code available [here](https://github.com/open-webui/open-webui). `JavaScript` `Svelte` `Python`
- **Finances**
  - [Actual](https://actualbudget.com) - local-first personal finance app. Deployed on `https://finances.${DOMAIN}`. Source code available [here](https://github.com/actualbudget/actual). `TypeScript`
  - [Wallos](https://wallosapp.com) - open-source personal subscription tracker. Deployed on `https://wallos.${DOMAIN}`. Source code available [here](https://github.com/ellite/wallos). `PHP` `JavaScript`
- **Inventory**
  - [Grocy](https://grocy.info) - groceries & household management solution for your home. Deployed on `https://grocy.${DOMAIN}`. Source code available [here](https://github.com/grocy/grocy). `Blade` `TypeScript` `PHP`
  - [HortusFox](https://hortusfox.github.io) - collaborative plant management platform. Deployed on `https://plants.${DOMAIN}`. Source code available [here](https://github.com/hortusfox/hortusfox.github.io).
  - [Homebox](https://homebox.software/en) - inventory and organization system built for the home user. Deployed on `https://homebox.${DOMAIN}`. Source code available [here](https://github.com/sysadminsmedia/homebox). `Go` `Vue` `TypeScript`
- **Travel**
  - [AdventureLog](https://adventurelog.app) - travel tracker and trip planner. Deployed on `https://travel.${DOMAIN}`. Source code available [here](https://github.com/seanmorley15/AdventureLog). `Svelte` `Python`
  - [Jetlog](https://github.com/pbogre/jetlog) - personal flight tracker and viewer. Deployed on `https://fly.${DOMAIN}`. Source code available [here](https://github.com/pbogre/jetlog). `TypeScript` `Python`
- **PDF Tools**
  - [Docuseal](https://www.docuseal.co) - open source DocuSign alternative. Deployed on `https://doc.${DOMAIN}`. Source code available [here](https://github.com/docusealco/docuseal). `Ruby` `Vue` `JavaScript`
  - [Stirling-PDF](https://stirlingtools.com) - allows you to perform various operations on PDF files. Deployed on `https://pdf.${DOMAIN}`. Source code available [here](https://github.com/Stirling-Tools/Stirling-PDF). `Java` `JavaScript`
- **Headless CMS**
  - [Directus](https://directus.io) backend for all your projects, turn your DB into a headless CMS, admin panels, or apps with a custom UI, instant APIs, auth & more. Deployed on `https://directus.${DOMAIN}`. Source code available [here](https://github.com/directus/directus). `TypeScript`
- **Survey Builder**
  - [Limesurvey](https://www.limesurvey.org) - alternative to SurveyMonkey, Typeform, Qualtrics, and Google Forms, making it simple to create online surveys and forms with unmatched flexibility. Deployed on `https://survey.${DOMAIN}`. Source code available [here](https://github.com/LimeSurvey/LimeSurvey). `JavaScript`  `PHP`
- **Wishlist**
  - [Wishlist](https://github.com/cmintey/wishlist) - wishlist application that you can share with your friends and family. Deployed on `https://wish.${DOMAIN}`. Source code available [here](https://github.com/cmintey/wishlist) `Svelte` `TypeScript`
- **Games**
  - [Minecraft Server](https://docker-minecraft-server.readthedocs.io/en/latest) - Minecraft Server for Java Edition that automatically downloads selected version at startup. Deployed on `<ip-address>:25565`. Source code available [here](https://github.com/itzg/docker-minecraft-server). `Shell`

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
  - [Dozzle](https://github.com/amir20/dozzle) [Go]: realtime log viewer for docker containers.
- **Dashboard**
  - [Dashy](https://dashy.to/): personal dashboard built for you. Includes status-checking, widgets, themes, icon packs, a UI editor and tons more. Source code available [here](https://github.com/Lissy93/dashy).
  - [Glance](https://github.com/glanceapp/glance): dashboard that puts all your feeds in one place. Source code available [here](https://github.com/glanceapp/glance).
  - [Heimdall](https://github.com/linuxserver/Heimdall): application dashboard and launcher.
  - [Organizr](https://github.com/causefx/Organizr): HTPC/Homelab Services Organizer - Written in PHP.
- **Finances**
  - [Actual AI](https://github.com/sakowicz/actual-ai) [TypeScript]: categorize transactions in Actual Budget using AI.
  - [DollarDollar](https://github.com/harung1993/dollardollar): expense splitting.
  - [Firefly III](https://github.com/firefly-iii/firefly-iii)
  - [Investbrain](https://github.com/investbrainapp/investbrain): investment tracker that consolidates and monitors market performance across your different brokerages.
  - [Invoice Ninja](https://github.com/invoiceninja/invoiceninja)
  - [Maybe](https://github.com/maybe-finance/maybe): OS for your personal finances.
  - [Monetr](https://github.com/monetr/monetr): budgeting application focused on planning for recurring expenses.
  - [Subscription Manager](https://github.com/dh1011/subscription-manager): keep track of your subscriptions and manage your expenses.
  - [Wapy.dev](https://github.com/meceware/wapy.dev): track, manage and optimize your recurring expenses in one powerful and human readable dashboard.
- **Health**
  - [Fasten Health](https://github.com/fastenhealth/fasten-onprem): Fasten is an open-source, personal/family electronic medical record aggregator, designed to integrate with 100,000's of insurances/hospitals/clinics.
- **Home Automation**
  - [Wol](https://github.com/Trugamr/wol) [Go]: Wake-On-LAN tool that works via CLI and web interface.
- **Inventory**
  - [Bar Assistant](https://github.com/karlomikus/bar-assistant) [PHP]: home bar management.
  - [Lubelogger](https://github.com/hargata/lubelog) [JavaScript]: vehicle maintenance and fuel mileage tracker.
  - [Warracker](https://github.com/sassanix/Warracker) [JavaScript]: web application to manage product warranties, track expiration dates, and store related documents.
- **Mail**
  - [Maddy](https://github.com/foxcpp/maddy) [Go]: composable all-in-one mail server.
- **Management**
  - **Ads**
    - [Umami](https://github.com/umami-software/umami) [TypeScript]: modern, privacy-focused alternative to Google Analytics.
  - **Bookmarks**
    - [Hoarder](https://github.com/hoarder-app/hoarder) [TypeScript]: bookmark-everything app (links, notes and images) with AI-based automatic tagging and full text search.
    - [Linkwarden](https://github.com/linkwarden/linkwarden) [TypeScript]: collaborative bookmark manager to collect, organize, and preserve webpages, articles, and documents.
  - **Code**
    - [Bugsink](https://github.com/bugsink/bugsink) [Python]: error tracking.
    - [Wakapi](https://github.com/muety/wakapi) [Go]: minimalist WakaTime-compatible backend for coding statistics.
    - [Ziit](https://github.com/0PandaDEV/Ziit) [TypeScript]: swiss army knife of code time tracking.
  - **Location**
    - [Dawarich](https://github.com/Freika/dawarich) [Ruby]: alternative to Google location history (Google Maps timeline).
    - [Statistics for Strava](https://github.com/robiningelbrecht/statistics-for-strava) [HTML]: statistics generated using Strava data.
    - [Wanderer](https://github.com/Flomp/wanderer) [HTML]: trail database, save your adventures.
  - **Travel**
    - [AdventureLog](https://github.com/seanmorley15/AdventureLog) [Python]: travel tracker and trip planner.
    - [Scratch Map](https://github.com/ad3m3r5/scratch-map) [JavaScript]: scratch-off style map to track your travels.
    - [VFD](https://github.com/kiinami/vfd): flight price tracking script.
  - **Passwords**
    - [AliasVault](https://github.com/lanedirt/AliasVault) [C#]: end-to-end encrypted password manager with a built-in alias generator and email server.
- **Media**
  - **Management**
    - [ConvertX](https://github.com/C4illin/ConvertX): online file converter. Supports 1000+ formats.
    - [DeepSubX](https://github.com/garanda21/deepsubx) [TypeScript]: uses the DeepL API to translate subtitles for TV shows and movies in your library.
    - [Lidarr](https://github.com/Lidarr/Lidarr): looks and smells like Sonarr but made for music.
    - [Lidify](https://github.com/TheWicklowWolf/Lidify) [Python]: music discovery tool that provides recommendations based on selected Lidarr artists, using Spotify or LastFM.
    - [MeTube](https://github.com/alexta69/metube) [Python/TypeScript]: YouTube downloader (web UI for youtube-dl / yt-dlp).
    - [Radarr](https://github.com/Radarr/Radarr): movie organizer/manager for usenet and torrent users.
    - [Slskd](https://github.com/slskd/slskd): modern client-server application for the Soulseek file sharing network.
    - [Sonarr](https://github.com/Sonarr/Sonarr): smart PVR for newsgroup and bittorrent users.
    - [Soularr](https://github.com/mrusse/soularr) [Python]: script that connects Lidarr with Soulseek.
    - [Syncthing](https://github.com/syncthing/syncthing): open source continuous file synchronization.
    - [Tubifarry](https://github.com/TypNull/Tubifarry) [C#]: Lidarr plugin that enhances your music library by fetching music from YouTube, integrating with Slskd for Soulseek access, automating Spotify playlist imports, converting files, and retrieving soundtracks from Radarr and Sonarr.
  - **Storage**
    - **Documents**
      - [myDrive](https://github.com/subnub/myDrive) [TypeScript]: node.js and mongoDB Google Drive clone.
      - [Paperless AI](https://github.com/clusterzx/paperless-ai) [JavaScript]: automated document analyzer for paperless-ngx using OpenAI API, Ollama, Deepseek-r1, Azure and all OpenAI API compatible services to automatically analyze and tag your documents.
    - **Photos**
      - [Photoview](https://github.com/photoview/photoview) [TypeScript]: photo gallery for personal servers.
      - [WeddingShare](https://github.com/Cirx08/WeddingShare) [JavaScript]: place for guests to view and drop pictures of the big day.
    - **Music**
      - [Ampache](https://github.com/ampache/ampache): web based audio/video streaming application and file manager allowing you to access your music & videos from anywhere, using almost any internet enabled device.
      - [Finamp (Jellyfin music client for mobile)](https://github.com/jmshrv/finamp)
      - [Koel](https://github.com/koel/koel): a personal music streaming server that works.
    - **Videos**
      - [BitPlay](https://github.com/aculix/bitplay) [Go]: stream video torrents in your web browser with ease.
      - [Plex](https://github.com/plexinc/pms-docker): Plex Media Server Docker repo, for all your PMS docker needs.
      - [Streamystats](https://github.com/fredrikburmester/streamystats) [TypeScript]: statistics service for Jellyfin, providing analytics and data visualization.
- **Monitoring**
  - [Beszel](https://github.com/henrygd/beszel) [Go]: lightweight server monitoring hub with historical data, docker stats, and alerts.
  - [Healthchecks](https://github.com/healthchecks/healthchecks) [Python]: cron job and background task monitoring service.
  - [Keep](https://github.com/keephq/keep) [Python]: open-source AIOps and alert management platform.
  - [LibreSpeed](https://github.com/librespeed/speedtest) [PHP]: speed test for HTML5 and more.
  - [NetAlertX](https://github.com/jokob-sk/NetAlertX) [JavaScript]: network intruder and presence detector, scans for devices connected to your network and alerts you if new and unknown devices are found.
  - [Uptime Kuma](https://github.com/louislam/uptime-kuma) [JavaScript]: fancy monitoring tool.
  - [WatchYourLAN](https://github.com/aceberg/WatchYourLAN) [TypeScript]: lightweight network IP scanner, can be used to notify about new hosts and monitor host online/offline history.
- **PKMS**
  - [Anytype](https://anytype.io/)
  - [Excalidraw](https://github.com/excalidraw/excalidraw) [TypeScript]: virtual whiteboard for sketching hand-drawn like diagrams.
  - [Grist](https://github.com/gristlabs/grist-core) [TypeScript]: modern relational spreadsheet.
  - [Joplin](https://github.com/laurent22/joplin) [TypeScript]: privacy-focused note taking app with sync capabilities for Windows, macOS, Linux, Android and iOS.
  - [NocoDB](https://github.com/nocodb/nocodb) [TypeScript]: open source Airtable alternative.
  - [Teable](https://github.com/teableio/teable) [TypeScript]: next gen Airtable alternative, no-code Postgres.
- **Project Management**
  - [Worklenz](https://github.com/Worklenz/worklenz): all in one project management tool for efficient teams.
- **Remote**
  - [Pangolin](https://github.com/fosrl/pangolin) [TypeScript]: tunneled mesh reverse proxy server with identity and access control and dashboard UI.
  - [Shadow SOCKS](https://github.com/shadowsocks/shadowsocks-rust)
  - TunnelMole:
    - [Client](https://github.com/robbie-cahill/tunnelmole-client)
    - [Service](https://github.com/robbie-cahill/tunnelmole-service)
- **Search**
  - [SearXNG](https://github.com/searxng/searxng) [Python]: free internet metasearch engine which aggregates results from various search services and databases, users are neither tracked nor profiled.
- **Security**
  - [Certwarden](https://github.com/gregtwallace/certwarden):  centralized ACME client.
  - [Crowdsec](https://github.com/crowdsecurity/crowdsec) [Go]: open-source and participative security solution offering crowdsourced protection against malicious IPs and access to the most advanced real-world CTI.
  - [Patterns: OWASP CRS and Bad Bot Detection for Web Servers](https://github.com/fabriziosalmi/patterns): Automated OWASP CRS and Bad Bot Detection for Nginx, Apache, Traefik and HaProxy.
  - [Tinyauth](https://github.com/steveiliop56/tinyauth) [Go]: simplest way to protect your apps with a login screen.
- **Trello alternative**
  - [Focalboard](https://github.com/mattermost-community/focalboard)
  - [Kanboard](https://github.com/kanboard/kanboard): Kanban project management software.
  - [Leantime](https://github.com/Leantime/leantime)
  - [Taiga](https://github.com/taigaio/taiga-docker)
  - [Vikunja](https://github.com/go-vikunja/vikunja)
  - [Wekan](https://github.com/wekan/wekan/tree/main)
- **Wishlist**
  - [Christmas Community](https://github.com/Wingysam/Christmas-Community): Christmas lists for families.
- **Other**
  - [Cluster-iPerf](https://github.com/Markbnj/cluster-iperf): Run iperf in client or server mode on kubernetes and ECS.
  - [Code Server](https://github.com/coder/code-server): VS Code in the browser.
  - [Garage](https://git.deuxfleurs.fr/Deuxfleurs/garage): S3-compatible distributed object storage service.
  - [Monica](https://github.com/monicahq/monica): Personal CRM. Remember everything about your friends, family and business relationships.
  - [Plausible](https://github.com/plausible/analytics): simple, open source, lightweight (< 1 KB) and privacy-friendly web analytics alternative to Google Analytics.
  - [Sentry](https://github.com/getsentry/self-hosted): feature-complete and packaged up for low-volume deployments and proofs-of-concept.
