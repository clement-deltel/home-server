# .bashrc
# Author: Clement Deltel
# Source:

USERID=$(whoami)
HOSTNAME=$(hostname)
PWD=$(pwd)
export PS1='${USERID}@${HOSTNAME}:${PWD} /> '
export PATH

export HOME=/home/${USERID}

#==========================================================================#
#               ------- Aliases - General --------                         #
#==========================================================================#

# bashrc
alias viba='vi ~/.bashrc'
alias srcba='source ~/.bashrc'
alias catba='cat ~/.bashrc'

# Common commands
alias c='clear'
alias h='history'
alias k='kill'
alias p='cat'
alias q='exit'
alias t='time'

# List files
alias ls='ls --color'
alias ll='ls -l --color'
alias la='ls -al --color'
alias lah='ls -ahl --color'

# Directories navigation
alias home='cd ~'
alias ..='cd ..'
alias ...='cd ..; cd ..'
alias ....='cd ..; cd ..; cd ..'

# Log in as root
alias root='sudo su -'
# Log in as docker
alias doc='sudo su - docker'

# List and sort directories by size
function du-sort-type-fn { du -sh ./*glob* | sort -h | awk '{usage=$1; $1="";cmd="file "$0;cmd |& getline type;print usage,type ;close(cmd)}'; }
alias du-sort='du -sh * | sort -h'
alias du-sort-type=du-sort-type-fn

# Make directory and then move inside
function mkdir-cd-fn { mkdir "$1"; cd "$1" || return; }
alias mkcd=mkdir-cd-fn

# Add given extension to all files without any in the current directory
function add-ext-fn { find . -type f -not -name "*.*" -exec mv "{}" "{}"."$1" \;; }
alias add-ext=add-ext-fn

# Create copies of a given file
function cp-n-fn { EXT="${1##*.}"; FILENAME="${1%.*}"; for i in $(seq 1 "$2"); do cp "$1" "${FILENAME}${i}.${EXT}"; done; }
alias cp-n=cp-n-fn

#==========================================================================#
#               ------- Aliases - Typos --------                           #
#==========================================================================#
alias :q='exit'

#==========================================================================#
#               ------- Aliases - Directories --------                     #
#==========================================================================#
alias dhome='cd ${SERVER_HOME}'
alias svrhome='cd ${SERVER_HOME}'
alias svr='cd ${SERVER_HOME}'
alias svc='cd ${SERVER_HOME}/services'
alias scr='cd ${SERVER_HOME}/scripts'
alias cdtest='cd ${SERVER_HOME}/test'
alias bckphome='cd ${BACKUP_HOME}'

# Services
alias cdbit='cd ${SERVER_HOME}/services/bitwarden'
alias cdtra='cd ${SERVER_HOME}/services/traefik'

alias svcbit='cd ${SERVER_HOME}/services/bitwarden'
alias svctra='cd ${SERVER_HOME}/services/traefik'
