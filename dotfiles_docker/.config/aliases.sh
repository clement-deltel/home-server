#!/bin/bash

#==============================================================================#
#               ------- Common --------                                        #
#==============================================================================#
alias c='clear'
alias cls='clear'
alias ki='kill'
alias q='exit'
alias t='time'

# cd
alias home='cd ~'
alias ..='cd ..'
alias ...='cd ..; cd ..'
alias ....='cd ..; cd ..; cd ..'

# cp
alias cp='cp -i'

# du
alias du-sort='du -sh * | sort -h'

# env
alias env='clear && env | sort'

# grep
alias grep='grep --color=auto'

# history
alias h='clear && history | tail -50'
alias muc='history | awk "{print $2}" | sort | uniq -c | sort -nr | head -10'

# lsof - list open ports
alias lsop='lsof -i -n -P | grep LISTEN'

# mv - prompt before overwrite
alias mv='mv -i'

# rm - prompt before every removal
alias rm='rm -i'

# tree - nice alternative to 'ls'
alias tree='tree -Csu'

# vim
alias vimo='vim -o'

#==============================================================================#
#               ------- ls --------                                            #
#==============================================================================#

# colorls
if [ -x "$(command -v colorls)" ]; then
    alias ls='colorls --color=auto'
else
    alias ls='ls --color=auto'
fi

# ls - list
alias ll='ls -l'
# ls - do not ignore entries starting with '.', do not list '.' and '..'
alias la='ls -Al'
# ls - list
alias lah='ls -Ahl'
# ls - recursive ls
alias lr='ls -lR'
# ls - sort by date
alias lrt='ls -ltr'
# ls - sort by size
alias lk='ls -lSr'
# ls - sort by extension
alias lx='ls -lXB'

#==============================================================================#
#               ------- Typos --------                                         #
#==============================================================================#
alias :q='exit'

#==============================================================================#
#               ------- Users --------                                         #
#==============================================================================#
alias root='sudo su -'
alias doc='sudo su - docker'

#==============================================================================#
#               ------- Server - Directories --------                          #
#==============================================================================#
alias {cd,d,svr}home='cd ${SERVER_HOME}'
alias svr='cd ${SERVER_HOME}'

alias cdsvc='cd ${SERVER_HOME}/services'
alias svc='cd ${SERVER_HOME}/services'

alias scr='cd ${SERVER_HOME}/scripts'
alias loghome='cd {SERVER_HOME}/logs'

#==============================================================================#
#               ------- Server - Services --------                             #
#==============================================================================#
alias {cd,svc}llm='cd ${SERVER_HOME}/services/ai/litellm'
alias {cd,svc}oll='cd ${SERVER_HOME}/services/ai/ollama'
alias {cd,svc}owu='cd ${SERVER_HOME}/services/ai/open-webui'
alias {cd,svc}hoa='cd ${SERVER_HOME}/services/dashboard/homarr'
alias {cd,svc}hoe='cd ${SERVER_HOME}/services/dashboard/homer'
alias {cd,svc}pih='cd ${SERVER_HOME}/services/dns/pihole'
alias {cd,svc}unb='cd ${SERVER_HOME}/services/dns/unbound'
alias {cd,svc}act='cd ${SERVER_HOME}/services/finances/actual'
alias {cd,svc}wal='cd ${SERVER_HOME}/services/finances/wallos'
alias {cd,svc}ha='cd ${SERVER_HOME}/services/home/home-assistant'
alias {cd,svc}up='cd ${SERVER_HOME}/services/home/upsnap'
alias {cd,svc}gro='cd ${SERVER_HOME}/services/inventory/grocy'
alias {cd,svc}hob='cd ${SERVER_HOME}/services/inventory/homebox'
alias {cd,svc}hor='cd ${SERVER_HOME}/services/inventory/hortusfox'
alias {cd,svc}byt='cd ${SERVER_HOME}/services/management/code/bytestash'
alias {cd,svc}git='cd ${SERVER_HOME}/services/management/code/gitlab'
alias {cd,svc}itt='cd ${SERVER_HOME}/services/management/code/it-tools'
alias {cd,svc}vau='cd ${SERVER_HOME}/services/management/passwords/vaultwarden'
alias {cd,svc}gok='cd ${SERVER_HOME}/services/media/sharing/gokapi'
alias {cd,svc}kav='cd ${SERVER_HOME}/services/media/storage/books/kavita'
alias {cd,svc}lib='cd ${SERVER_HOME}/services/media/storage/books/librum'
alias {cd,svc}nex='cd ${SERVER_HOME}/services/media/storage/documents/nextcloud'
alias {cd,svc}pap='cd ${SERVER_HOME}/services/media/storage/documents/paperless'
alias {cd,svc}nav='cd ${SERVER_HOME}/services/media/storage/music/navidrome'
alias {cd,svc}imm='cd ${SERVER_HOME}/services/media/storage/pictures/immich'
alias {cd,svc}phot='cd ${SERVER_HOME}/services/media/storage/pictures/photoprism'
alias {cd,svc}jel='cd ${SERVER_HOME}/services/media/storage/videos/jellyfin'
alias {cd,svc}det='cd ${SERVER_HOME}/services/monitoring/detection'
alias {cd,svc}gra='cd ${SERVER_HOME}/services/monitoring/grafana'
alias {cd,svc}jet='cd ${SERVER_HOME}/services/monitoring/jetlog'
alias {cd,svc}ntf='cd ${SERVER_HOME}/services/monitoring/ntfy'
alias {cd,svc}pro='cd ${SERVER_HOME}/services/monitoring/prometheus'
alias {cd,svc}scr='cd ${SERVER_HOME}/services/monitoring/scrutiny'
alias {cd,svc}fre='cd ${SERVER_HOME}/services/news/freshrss'
alias {cd,svc}doc='cd ${SERVER_HOME}/services/pdf/docuseal'
alias {cd,svc}sti='cd ${SERVER_HOME}/services/pdf/stirling-pdf'
alias {cd,svc}aff='cd ${SERVER_HOME}/services/pkms/affine'
alias {cd,svc}mat='cd ${SERVER_HOME}/services/pkms/mathesar'
alias {cd,svc}obs='cd ${SERVER_HOME}/services/pkms/obsidian'
alias {cd,svc}siy='cd ${SERVER_HOME}/services/pkms/siyuan'
alias {cd,svc}gua='cd ${SERVER_HOME}/services/remote/guacamole'
alias {cd,svc}rus='cd ${SERVER_HOME}/services/remote/rustdesk'
alias {cd,svc}wge='cd ${SERVER_HOME}/services/remote/wg-easy'
alias {cd,svc}wir='cd ${SERVER_HOME}/services/remote/wireguard'
alias {cd,svc}enc='cd ${SERVER_HOME}/services/security/enclosed'
alias {cd,svc}waz='cd ${SERVER_HOME}/services/security/wazuh'

