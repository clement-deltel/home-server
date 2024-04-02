#!/bin/bash

SERVER_HOME=/opt/home-server
source ${SERVER_HOME}/env/.env

CONNECTION_STRING="--host localhost --port ${MINECRAFT_RCON_PORT} --password ${MINECRAFT_RCON_PASSWORD}"

docker exec minecraft rcon-cli ${CONNECTION_STRING} say "[WARNING] Server backup process will begin in 5 minutes." sleep 5m

docker exec minecraft rcon-cli ${CONNECTION_STRING} say "[WARNING] Server backup process is starting NOW."
docker exec minecraft rcon-cli ${CONNECTION_STRING} save-off
docker exec minecraft rcon-cli ${CONNECTION_STRING} save-all
tar -cpf ${SERVER_HOME}/services/kopia/persistence/files/minecraft.tar ${SERVER_HOME}/services/minecraft/persistence

docker exec minecraft rcon-cli ${CONNECTION_STRING} save-on
docker exec minecraft rcon-cli ${CONNECTION_STRING} say "[NOTICE] Server backup process is complete. Carry on."
