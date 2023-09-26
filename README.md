# Home Server <!-- omit in toc -->

## Table of Contents <!-- omit in toc -->

- [1. Introduction](#1-introduction)
- [2. Hardware](#2-hardware)
- [3. Domain Name](#3-domain-name)
- [4. Operating System](#4-operating-system)
- [5. Services](#5-services)
- [6. Port Mapping](#6-port-mapping)

## 1. Introduction

Collection of tools for self hosting.

## 2. Hardware

## 3. Domain Name

## 4. Operating System

- Name: Ubuntu
- Version: 22.04

## 5. Services

- Reverse Proxy
  - [Traefik](services/traefik/README.md)
    - `https://traefik.${DOMAIN_NAME}/dashboard`
- Password Manager
  - [Bitwarden](services/bitwarden/README.md)
    - `https://bitwarden.${DOMAIN_NAME}`

## 6. Port Mapping

- TCP
  - 53: Pihole
  - 80: Traefik HTTP
  - 443: Traefik HTTPS
  - 3012: Bitwarden WebSocket
  - 8080: Traefik Dashboard
- UDP
  - 53: Pihole
