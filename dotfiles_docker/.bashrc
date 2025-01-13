#!/bin/bash
# .bashrc

#==============================================================================#
#               ------- Colors ------                                          #
#==============================================================================#
RED='\e[1;31m'
NC='\e[0m'

#==============================================================================#
#               ------- Configuration --------                                 #
#==============================================================================#

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# Shell optional behavior
shopt -s autocd
shopt -s cdspell
shopt -s checkwinsize # check the window size after each command
shopt -s cmdhist
shopt -s histappend # append to the history file, don't overwrite it
shopt -s histreedit
shopt -s progcomp
shopt -s sourcepath

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=999999
export HISTFILESIZE=999999

# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL=ignoredups:ignorespace

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]$(pwd)\[\033[00m\] /> '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:$(pwd) /> '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*)
  ;;
esac

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

set -o ignoreeof    # Shell doesnt quit upon reading the end of file.
#set -o noclobber   # Prevents overwriting existing regular files
set -o notify       # Alerts the user upon background job termination
#set -o xtrace      # Prints out command arguments during execution
set -o vi           # Set vi mode for shell

# User specific environment and startup programs
export HOME=/home/${USER}
export PATH=${PATH}:${HOME}/.local/bin:${HOME}/bin

#==============================================================================#
#               ------- Functions ------                                       #
#==============================================================================#

# Print only column x of output
function col {
  awk -v col="$1" '{print $col}'
}

# Add extension $1 to all files without any extension in the current directory
function add-ext { find . -type f -not -name "*.*" -exec mv "{}" "{}"."$1" \;; }

# Create $2 copies of file $1
function cp-n { EXT="${1##*.}"; FILENAME="${1%.*}"; for i in $(seq 1 "$2"); do cp "$1" "${FILENAME}${i}.${EXT}"; done; }

# Execute $@ command in all the subdirectories
function exec-sub { find . -maxdepth 1 -mindepth 1 -type d -execdir echo {} \; -execdir $@ {} \; -execdir echo \;; }

# Make directory $1 and then cd inside
function mkcd { mkdir "$1"; cd "$1" || return; }

# Base64 decoding
function dec { echo "$1" | base64 --decode; }

# Host Info

# IP adresses
function my-ip(){
    MY_IP=$(/sbin/ifconfig enp8s0 | awk '/inet/ { print $2 } ' | sed -e s/addr://)
}

# Full summary
function ii() {
    echo -e "\nYou are logged on ${RED}$(hostname)"
    echo -e "\nAdditionnal information:$NC " ; uname -a
    echo -e "\n${RED}Users logged on:$NC " ; w -h
    echo -e "\n${RED}Current date :$NC " ; date
    echo -e "\n${RED}Machine stats :$NC " ; uptime
    echo -e "\n${RED}Memory stats :$NC " ; free
    my-ip 2>&- ;
    echo -e "\n${RED}Local IP Address :$NC" ; echo "${MY_IP:-"Not connected"}"
    echo
}

# Online cheatsheet
function cheatsheet { curl cheat.sh/"$1"; }

#==============================================================================#
#               ------- Aliases --------                                       #
#==============================================================================#

# Global
alias c='clear'
alias cls='clear'
alias d='date'
alias k='kill'
alias q='exit'
alias t='time'

# bashrc
alias vib='vi ~/.bashrc'
alias srb='source ~/.bashrc'
alias cab='cat ~/.bashrc'

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

# ls
alias ll='ls -l --color=auto'
alias la='ls -Al --color=auto'
alias lah='ls -Ahl --color=auto'
alias lk='ls -lSr'          # sort by size
alias lr='ls -lR'           # recursive ls
alias ltr='ls -ltr'         # sort by date
alias lx='ls -lXB'          # sort by extension

# lsof - List open ports
alias lsop='lsof -i -n -P | grep LISTEN'

# mv
alias mv='mv -i'

# rm
alias rm='rm -i'

# su
alias root='sudo su -'
alias doc='sudo su - docker'

# tree
alias tree='tree -Csu'		# nice alternative to 'ls'

# vim
alias vimo='vim -o '

#==============================================================================#
#               ------- Aliases - Typos --------                               #
#==============================================================================#
alias :q='exit'

#==============================================================================#
#               ------- Functions & Aliases - Docker ------                    #
#==============================================================================#
function docker-exec-fn { docker exec -it "$1" "${2:-bash}"; }
function docker-image-rm-fn { docker image rm "$1"; }
function docker-inspect-fn { docker inspect "$1"; }
function docker-ip-fn {
  echo "IP addresses of all named running containers"
  for DOC in $(dnames-fn)
  do
    IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}' "$DOC")
    OUT+=$DOC'\t'$IP'\n'
  done
  echo -e "$OUT" | column -t
  unset OUT
}
function docker-logs-fn { docker logs -f "$1"; }
function docker-names-fn {
	for ID in $(docker ps | awk '{print $1}' | grep -v 'CONTAINER')
	do
    docker inspect "$ID" | grep Name | head -1 | awk '{print $2}' | sed 's/,//g' | sed 's%/%%g' | sed 's/"//g'
	done
}
function docker-pull-fn { docker pull "$1"; }
function docker-rm-exited-fn { docker rm "$(docker ps --all -q -f status=exited)"; }
function docker-rm-dangling-images-fn {
    IMGS=$(docker images --filter "dangling=true" -q --no-trunc)
    [[ -n ${IMGS} ]] && docker rmi ${IMGS} || echo "no dangling images."
}
function docker-rm-dangling-volumes-fn {
    VOLS=$(docker volume ls --filter "dangling=true" -q)
    [[ -n ${VOLS} ]] && docker volume rm ${VOLS} || echo "no dangling volumes."
}
function docker-run-fn { docker run -it "$1" "$2"; }
function docker-stop-rm-fn { docker stop "$1"; docker rm "$1"; }

