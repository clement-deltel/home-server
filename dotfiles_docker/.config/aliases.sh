#!/bin/bash

# ---------------------------------------------------------------------------- #
#               ------- Common --------
# ---------------------------------------------------------------------------- #
alias c='clear'
alias cls='clear'
alias ki='kill'
alias q='exit'
alias t='time'

# cd
alias home='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias 2..='cd ../..'
alias 3..='cd ../../..'
alias 4..='cd ../../../..'
alias 5..='cd ../../../../..'

# cp
alias cp='cp -i'

# du
alias dus='du -sh * | sort -h'

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

# ---------------------------------------------------------------------------- #
#               ------- bat - cat --------
# ---------------------------------------------------------------------------- #
alias bat='batcat'
alias cat='batcat --paging=never'

alias release='cat /etc/*-release'

# ---------------------------------------------------------------------------- #
#               ------- ls --------
# ---------------------------------------------------------------------------- #

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

# ---------------------------------------------------------------------------- #
#               ------- Typos --------
# ---------------------------------------------------------------------------- #
alias ,,='cd ..'
alias ..l='cd .. && ls'
alias cd..='cd ..'
alias :q='exit'

# ---------------------------------------------------------------------------- #
#               ------- Users --------                                         #
# ---------------------------------------------------------------------------- #
alias root='sudo su -'
alias doc='sudo su - docker'

# ---------------------------------------------------------------------------- #
#               ------- Bitwarden CLI ------                                   #
# ---------------------------------------------------------------------------- #
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

# ---------------------------------------------------------------------------- #
#               ------- Docker ------                                          #
# ---------------------------------------------------------------------------- #
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

alias lzd='lazydocker'

# ---------------------------------------------------------------------------- #
#               ------- Docker Compose ------                                  #
# ---------------------------------------------------------------------------- #
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

# ---------------------------------------------------------------------------- #
#               ------- Terraform ------                                       #
# ---------------------------------------------------------------------------- #
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

# ---------------------------------------------------------------------------- #
#               ------- Bash --------                                          #
# ---------------------------------------------------------------------------- #
alias vib='vi ~/.bashrc'
alias srb='source ~/.bashrc'
alias cab='cat ~/.bashrc'
