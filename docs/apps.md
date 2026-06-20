# Self-Hosted Applications <!-- omit in toc -->

Here is a list of self-hosted apps that I am currently using, that could be interesting and further enhance the stack, as well as some that I no longer use or which are obsolete.

## Table of Contents <!-- omit in toc -->

- [Current](#current)
  - [Reverse Proxy](#reverse-proxy)
  - [DNS](#dns)
    - [Ad-blocker](#ad-blocker)
    - [Recursive DNS](#recursive-dns)
  - [Dashboard](#dashboard)
  - [Home Automation](#home-automation)
  - [Remote Access](#remote-access)
    - [VPN](#vpn)
    - [Clientless Remote Desktop Gateway (SSH, RDP...)](#clientless-remote-desktop-gateway-ssh-rdp)
    - [Remote Control Server](#remote-control-server)
  - [Monitoring](#monitoring)
  - [Backup](#backup)
  - [Security](#security)
  - [Search](#search)
  - [Media Storage](#media-storage)
    - [Bookmarks](#bookmarks)
    - [Books](#books)
    - [Files](#files)
    - [Music](#music)
    - [News](#news)
    - [Pictures](#pictures)
    - [Videos](#videos)
  - [Media Tools](#media-tools)
  - [Management](#management)
    - [Code](#code)
    - [Passwords](#passwords)
  - [Personal Knowledge Management System (PKMS)](#personal-knowledge-management-system-pkms)
  - [Artificial Intelligence](#artificial-intelligence)
  - [Automation](#automation)
  - [Development and Projects](#development-and-projects)
  - [Finances](#finances)
  - [Inventory](#inventory)
  - [Travel](#travel)
  - [Surveys](#surveys)
  - [Games](#games)
- [Enhancements](#enhancements)
  - [Artificial Intelligence](#artificial-intelligence-1)
  - [Backup](#backup-1)
  - [Containers](#containers)
  - [Dashboard](#dashboard-1)
  - [Databases](#databases)
  - [DNS](#dns-1)
  - [Finances](#finances-1)
  - [Fitness](#fitness)
  - [Games](#games-1)
  - [Health](#health)
  - [Home Automation](#home-automation-1)
  - [Inventory](#inventory-1)
  - [Location \& Travel](#location--travel)
  - [Mail](#mail)
  - [Maintenance](#maintenance)
  - [Management](#management-1)
    - [Ads](#ads)
    - [Code](#code-1)
    - [Passwords](#passwords-1)
  - [Media Management](#media-management)
  - [Media Storage](#media-storage-1)
    - [Audiobooks](#audiobooks)
    - [Bookmarks](#bookmarks-1)
    - [Files](#files-1)
    - [Pictures](#pictures-1)
    - [Music](#music-1)
    - [News](#news-1)
    - [Videos](#videos-1)
  - [Media Tools](#media-tools-1)
  - [Monitoring](#monitoring-1)
  - [PKMS](#pkms)
  - [Project Management](#project-management)
  - [Proxy](#proxy)
  - [Remote](#remote)
  - [Search](#search-1)
  - [Security](#security-1)
  - [Social](#social)
  - [Software Development](#software-development)
  - [Storage](#storage)
  - [Surveys](#surveys-1)
  - [Trello alternative - Find a kanban board](#trello-alternative---find-a-kanban-board)
  - [Wishlist](#wishlist)
  - [Other](#other)

## Current

### Reverse Proxy

- [Traefik](https://traefik.io/traefik) - cloud native application proxy. ([Source Code](https://github.com/traefik/traefik)) `Go`

### DNS

#### Ad-blocker

- [Pi-hole](https://pi-hole.net) - a black hole for Internet advertisements. ([Source Code](https://github.com/pi-hole/pi-hole)) `Shell` `Python`

#### Recursive DNS

- [Unbound](https://www.nlnetlabs.nl/projects/unbound/about)

### Dashboard

- [Homarr](https://homarr.dev) - modern and easy to use dashboard. ([Source Code](https://github.com/homarr-labs/homarr)) `TypeScript`
- [Homer](https://homer-demo.netlify.app) - very simple static homepage for your server. ([Source Code](https://github.com/bastienwirtz/homer)) `Vue` `JavaScript`

### Home Automation

- [Home Assistant](https://www.home-assistant.io) - home automation that puts local control and privacy first. ([Source Code](https://github.com/home-assistant/core)) `Python`
- [UpSnap](https://github.com/seriousm4x/UpSnap) - simple wake on lan web app. ([Source Code](https://github.com/seriousm4x/UpSnap)) `Svelte` `Go`

### Remote Access

#### VPN

- [Wireguard](https://www.wireguard.com)
- [Wireguard Easy](https://github.com/wg-easy/wg-easy) - easiest way to run WireGuard VPN + Web-based Admin UI. ([Source Code](https://github.com/wg-easy/wg-easy)) `TypeScript` `Vue`

#### Clientless Remote Desktop Gateway (SSH, RDP...)

- [Apache Guacamole](https://guacamole.apache.org) - clientless remote desktop gateway. It supports standard protocols like VNC, RDP, and SSH. ([Source Code](https://github.com/apache/guacamole-server)) `C`

#### Remote Control Server

- [RustDesk](https://rustdesk.com) - remote desktop application designed for self-hosting, as an alternative to TeamViewer. ([Source Code](https://github.com/rustdesk/rustdesk-server)) `Rust`

### Monitoring

- [changedetection.io](https://changedetection.io) - web page change detection, website watcher, restock monitor and notification service. ([Source Code](https://github.com/dgtlmoon/changedetection.io)) `Python`
- [Diun](https://crazymax.dev/diun) - receive notifications when an image is updated on a Docker registry. ([Source Code](https://github.com/crazy-max/diun)) `Go`
- [Dozzle](https://dozzle.dev) - realtime log viewer for docker containers. ([Source Code](https://github.com/amir20/dozzle)) `Go` `Vue` `TypeScript`
- [Grafana](https://grafana.com) - open and composable observability and data visualization platform.  ([Source Code](https://github.com/grafana/grafana)) `TypeScript` `Go`
- [ntfy](https://ntfy.sh) - send push notifications to your phone or desktop using PUT/POST. ([Source Code](https://github.com/binwiederhier/ntfy)) `Go` `JavaScript`
- [Scrutiny](https://github.com/AnalogJ/scrutiny) - hard drive S.M.A.R.T monitoring, historical trends & real world failure thresholds. ([Source Code](https://github.com/AnalogJ/scrutiny)) `Go`

### Backup

- [Kopia](https://kopia.io) - cross-platform backup tool with fast, incremental backups, client-side end-to-end encryption, compression and data deduplication. CLI and GUI included. ([Source Code](https://github.com/kopia/kopia)) `Go`

### Security

- [Authentik](https://goauthentik.io) - authentication glue you need. ([Source Code](https://github.com/goauthentik/authentik)) `Python` `TypeScript`
- [CrowdSec](https://app.crowdsec.net) - open-source and participative security solution offering crowdsourced protection against malicious IPs and access to the most advanced real-world CTI. ([Source Code](https://github.com/crowdsecurity/crowdsec)) `Go` `Shell`
- [Enclosed](https://enclosed.cc) - Minimalistic web app designed for sending private and secure notes. ([Source Code](https://github.com/CorentinTh/enclosed)) `TypeScript`
- [Gluetun](https://github.com/qdm12/gluetun-wiki) - VPN client in a thin Docker container for multiple VPN providers, and using OpenVPN or Wireguard, DNS over TLS, with a few proxy servers built-in. ([Source Code](https://github.com/qdm12/gluetun)) `Go`
- [Wazuh](https://wazuh.com) - open source security platform, unified XDR and SIEM protection for endpoints and cloud workloads. ([Source Code](https://github.com/wazuh/wazuh)) `C` `C++` `Python`

### Search

- [SearXNG](https://docs.searxng.org) - free internet metasearch engine which aggregates results from various search services and databases, users are neither tracked nor profiled. ([Source Code](https://github.com/searxng/searxng)) `Python`

### Media Storage

#### Bookmarks

- [Karakeep](https://karakeep.app/) - bookmark-everything app (links, notes and images) with AI-based automatic tagging and full text search. ([Source Code](https://github.com/karakeep-app/karakeep)) `TypeScript`
- [Linkace](https://www.linkace.org) - archive to collect links of your favorite websites. ([Source Code](https://github.com/Kovah/LinkAce)) `PHP` `Blade`

#### Books

- [Kavita](https://www.kavitareader.com) - fast, feature rich, cross platform reading server. ([Source Code](https://github.com/Kareadita/Kavita)) `C#` `TypeScript`
- [Librum](https://librumreader.com) - manage your own online library and access it from any device anytime, anywhere. No web-interface, need to install the desktop app as well. ([Source Code](https://github.com/Librum-Reader/Librum)) `C++` `QML`

#### Files

- [NextCloud](https://nextcloud.com) - a safe home for all your data. ([Source Code](https://github.com/nextcloud/server)) `PHP` `JavaScript`
- [Paperless](https://docs.paperless-ngx.com) - document management system: scan, index and archive all your documents. ([Source Code](https://github.com/paperless-ngx/paperless-ngx)) `Python` `TypeScript`
- [SFTPGo](https://sftpgo.com) - full-featured and highly configurable SFTP, HTTP/S, FTP/S and WebDAV server. ([Source Code](https://github.com/drakkan/sftpgo)) `Go`

#### Music

- [Navidrome](https://www.navidrome.org) - personal streaming service. ([Source Code](https://github.com/navidrome/navidrome)) `Go` `JavaScript`

#### News

- [FreshRSS](https://freshrss.org/index.html) -  news aggregator. ([Source Code](https://github.com/FreshRSS/FreshRSS)) `PHP`

#### Pictures

- [Immich](https://immich.app) - high performance self-hosted photo and video management solution. ([Source Code](https://github.com/immich-app/immich)) `TypeScript` `Dart` `Svelte`
- [Meme Search](https://github.com/neonwatty/meme-search) - meme search engine and finder. ([Source Code](https://github.com/neonwatty/meme-search)) `Ruby` `Python`
- [Photoprism](https://www.photoprism.app) - photos app for the decentralized web. ([Source Code](https://github.com/photoprism/photoprism)) `Go` `JavaScript`
- [Pinry](https://github.com/pinry/pinry) - tiling image board system for people who want to save, tag, and share images, videos and webpages in an easy to skim through format. ([Source Code](https://github.com/pinry/pinry)) `Python`

#### Videos

- [Jellyfin](https://jellyfin.org) - free software media system. ([Source Code](https://github.com/jellyfin/jellyfin)) `C#`

### Media Tools

- [BentoPDF](https://bentopdf.com) - privacy first PDF toolkit. ([Source Code](https://github.com/alam00000/bentopdf)) `JavaScript` `Fluent` `TypeScript`
- [ConvertX](https://github.com/C4illin/ConvertX) - online file converter. Supports 1000+ formats. ([Source Code](https://github.com/C4illin/ConvertX)) `TypeScript`
- [Docuseal](https://www.docuseal.co) - open source DocuSign alternative. ([Source Code](https://github.com/docusealco/docuseal)) `Ruby` `Vue` `JavaScript`
- [Gokapi](https://github.com/Forceu/Gokapi) - lightweight Firefox Send alternative without public upload. ([Source Code](https://github.com/Forceu/Gokapi)) `Go` `JavaScript`
- [iSponsorBlockTV](https://github.com/dmunozv04/iSponsorBlockTV) - SponsorBlock client for all YouTube TV clients. ([Source Code](https://github.com/dmunozv04/iSponsorBlockTV)) `Python`
- [QBittorent](https://github.com/linuxserver/docker-qbittorrent) - torrent client based on the Qt toolkit and libtorrent-rasterbar library. ([Source Code](https://github.com/linuxserver/docker-qbittorrent))
- [Stirling-PDF](https://stirlingtools.com) - allows you to perform various operations on PDF files. ([Source Code](https://github.com/Stirling-Tools/Stirling-PDF)) `Java` `JavaScript`

### Management

#### Code

- [ByteStash](https://github.com/jordan-dalby/bytestash) - a code snippet storage solution written in React & node.js. ([Source Code](https://github.com/jordan-dalby/bytestash)) `TypeScript`
- [Forgejo](https://forgejo.org) - Beyond coding, we forge. ([Source Code](https://codeberg.org/forgejo/forgejo)) `Go`
- [Gitea Mirror](https://giteamirror.com) - auto-syncs GitHub repos to your self-hosted Gitea/Forgejo, with a sleek Web UI and easy Docker deployment. ([Source Code](https://github.com/RayLabsHQ/gitea-mirror)) `TypeScript`
- [Gitlab](https://gitlab.com/gitlab-org/gitlab) `Ruby`
- [IT-Tools](https://it-tools.tech) - collection of handy online tools for developers, with great UX. ([Source Code](https://github.com/corentinth/it-tools)) `Vue` `TypeScript`
- [Wakapi](https://wakapi.dev) - minimalist, self-hosted WakaTime-compatible backend for coding statistics. ([Source Code](https://github.com/muety/wakapi)) `Go`

#### Passwords

- [Vaultwarden](https://github.com/dani-garcia/vaultwarden) - unofficial Bitwarden compatible server, formerly known as bitwarden_rs. ([Source Code](https://github.com/dani-garcia/vaultwarden)) `Rust`

### Personal Knowledge Management System (PKMS)

- [Affine](https://affine.pro) - knowledge base that brings planning, sorting, creating all together. Privacy first and open-source. ([Source Code](https://github.com/toeverything/AFFiNE)) `TypeScript`
- [Mathesar](https://mathesar.org) - spreadsheet-like interface that lets users of all technical skill levels view, edit, query, and collaborate on Postgres data directly. ([Source Code](https://github.com/mathesar-foundation/mathesar)) `Svelte` `TypeScript` `Python`
- [Memos](https://github.com/usememos/memos) - note-taking service, your thoughts, your data, your control — no tracking, no ads, no subscription fees. ([Source Code](https://github.com/usememos/memos)) `Go` `TypeScript`
- [Siyuan](https://b3log.org/siyuan/en) - privacy-first, self-hosted, fully open source personal knowledge management software. ([Source Code](https://github.com/siyuan-note/siyuan)) `TypeScript` `Go`

### Artificial Intelligence

- [Hermes](https://hermes-agent.nousresearch.com) - the agent that grows with you. ([Source Code](https://github.com/NousResearch/hermes-agent)) `Python` `TypeScript`
- [Honcho](https://docs.honcho.dev) - memory library for building stateful agents. ([Source Code](https://github.com/plastic-labs/honcho)) `Python`
- [LiteLLM](https://www.litellm.ai) - Python SDK, proxy server (LLM gateway) to call 100+ LLM APIs in OpenAI format. ([Source Code](https://github.com/BerriAI/litellm)) `Python`
- [Ollama](https://ollama.com) - get up and running with Llama 3.3, DeepSeek-R1, Phi-4, Gemma 3, and other large language models. ([Source Code](https://github.com/ollama/ollama)) `Go`
- [OpenConcho](https://github.com/offendingcommit/openconcho) - privacy-first desktop & web UI for self-hosted Honcho, browse memories, peers, sessions, conclusions, and chat with memory context. ([Source Code](https://github.com/offendingcommit/openconcho)) `TypeScript`
- [Open WebUI](https://openwebui.com) - user-friendly AI Interface (supports Ollama, OpenAI API, ...). ([Source Code](https://github.com/open-webui/open-webui)) `JavaScript` `Svelte` `Python`

### Automation

- [n8n](https://n8n.io) -  workflow automation platform with native AI capabilities, combine visual building with custom code, self-host or cloud, 400+ integrations. ([Source Code](https://github.com/n8n-io/n8n)) `TypeScript`

### Development and Projects

- [Directus](https://directus.io) backend for all your projects, turn your DB into a headless CMS, admin panels, or apps with a custom UI, instant APIs, auth & more. ([Source Code](https://github.com/directus/directus)) `TypeScript`

### Finances

- [Actual](https://actualbudget.com) - local-first personal finance app. ([Source Code](https://github.com/actualbudget/actual)) `TypeScript`
- [Wallos](https://wallosapp.com) - open-source personal subscription tracker. ([Source Code](https://github.com/ellite/wallos)) `PHP` `JavaScript`

### Inventory

- [Grocy](https://grocy.info) - groceries & household management solution for your home. ([Source Code](https://github.com/grocy/grocy)) `Blade` `TypeScript` `PHP`
- [HortusFox](https://hortusfox.com) - collaborative plant management platform. ([Source Code](https://github.com/danielbrendel/hortusfox-web))
- [Homebox](https://homebox.software/en) - inventory and organization system built for the home user. ([Source Code](https://github.com/sysadminsmedia/homebox)) `Go` `Vue` `TypeScript`
- [Mealie](https://docs.mealie.io) - recipe manager and meal planner with a RestAPI backend and a reactive frontend application built in Vue for a pleasant user experience for the whole family. ([Source Code](https://github.com/mealie-recipes/mealie)) `Python` `Vue` `TypeScript`
- [Wishlist](https://github.com/cmintey/wishlist) - wishlist application that you can share with your friends and family. ([Source Code](https://github.com/cmintey/wishlist)) `Svelte` `TypeScript`

### Travel

- [AdventureLog](https://adventurelog.app) - travel tracker and trip planner. ([Source Code](https://github.com/seanmorley15/AdventureLog)) `Svelte` `Python`
- [Dawarich](https://dawarich.app) - alternative to Google location history (Google Maps timeline). ([Source Code](https://github.com/Freika/dawarich)) `Ruby` `JavaScript`
- [Jetlog](https://github.com/pbogre/jetlog) - personal flight tracker and viewer. ([Source Code](https://github.com/pbogre/jetlog)) `TypeScript` `Python`

### Surveys

- [Limesurvey](https://www.limesurvey.org) - alternative to SurveyMonkey, Typeform, Qualtrics, and Google Forms, making it simple to create online surveys and forms with unmatched flexibility. ([Source Code](https://github.com/LimeSurvey/LimeSurvey)) `JavaScript`  `PHP`

### Games

- [Minecraft Server](https://docker-minecraft-server.readthedocs.io/en/latest) - Minecraft Server for Java Edition that automatically downloads selected version at startup. Deployed on `<ip-address>:25565`. ([Source Code](https://github.com/itzg/docker-minecraft-server)) `Shell`
- [Romm](https://romm.app) - beautiful, powerful, self-hosted rom manager and player. ([Source Code](https://github.com/rommapp/romm)) `Python` `Vue`

## Enhancements

### Artificial Intelligence

- [firecrawl](https://firecrawl.dev) - web data API for AI - Turn entire websites into LLM-ready markdown or structured data. ([Source Code](https://github.com/firecrawl/firecrawl)) `TypeScript` `Python`
- [odysseus](https://pewdiepie-archdaemon.github.io/odysseus) - self-hosted AI workspace. ([Source Code](https://github.com/pewdiepie-archdaemon/odysseus)) `Python` `JavaScript`
- [onyx](https://onyx.app) - AI platform / chat with advanced features that works with every LLM. ([Source Code](https://github.com/onyx-dot-app/onyx)) `Python` `TypeScript`

### Backup

- [Backrest](https://github.com/garethgeorge/backrest) - Backrest is a web UI and orchestrator for restic backup. ([Source Code](https://github.com/garethgeorge/backrest)) `Go` `TypeScript`
- [Borg](https://www.borgbackup.org) - deduplicating archiver with compression and authenticated encryption. ([Source Code](https://github.com/borgbackup/borg)) `Python`
- [Pluton](https://usepluton.com) - backup solution for secure, encrypted backups across local and cloud storage. ([Source Code](https://github.com/plutonhq/pluton)) `TypeScript`
- [Zerobyte](https://github.com/nicotsx/zerobyte) - backup automation for self-hosting, built on top of restic. ([Source Code](https://github.com/nicotsx/zerobyte)) `TypeScript`

### Containers

- [Any Sync Docker Compose](https://github.com/anyproto/any-sync-dockercompose) - docker-compose for testing any-sync. ([Source Code](https://github.com/anyproto/any-sync-dockercompose)) `Shell` `Python`
- [CAdvisor](https://github.com/google/cadvisor) - analyzes resource usage and performance characteristics of running containers. ([Source Code](https://github.com/google/cadvisor)) `Go`
- [Dockge](https://dockge.kuma.pet) - docker compose.yaml stack-oriented manager. ([Source Code](https://github.com/louislam/dockge)) `TypeScript`
- [Komodo](https://komo.do) - tool to build and deploy software on many servers. ([Source Code](https://github.com/moghtech/komodo)) `Rust` `TypeScript`
- [Portainer](https://www.portainer.io) - making Docker and Kubernetes management easy. ([Source Code](https://github.com/portainer/portainer)) `TypeScript` `Go`

### Dashboard

- [Astroluma](https://getastroluma.com) - dashboard designed to help you manage multiple aspects of your daily tasks and services. ([Source Code](https://github.com/Sanjeet990/Astroluma)) `JavaScript`
- [Dashy](https://dashy.to) - personal dashboard built for you. Includes status-checking, widgets, themes, icon packs, a UI editor and tons more. ([Source Code](https://github.com/Lissy93/dashy)) `Vue` `JavaScript`
- [Glance](https://github.com/glanceapp/glance) - dashboard that puts all your feeds in one place. ([Source Code](https://github.com/glanceapp/glance)) `Go` `JavaScript`
- [Heimdall](https://heimdall.site) - application dashboard and launcher. ([Source Code](https://github.com/linuxserver/Heimdall)) `PHP`
- [Organizr](https://demo.organizr.app) - HTPC/Homelab Services Organizer - Written in PHP. ([Source Code](https://github.com/causefx/Organizr)) `PHP` `JavaScript`
- [Trala](https://www.trala.fyi) -  simple, modern, and dynamic dashboard for your Traefik services. ([Source Code](https://github.com/dannybouwers/trala)) `Go`

### Databases

- [milvus](https://milvus.io) - high-performance, cloud-native vector database built for scalable vector ANN search. ([Source Code](https://github.com/milvus-io/milvus)) `Go` `Python` `C++`
- [qdrant](https://qdrant.tech) - high-performance, massive-scale vector database and vector search engine for the next generation of AI. ([Source Code](https://github.com/qdrant/qdrant)) `Rust`
- [turso](https://github.com/tursodatabase/turso) - in-process SQL database, compatible with SQLite ([Source Code](https://github.com/tursodatabase/turso)). `Rust`
- [weaviate](https://weaviate.io/developers/weaviate) - vector database that stores both objects and vectors, allowing for the combination of vector search with structured filtering with the fault tolerance and scalability of a cloud-native database​. ([Source Code](https://github.com/weaviate/weaviate)) `Go`

### DNS

- [AdGuardHome](https://adguard.com/en/adguard-home/overview.html) - network-wide ads & trackers blocking DNS server. ([Source Code](https://github.com/AdguardTeam/AdguardHome)) `Go` `TypeScript`
- [Blocky](https://0xerr0r.github.io/blocky/latest) - fast and lightweight DNS proxy as ad-blocker for local network with many features. ([Source Code](https://github.com/0xERR0R/blocky)) `Go`
- [Technitium](https://technitium.com/dns) - Technitium DNS server. ([Source Code](https://github.com/TechnitiumSoftware/DnsServer)) `C#`

### Finances

- [Actual AI](https://github.com/sakowicz/actual-ai) - categorize transactions in Actual Budget using AI. ([Source Code](https://github.com/sakowicz/actual-ai)) `TypeScript`
- [Cents per Point](https://github.com/ayostepht/Cents-Per-Point) - track credit card point redemptions and calculate Cents Per Point (CPP) values to optimize your rewards strategy. ([Source Code](https://github.com/ayostepht/Cents-Per-Point)) `JavaScript`
- [DollarDollar](https://ddby.finforward.xyz/dashboard) - expense splitting. ([Source Code](https://github.com/harung1993/dollardollar)) `JavaScript` `Python`
- [Firefly III](https://firefly-iii.org) - personal finances manager. ([Source Code](https://github.com/firefly-iii/firefly-iii)) `PHP` `JavaScript`
- [Ghostfolio](https://ghostfol.io/en/start) - wealth management software. ([Source Code](https://github.com/ghostfolio/ghostfolio)) `TypeScript`
- [Investbrain](https://investbra.in) - investment tracker that consolidates and monitors market performance across your different brokerages. ([Source Code](https://github.com/investbrainapp/investbrain)) `PHP`
- [Invoice Ninja](https://invoiceninja.com) - invoice, quote, project and time-tracking app. ([Source Code](https://github.com/invoiceninja/invoiceninja)) `PHP`
- [Maybe](https://github.com/maybe-finance/maybe) - OS for your personal finances. ([Source Code](https://github.com/maybe-finance/maybe)) `Ruby`
- [Monetr](https://monetr.app) - budgeting application focused on planning for recurring expenses. ([Source Code](https://github.com/monetr/monetr)) `Go` `TypeScript`
- [MoneyPrinter](https://github.com/FujiwaraChoki/MoneyPrinterV2) - automate the process of making money online. ([Source Code](https://github.com/FujiwaraChoki/MoneyPrinterV2)) `Python`
- [OpenBB](https://openbb.co) - financial data platform for analysts, quants and AI agents. ([Source Code](https://github.com/OpenBB-finance/OpenBB)) `Python`
- [Subscription Manager](https://github.com/dh1011/subscription-manager) - keep track of your subscriptions and manage your expenses. ([Source Code](https://github.com/dh1011/subscription-manager)) `JavaScript` `Python`
- [Wapy.dev](https://www.wapy.dev) - track, manage and optimize your recurring expenses in one powerful and human readable dashboard. ([Source Code](https://github.com/meceware/wapy.dev)) `JavaScript`

### Fitness

- [Endurain](https://docs.endurain.com) - fitness tracking service designed to give users full control over their data and hosting environment. ([Source Code](https://github.com/endurain-project/endurain)) `Python`

### Games

- [En Croissant](https://encroissant.org) - the ultimate chess toolkit. ([Source Code](https://github.com/franciscoBSalgueiro/en-croissant)) `TypeScript` `Rust`
- [Factorio](https://hub.docker.com/r/factoriotools/factorio) - headless server in a Docker container. ([Source Code](https://github.com/factoriotools/factorio-docker)) `Shell` `Python` `C`
- [GameVault](https://gamevau.lt) - self-hosted gaming platform for drm-free games. ([Source Code](https://github.com/Phalcode/gamevault-backend)) `TypeScript`
- [Lodestone](https://www.lodestone.cc) - server hosting tool for Minecraft and other multiplayer games. ([Source Code](https://github.com/Lodestone-Team/lodestone)) `Rust` `TypeScript`
- [Paper](https://papermc.io/software/paper) - high performance Minecraft server that aims to fix gameplay and mechanics inconsistencies. ([Source Code](https://github.com/PaperMC/Paper)) `Java`
- [Satisfactory](https://hub.docker.com/r/wolveix/satisfactory-server) - containerized version of the Satisfactory dedicated server. ([Source Code](https://github.com/wolveix/satisfactory-server)) `Shell` `Go`
- [Sunshine](https://app.lizardbyte.dev/Sunshine/?lng=en) - game stream host for Moonlight. ([Source Code](https://github.com/LizardByte/Sunshine)) `C++`
- [Valheim](https://github.com/Nimdy/Dedicated_Valheim_Server_Script) - Valheim server manager. ([Source Code](https://github.com/Nimdy/Dedicated_Valheim_Server_Script)) `Shell`
- [Wolf](https://games-on-whales.github.io/wolf/stable) - stream virtual desktops and games running in Docker. ([Source Code](https://github.com/games-on-whales/wolf)) `C++`

### Health

- [Fasten Health](https://www.fastenhealth.com) - personal/family electronic medical record aggregator, designed to integrate with 100,000's of insurances/hospitals/clinics. ([Source Code](https://github.com/fastenhealth/fasten-onprem)) `Go` `TypeScript`
- [OpenEMR](https://www.open-emr.org) - electronic health records and medical practice management solution. ([Source Code](https://github.com/openemr/openemr)) `PHP`

### Home Automation

- [Wakezilla](https://github.com/guibeira/wakezilla) - simple Wake-on-LAN & reverse proxy toolkit — wake, route, and control your machines from anywhere. ([Source Code](https://github.com/guibeira/wakezilla)) `Rust`
- [Wol](https://github.com/Trugamr/wol) - Wake-On-LAN tool that works via CLI and web interface. ([Source Code](https://github.com/Trugamr/wol)) `Go`

### Inventory

- [Bar Assistant](https://barassistant.app) - home bar management. ([Source Code](https://github.com/karlomikus/bar-assistant)) `PHP`
- [Lubelogger](https://lubelogger.com) - vehicle maintenance and fuel mileage tracker. ([Source Code](https://github.com/hargata/lubelog)) `JavaScript` `C#`
- [Sprout Track](https://www.sprout-track.com) - tracker to track baby diapers, feedings, naps, pumping, and other activities. ([Source Code](https://github.com/Oak-and-Sprout/sprout-track)) `TypeScript`
- [VoucherVault](https://github.com/l4rm4nd/VoucherVault/wiki) - store and manage vouchers, coupons, loyalty and gift cards digitally. ([Source Code](https://github.com/l4rm4nd/VoucherVault)) `Python`
- [Warracker](https://warracker.com) - web application to manage product warranties, track expiration dates, and store related documents. ([Source Code](https://github.com/sassanix/Warracker)) `JavaScript` `Python`

### Location & Travel

- [Scratch Map](https://github.com/ad3m3r5/scratch-map) - scratch-off style map to track your travels. ([Source Code](https://github.com/ad3m3r5/scratch-map)) `JavaScript`
- [Statistics for Strava](https://statistics-for-strava.robiningelbrecht.be/dashboard) - statistics generated using Strava data. ([Source Code](https://github.com/robiningelbrecht/statistics-for-strava)) `PHP`
- [TREK](https://demo-nomad.pakulat.org) - travel/trip planner with real-time collaboration, interactive maps, PWA support, SSO, budgets, packing lists, and more. ([Source Code](https://github.com/mauriceboe/TREK)) `TypeScript`
- [VFD](https://github.com/kiinami/vfd) - flight price tracking script. ([Source Code](https://github.com/kiinami/vfd)) `Python`
- [Wanderer](https://wanderer.to) - trail database, save your adventures. ([Source Code](https://github.com/Flomp/wanderer)) `Svelte` `Go` `TypeScript`

### Mail

- [docker-mailserver](https://docker-mailserver.github.io/docker-mailserver/latest) - production-ready fullstack but simple mail server (SMTP, IMAP, LDAP, Antispam, Antivirus, etc.) running inside a container. ([Source Code](https://github.com/docker-mailserver/docker-mailserver)) `Shell`
- [Maddy](https://maddy.email) - composable all-in-one mail server. ([Source Code](https://github.com/foxcpp/maddy)) `Go`
- [OpenArchiver](https://openarchiver.com) - platform for legally compliant email archiving. ([Source Code](https://github.com/LogicLabs-OU/OpenArchiver)) `TypeScript` `Svelte`
- [Piler](https://www.mailpiler.org) - email archiving application. ([Source Code](https://github.com/jsuto/piler)) `PHP`
- [simple-login](https://simplelogin.io) - simple login back-end and web app. ([Source Code](https://github.com/simple-login/app)) `Python` `JavaScript`

### Maintenance

- [olivetin](https://olivetin.app) -  safe and simple access to predefined shell commands from a web interface. ([Source Code](https://github.com/OliveTin/OliveTin)) `Go` `JavaScript`

### Management

#### Ads

- [Plausible](https://plausible.io) - simple, open source, lightweight (< 1 KB) and privacy-friendly web analytics alternative to Google Analytics. ([Source Code](https://github.com/plausible/analytics)) `Elixir`
- [Umami](https://github.com/umami-software/umami) - modern, privacy-focused alternative to Google Analytics. ([Source Code](https://github.com/umami-software/umami)) `TypeScript`

#### Code

- [Bugsink](https://www.bugsink.com) - error tracking. ([Source Code](https://github.com/bugsink/bugsink)) `Python`
- [Cyber Chef](https://gchq.github.io/CyberChef) - web app for encryption, encoding, compression and data analysis. ([Source Code](https://github.com/gchq/CyberChef)) `JavaScript`
- [Gitea](https://gitea.com) - all-in-one software development service, including Git hosting, code review, team collaboration, package registry and CI/CD. ([Source Code](https://github.com/go-gitea/gitea)) `Go`
- [Networking Toolbox](https://networkingtoolbox.net) - . ([Source Code](https://github.com/Lissy93/networking-toolbox)) `Svelte` `TypeScript`
- [OpenGist](https://opengist.io) - pastebin powered by Git, open-source alternative to Github Gist. ([Source Code](https://github.com/thomiceli/opengist)) `Go` `TypeScript`
- [PyPI Server](https://hub.docker.com/r/pypiserver/pypiserver) - minimal PyPI server for uploading & downloading packages with pip. Source code [here](https://github.com/pypiserver/pypiserver). `Python`
- [Sentry](https://sentry.io/welcome) - feature-complete and packaged up for low-volume deployments and proofs-of-concept. ([Source Code](https://github.com/getsentry/self-hosted)) `Shell` `Python`
- [woodpecker](https://woodpecker-ci.org) - simple, yet powerful CI/CD engine with great extensibility. ([Source Code](https://github.com/woodpecker-ci/woodpecker)) `Go`
- [Ziit](https://ziit.app/login) - swiss army knife of code time tracking. ([Source Code](https://github.com/0PandaDEV/Ziit)) `TypeScript` `Vue`

#### Passwords

- [AliasVault](https://www.aliasvault.net) - end-to-end encrypted password manager with a built-in alias generator and email server. ([Source Code](https://github.com/lanedirt/AliasVault)) `C#` `TypeScript`

### Media Management

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

### Media Storage

#### Audiobooks

- [Audiobookshelf](https://audiobookshelf.org) - audiobook and podcast server. ([Source Code](https://github.com/advplyr/audiobookshelf)) `JavaScript` `Vue`

#### Bookmarks

- [Linkwarden](https://linkwarden.app) - collaborative bookmark manager to collect, organize, and preserve webpages, articles, and documents. ([Source Code](https://github.com/linkwarden/linkwarden)) `TypeScript`

#### Files

- [dufs](https://github.com/sigoden/dufs) - file server that supports static serving, uploading, searching, accessing control, webdav. ([Source Code](https://github.com/sigoden/dufs)) `Rust`
- [filestash](https://www.filestash.app) - file management platform, universal data access layer (without FUSE). ([Source Code](https://github.com/mickael-kerjean/filestash)) `Go` `JavaScript`
- [myDrive](https://mydrive-storage.com) - node.js and mongoDB Google Drive clone. ([Source Code](https://github.com/subnub/myDrive)) `TypeScript`
- [OxiCloud](https://github.com/DioCrafts/OxiCloud) - ultra-fast, secure & lightweight self-hosted cloud storage — your files, photos, calendars & contacts, all in one place. ([Source Code](https://github.com/DioCrafts/OxiCloud)) `Rust` `JavaScript`
- [Paperless AI](https://clusterzx.github.io/paperless-ai) - automated document analyzer for paperless-ngx using OpenAI API, Ollama, Deepseek-r1, Azure and all OpenAI API compatible services to automatically analyze and tag your documents. ([Source Code](https://github.com/clusterzx/paperless-ai)) `JavaScript`
- [Papra](https://demo.papra.app) - minimalistic document archiving platform. ([Source Code](https://github.com/papra-hq/papra)) `TypeScript`
- [Seafile](http://seafile.com) - beyond file syncing and sharing, a new way to organize your files with extensible file properties and flexible views. ([Source Code](https://github.com/haiwen/seafile)) `C` `Python`

#### Pictures

- [Photoview](https://photoview.github.io) - photo gallery for personal servers. ([Source Code](https://github.com/photoview/photoview)) `TypeScript` `Go`
- [WeddingShare](https://docs.wedding-share.org) - place for guests to view and drop pictures of the big day. ([Source Code](https://github.com/Cirx08/WeddingShare)) `JavaScript` `C#`

#### Music

- [Ampache](https://ampache.org) - web based audio/video streaming application and file manager allowing you to access your music & videos from anywhere, using almost any internet enabled device. ([Source Code](https://github.com/ampache/ampache)) `PHP`
- [Finamp (Jellyfin music client for mobile)](https://github.com/jmshrv/finamp)
- [Koel](https://koel.dev) - a personal music streaming server that works. ([Source Code](https://github.com/koel/koel)) `PHP` `TypeScript`

#### News

- [Miniflux](https://miniflux.app) - minimalist and opinionated feed reader. ([Source Code](https://github.com/miniflux/v2)) `Go`

#### Videos

- [BitPlay](https://github.com/aculix/bitplay) - stream video torrents in your web browser with ease. ([Source Code](https://github.com/aculix/bitplay)) `Go`
- [Kodi](https://kodi.tv) - open source home theater/media center software and entertainment hub for digital media. ([Source Code](https://github.com/xbmc/xbmc)) `C++`
- [Plex](https://www.plex.tv) - Plex Media Server Docker repo, for all your PMS docker needs. ([Source Code](https://github.com/plexinc/pms-docker))
- [Streamyfin](https://streamyfin.app) - modern Jellyfin client. ([Source Code](https://github.com/streamyfin/streamyfin)) `TypeScript`
- [Streamystats](https://github.com/fredrikburmester/streamystats) - statistics service for Jellyfin, providing analytics and data visualization. ([Source Code](https://github.com/fredrikburmester/streamystats)) `TypeScript`
- Web
- [ArchiveBox](https://archivebox.io) - web archiving that takes URLs/browser history/bookmarks/Pocket/Pinboard/etc. ([Source Code](https://github.com/ArchiveBox/ArchiveBox)) `Python`

### Media Tools

- [Ashim](https://ashim-hq.github.io/ashim) - image manipulator, 45+ tools, local AI, and pipelines. ([Source Code](https://github.com/ashim-hq/ashim)) `TypeScript`
- [Cobalt](https://cobalt.tools) - best way to save what you love. ([Source Code](https://github.com/imputnet/cobalt)) `Svelte` `JavaScript` `TypeScript`
- [Immich Places](https://github.com/Majorfi/immich-places) - web UI addon to help assign GPS coordinates to photos. ([Source Code](https://github.com/Majorfi/immich-places)) `TypeScript` `Go`
- [Invidious](https://invidious.io) - alternative front-end to YouTube. ([Source Code](https://github.com/iv-org/invidious)) `Crystal`
- [Mazanoke](https://mazanoke.com) - local image optimizer that runs in your browser. ([Source Code](https://github.com/civilblur/mazanoke)) `JavaScript`
- [OmniTools](https://omnitools.app) - collection of powerful web-based tools for everyday tasks. ([Source Code](https://github.com/iib0011/omni-tools)) `TypeScript`
- [SmartTube](https://github.com/yuliskov/SmartTube) - browse media content with your own rules on Android TV. `Java`
- [Vert](https://vert.sh) - next-generation file converter. ([Source Code](https://github.com/VERT-sh/VERT)) `Svelte` `TypeScript`
- [VoiceBox](https://voicebox.sh) - open-source AI voice studio, clone, dictate, create. ([Source Code](https://github.com/jamiepine/voicebox)) `TpeScript` `Python`
- [WithoutBG](https://withoutbg.com) - image background removal toolkit. ([Source Code](https://github.com/withoutbg/withoutbg)) `Python` `JavaScript`

### Monitoring

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
- [Znail](https://github.com/znailnetem/znail) - network emulator intended to run on a Raspberry Pi. ([Source Code](https://github.com/znailnetem/znail)) `Python`

### PKMS

- [Anytype](https://anytype.io) - the everything app for those who celebrate trust & autonomy. ([Source Code](https://github.com/anyproto/anytype-ts)) `TypeScript`
- [ApiTable](https://aitable.ai/) - API-oriented low-code platform for building collaborative apps and better than all other Airtable open-source alternatives. ([Source Code](https://github.com/apitable/apitable)) `TypeScript` `Java`
- [BookStack](https://www.bookstackapp.com) - platform to create documentation/wiki content. ([Source Code](https://github.com/BookStackApp/BookStack)) `PHP` `TypeScript`
- [Docs](https://github.com/suitenumerique/docs) - collaborative note taking, wiki and documentation platform that scales. ([Source Code](https://github.com/suitenumerique/docs)) `Python` `TypeScript`
- [Epicenter](https://epicenter.so) - open-source, local-first apps. ([Source Code](https://github.com/EpicenterHQ/epicenter)) `TypeScript` `Svelte`
- [Excalidraw](https://excalidraw.com) - virtual whiteboard for sketching hand-drawn like diagrams. ([Source Code](https://github.com/excalidraw/excalidraw)) `TypeScript`
- [Grist](https://www.getgrist.com) - modern relational spreadsheet. ([Source Code](https://github.com/gristlabs/grist-core)) `TypeScript` `Python`
- [Joplin](https://joplinapp.org) - privacy-focused note taking app with sync capabilities for Windows, macOS, Linux, Android and iOS. ([Source Code](https://github.com/laurent22/joplin)) `TypeScript` `JavaScript`
- [Memos](https://www.usememos.com) - knowledge management and note-taking platform designed for privacy-conscious users and organizations. ([Source Code](https://github.com/usememos/memos)) `Go` `TypeScript`
- [NocoDB](https://nocodb.com) - open source Airtable alternative. ([Source Code](https://github.com/nocodb/nocodb)) `TypeScript` `Vue`
- [Project N.O.M.A.D](https://github.com/Crosstalk-Solutions/project-nomad) - self-contained, offline survival computer packed with critical tools, knowledge, and AI to keep you informed and empowered, anytime, anywhere. ([Source Code](https://github.com/Crosstalk-Solutions/project-nomad)) `TypeScript`
- [Teable](https://teable.io) - next gen Airtable alternative, no-code Postgres. ([Source Code](https://github.com/teableio/teable)) `TypeScript`
- [TypeMill](https://typemill.net) - flat-file CMS based on Markdown and designed for informational websites like documentation, manuals, and handbooks. ([Source Code](https://github.com/typemill/typemill)) `JavaScript` `PHP`

### Project Management

- [kaneo](https://kaneo.app) - open source project management. ([Source Code](https://github.com/usekaneo/kaneo)) `TypeScript`
- [Rustical](https://lennart-k.github.io/rustical) - calendar server aiming to be simple, fast and passwordless. ([Source Code](https://github.com/lennart-k/rustical)) `Rust`
- [Worklenz](https://worklenz.com) - all in one project management tool for efficient teams. ([Source Code](https://github.com/Worklenz/worklenz)) `TypeScript` `JavaScript`

### Proxy

- [NPMPlus](https://github.com/ZoeyVid/NPMplus) - fork of nginx-proxy-manager. ([Source Code](https://github.com/ZoeyVid/NPMplus)) `TypeScript` `JavaScript`
- [Pangolin](https://digpangolin.com) - tunneled mesh reverse proxy server with identity and access control and dashboard UI. ([Source Code](https://github.com/fosrl/pangolin)) `TypeScript`
- [Traefik Log Dashboard](https://github.com/hhftechnology/traefik-log-dashboard) - real-time dashboard for analyzing Traefik logs with IP geolocation, status code analysis, and service metrics. ([Source Code](https://github.com/hhftechnology/traefik-log-dashboard)) `TypeScript` `Go`

### Remote

- [Defguard](https://defguard.net) - zero-trust access management with true WireGuard® 2FA/MFA. ([Source Code](https://github.com/DefGuard/defguard)) `Rust` `TypeScript`
- [Headscale](https://github.com/juanfont/headscale) - open source, self-hosted implementation of the Tailscale control server. ([Source Code](https://github.com/juanfont/headscale)) `Go`
- [Shadow SOCKS](https://github.com/shadowsocks/shadowsocks-rust)
- [Termix](https://termix.site) - Termix is a web-based server management platform with SSH terminal, tunneling, and file editing capabilities. ([Source Code](https://github.com/Termix-SSH/Termix)) `TypeScript`
- TunnelMole:
- [Client](https://github.com/robbie-cahill/tunnelmole-client)
- [Service](https://github.com/robbie-cahill/tunnelmole-service)

### Search

- [Chibisafe](https://chibisafe.app) - blazing fast file vault. ([Source Code](https://github.com/chibisafe/chibisafe)) `TypeScript`
- [Crowdsec Manager](https://crowdsec-manager.hhf.technology) - management interface and dashboard for CrowdSec security stack with Pangolin integration and multi proxy support. ([Source Code](https://github.com/hhftechnology/crowdsec_manager)) `TypeScript` `Go`
- [DumbWhoIs](https://dumbwhois.dumbware.io) - dumb whois. ([Source Code](https://github.com/DumbWareio/DumbWhoIs)) `JavaScript`
- [Whoogle](https://pypi.org/project/whoogle-search) - ad-free, privacy-respecting metasearch engine. ([Source Code](https://github.com/benbusby/whoogle-search)) `Python`

### Security

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

### Social

- [bridge-manager](https://github.com/beeper/bridge-manager) - tool for running self-hosted bridges with the Beeper Matrix server. ([Source Code](https://github.com/beeper/bridge-manager)) `Go`

### Software Development

- [ChartDB](https://chartdb.io) - . ([Source Code](https://github.com/chartdb/chartdb)) `TypeScript`
- [Code Server](https://coder.com) - VS Code in the browser. ([Source Code](https://github.com/coder/code-server)) `TypeScript` `Shell`
- [Coolify](https://coolify.io) - self-hostable PaaS alternative to Vercel, Heroku & Netlify. ([Source Code](https://github.com/coollabsio/coolify)) `PHP` `Blade`
- [DevPush](https://devpu.sh) - like Vercel, but open source and for all languages. ([Source Code](https://github.com/hunvreus/devpush)) `Python`

### Storage

- [Garage](https://garagehq.deuxfleurs.fr) - S3-compatible distributed object storage service. ([Source Code](https://git.deuxfleurs.fr/Deuxfleurs/garage)) `Rust`
- [RustFS](https://rustfs.com/download) - high-performance distributed object storage for MinIO alternative. ([Source Code](https://github.com/rustfs/rustfs)) `Rust`

### Surveys

- [Formbricks](https://formbricks.com) - open source Qualtrics alternative. ([Source Code](https://github.com/formbricks/formbricks)) `TypeScript`

### Trello alternative - [Find a kanban board](https://github.com/NatoBoram/docker-compose/issues/44)

- [Focalboard](https://github.com/mattermost-community/focalboard) - ([Source Code](https://github.com/mattermost-community/focalboard))
- [Kan](https://kan.bn) - open source Trello alternative. ([Source Code](https://github.com/kanbn/kan)) `TypeScript`
- [Kanboard](https://kanboard.org) - Kanban project management software. ([Source Code](https://github.com/kanboard/kanboard)) `PHP`
- [Leantime](https://leantime.io) - goals focused project management system for non-project managers. ([Source Code](https://github.com/Leantime/leantime)) `PHP` `JavaScript`
- [Taiga](https://github.com/taigaio/taiga-docker) - ([Source Code](https://github.com/taigaio/taiga-docker)) `Shell`
- [Vikunja](https://vikunja.io) - to-do app to organize your life. ([Source Code](https://github.com/go-vikunja/vikunja)) `Go` `Vue` `TypeScript`
- [Wekan](https://wekan.fi) - open-source kanban. ([Source Code](https://github.com/wekan/wekan)) `JavaScript`

### Wishlist

- [Christmas Community](https://github.com/Wingysam/Christmas-Community) - Christmas lists for families. ([Source Code](https://github.com/Wingysam/Christmas-Community))

### Other

- [Aeterna](https://github.com/alpyxn/aeterna) - lightweight dead man's switch. ([Source Code](https://github.com/alpyxn/aeterna)) `JavaScript` `Go`
- [Email Verifier](https://rapid-email-verifier.fly.dev) - privacy-first open source email verifier. ([Source Code](https://github.com/umuterturk/email-verifier)) `Go`
- [Monica](https://beta.monicahq.com/login) - Personal CRM. Remember everything about your friends, family and business relationships. ([Source Code](https://github.com/monicahq/monica)) `PHP`
- [Puter](https://puter.com) - The Internet Computer, free, open-source, and self-hostable. ([Source Code](https://github.com/HeyPuter/puter)) `JavaScript`