alias dex=docker-exec-fn
alias di=docker-inspect-fn
alias dim='docker images | (sed -u 1q; sort)'
alias dirm=docker-image-rm-fn
alias dip=docker-ip-fn
alias dl=docker-logs-fn
alias dnames=docker-names-fn
alias dnls='docker network ls'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dpsf='docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}"'
alias dpu=docker-pull-fn
alias drmc=docker-rm-exited-fn
alias drmid=docker-rm-dangling-images-fn
alias drmvd=docker-rm-dangling-volumes-fn
alias drun=docker-run-fn
alias dsdf='docker system df -v'
alias dsp='docker system prune --all'
alias dsr=docker-stop-rm-fn
alias dvls='docker volume ls'

#==============================================================================#
#               ------- Functions & Aliases - Docker Compose ------            #
#==============================================================================#
function docker-compose-fn { docker compose "$@"; }
function docker-compose-run-fn { docker compose run "$@"; }

# Compose file
alias catco='cat compose.yaml'
alias vico='vim compose.yaml'

# CLI
alias dc=docker-compose-fn
alias dcd='docker compose down -v'
alias dcru=docker-compose-run-fn
alias dcu='docker compose up -d'
alias dcub='docker compose up -d --build'
alias dcr='docker compose restart'
alias dcsta='docker compose start'
alias dcsto='docker compose stop'

#==============================================================================#
#               ------- Functions & Aliases - Server --------                  #
#==============================================================================#

# Environment variables
export SERVER_HOME=/opt/home-server
export BACKUP_HOME=${SERVER_HOME}/backups
export LOG_HOME=${SERVER_HOME}/logs

# Scripts
export PATH=${PATH}:${SERVER_HOME}/scripts/all:${SERVER_HOME}/scripts/backup:${SERVER_HOME}/scripts/restore

# Set and unset env
function set-env-fn { export $(grep -v '^#' "${SERVER_HOME}/env/.env" | xargs -d '\n'); }
function unset-env-fn { unset $(grep -v '^#' "${SERVER_HOME}/env/.env" | sed -E 's/(.*)=.*/\1/' | xargs); }

alias set-env=set-env-fn
alias unset-env=unset-env-fn
set-env

#==============================================================================#
#               ------- Aliases - Directories --------                         #
#==============================================================================#
alias dhome='cd ${SERVER_HOME}'
alias svrhome='cd ${SERVER_HOME}'
alias svr='cd ${SERVER_HOME}'
alias svc='cd ${SERVER_HOME}/services'
alias scr='cd ${SERVER_HOME}/scripts'
alias cdtest='cd ${SERVER_HOME}/test'

alias bckphome='cd ${BACKUP_HOME}'
alias loghome='cd ${LOG_HOME}'

# Services
alias cdhom='cd ${SERVER_HOME}/services/dashboard/homarr'
alias cdpih='cd ${SERVER_HOME}/services/dns/pihole'
alias cdunb='cd ${SERVER_HOME}/services/dns/unbound'
alias cdact='cd ${SERVER_HOME}/services/finances/actual'
alias cdgro='cd ${SERVER_HOME}/services/inventory/grocy'
alias cdhor='cd ${SERVER_HOME}/services/inventory/hortusfox'
alias cdbyt='cd ${SERVER_HOME}/services/management/code/bytestash'
alias cdvau='cd ${SERVER_HOME}/services/management/passwords/vaultwarden'
alias cdgok='cd ${SERVER_HOME}/services/media/sharing/gokapi'
alias cdkav='cd ${SERVER_HOME}/services/media/storage/books/kavita'
alias cdlib='cd ${SERVER_HOME}/services/media/storage/books/librum'
alias cdnex='cd ${SERVER_HOME}/services/media/storage/documents/nextcloud'
alias cdpap='cd ${SERVER_HOME}/services/media/storage/documents/paperless'
alias cdnav='cd ${SERVER_HOME}/services/media/storage/music/navidrome'
alias cdimm='cd ${SERVER_HOME}/services/media/storage/pictures/immich'
alias cdphot='cd ${SERVER_HOME}/services/media/storage/pictures/photoprism'
alias cdjel='cd ${SERVER_HOME}/services/media/storage/videos/jellyfin'
alias cddet='cd ${SERVER_HOME}/services/monitoring/detection'
alias cdjet='cd ${SERVER_HOME}/services/monitoring/jetlog'
alias cdntf='cd ${SERVER_HOME}/services/monitoring/ntfy'
alias cdpro='cd ${SERVER_HOME}/services/monitoring/prometheus'
alias cddoc='cd ${SERVER_HOME}/services/pdf/docuseal'
alias cdsti='cd ${SERVER_HOME}/services/pdf/stirling-pdf'
alias cdgua='cd ${SERVER_HOME}/services/remote/guacamole'
alias cdrus='cd ${SERVER_HOME}/services/remote/rustdesk'
alias cdwge='cd ${SERVER_HOME}/services/remote/wg-easy'
alias cdwir='cd ${SERVER_HOME}/services/remote/wireguard'
alias cdwaz='cd ${SERVER_HOME}/services/security/wazuh'

