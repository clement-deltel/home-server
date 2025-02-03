#!/bin/bash

#==============================================================================#
#               ------- General ------                                         #
#==============================================================================#

# Add extension $1 to all files without any extension in the current directory
function add-ext { find . -type f -not -name "*.*" -exec mv "{}" "{}"."$1" \;; }

# Print only column x of output
function col { awk -v col="$1" "{print $col}"; }

# Create $2 copies of file $1
function cp-n { EXT="${1##*.}"; FILENAME="${1%.*}"; for i in $(seq 1 "$2"); do cp "$1" "${FILENAME}${i}.${EXT}"; done; }

# Base64 decoding
function dec { echo "$1" | base64 --decode; }

# Execute $@ command in all the subdirectories
function exec-sub { find . -maxdepth 1 -mindepth 1 -type d -execdir echo {} \; -execdir $@ {} \; -execdir echo \;; }

# List files with a certain depth
function lsdp { find . -maxdepth "$1" -ls -path "./.git*" -prune; }

# Make directory $1 and then cd inside
function mkcd { mkdir "$1"; cd "$1" || return; }

# Tail with continuous monitoring of a given file with syntax highlighting
function tailc { tail -f "$1" | batcat -l log --paging=never; }

# Host Info

# IP adresses
function my-ip (){
  MY_IP=$(/sbin/ifconfig enp8s0 | awk '/inet/ { print $2 }' | sed -e s/addr://)
}

# Full summary
function ii (){
  echo -e "\nYou are logged on ${RED}$(hostname)"
  echo -e "\nAdditionnal information:$NC" ; uname -a
  echo -e "\n${RED}Users logged on:$NC" ; w -h
  echo -e "\n${RED}Current date:$NC" ; date
  echo -e "\n${RED}Machine stats:$NC" ; uptime
  echo -e "\n${RED}Memory stats:$NC" ; free
  my-ip 2>&- ;
  echo -e "\n${RED}Local IP Address:$NC" ; echo "${MY_IP:-"Not connected"}"
  echo
}

# Online cheatsheet
function cheatsheet { curl cheat.sh/"$1"; }

#==============================================================================#
#               ------- Server - Environment ------                            #
#==============================================================================#
function load-env { export $(grep -v '^#' "$1" | xargs -d '\n'); }
function unload-env { unset $(grep -v '^#' "$1" | sed -E 's/(.*)=.*/\1/' | xargs); }

function set-env { load_env ${SERVER_HOME}/env/services.env; load_env ${SERVER_HOME}/env/secrets.env; }
function unset-env-fn { unload_env ${SERVER_HOME}/env/services.env; unload_env ${SERVER_HOME}/env/secrets.env; }

#==============================================================================#
#               ------- Bitwarden CLI ------                                   #
#==============================================================================#
function bitwarden-create-session-fn {
  # Prompt for the Bitwarden password securely
  echo -n 'Enter your Bitwarden password: '
  read -s BW_PASSWORD
  echo
  export BW_PASSWORD
  # Run the unlock command and set BW_SESSION
  BW_SESSION=$(bw unlock --passwordenv BW_PASSWORD --raw)
  # Check if the command succeeded
  if [ $? -eq 0 ]; then
    export BW_SESSION
    echo 'BW_SESSION set successfully.'
  else
    echo 'Failed to set BW_SESSION. Please check your password or Bitwarden setup.'
  fi
  # Unset the password variable for security
  unset BW_PASSWORD
}

function bitwarden-login-fn {
  # Prompt for the Bitwarden client id and secret securely
  echo -n 'Enter your Bitwarden client ID: '
  read -s BW_CLIENTID
  echo
  echo -n 'Enter your Bitwarden client secret: '
  read -s BW_CLIENTSECRET
  echo
  export BW_CLIENTID
  export BW_CLIENTSECRET
  # Run the login command
  bw login --apikey
  # Unset the API credentials variables for security
  unset BW_CLIENTID
  unset BW_CLIENTSECRET
}

function bitwarden-open-fn {
  bitwarden-login-fn
  bitwarden-create-session-fn
}

function bitwarden-create-item-notes-fn {
    bitwarden-create-session-fn
    notes=$(grep -v '^#' "$1")
    bw get template item | jq ".type = 1 | .name='$2' | .notes='${notes}'" | bw create item
    unset BW_SESSION
}

function bitwarden-load-env-fn {
    bitwarden-create-session-fn
    export $(bw get notes home_server_env | xargs -d '\n')
    unset BW_SESSION
}

function bitwarden-load-yml-fn {
    bitwarden-create-session-fn
    bw get notes home_server_yml > ${SERVER_HOME}/ansible/vars/secrets.yml
    unset BW_SESSION
}

#==============================================================================#
#               ------- Docker ------                                          #
#==============================================================================#
function docker-exec-fn { docker exec -it "$1" "${2:-bash}"; }
function docker-fn { docker "$@"; }
function docker-image-rm-dangling-fn {
    IMGS=$(docker images --filter 'dangling=true' -q --no-trunc)
    [[ -n ${IMGS} ]] && docker rmi ${IMGS} || echo 'no dangling images.'
}
function docker-inspect-fn { docker inspect "$1"; }
function docker-ip-fn {
  echo 'IP addresses of all named running containers'
  for DOC in $(docker-names-fn)
  do
    IP=$(docker inspect --format='{{ "{{" }}range .NetworkSettings.Networks{{ "}}" }}{{ "{{" }}.IPAddress{{ "}}" }} {{ "{{" }}end{{ "}}" }}' "$DOC")
    OUT+=$DOC'\t'$IP'\n'
  done
  echo -e "$OUT" | column -t
  unset OUT
}
function docker-logs-fn { docker logs -f "$1"; }
function docker-names-fn {
	for ID in $(docker ps | awk "{print $1}" | grep -v 'CONTAINER')
	do
    docker inspect "$ID" | grep Name | head -1 | awk "{print $2}" | sed 's/,//g' | sed 's%/%%g' | sed 's/"//g'
	done
}
function docker-network-rm-fn { docker network rm "$1"; }
function docker-pull-fn { docker pull "$1"; }
function docker-rm-exited-fn { docker rm "$(docker ps --all -q -f status=exited)"; }
function docker-run-fn { docker run -it "$1" "$2"; }
function docker-stop-rm-fn { docker stop "$1"; docker rm "$1"; }
function docker-volume-rm-fn { docker volume rm "$1"; }
function docker-volume-rm-dangling-fn {
    VOLS=$(docker volume ls --filter 'dangling=true' -q)
    [[ -n ${VOLS} ]] && docker volume rm ${VOLS} || echo 'no dangling volumes.'
}

function docker-image-rm-fn { docker image rm "$@"; }

#==============================================================================#
#               ------- Docker Compose ------                                  #
#==============================================================================#
function docker-compose-fn { docker compose "$@"; }
function docker-compose-run-fn { docker compose run "$@"; }

#==============================================================================#
#               ------- Terraform ------                                       #
#==============================================================================#
function terraform-fn { terraform "$@"; }
function terraform-state-fn { terraform state "$@"; }
