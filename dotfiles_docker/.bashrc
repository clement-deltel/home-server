# .bashrc
# Author: Clement Deltel
# Source:

USERID=$(whoami)
HOSTNAME=$(hostname)
PWD=$(pwd)
export PS1='${USERID}@${HOSTNAME}:${PWD} /> '
export PATH

# Choose the root folder for all Docker services installation
export HOME=/home/${USERID}
export SERVER_HOME=/opt/home-server
export BACKUP_HOME=${SERVER_HOME}/backups
export LOG_HOME=${SERVER_HOME}/logs

# User specific environment and startup programs
export PATH=${PATH}:${HOME}/.local/bin:${HOME}/bin

# Scripts
export PATH=${PATH}:${SERVER_HOME}/scripts/common:${SERVER_HOME}/scripts/backup

#==============================================================================#
#               ------- Aliases - General --------                             #
#==============================================================================#

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
alias root='su -'

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

# Export and unset env
function set-env-fn { export $(grep -v '^#' ${SERVER_HOME}/env/server.env | xargs -d '\n'); }
function unset-env-fn { unset $(grep -v '^#' ${SERVER_HOME}/env/server.env | sed -E 's/(.*)=.*/\1/' | xargs); }
alias set-env=set-env-fn
alias unset-env=unset-env-fn

set-env

#==============================================================================#
#               ------- Aliases - Typos --------                               #
#==============================================================================#
alias :q='exit'

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

# Services
alias cdbit='cd ${SERVER_HOME}/services/bitwarden'
alias cdnex='cd ${SERVER_HOME}/services/nextcloud'
alias cdtra='cd ${SERVER_HOME}/services/traefik'

alias svcbit='cd ${SERVER_HOME}/services/bitwarden'
alias svcnex='cd ${SERVER_HOME}/services/nextcloud'
alias svctra='cd ${SERVER_HOME}/services/traefik'

# Scripts
alias scrcom='cd ${SERVER_HOME}/scripts/common'

alias scrbit='cd ${SERVER_HOME}/scripts/bitwarden'
alias scrnex='cd ${SERVER_HOME}/scripts/nextcloud'
alias scrtra='cd ${SERVER_HOME}/scripts/traefik'

#==============================================================================#
#               ------- Useful Docker Aliases --------                         #
#                                                                              #
#     # Usage:                                                                 #
#     dex <container>: execute a bash shell inside the RUNNING <container>     #
#     di <container> : docker inspect <container>                              #
#     dim            : docker images                                           #
#     dip            : IP addresses of all running containers                  #
#     dirm           : docker remove image                                     #
#     dl <container> : docker logs -f <container>                              #
#     dnames         : names of all running containers                         #
#     dps            : docker ps                                               #
#     dpsa           : docker ps -a                                            #
#     dpsf           : docker ps -a with specific formatting                   #
#     dpu            : docker pull <image>                                     #
#     drmc           : remove all exited containers                            #
#     drmid          : remove all dangling images                              #
#     drun <image>   : execute a bash shell in NEW container from <image>      #
#     dsp            : docker system prune all                                 #
#     dsr <container>: stop then remove <container>                            #
#                                                                              #
#     vidc           : vi compose.yaml                                         #
#     catdc          : cat compose.yaml                                        #
#                                                                              #
#     dc             : docker compose                                          #
#     dcu            : docker compose up -d                                    #
#     dcd            : docker compose down -v                                  #
#     dcr            : docker compose restart                                  #
#     dcsta          : docker compose start                                    #
#     dcsto          : docker compose stop                                     #
#     dcru           : docker compose run                                      #
#                                                                              #
#==============================================================================#

function docker-compose-fn { docker compose "$@"; }

function docker-compose-run-fn { docker compose run "$@"; }

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

# in order to do things like dex $(dlab label) sh
function dlab { docker ps --filter="label=$1" --format="{{.ID}}"; }

function docker-logs-fn { docker logs -f "$1"; }

function docker-names-fn {
	for ID in $(docker ps | awk '{print $1}' | grep -v 'CONTAINER')
	do
    	docker inspect "$ID" | grep Name | head -1 | awk '{print $2}' | sed 's/,//g' | sed 's%/%%g' | sed 's/"//g'
	done
}

function docker-pull-fn { docker pull "$1"; }

function docker-rm-exited-fn { docker rm "$(docker ps --all -q -f status=exited)"; }

function docker-rm-dangling-fn {
       imgs=$(docker images -q -f dangling=true)
       [ -n "$imgs" ] && docker rmi "$imgs" || echo "no dangling images."
}

function docker-run-fn { docker run -it "$1" "$2"; }

function docker-stop-rm-fn { docker stop "$1"; docker rm "$1"; }

alias dex=docker-exec-fn
alias di=docker-inspect-fn
alias dim='docker images'
alias dip=docker-ip-fn
alias dirm=docker-image-rm-fn
alias dl=docker-logs-fn
alias dnames=docker-names-fn
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dpsf='docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}"'
alias dpu=docker-pull-fn
alias drmc=docker-rm-exited-fn
alias drmid=docker-rm-dangling-fn
alias drun=docker-run-fn
alias dsp='docker system prune --all'
alias dsr=docker-stop-rm-fn

# Compose file
alias catdc='cat compose.yaml'
alias vidc='vi compose.yaml'

# Compose CLI
alias dc=docker-compose-fn
alias dcu='docker compose up -d'
alias dcd='docker compose down -v'
alias dcr='docker compose restart'
alias dcsta='docker compose start'
alias dcsto='docker compose stop'
alias dcru=docker-compose-run-fn