alias cddir='cd ${SERVER_HOME}/services/directus'
alias cdgra='cd ${SERVER_HOME}/services/grafana'
alias cdkop='cd ${SERVER_HOME}/services/kopia'
alias cdlim='cd ${SERVER_HOME}/services/limesurvey'
alias cdmin='cd ${SERVER_HOME}/services/minecraft'
alias cdphon='cd ${SERVER_HOME}/services/phoneinfoga'
alias cdtra='cd ${SERVER_HOME}/services/traefik'
alias cdwis='cd ${SERVER_HOME}/services/wishlist'


alias svchom='cd ${SERVER_HOME}/services/dashboard/homarr'
alias svcpih='cd ${SERVER_HOME}/services/dns/pihole'
alias svcunb='cd ${SERVER_HOME}/services/dns/unbound'
alias svcact='cd ${SERVER_HOME}/services/finances/actual'
alias svcgro='cd ${SERVER_HOME}/services/inventory/grocy'
alias svchor='cd ${SERVER_HOME}/services/inventory/hortusfox'
alias svcbyt='cd ${SERVER_HOME}/services/management/code/bytestash'
alias svcvau='cd ${SERVER_HOME}/services/management/passwords/vaultwarden'
alias svcgok='cd ${SERVER_HOME}/services/media/sharing/gokapi'
alias svckav='cd ${SERVER_HOME}/services/media/storage/books/kavita'
alias svclib='cd ${SERVER_HOME}/services/media/storage/books/librum'
alias svcnex='cd ${SERVER_HOME}/services/media/storage/documents/nextcloud'
alias svcpap='cd ${SERVER_HOME}/services/media/storage/documents/paperless'
alias svcnav='cd ${SERVER_HOME}/services/media/storage/music/navidrome'
alias svcimm='cd ${SERVER_HOME}/services/media/storage/pictures/immich'
alias svcphot='cd ${SERVER_HOME}/services/media/storage/pictures/photoprism'
alias svcjel='cd ${SERVER_HOME}/services/media/storage/videos/jellyfin'
alias svcdet='cd ${SERVER_HOME}/services/monitoring/detection'
alias svcjet='cd ${SERVER_HOME}/services/monitoring/jetlog'
alias svcntf='cd ${SERVER_HOME}/services/monitoring/ntfy'
alias svcpro='cd ${SERVER_HOME}/services/monitoring/prometheus'
alias svcdoc='cd ${SERVER_HOME}/services/pdf/docuseal'
alias svcsti='cd ${SERVER_HOME}/services/pdf/stirling-pdf'
alias svcgua='cd ${SERVER_HOME}/services/remote/guacamole'
alias svcrus='cd ${SERVER_HOME}/services/remote/rustdesk'
alias svcwge='cd ${SERVER_HOME}/services/remote/wg-easy'
alias svcwir='cd ${SERVER_HOME}/services/remote/wireguard'
alias svcwaz='cd ${SERVER_HOME}/services/security/wazuh'

alias svcdir='cd ${SERVER_HOME}/services/directus'
alias svcgra='cd ${SERVER_HOME}/services/grafana'
alias svckop='cd ${SERVER_HOME}/services/kopia'
alias svclim='cd ${SERVER_HOME}/services/limesurvey'
alias svcmin='cd ${SERVER_HOME}/services/minecraft'
alias svcphon='cd ${SERVER_HOME}/services/phoneinfoga'
alias svctra='cd ${SERVER_HOME}/services/traefik'
alias svcwis='cd ${SERVER_HOME}/services/wishlist'

# Scripts
alias scrall='cd ${SERVER_HOME}/scripts/all'
alias scrbck='cd ${SERVER_HOME}/scripts/backup'
alias scrres='cd ${SERVER_HOME}/scripts/restore'
