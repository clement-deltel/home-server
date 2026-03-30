# Home Server <!-- omit in toc -->

Collection of self hosted services for my home server setup.

## Table of Contents <!-- omit in toc -->

- [Pre-requisites](#pre-requisites)
- [Getting Started](#getting-started)
- [Hardware](#hardware)
- [RAID \& ZFS](#raid--zfs)
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

- Purchase the server hardware (refer to the [Hardware](#hardware) section for more details)
- Purchase a domain (refer to the [Domain Name](#domain-name) section for more details)
- Build the server, optionally with RAID support (refer to the [RAID & ZFS](#raid--zfs) section for more details)
- Configure port forwarding on your router (refer to the [Port Mapping](#port-mapping) section for more details)
- Install the operating system of your choice on your server (refer to the [Operating System](#operating-system) section for more details)

Create the accounts below:

- AWS account (see [AWS set up tutorial](https://docs.aws.amazon.com/streams/latest/dev/setting-up.html) for more details): AWS SES used as a SMTP relay for service-related emails.
- [Backblaze](https://www.backblaze.com): cloud storage for offsite backups.
- [Crowdsec](https://app.crowdsec.net): malicious traffic bouncer.
- [Doppler](https://www.doppler.com): secret management.

Optionally, create also the accounts below:

- **Artificial Intelligence**
  - [OpenAI](https://platform.openai.com): used by Karakeep and Open WebUI.
- **Games**
  - [IGDB](https://www.igdb.com): used by Romm.
  - [RetroAchievements](https://retroachievements.org): used by Romm.
  - [SteamGrid](https://www.steamgriddb.com): used by Romm.
- **Inventory**
  - [Pl@ntNet](https://my.plantnet.org): used by HortusFox.
- **Media**
  - [Spotify](https://accounts.spotify.com): used by Navidrome.
- **Monitoring**
  - [OpenWeatherMap](https://openweathermap.org): used by Telegraf.

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
      - [Bitwarden CLI](https://bitwarden.com/help/cli)
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
  - Disks 1 & 2:
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

## RAID & ZFS

Disks 1 and 2 are in RAID 1 for better fault tolerance and to avoid any data loss.

More information available at: [Wikipedia - Standard RAID Levels](https://en.wikipedia.org/wiki/Standard_RAID_levels).

## Domain Name

Recommended registrars:

- [CloudFlare](https://www.cloudflare.com/products/registrar/)
- [OVH](https://www.ovhcloud.com/en/domains/)

## Port Mapping

This section covers all the ports exposed to the internet. Those are the ports that must be forwarded on the router to the server hosting all services.

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
  - [Traefik](https://traefik.io/traefik) - cloud native application proxy. ([Source Code](https://github.com/traefik/traefik)) `Go`
- **DNS**
  - **Ad-blocker**
    - [Pi-hole](https://pi-hole.net) - a black hole for Internet advertisements. ([Source Code](https://github.com/pi-hole/pi-hole)) `Shell` `Python`
  - **Recursive DNS**
    - [Unbound](https://www.nlnetlabs.nl/projects/unbound/about)
- **Dashboard**
  - [Homarr](https://homarr.dev) - modern and easy to use dashboard. ([Source Code](https://github.com/homarr-labs/homarr)) `TypeScript`
  - [Homer](https://homer-demo.netlify.app) - very simple static homepage for your server. ([Source Code](https://github.com/bastienwirtz/homer)) `Vue` `JavaScript`
- **Home Automation**
  - [Home Assistant](https://www.home-assistant.io) - home automation that puts local control and privacy first. ([Source Code](https://github.com/home-assistant/core)) `Python`
  - [UpSnap](https://github.com/seriousm4x/UpSnap) - simple wake on lan web app. ([Source Code](https://github.com/seriousm4x/UpSnap)) `Svelte` `Go`
- **Remote Access**
  - **VPN**
    - [Wireguard](https://www.wireguard.com)
    - [Wireguard Easy](https://github.com/wg-easy/wg-easy) - easiest way to run WireGuard VPN + Web-based Admin UI. ([Source Code](https://github.com/wg-easy/wg-easy)) `TypeScript` `Vue`
  - **Clientless Remote Desktop Gateway (SSH, RDP...)**
    - [Apache Guacamole](https://guacamole.apache.org) - clientless remote desktop gateway. It supports standard protocols like VNC, RDP, and SSH. ([Source Code](https://github.com/apache/guacamole-server)) `C`
  - **Remote Control Server**
    - [RustDesk](https://rustdesk.com) - remote desktop application designed for self-hosting, as an alternative to TeamViewer. ([Source Code](https://github.com/rustdesk/rustdesk-server)) `Rust`
- **Monitoring**
  - [changedetection.io](https://changedetection.io) - web page change detection, website watcher, restock monitor and notification service. ([Source Code](https://github.com/dgtlmoon/changedetection.io)) `Python`
  - [Dozzle](https://dozzle.dev) - realtime log viewer for docker containers. ([Source Code](https://github.com/amir20/dozzle)) `Go` `Vue` `TypeScript`
  - [Grafana](https://grafana.com) - open and composable observability and data visualization platform.  ([Source Code](https://github.com/grafana/grafana)) `TypeScript` `Go`
  - [ntfy](https://ntfy.sh) - send push notifications to your phone or desktop using PUT/POST. ([Source Code](https://github.com/binwiederhier/ntfy)) `Go` `JavaScript`
  - [Scrutiny](https://github.com/AnalogJ/scrutiny) - hard drive S.M.A.R.T monitoring, historical trends & real world failure thresholds. ([Source Code](https://github.com/AnalogJ/scrutiny)) `Go`
- **Backup**
  - [Kopia](https://kopia.io) - cross-platform backup tool with fast, incremental backups, client-side end-to-end encryption, compression and data deduplication. CLI and GUI included. ([Source Code](https://github.com/kopia/kopia)) `Go`
- **Security**
  - [Authentik](https://goauthentik.io) - authentication glue you need. ([Source Code](https://github.com/goauthentik/authentik)) `Python` `TypeScript`
  - [CrowdSec](https://app.crowdsec.net) - open-source and participative security solution offering crowdsourced protection against malicious IPs and access to the most advanced real-world CTI. ([Source Code](https://github.com/crowdsecurity/crowdsec)) `Go` `Shell`
  - [Enclosed](https://enclosed.cc) - Minimalistic web app designed for sending private and secure notes. ([Source Code](https://github.com/CorentinTh/enclosed)) `TypeScript`
  - [Gluetun](https://github.com/qdm12/gluetun-wiki) - VPN client in a thin Docker container for multiple VPN providers, and using OpenVPN or Wireguard, DNS over TLS, with a few proxy servers built-in. ([Source Code](https://github.com/qdm12/gluetun)) `Go`
  - [Wazuh](https://wazuh.com) - open source security platform, unified XDR and SIEM protection for endpoints and cloud workloads. ([Source Code](https://github.com/wazuh/wazuh)) `C` `C++` `Python`
- **Search**
  - [SearXNG](https://docs.searxng.org) - free internet metasearch engine which aggregates results from various search services and databases, users are neither tracked nor profiled. ([Source Code](https://github.com/searxng/searxng)) `Python`
- **Media Storage**
  - **Bookmarks**
    - [Karakeep](https://karakeep.app/) - bookmark-everything app (links, notes and images) with AI-based automatic tagging and full text search. ([Source Code](https://github.com/karakeep-app/karakeep)) `TypeScript`
    - [Linkace](https://www.linkace.org) - archive to collect links of your favorite websites. ([Source Code](https://github.com/Kovah/LinkAce)) `PHP` `Blade`
  - **Books**
    - [Kavita](https://www.kavitareader.com) - fast, feature rich, cross platform reading server. ([Source Code](https://github.com/Kareadita/Kavita)) `C#` `TypeScript`
    - [Librum](https://librumreader.com) - manage your own online library and access it from any device anytime, anywhere. No web-interface, need to install the desktop app as well. ([Source Code](https://github.com/Librum-Reader/Librum)) `C++` `QML`
  - **Documents**
    - [NextCloud](https://nextcloud.com) - a safe home for all your data. ([Source Code](https://github.com/nextcloud/server)) `PHP` `JavaScript`
    - [Paperless](https://docs.paperless-ngx.com) - document management system: scan, index and archive all your documents. ([Source Code](https://github.com/paperless-ngx/paperless-ngx)) `Python` `TypeScript`
  - **Music**
    - [Navidrome](https://www.navidrome.org) - personal streaming service. ([Source Code](https://github.com/navidrome/navidrome)) `Go` `JavaScript`
  - **News**
    - [FreshRSS](https://freshrss.org/index.html) -  news aggregator. ([Source Code](https://github.com/FreshRSS/FreshRSS)) `PHP`
  - **Pictures**
    - [Immich](https://immich.app) - high performance self-hosted photo and video management solution. ([Source Code](https://github.com/immich-app/immich)) `TypeScript` `Dart` `Svelte`
    - [Meme Search](https://github.com/neonwatty/meme-search) - meme search engine and finder. ([Source Code](https://github.com/neonwatty/meme-search)) `Ruby` `Python`
    - [Photoprism](https://www.photoprism.app) - photos app for the decentralized web. ([Source Code](https://github.com/photoprism/photoprism)) `Go` `JavaScript`
    - [Pinry](https://github.com/pinry/pinry) - tiling image board system for people who want to save, tag, and share images, videos and webpages in an easy to skim through format. ([Source Code](https://github.com/pinry/pinry)) `Python`
  - **Videos**
    - [Jellyfin](https://jellyfin.org) - free software media system. ([Source Code](https://github.com/jellyfin/jellyfin)) `C#`
- **Media Tools**
  - [ConvertX](https://github.com/C4illin/ConvertX) - online file converter. Supports 1000+ formats. ([Source Code](https://github.com/C4illin/ConvertX)) `TypeScript`
  - [Docuseal](https://www.docuseal.co) - open source DocuSign alternative. ([Source Code](https://github.com/docusealco/docuseal)) `Ruby` `Vue` `JavaScript`
  - [Gokapi](https://github.com/Forceu/Gokapi) - lightweight Firefox Send alternative without public upload. ([Source Code](https://github.com/Forceu/Gokapi)) `Go` `JavaScript`
  - [iSponsorBlockTV](https://github.com/dmunozv04/iSponsorBlockTV) - SponsorBlock client for all YouTube TV clients. ([Source Code](https://github.com/dmunozv04/iSponsorBlockTV)) `Python`
  - [QBittorent](https://github.com/linuxserver/docker-qbittorrent) - torrent client based on the Qt toolkit and libtorrent-rasterbar library. ([Source Code](https://github.com/linuxserver/docker-qbittorrent))
  - [Stirling-PDF](https://stirlingtools.com) - allows you to perform various operations on PDF files. ([Source Code](https://github.com/Stirling-Tools/Stirling-PDF)) `Java` `JavaScript`
- **Management**
  - **Code**
    - [ByteStash](https://github.com/jordan-dalby/bytestash) - a code snippet storage solution written in React & node.js. ([Source Code](https://github.com/jordan-dalby/bytestash)) `TypeScript`
    - [Forgejo](https://forgejo.org) - Beyond coding, we forge. ([Source Code](https://codeberg.org/forgejo/forgejo)) `Go`
    - [Gitea Mirror](https://giteamirror.com) - auto-syncs GitHub repos to your self-hosted Gitea/Forgejo, with a sleek Web UI and easy Docker deployment. ([Source Code](https://github.com/RayLabsHQ/gitea-mirror)) `TypeScript`
    - [Gitlab](https://gitlab.com/gitlab-org/gitlab) `Ruby`
    - [IT-Tools](https://it-tools.tech) - collection of handy online tools for developers, with great UX. ([Source Code](https://github.com/corentinth/it-tools)) `Vue` `TypeScript`
    - [Wakapi](https://wakapi.dev) - minimalist, self-hosted WakaTime-compatible backend for coding statistics. ([Source Code](https://github.com/muety/wakapi)) `Go`
  - **Passwords**
    - [Vaultwarden](https://github.com/dani-garcia/vaultwarden) - unofficial Bitwarden compatible server, formerly known as bitwarden_rs. ([Source Code](https://github.com/dani-garcia/vaultwarden)) `Rust`
  - **Personal Knowledge Management System (PKMS)**
    - [Affine](https://affine.pro) - knowledge base that brings planning, sorting, creating all together. Privacy first and open-source. ([Source Code](https://github.com/toeverything/AFFiNE)) `TypeScript`
    - [Mathesar](https://mathesar.org) - spreadsheet-like interface that lets users of all technical skill levels view, edit, query, and collaborate on Postgres data directly. ([Source Code](https://github.com/mathesar-foundation/mathesar)) `Svelte` `TypeScript` `Python`
    - [Memos](https://github.com/usememos/memos) - note-taking service, your thoughts, your data, your control — no tracking, no ads, no subscription fees. ([Source Code](https://github.com/usememos/memos)) `Go` `TypeScript`
    - [Siyuan](https://b3log.org/siyuan/en) - privacy-first, self-hosted, fully open source personal knowledge management software. ([Source Code](https://github.com/siyuan-note/siyuan)) `TypeScript` `Go`
- **Artificial Intelligence**
  - [LiteLLM](https://www.litellm.ai) - Python SDK, proxy server (LLM gateway) to call 100+ LLM APIs in OpenAI format. ([Source Code](https://github.com/BerriAI/litellm)) `Python`
  - [Ollama](https://ollama.com) - get up and running with Llama 3.3, DeepSeek-R1, Phi-4, Gemma 3, and other large language models. ([Source Code](https://github.com/ollama/ollama)) `Go`
  - [Open WebUI](https://openwebui.com) - user-friendly AI Interface (supports Ollama, OpenAI API, ...). ([Source Code](https://github.com/open-webui/open-webui)) `JavaScript` `Svelte` `Python`
- **Automation**
  - [n8n](https://n8n.io) -  workflow automation platform with native AI capabilities, combine visual building with custom code, self-host or cloud, 400+ integrations. ([Source Code](https://github.com/n8n-io/n8n)) `TypeScript`
- **Development & Projects**
  - [Directus](https://directus.io) backend for all your projects, turn your DB into a headless CMS, admin panels, or apps with a custom UI, instant APIs, auth & more. ([Source Code](https://github.com/directus/directus)) `TypeScript`
- **Finances**
  - [Actual](https://actualbudget.com) - local-first personal finance app. ([Source Code](https://github.com/actualbudget/actual)) `TypeScript`
  - [Wallos](https://wallosapp.com) - open-source personal subscription tracker. ([Source Code](https://github.com/ellite/wallos)) `PHP` `JavaScript`
- **Inventory**
  - [Grocy](https://grocy.info) - groceries & household management solution for your home. ([Source Code](https://github.com/grocy/grocy)) `Blade` `TypeScript` `PHP`
  - [HortusFox](https://hortusfox.com) - collaborative plant management platform. ([Source Code](https://github.com/danielbrendel/hortusfox-web))
  - [Homebox](https://homebox.software/en) - inventory and organization system built for the home user. ([Source Code](https://github.com/sysadminsmedia/homebox)) `Go` `Vue` `TypeScript`
  - [Mealie](https://docs.mealie.io) - recipe manager and meal planner with a RestAPI backend and a reactive frontend application built in Vue for a pleasant user experience for the whole family. ([Source Code](https://github.com/mealie-recipes/mealie)) `Python` `Vue` `TypeScript`
  - [Wishlist](https://github.com/cmintey/wishlist) - wishlist application that you can share with your friends and family. ([Source Code](https://github.com/cmintey/wishlist)) `Svelte` `TypeScript`
- **Travel**
  - [AdventureLog](https://adventurelog.app) - travel tracker and trip planner. ([Source Code](https://github.com/seanmorley15/AdventureLog)) `Svelte` `Python`
  - [Dawarich](https://dawarich.app) - alternative to Google location history (Google Maps timeline). ([Source Code](https://github.com/Freika/dawarich)) `Ruby` `JavaScript`
  - [Jetlog](https://github.com/pbogre/jetlog) - personal flight tracker and viewer. ([Source Code](https://github.com/pbogre/jetlog)) `TypeScript` `Python`
- **Surveys**
  - [Limesurvey](https://www.limesurvey.org) - alternative to SurveyMonkey, Typeform, Qualtrics, and Google Forms, making it simple to create online surveys and forms with unmatched flexibility. ([Source Code](https://github.com/LimeSurvey/LimeSurvey)) `JavaScript`  `PHP`
- **Games**
  - [Minecraft Server](https://docker-minecraft-server.readthedocs.io/en/latest) - Minecraft Server for Java Edition that automatically downloads selected version at startup. Deployed on `<ip-address>:25565`. ([Source Code](https://github.com/itzg/docker-minecraft-server)) `Shell`
  - [Romm](https://romm.app) - beautiful, powerful, self-hosted rom manager and player. ([Source Code](https://github.com/rommapp/romm)) `Python` `Vue`

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

- **Artificial Intelligence**
  - [firecrawl](https://firecrawl.dev) - web data API for AI - Turn entire websites into LLM-ready markdown or structured data. ([Source Code](https://github.com/firecrawl/firecrawl)) `TypeScript` `Python`
- **Backup**
  - [Backrest](https://github.com/garethgeorge/backrest) - Backrest is a web UI and orchestrator for restic backup. ([Source Code](https://github.com/garethgeorge/backrest)) `Go` `TypeScript`
  - [Borg](https://www.borgbackup.org) - deduplicating archiver with compression and authenticated encryption. ([Source Code](https://github.com/borgbackup/borg)) `Python`
  - [Zerobyte](https://github.com/nicotsx/zerobyte) - backup automation for self-hosting, built on top of restic. ([Source Code](https://github.com/nicotsx/zerobyte)) `TypeScript`
- **Containers**
  - [Any Sync Docker Compose](https://github.com/anyproto/any-sync-dockercompose) - docker-compose for testing any-sync. ([Source Code](https://github.com/anyproto/any-sync-dockercompose)) `Shell` `Python`
  - [CAdvisor](https://github.com/google/cadvisor) - analyzes resource usage and performance characteristics of running containers. ([Source Code](https://github.com/google/cadvisor)) `Go`
  - [Dockge](https://dockge.kuma.pet) - docker compose.yaml stack-oriented manager. ([Source Code](https://github.com/louislam/dockge)) `TypeScript`
  - [Komodo](https://komo.do) - tool to build and deploy software on many servers. ([Source Code](https://github.com/moghtech/komodo)) `Rust` `TypeScript`
  - [Portainer](https://www.portainer.io) - making Docker and Kubernetes management easy. ([Source Code](https://github.com/portainer/portainer)) `TypeScript` `Go`
- **Dashboard**
  - [Astroluma](https://getastroluma.com) - dashboard designed to help you manage multiple aspects of your daily tasks and services. ([Source Code](https://github.com/Sanjeet990/Astroluma)) `JavaScript`
  - [Dashy](https://dashy.to) - personal dashboard built for you. Includes status-checking, widgets, themes, icon packs, a UI editor and tons more. ([Source Code](https://github.com/Lissy93/dashy)) `Vue` `JavaScript`
  - [Glance](https://github.com/glanceapp/glance) - dashboard that puts all your feeds in one place. ([Source Code](https://github.com/glanceapp/glance)) `Go` `JavaScript`
  - [Heimdall](https://heimdall.site) - application dashboard and launcher. ([Source Code](https://github.com/linuxserver/Heimdall)) `PHP`
  - [Organizr](https://demo.organizr.app) - HTPC/Homelab Services Organizer - Written in PHP. ([Source Code](https://github.com/causefx/Organizr)) `PHP` `JavaScript`
  - [Trala](https://www.trala.fyi) -  simple, modern, and dynamic dashboard for your Traefik services. ([Source Code](https://github.com/dannybouwers/trala)) `Go`
- **DNS**
  - [Blocky](https://0xerr0r.github.io/blocky/latest) - fast and lightweight DNS proxy as ad-blocker for local network with many features. ([Source Code](https://github.com/0xERR0R/blocky)) `Go`
- **Finances**
  - [Actual AI](https://github.com/sakowicz/actual-ai) - categorize transactions in Actual Budget using AI. ([Source Code](https://github.com/sakowicz/actual-ai)) `TypeScript`
  - [Cents per Point](https://github.com/ayostepht/Cents-Per-Point) - track credit card point redemptions and calculate Cents Per Point (CPP) values to optimize your rewards strategy. ([Source Code](https://github.com/ayostepht/Cents-Per-Point)) `JavaScript`
  - [DollarDollar](https://ddby.finforward.xyz/dashboard) - expense splitting. ([Source Code](https://github.com/harung1993/dollardollar)) `JavaScript` `Python`
  - [Firefly III](https://firefly-iii.org) - personal finances manager. ([Source Code](https://github.com/firefly-iii/firefly-iii)) `PHP` `JavaScript`
  - [Ghostfolio](https://ghostfol.io/en/start) - wealth management software. ([Source Code](https://github.com/ghostfolio/ghostfolio)) `TypeScript`
  - [Investbrain](https://investbra.in) - investment tracker that consolidates and monitors market performance across your different brokerages. ([Source Code](https://github.com/investbrainapp/investbrain)) `PHP`
  - [Invoice Ninja](https://invoiceninja.com) - invoice, quote, project and time-tracking app. ([Source Code](https://github.com/invoiceninja/invoiceninja)) `PHP`
  - [Maybe](https://github.com/maybe-finance/maybe) - OS for your personal finances. ([Source Code](https://github.com/maybe-finance/maybe)) `Ruby`
  - [Monetr](https://monetr.app) - budgeting application focused on planning for recurring expenses. ([Source Code](https://github.com/monetr/monetr)) `Go` `TypeScript`
  - [OpenBB](https://openbb.co) - financial data platform for analysts, quants and AI agents. ([Source Code](https://github.com/OpenBB-finance/OpenBB)) `Python`
  - [Subscription Manager](https://github.com/dh1011/subscription-manager) - keep track of your subscriptions and manage your expenses. ([Source Code](https://github.com/dh1011/subscription-manager)) `JavaScript` `Python`
  - [Wapy.dev](https://www.wapy.dev) - track, manage and optimize your recurring expenses in one powerful and human readable dashboard. ([Source Code](https://github.com/meceware/wapy.dev)) `JavaScript`
- **Fitness**
  - [Endurain](https://docs.endurain.com) - fitness tracking service designed to give users full control over their data and hosting environment. ([Source Code](https://github.com/endurain-project/endurain)) `Python`
- **Games**
  - [Factorio](https://hub.docker.com/r/factoriotools/factorio) - headless server in a Docker container. ([Source Code](https://github.com/factoriotools/factorio-docker)) `Shell` `Python` `C`
  - [GameVault](https://gamevau.lt) - self-hosted gaming platform for drm-free games. ([Source Code](https://github.com/Phalcode/gamevault-backend)) `TypeScript`
  - [Lodestone](https://www.lodestone.cc) - server hosting tool for Minecraft and other multiplayer games. ([Source Code](https://github.com/Lodestone-Team/lodestone)) `Rust` `TypeScript`
  - [Paper](https://papermc.io/software/paper) - high performance Minecraft server that aims to fix gameplay and mechanics inconsistencies. ([Source Code](https://github.com/PaperMC/Paper)) `Java`
  - [Satisfactory](https://hub.docker.com/r/wolveix/satisfactory-server) - containerized version of the Satisfactory dedicated server. ([Source Code](https://github.com/wolveix/satisfactory-server)) `Shell` `Go`
  - [Sunshine](https://app.lizardbyte.dev/Sunshine/?lng=en) - game stream host for Moonlight. ([Source Code](https://github.com/LizardByte/Sunshine)) `C++`
  - [Valheim](https://github.com/Nimdy/Dedicated_Valheim_Server_Script) - Valheim server manager. ([Source Code](https://github.com/Nimdy/Dedicated_Valheim_Server_Script)) `Shell`
  - [Wolf](https://games-on-whales.github.io/wolf/stable) - stream virtual desktops and games running in Docker. ([Source Code](https://github.com/games-on-whales/wolf)) `C++`
- **Health**
  - [Fasten Health](https://www.fastenhealth.com) - personal/family electronic medical record aggregator, designed to integrate with 100,000's of insurances/hospitals/clinics. ([Source Code](https://github.com/fastenhealth/fasten-onprem)) `Go` `TypeScript`
  - [OpenEMR](https://www.open-emr.org) - electronic health records and medical practice management solution. ([Source Code](https://github.com/openemr/openemr)) `PHP`
- **Home Automation**
  - [Wakezilla](https://github.com/guibeira/wakezilla) - simple Wake-on-LAN & reverse proxy toolkit — wake, route, and control your machines from anywhere. ([Source Code](https://github.com/guibeira/wakezilla)) `Rust`
  - [Wol](https://github.com/Trugamr/wol) - Wake-On-LAN tool that works via CLI and web interface. ([Source Code](https://github.com/Trugamr/wol)) `Go`
- **Inventory**
  - [Bar Assistant](https://barassistant.app) - home bar management. ([Source Code](https://github.com/karlomikus/bar-assistant)) `PHP`
  - [Lubelogger](https://lubelogger.com) - vehicle maintenance and fuel mileage tracker. ([Source Code](https://github.com/hargata/lubelog)) `JavaScript` `C#`
  - [VoucherVault](https://github.com/l4rm4nd/VoucherVault/wiki) - store and manage vouchers, coupons, loyalty and gift cards digitally. ([Source Code](https://github.com/l4rm4nd/VoucherVault)) `Python`
  - [Warracker](https://warracker.com) - web application to manage product warranties, track expiration dates, and store related documents. ([Source Code](https://github.com/sassanix/Warracker)) `JavaScript` `Python`
- **Location & Travel**
  - [Scratch Map](https://github.com/ad3m3r5/scratch-map) - scratch-off style map to track your travels. ([Source Code](https://github.com/ad3m3r5/scratch-map)) `JavaScript`
  - [Statistics for Strava](https://statistics-for-strava.robiningelbrecht.be/dashboard) - statistics generated using Strava data. ([Source Code](https://github.com/robiningelbrecht/statistics-for-strava)) `PHP`
  - [VFD](https://github.com/kiinami/vfd) - flight price tracking script. ([Source Code](https://github.com/kiinami/vfd)) `Python`
  - [Wanderer](https://wanderer.to) - trail database, save your adventures. ([Source Code](https://github.com/Flomp/wanderer)) `Svelte` `Go` `TypeScript`
- **Mail**
  - [docker-mailserver](https://docker-mailserver.github.io/docker-mailserver/latest) - production-ready fullstack but simple mail server (SMTP, IMAP, LDAP, Antispam, Antivirus, etc.) running inside a container. ([Source Code](https://github.com/docker-mailserver/docker-mailserver)) `Shell`
  - [Maddy](https://maddy.email) - composable all-in-one mail server. ([Source Code](https://github.com/foxcpp/maddy)) `Go`
  - [OpenArchiver](https://openarchiver.com) - platform for legally compliant email archiving. ([Source Code](https://github.com/LogicLabs-OU/OpenArchiver)) `TypeScript` `Svelte`
  - [Piler](https://www.mailpiler.org) - email archiving application. ([Source Code](https://github.com/jsuto/piler)) `PHP`
  - [simple-login](https://simplelogin.io) - simple login back-end and web app. ([Source Code](https://github.com/simple-login/app)) `Python` `JavaScript`
- **Maintenance**
  - [olivetin](https://olivetin.app) -  safe and simple access to predefined shell commands from a web interface. ([Source Code](https://github.com/OliveTin/OliveTin)) `Go` `JavaScript`
- **Management**
  - **Ads**
    - [Plausible](https://plausible.io) - simple, open source, lightweight (< 1 KB) and privacy-friendly web analytics alternative to Google Analytics. ([Source Code](https://github.com/plausible/analytics)) `Elixir`
    - [Umami](https://github.com/umami-software/umami) - modern, privacy-focused alternative to Google Analytics. ([Source Code](https://github.com/umami-software/umami)) `TypeScript`
  - **Code**
    - [Bugsink](https://www.bugsink.com) - error tracking. ([Source Code](https://github.com/bugsink/bugsink)) `Python`
    - [Cyber Chef](https://gchq.github.io/CyberChef) - web app for encryption, encoding, compression and data analysis. ([Source Code](https://github.com/gchq/CyberChef)) `JavaScript`
    - [Gitea](https://gitea.com) - all-in-one software development service, including Git hosting, code review, team collaboration, package registry and CI/CD. ([Source Code](https://github.com/go-gitea/gitea)) `Go`
    - [Networking Toolbox](https://networkingtoolbox.net) - . ([Source Code](https://github.com/Lissy93/networking-toolbox)) `Svelte` `TypeScript`
    - [OpenGist](https://opengist.io) - pastebin powered by Git, open-source alternative to Github Gist. ([Source Code](https://github.com/thomiceli/opengist)) `Go` `TypeScript`
    - [PyPI Server](https://hub.docker.com/r/pypiserver/pypiserver) - minimal PyPI server for uploading & downloading packages with pip. Source code [here](https://github.com/pypiserver/pypiserver). `Python`
    - [Sentry](https://sentry.io/welcome) - feature-complete and packaged up for low-volume deployments and proofs-of-concept. ([Source Code](https://github.com/getsentry/self-hosted)) `Shell` `Python`
    - [woodpecker](https://woodpecker-ci.org) - simple, yet powerful CI/CD engine with great extensibility. ([Source Code](https://github.com/woodpecker-ci/woodpecker)) `Go`
    - [Ziit](https://ziit.app/login) - swiss army knife of code time tracking. ([Source Code](https://github.com/0PandaDEV/Ziit)) `TypeScript` `Vue`
  - **Passwords**
    - [AliasVault](https://www.aliasvault.net) - end-to-end encrypted password manager with a built-in alias generator and email server. ([Source Code](https://github.com/lanedirt/AliasVault)) `C#` `TypeScript`
- **Media**
  - **Management**
    - [Bazarr](https://www.bazarr.media) - manage and download subtitles based on your requirements. ([Source Code](https://github.com/morpheus65535/bazarr)) `Python`
    - [Cleanuparr](https://github.com/Cleanuparr/Cleanuparr) - tool for automating the cleanup of unwanted or blocked files in Sonarr, Radarr, and supported download clients like qBittorrent. ([Source Code](https://github.com/Cleanuparr/Cleanuparr)) `C#`
    - [DeepSubX](https://github.com/garanda21/deepsubx) - uses the DeepL API to translate subtitles for TV shows and movies in your library. ([Source Code](https://github.com/garanda21/deepsubx)) `TypeScript` `JavaScript`
    - [Lidarr](https://lidarr.audio) - looks and smells like Sonarr but made for music. ([Source Code](https://github.com/Lidarr/Lidarr)) `C#` `JavaScript`
    - [Lidify](https://github.com/TheWicklowWolf/Lidify) - music discovery tool that provides recommendations based on selected Lidarr artists, using Spotify or LastFM. ([Source Code](https://github.com/TheWicklowWolf/Lidify)) `Python` `JavaScript`
    - [MeTube](https://github.com/alexta69/metube) - YouTube downloader (web UI for youtube-dl / yt-dlp). ([Source Code](https://github.com/alexta69/metube)) `TypeScript` `Python`
    - [Profilarr](https://dictionarry.dev) - configuration management platform for Radarr/Sonarr. ([Source Code](https://github.com/Dictionarry-Hub/profilarr)) `TypeScript` `Svelte`
    - [Prowlarr](https://prowlarr.com) - . ([Source Code](https://github.com/Prowlarr/Prowlarr)) `C#` `JavaScript`
    - [qui](https://getqui.com) - qBittorrent web UI: manage multiple instances, automate torrent workflows, and cross-seed across trackers. ([Source Code](https://github.com/autobrr/qui)) `Go` `TypeScript`
    - [Radarr](https://radarr.video) - movie organizer/manager for usenet and torrent users. ([Source Code](https://github.com/Radarr/Radarr)) `C#` `TypeScript`
    - [Seerr](https://docs.seerr.dev) - media request and discovery manager for Jellyfin, Plex, and Emby. ([Source Code](https://github.com/seerr-team/seerr))
    - [Slskd](https://github.com/slskd/slskd) - modern client-server application for the Soulseek file sharing network. ([Source Code](https://github.com/slskd/slskd)) `C#`
    - [Sonarr](https://sonarr.tv) - smart PVR for newsgroup and bittorrent users. ([Source Code](https://github.com/Sonarr/Sonarr)) `C#` `TypeScript`
    - [Soularr](https://soularr.net) - script that connects Lidarr with Soulseek. ([Source Code](https://github.com/mrusse/soularr)) `Python`
    - [Spotizerr](https://github.com/Xoconoch/spotizerr) - spotify music downloader with a lossless twist, based on the deezspot library. ([Source Code](https://github.com/Xoconoch/spotizerr)) `Python` `TypeScript`
    - [Syncthing](https://syncthing.net) - open source continuous file synchronization. ([Source Code](https://github.com/syncthing/syncthing)) `Go`
    - [Tdarr](https://home.tdarr.io) - distributed transcode automation using FFmpeg/HandBrake + audio/video library analytics + video health checking. ([Source Code](https://github.com/HaveAGitGat/Tdarr)) `Makefile`
    - [Tubifarry](https://github.com/TypNull/Tubifarry) - Lidarr plugin that enhances your music library by fetching music from YouTube, integrating with Slskd for Soulseek access, automating Spotify playlist imports, converting files, and retrieving soundtracks from Radarr and Sonarr. ([Source Code](https://github.com/TypNull/Tubifarry)) `C#`
    - [yt-dlp](https://github.com/yt-dlp/yt-dlp) - feature-rich command-line audio/video downloader. ([Source Code](https://github.com/yt-dlp/yt-dlp)) `Python`
  - **Storage**
    - Audiobooks
      - [Audiobookshelf](https://audiobookshelf.org) - audiobook and podcast server. ([Source Code](https://github.com/advplyr/audiobookshelf)) `JavaScript` `Vue`
    - **Bookmarks**
      - [Linkwarden](https://linkwarden.app) - collaborative bookmark manager to collect, organize, and preserve webpages, articles, and documents. ([Source Code](https://github.com/linkwarden/linkwarden)) `TypeScript`
    - **Documents**
      - [myDrive](https://mydrive-storage.com) - node.js and mongoDB Google Drive clone. ([Source Code](https://github.com/subnub/myDrive)) `TypeScript`
      - [OxiCloud](https://github.com/DioCrafts/OxiCloud) - ultra-fast, secure & lightweight self-hosted cloud storage — your files, photos, calendars & contacts, all in one place. ([Source Code](https://github.com/DioCrafts/OxiCloud)) `Rust` `JavaScript`
      - [Paperless AI](https://clusterzx.github.io/paperless-ai) - automated document analyzer for paperless-ngx using OpenAI API, Ollama, Deepseek-r1, Azure and all OpenAI API compatible services to automatically analyze and tag your documents. ([Source Code](https://github.com/clusterzx/paperless-ai)) `JavaScript`
      - [Papra](https://demo.papra.app) - minimalistic document archiving platform. ([Source Code](https://github.com/papra-hq/papra)) `TypeScript`
      - [Seafile](http://seafile.com) - beyond file syncing and sharing, a new way to organize your files with extensible file properties and flexible views. ([Source Code](https://github.com/haiwen/seafile)) `C` `Python`
    - **Photos**
      - [Photoview](https://photoview.github.io) - photo gallery for personal servers. ([Source Code](https://github.com/photoview/photoview)) `TypeScript` `Go`
      - [WeddingShare](https://docs.wedding-share.org) - place for guests to view and drop pictures of the big day. ([Source Code](https://github.com/Cirx08/WeddingShare)) `JavaScript` `C#`
    - **Music**
      - [Ampache](https://ampache.org) - web based audio/video streaming application and file manager allowing you to access your music & videos from anywhere, using almost any internet enabled device. ([Source Code](https://github.com/ampache/ampache)) `PHP`
      - [Finamp (Jellyfin music client for mobile)](https://github.com/jmshrv/finamp)
      - [Koel](https://koel.dev) - a personal music streaming server that works. ([Source Code](https://github.com/koel/koel)) `PHP` `TypeScript`
    - **News**
      - [Miniflux](https://miniflux.app) - minimalist and opinionated feed reader. ([Source Code](https://github.com/miniflux/v2)) `Go`
    - **Videos**
      - [BitPlay](https://github.com/aculix/bitplay) - stream video torrents in your web browser with ease. ([Source Code](https://github.com/aculix/bitplay)) `Go`
      - [Kodi](https://kodi.tv) - open source home theater/media center software and entertainment hub for digital media. ([Source Code](https://github.com/xbmc/xbmc)) `C++`
      - [Plex](https://www.plex.tv) - Plex Media Server Docker repo, for all your PMS docker needs. ([Source Code](https://github.com/plexinc/pms-docker))
      - [Streamystats](https://github.com/fredrikburmester/streamystats) - statistics service for Jellyfin, providing analytics and data visualization. ([Source Code](https://github.com/fredrikburmester/streamystats)) `TypeScript`
    - Web
      - [ArchiveBox](https://archivebox.io) - web archiving that takes URLs/browser history/bookmarks/Pocket/Pinboard/etc. ([Source Code](https://github.com/ArchiveBox/ArchiveBox)) `Python`
  - **Tools**
    - [BentoPDF](https://bentopdf.com) - privacy first PDF toolkit. ([Source Code](https://github.com/alam00000/bentopdf)) `JavaScript` `Fluent` `TypeScript`
    - [Cobalt](https://cobalt.tools) - best way to save what you love. ([Source Code](https://github.com/imputnet/cobalt)) `Svelte` `JavaScript` `TypeScript`
    - [Invidious](https://invidious.io) - alternative front-end to YouTube. ([Source Code](https://github.com/iv-org/invidious)) `Crystal`
    - [Mazanoke](https://mazanoke.com) - local image optimizer that runs in your browser. ([Source Code](https://github.com/civilblur/mazanoke)) `JavaScript`
    - [OmniTools](https://omnitools.app) - collection of powerful web-based tools for everyday tasks. ([Source Code](https://github.com/iib0011/omni-tools)) `TypeScript`
    - [SmartTube](https://github.com/yuliskov/SmartTube) - browse media content with your own rules on Android TV. `Java`
    - [Vert](https://vert.sh) - next-generation file converter. ([Source Code](https://github.com/VERT-sh/VERT)) `Svelte` `TypeScript`
    - [WithoutBG](https://withoutbg.com) - image background removal toolkit. ([Source Code](https://github.com/withoutbg/withoutbg)) `Python` `JavaScript`
- **Monitoring**
  - [Beszel](https://beszel.dev/) - lightweight server monitoring hub with historical data, docker stats, and alerts. ([Source Code](https://github.com/henrygd/beszel)) `Go`
  - [Cluster-iPerf](https://github.com/Markbnj/cluster-iperf) - Run iperf in client or server mode on kubernetes and ECS. ([Source Code](https://github.com/Markbnj/cluster-iperf))
  - [Domain Monitor](https://github.com/nwesterhausen/domain-monitor) - monitor WHOIS records for specified domains. ([Source Code](https://github.com/nwesterhausen/domain-monitor)) `Go`
  - [Gatus](https://gatus.io) - automated developer-oriented status page with alerting and incident support. ([Source Code](https://github.com/TwiN/gatus)) `Go`
  - [Healthchecks](https://healthchecks.io) - cron job and background task monitoring service. ([Source Code](https://github.com/healthchecks/healthchecks)) `Python`
  - [Keep](https://www.keephq.dev) - open-source AIOps and alert management platform. ([Source Code](https://github.com/keephq/keep)) `Python` `TypeScript`
  - [LibreSpeed](https://librespeed.org) - speed test for HTML5 and more. ([Source Code](https://github.com/librespeed/speedtest)) `PHP` `JavaScript`
  - [NetAlertX](https://netalertx.com/) - network intruder and presence detector, scans for devices connected to your network and alerts you if new and unknown devices are found. ([Source Code](https://github.com/jokob-sk/NetAlertX)) `JavaScript` `Python` `PHP`
  - [Scanopy](https://scanopy.net) - clean network diagrams. ([Source Code](https://github.com/scanopy/scanopy)) `Rust` `Svelte`
  - [Signoz](https://signoz.io) - observability platform native to OpenTelemetry with logs, traces and metrics in a single application. ([Source Code](https://github.com/SigNoz/signoz)) `TypeScript` `Go`
  - [Uptime Kuma](https://uptime.kuma.pet) - fancy monitoring tool. ([Source Code](https://github.com/louislam/uptime-kuma)) `JavaScript` `Vue`
  - [WatchYourLAN](https://github.com/aceberg/WatchYourLAN) - lightweight network IP scanner, can be used to notify about new hosts and monitor host online/offline history. ([Source Code](https://github.com/aceberg/WatchYourLAN)) `TypeScript` `Go`
- **PKMS**
  - [Anytype](https://anytype.io) - the everything app for those who celebrate trust & autonomy. ([Source Code](https://github.com/anyproto/anytype-ts)) `TypeScript`
  - [ApiTable](https://aitable.ai/) - API-oriented low-code platform for building collaborative apps and better than all other Airtable open-source alternatives. ([Source Code](https://github.com/apitable/apitable)) `TypeScript` `Java`
  - [BookStack](https://www.bookstackapp.com) - platform to create documentation/wiki content. ([Source Code](https://github.com/BookStackApp/BookStack)) `PHP` `TypeScript`
  - [Excalidraw](https://excalidraw.com) - virtual whiteboard for sketching hand-drawn like diagrams. ([Source Code](https://github.com/excalidraw/excalidraw)) `TypeScript`
  - [Grist](https://www.getgrist.com) - modern relational spreadsheet. ([Source Code](https://github.com/gristlabs/grist-core)) `TypeScript` `Python`
  - [Joplin](https://joplinapp.org) - privacy-focused note taking app with sync capabilities for Windows, macOS, Linux, Android and iOS. ([Source Code](https://github.com/laurent22/joplin)) `TypeScript` `JavaScript`
  - [Memos](https://www.usememos.com) - knowledge management and note-taking platform designed for privacy-conscious users and organizations. ([Source Code](https://github.com/usememos/memos)) `Go` `TypeScript`
  - [NocoDB](https://nocodb.com) - open source Airtable alternative. ([Source Code](https://github.com/nocodb/nocodb)) `TypeScript` `Vue`
  - [Teable](https://teable.io) - next gen Airtable alternative, no-code Postgres. ([Source Code](https://github.com/teableio/teable)) `TypeScript`
  - [TypeMill](https://typemill.net) - flat-file CMS based on Markdown and designed for informational websites like documentation, manuals, and handbooks. ([Source Code](https://github.com/typemill/typemill)) `JavaScript` `PHP`
- **Project Management**
  - [kaneo](https://kaneo.app) - open source project management. ([Source Code](https://github.com/usekaneo/kaneo)) `TypeScript`
  - [Rustical](https://lennart-k.github.io/rustical) - calendar server aiming to be simple, fast and passwordless. ([Source Code](https://github.com/lennart-k/rustical)) `Rust`
  - [Worklenz](https://worklenz.com) - all in one project management tool for efficient teams. ([Source Code](https://github.com/Worklenz/worklenz)) `TypeScript` `JavaScript`
- **Proxy**
  - [Pangolin](https://digpangolin.com) - tunneled mesh reverse proxy server with identity and access control and dashboard UI. ([Source Code](https://github.com/fosrl/pangolin)) `TypeScript`
  - [Traefik Log Dashboard](https://github.com/hhftechnology/traefik-log-dashboard) - real-time dashboard for analyzing Traefik logs with IP geolocation, status code analysis, and service metrics. ([Source Code](https://github.com/hhftechnology/traefik-log-dashboard)) `TypeScript` `Go`
- **Remote**
  - [Defguard](https://defguard.net) - zero-trust access management with true WireGuard® 2FA/MFA. ([Source Code](https://github.com/DefGuard/defguard)) `Rust` `TypeScript`
  - [Shadow SOCKS](https://github.com/shadowsocks/shadowsocks-rust)
  - [Termix](https://termix.site) - Termix is a web-based server management platform with SSH terminal, tunneling, and file editing capabilities. ([Source Code](https://github.com/Termix-SSH/Termix)) `TypeScript`
  - TunnelMole:
    - [Client](https://github.com/robbie-cahill/tunnelmole-client)
    - [Service](https://github.com/robbie-cahill/tunnelmole-service)
- **Search**
  - [DumbWhoIs](https://dumbwhois.dumbware.io) - dumb whois. ([Source Code](https://github.com/DumbWareio/DumbWhoIs)) `JavaScript`
  - [Whoogle](https://pypi.org/project/whoogle-search) - ad-free, privacy-respecting metasearch engine. ([Source Code](https://github.com/benbusby/whoogle-search)) `Python`
- **Security**
  - [Authelia](https://www.authelia.com) - single sign-on multi-factor portal for web apps, now OpenID certified. ([Source Code](https://github.com/authelia/authelia)) `Go` `TypeScript`
  - [Certwarden](https://www.certwarden.com) -  centralized ACME client. ([Source Code](https://github.com/gregtwallace/certwarden))
  - [Cloudflared](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel) - cloudflare tunnel client. ([Source Code](https://github.com/cloudflare/cloudflared)) `Go`
  - [fail2ban-ui](https://fail2ban-ui.com) - web interface for operating Fail2Ban across one or more Linux hosts. ([Source Code](https://github.com/swissmakers/fail2ban-ui)) `Go` `JavaScript`
  - [GlitchTip](https://gitlab.com/glitchtip/glitchtip-backend) - Sentry API compatible error tracking platform. ([Source Code](https://gitlab.com/glitchtip/glitchtip-backend)) `Python`
  - [Keycloak](https://www.keycloak.org) - identity and access management for modern applications and services. ([Source Code](https://github.com/keycloak/keycloak)) `Java`
  - [Krawl](https://demo.krawlme.com/das_dashboard) - cloud native web deception server and anti-crawler that creates fake web applications with low-hanging vulnerabilities and realistic, randomly generated decoy data. ([Source Code](https://github.com/BlessedRebuS/Krawl)) `Python` `JavaScript`
  - [Maltrail](https://github.com/stamparm/maltrail) - malicious traffic detection system. ([Source Code](https://github.com/stamparm/maltrail)) `Python` `JavaScript`
  - [Patterns: OWASP CRS and Bad Bot Detection for Web Servers](https://github.com/fabriziosalmi/patterns) - Automated OWASP CRS and Bad Bot Detection for Nginx, Apache, Traefik and HaProxy. ([Source Code](https://github.com/fabriziosalmi/patterns)) `Python`
  - [Tinyauth](https://tinyauth.app) - simplest way to protect your apps with a login screen. ([Source Code](https://github.com/steveiliop56/tinyauth)) `Go` `TypeScript`
  - [Web-Check](https://web-check.xyz) - all-in-one OSINT tool for analyzing any website. ([Source Code](https://github.com/Lissy93/web-check)) `TypeScript` `JavaScript`
  - [Zitadel](https://zitadel.com) - identity infrastructure, simplified for you. ([Source Code](https://github.com/zitadel/zitadel)) `Go` `TypScript`
- **Social**
  - [bridge-manager](https://github.com/beeper/bridge-manager) - tool for running self-hosted bridges with the Beeper Matrix server. ([Source Code](https://github.com/beeper/bridge-manager)) `Go`
- **Software Development**
  - [ChartDB](https://chartdb.io) - . ([Source Code](https://github.com/chartdb/chartdb)) `TypeScript`
  - [Code Server](https://coder.com) - VS Code in the browser. ([Source Code](https://github.com/coder/code-server)) `TypeScript` `Shell`
  - [Coolify](https://coolify.io) - self-hostable PaaS alternative to Vercel, Heroku & Netlify. ([Source Code](https://github.com/coollabsio/coolify)) `PHP` `Blade`
  - [DevPush](https://devpu.sh) - like Vercel, but open source and for all languages. ([Source Code](https://github.com/hunvreus/devpush)) `Python`
- **Storage**
  - [Garage](https://garagehq.deuxfleurs.fr) - S3-compatible distributed object storage service. ([Source Code](https://git.deuxfleurs.fr/Deuxfleurs/garage)) `Rust`
  - [RustFS](https://rustfs.com/download) - high-performance distributed object storage for MinIO alternative. ([Source Code](https://github.com/rustfs/rustfs)) `Rust`
- **Surveys**
  - [Formbricks](https://formbricks.com) - open source Qualtrics alternative. ([Source Code](https://github.com/formbricks/formbricks)) `TypeScript`
- **Trello alternative** - [Find a kanban board](https://github.com/NatoBoram/docker-compose/issues/44)
  - [Focalboard](https://github.com/mattermost-community/focalboard) - ([Source Code](https://github.com/mattermost-community/focalboard))
  - [Kan](https://kan.bn) - open source Trello alternative. ([Source Code](https://github.com/kanbn/kan)) `TypeScript`
  - [Kanboard](https://kanboard.org) - Kanban project management software. ([Source Code](https://github.com/kanboard/kanboard)) `PHP`
  - [Leantime](https://leantime.io) - goals focused project management system for non-project managers. ([Source Code](https://github.com/Leantime/leantime)) `PHP` `JavaScript`
  - [Taiga](https://github.com/taigaio/taiga-docker) - ([Source Code](https://github.com/taigaio/taiga-docker)) `Shell`
  - [Vikunja](https://vikunja.io) - to-do app to organize your life. ([Source Code](https://github.com/go-vikunja/vikunja)) `Go` `Vue` `TypeScript`
  - [Wekan](https://wekan.fi) - open-source kanban. ([Source Code](https://github.com/wekan/wekan)) `JavaScript`
- **Wishlist**
  - [Christmas Community](https://github.com/Wingysam/Christmas-Community) - Christmas lists for families. ([Source Code](https://github.com/Wingysam/Christmas-Community))
- **Other**
  - [Aeterna](https://github.com/alpyxn/aeterna) - lightweight dead man's switch. ([Source Code](https://github.com/alpyxn/aeterna)) `JavaScript` `Go`
  - [Monica](https://beta.monicahq.com/login) - Personal CRM. Remember everything about your friends, family and business relationships. ([Source Code](https://github.com/monicahq/monica)) `PHP`
  - [Puter](https://puter.com) - The Internet Computer, free, open-source, and self-hostable. ([Source Code](https://github.com/HeyPuter/puter)) `JavaScript`
