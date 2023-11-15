#!/bin/bash

#==============================================================================#
#AUTHOR: Clement Deltel
#DATE: 2023/03/16
#DESCRIPTION: Lists all the methods to restore all elements of Vaultwarden.
#==============================================================================#

#==============================================================================#
#FUNCTION: restore_database
#DESCRIPTION: Executes all the steps to restore from an existing backup of the
#             database.
#==============================================================================#
restore_database(){
  # Evaluation of the time to perform this task: worst case scenario 1m
  echo "${TODAY} [INFO] Database recovery start..." | tee -a ${LOG_FILE}

  # S3 bucket - Grab the latest version of the database
  OBJECT=$(aws s3 ls s3://${S3_BUCKET}/${CONTAINER_NAME}/database/ | tail -n 1 | awk '{print $4}')

  # S3 bucket - Copy the archive to the service directory
  echo "${TODAY} [INFO] aws s3 cp s3://${S3_BUCKET}/${CONTAINER_NAME}/database/${OBJECT} ${OBJECT}" | tee -a ${LOG_FILE}
  aws s3 cp s3://${S3_BUCKET}/${CONTAINER_NAME}/database/${OBJECT} ${OBJECT}

  echo "${TODAY} [INFO] File used for database recovery: ${OBJECT}" | tee -a ${LOG_FILE}

  # Restore database from file
  echo "${TODAY} [INFO] gunzip -c *.gz | mysql -h ${VAULTWARDEN_DB_IP} -u ${VAULTWARDEN_DB_USER} -p${VAULTWARDEN_DB_PASSWORD} vaultwarden_db" | tee -a ${LOG_FILE}
  gunzip -c *.gz | mysql -h ${VAULTWARDEN_DB_IP} -u ${VAULTWARDEN_DB_USER} -p${VAULTWARDEN_DB_PASSWORD} vaultwarden_db

  # Delete the gzip file
  rm -f ${OBJECT}

  echo "${TODAY} [INFO] Successful database recovery!" | tee -a ${LOG_FILE}
  echo "#===============================================================#" | tee -a ${LOG_FILE}
}

#==============================================================================#
#FUNCTION: restore_attachments
#DESCRIPTION: Executes all the steps to restore from an existing backup of the
#             attachments.
#==============================================================================#
restore_attachments(){
  # Evaluation of the time to perform this task: worst case scenario 1m
  echo "${TODAY} [INFO] Attachments recovery start..." | tee -a ${LOG_FILE}

  # S3 bucket - Grab the latest version of the attachments
  OBJECT=$(aws s3 ls s3://${S3_BUCKET}/${CONTAINER_NAME}/attachments/ | tail -n 1 | awk '{print $4}')

  if [[ ! -z ${OBJECT} ]]; then
    # S3 bucket - Copy the archive to the service directory
    echo "${TODAY} [INFO] aws s3 cp s3://${S3_BUCKET}/${CONTAINER_NAME}/attachments/${OBJECT} ${OBJECT}" | tee -a ${LOG_FILE}
    aws s3 cp s3://${S3_BUCKET}/${CONTAINER_NAME}/attachments/${OBJECT} ${OBJECT}

    echo "${TODAY} [INFO] File used for attachments recovery: ${OBJECT}" | tee -a ${LOG_FILE}

    # Uncompress the TAR archive to its target directory
    echo "${TODAY} [INFO] tar -zxvf ${OBJECT}"
    tar -zxvf ${OBJECT}

    # Delete the TAR archive
    rm -f ${OBJECT}

    echo "${TODAY} [INFO] Successful recovery!" | tee -a ${LOG_FILE}
    echo "#===============================================================#" | tee -a ${LOG_FILE}
  else
    echo "${TODAY} [INFO] No attachments to recover!" | tee -a ${LOG_FILE}
    echo "#===============================================================#" | tee -a ${LOG_FILE}
  fi
}

#==============================================================================#
#FUNCTION: restore_sends
#DESCRIPTION: Executes all the steps to restore from an existing backup of the
#             sends.
#==============================================================================#
restore_sends(){
  # Evaluation of the time to perform this task: worst case scenario 1m
  echo "${TODAY} [INFO] Sends recovery start..." | tee -a ${LOG_FILE}

  # S3 bucket - Grab the latest version of the sends
  OBJECT=$(aws s3 ls s3://${S3_BUCKET}/${CONTAINER_NAME}/sends/ | tail -n 1 | awk '{print $4}')

  if [[ ! -z ${OBJECT} ]]; then
    # S3 bucket - Copy the archive to the service directory
    echo "${TODAY} [INFO] aws s3 cp s3://${S3_BUCKET}/${CONTAINER_NAME}/sends/${OBJECT} ${OBJECT}" | tee -a ${LOG_FILE}
    aws s3 cp s3://${S3_BUCKET}/${CONTAINER_NAME}/sends/${OBJECT} ${OBJECT}

    echo "${TODAY} [INFO] File used for sends recovery: ${OBJECT}" | tee -a ${LOG_FILE}

    # Uncompress the TAR archive to its target directory
    echo "${TODAY} [INFO] tar -zxvf ${OBJECT}"
    tar -zxvf ${OBJECT}

    # Delete the TAR archive
    rm -f ${OBJECT}

    echo "${TODAY} [INFO] Successful recovery!" | tee -a ${LOG_FILE}
    echo "#===============================================================#" | tee -a ${LOG_FILE}
  else
    echo "${TODAY} [INFO] No sends to recover!" | tee -a ${LOG_FILE}
    echo "#===============================================================#" | tee -a ${LOG_FILE}
  fi
}

#==============================================================================#
#FUNCTION: restore_config
#DESCRIPTION: Executes all the steps to restore from an existing backup of the
#             configuration file.
#==============================================================================#
restore_config(){
  # Evaluation of the time to perform this task: worst case scenario 15s
  echo "${TODAY} [INFO] Configuration file recovery start..." | tee -a ${LOG_FILE}

  # S3 bucket - Grab the latest version of the configuration file
  OBJECT=$(aws s3 ls s3://${S3_BUCKET}/${CONTAINER_NAME}/config/ | tail -n 1 | awk '{print $4}')

  # S3 bucket - Copy the configuration file to the service directory
  echo "${TODAY} [INFO] aws s3 cp s3://${S3_BUCKET}/${CONTAINER_NAME}/config/${OBJECT} persistence/config.json" | tee -a ${LOG_FILE}
  aws s3 cp s3://${S3_BUCKET}/${CONTAINER_NAME}/config/${OBJECT} persistence/config.json

  echo "${TODAY} [INFO] Successful recovery!" | tee -a ${LOG_FILE}
  echo "#===============================================================#" | tee -a ${LOG_FILE}
}

#==============================================================================#
#FUNCTION: restore_rsa_keys
#DESCRIPTION: Executes all the steps to restore from an existing backup of the
#             rsa_keys.
#==============================================================================#
restore_rsa_keys(){
  # Evaluation of the time to perform this task: worst case scenario 15s
  echo "${TODAY} [INFO] RSA keys recovery start..." | tee -a ${LOG_FILE}

  # S3 bucket - Grab the latest version of the rsa_keys
  OBJECT=$(aws s3 ls s3://${S3_BUCKET}/${CONTAINER_NAME}/rsa_keys/ | tail -n 1 | awk '{print $4}')

  if [[ ! -z ${OBJECT} ]]; then
    # S3 bucket - Copy the archive to the service directory
    echo "${TODAY} [INFO] aws s3 cp s3://${S3_BUCKET}/${CONTAINER_NAME}/rsa_keys/${OBJECT} ${OBJECT}" | tee -a ${LOG_FILE}
    aws s3 cp s3://${S3_BUCKET}/${CONTAINER_NAME}/rsa_keys/${OBJECT} ${OBJECT}

    echo "${TODAY} [INFO] File used for rsa_keys recovery: ${OBJECT}" | tee -a ${LOG_FILE}

    # Uncompress the TAR archive to its target directory
    echo "${TODAY} [INFO] tar -zxvf ${OBJECT}"
    tar -zxvf ${OBJECT}

    # Delete the TAR archive
    rm -f ${OBJECT}

    echo "${TODAY} [INFO] Successful recovery!" | tee -a ${LOG_FILE}
    echo "#===============================================================#" | tee -a ${LOG_FILE}
  else
    echo "${TODAY} [INFO] No RSA keys to recover!" | tee -a ${LOG_FILE}
    echo "#===============================================================#" | tee -a ${LOG_FILE}
  fi
}

#==============================================================================#
#FUNCTION: restore_icon_cache
#DESCRIPTION: Executes all the steps to restore from an existing backup of the
#             icon_cache.
#==============================================================================#
restore_icon_cache(){
  # Evaluation of the time to perform this task: worst case scenario 1m
  echo "${TODAY} [INFO] Icon cache recovery start..." | tee -a ${LOG_FILE}

  # S3 bucket - Grab the latest version of the icon_cache
  OBJECT=$(aws s3 ls s3://${S3_BUCKET}/${CONTAINER_NAME}/icon_cache/ | tail -n 1 | awk '{print $4}')

  if [[ ! -z ${OBJECT} ]]; then
    # S3 bucket - Copy the archive to the service directory
    echo "${TODAY} [INFO] aws s3 cp s3://${S3_BUCKET}/${CONTAINER_NAME}/icon_cache/${OBJECT} ${OBJECT}" | tee -a ${LOG_FILE}
    aws s3 cp s3://${S3_BUCKET}/${CONTAINER_NAME}/icon_cache/${OBJECT} ${OBJECT}

    echo "${TODAY} [INFO] File used for icon_cache recovery: ${OBJECT}" | tee -a ${LOG_FILE}

    # Uncompress the TAR archive to its target directory
    echo "${TODAY} [INFO] tar -zxvf ${OBJECT}"
    tar -zxvf ${OBJECT}

    # Delete the TAR archive
    rm -f ${OBJECT}

    echo "${TODAY} [INFO] Successful recovery!" | tee -a ${LOG_FILE}
    echo "#===============================================================#" | tee -a ${LOG_FILE}
  else
    echo "${TODAY} [INFO] No Icon cache to recover!" | tee -a ${LOG_FILE}
    echo "#===============================================================#" | tee -a ${LOG_FILE}
  fi
}

#==============================================================================#
#FUNCTION: restore_docker_image
#DESCRIPTION:
#==============================================================================#
restore_docker_image(){
  true
}

#==============================================================================#
#FUNCTION: main
#==============================================================================#
main(){
  RESTORE_STRATEGY="S3"
  CONTAINER_NAME="vaultwarden"
  TASK=$1

  # Get the date
  TODAY=$(date +%Y%m%d_%H%M)

  # Logging
  LOG_FILE="${LOG_HOME}/${CONTAINER_NAME}/restore_${TASK}_$(date +%m).log"
  create_log_file.sh ${LOG_FILE}

  # Current directory
  INIT_PWD=$(pwd)
  cd ${SERVER_HOME}/services/${CONTAINER_NAME}

  if [[ ${TASK} == "all" ]];then
    restore_database
    restore_attachments
    restore_sends
    restore_config
    restore_rsa_keys
    restore_icon_cache
    restore_docker_image

  elif [[ ${TASK} == "database" ]];then
    restore_database

  elif [[ ${TASK} == "attachments" ]];then
    restore_attachments

  elif [[ ${TASK} == "sends" ]];then
    restore_sends

  elif [[ ${TASK} == "config" ]];then
    restore_config

  elif [[ ${TASK} == "rsa_keys" ]];then
    restore_rsa_keys

  elif [[ ${TASK} == "icon_cache" ]];then
    restore_icon_cache

  elif [[ ${TASK} == "docker_image" ]];then
    restore_docker_image
  fi

  # Reboot Vaultwarden
  echo "${TODAY} [INFO] docker restart ${CONTAINER_NAME}" | tee -a ${LOG_FILE}
  docker restart ${CONTAINER_NAME}

  cd ${INIT_PWD}
}

source ~/.bashrc
main $@