alias {cd,svc}dir='cd ${SERVER_HOME}/services/directus'
alias {cd,svc}kop='cd ${SERVER_HOME}/services/kopia'
alias {cd,svc}lim='cd ${SERVER_HOME}/services/limesurvey'
alias {cd,svc}min='cd ${SERVER_HOME}/services/minecraft'
alias {cd,svc}phon='cd ${SERVER_HOME}/services/phoneinfoga'
alias {cd,svc}tra='cd ${SERVER_HOME}/services/traefik'
alias {cd,svc}wis='cd ${SERVER_HOME}/services/wishlist'

#==============================================================================#
#               ------- Server - Scripts --------                              #
#==============================================================================#
alias scrall='cd ${SERVER_HOME}/scripts/all'
alias scrbck='cd ${SERVER_HOME}/scripts/backup'
alias scrres='cd ${SERVER_HOME}/scripts/restore'

#==============================================================================#
#               ------- Ansible --------                                       #
#==============================================================================#
alias af='ansible localhost -m ansible.builtin.setup'

#==============================================================================#
#               ------- Bitwarden CLI ------                                   #
#==============================================================================#
alias bwc=bitwarden-create-item-notes-fn
alias bwl='bw lock'
alias bwle=bitwarden-load-env-fn
alias bwli=bitwarden-login-fn
alias bwlo='bw logout'
alias bwly=bitwarden-load-yml-fn
alias bwo=bitwarden-open-fn
alias bwq='bw lock && bw logout'
alias bws=bitwarden-create-session-fn
alias bwst='bw status | jq'
alias bwsy='bw sync'

#==============================================================================#
#               ------- Docker ------                                          #
#==============================================================================#
alias d=docker-fn
alias dcrme=docker-rm-exited-fn
alias dex=docker-exec-fn
alias di=docker-inspect-fn
alias dim='docker images | (sed -u 1q; sort)'
alias dip=docker-ip-fn
alias dirmd=docker-image-rm-dangling-fn
alias dl=docker-logs-fn
alias dnames=docker-names-fn
alias dnrm=docker-network-rm-fn
alias dpsf='docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}"'
alias dpu=docker-pull-fn
alias drun=docker-run-fn
alias dsdf='docker system df -v'
alias dsp='docker system prune'
alias dspa='docker system prune --all'
alias dsr=docker-stop-rm-fn
alias dvrm=docker-volume-rm-fn
alias dvrmd=docker-volume-rm-dangling-fn

alias dirm=docker-image-rm-fn
alias dnls='docker network ls'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dvls='docker volume ls'

#==============================================================================#
#               ------- Docker Compose ------                                  #
#==============================================================================#
alias catco='cat compose.yaml'
alias vico='vim compose.yaml'

# CLI
alias dc=docker-compose-fn
alias dcd='docker compose down -v'
alias dcr='docker compose restart'
alias dcru=docker-compose-run-fn
alias dcsta='docker compose start'
alias dcsto='docker compose stop'
alias dcu='docker compose up -d'
alias dcub='docker compose up -d --build'

#==============================================================================#
#               ------- Terraform ------                                       #
#==============================================================================#
alias tf=terraform-fn
alias tfa='terraform apply'
alias tfaa='terraform apply --auto-approve'
alias tfd='terraform destroy'
alias tfi='terraform init'
alias tfo='terraform output'
alias tfp='terraform plan'
alias tfs=terraform-state-fn
alias tfsh='terraform show'
alias tfv='terraform validate'

#==============================================================================#
#               ------- Bash --------                                          #
#==============================================================================#
alias vib='vi ~/.bashrc'
alias srb='source ~/.bashrc'
alias cab='cat ~/.bashrc'
