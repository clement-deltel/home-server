# Home Server <!-- omit in toc -->

## Table of Contents <!-- omit in toc -->

- [1. Introduction](#1-introduction)
- [2. Services](#1-introduction)
- [3. Port Mapping](#1-introduction)

## 1. Introduction

Collection of tools for self hosting.

## 2. Services

- Reverse Proxy
  - [Traefik](services/reverse_proxy/traefik/README.md)
    - `https://traefik.${DOMAIN_NAME}/dashboard`
- Password Manager
  - [Bitwarden](services/password_manager/bitwarden/README.md)
    - `https://bitwarden.${DOMAIN_NAME}`

## 3. Port Mapping 

- TCP
  - 80: Traefik HTTP
  - 443: Traefik HTTPS
  - 3012: Bitwarden WebSocket
  - 8080: Traefik Dashboard