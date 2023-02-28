#!/bin/bash

#==============================================================================#
#AUTHOR: Clement Deltel
#DATE: 2023/02/27
#DESCRIPTION: Lists all the methods to backup all elements of Bitwarden.
#==============================================================================#

#==============================================================================#
#FUNCTION: backup_database
#DESCRIPTION: Executes all the steps to create and save a backup of the #             database.
#==============================================================================#
backup_database(){
  # Evaluation of the time to perform this task: worst case scenario
  echo "${TODAY} [INFO] Database backup start..." | tee -a ${LOG_FILE}

  # Create database backup directory
  OBJECT=$(date +%m)_bitwarden_db
  echo "${TODAY} [INFO] mkdir ${OBJECT}"
  mkdir ${OBJECT}

  # Backup the database
  echo "${TODAY} [INFO] sqlite3 persistence/db.sqlite3 '.backup '${OBJECT}/db.sqlite3''"
  sqlite3 persistence/db.sqlite3 ".backup '${OBJECT}/db.sqlite3'"

  # Compress the directory to a TAR archive
  echo "${TODAY} [INFO] tar -zcvf ${OBJECT}.tar.gz ${OBJECT}"
  tar -zcvf ${OBJECT}.tar.gz ${OBJECT}

  # Delete database backup directory
  echo "${TODAY} [INFO] rm -rf ${OBJECT}"
  rm -rf ${OBJECT}

  # S3 bucket - Move the file to the backup directory
  OBJECT=${OBJECT}.tar.gz
  echo "${TODAY} [INFO] aws s3 mv ${OBJECT} s3://${S3_BUCKET}/${CONTAINER_NAME}/database/"
  aws s3 mv ${OBJECT} s3://${S3_BUCKET}/${CONTAINER_NAME}/database/

  echo "${TODAY} [INFO] Successful backup!" | tee -a ${LOG_FILE}
  echo "#===============================================================#" | tee -a ${LOG_FILE}
}

#==============================================================================#
#FUNCTION: backup_attachments
#DESCRIPTION: Executes all the steps to create and save a backup of the #             attachments.
#==============================================================================#
backup_attachments(){
  # Evaluation of the time to perform this task: worst case scenario
  echo "${TODAY} [INFO] Attachments backup start..." | tee -a ${LOG_FILE}

  if [[ -d "persistence/attachments" ]]; then
    # Compress the directory to a TAR archive
    OBJECT=$(date +%m)_attachments.tar.gz
    echo "${TODAY} [INFO] tar -zcvf ${OBJECT} persistence/attachments"
    tar -zcvf ${OBJECT} persistence/attachments

    # S3 bucket - Move the file to the backup directory
    echo "${TODAY} [INFO] aws s3 mv ${OBJECT} s3://${S3_BUCKET}/${CONTAINER_NAME}/attachments/"
    aws s3 mv ${OBJECT} s3://${S3_BUCKET}/${CONTAINER_NAME}/attachments/

    echo "${TODAY} [INFO] Successful backup!" | tee -a ${LOG_FILE}
    echo "#===============================================================#" | tee -a ${LOG_FILE}
  fi
}

#==============================================================================#
#FUNCTION: backup_sends
#DESCRIPTION: Executes all the steps to create and save a backup of the sends.
#==============================================================================#
backup_sends(){
  # Evaluation of the time to perform this task: worst case scenario
  # Start time: every first of the month at 1AM
  echo "${TODAY} [INFO] Sends backup start..." | tee -a ${LOG_FILE}

  if [[ -d "persistence/sends" ]]; then
    # Compress the directory to a TAR archive
    OBJECT=$(date +%m)_sends.tar.gz
    echo "${TODAY} [INFO] tar -zcvf ${OBJECT} persistence/sends"
    tar -zcvf ${OBJECT} persistence/sends

    # S3 bucket - Move the file to the backup directory
    echo "${TODAY} [INFO] aws s3 mv ${OBJECT} s3://${S3_BUCKET}/${CONTAINER_NAME}/sends/"
    aws s3 mv ${OBJECT} s3://${S3_BUCKET}/${CONTAINER_NAME}/sends/

    echo "${TODAY} [INFO] Successful backup!" | tee -a ${LOG_FILE}
    echo "#===============================================================#" | tee -a ${LOG_FILE}
  fi
}

#==============================================================================#
#FUNCTION: backup_config
#DESCRIPTION: Executes all the steps to create and save a backup of the #             configuration file.
#==============================================================================#
backup_config(){
  # Evaluation of the time to perform this task: worst case scenario 1 min
  # Start time: every first of the month at 1AM
  echo "${TODAY} [INFO] Configuration file backup start..." | tee -a ${LOG_FILE}

  # Copy configuration file from Bitwarden persitence directory for formatting
  OBJECT=$(date +%m)_config.json
  echo "${TODAY} [INFO] cp persistence/config.json ${OBJECT}" | tee -a ${LOG_FILE}
  cp persistence/config.json ${OBJECT}

  # S3 bucket - Move the file to the backup directory
  echo "${TODAY} [INFO] aws s3 mv ${OBJECT} s3://${S3_BUCKET}/${CONTAINER_NAME}/config/" | tee -a ${LOG_FILE}
  aws s3 mv ${OBJECT} s3://${S3_BUCKET}/${CONTAINER_NAME}/config/

  echo "${TODAY} [INFO] Successful backup!" | tee -a ${LOG_FILE}
  echo "#===============================================================#" | tee -a ${LOG_FILE}
}

#==============================================================================#
#FUNCTION: backup_rsa_keys
#DESCRIPTION: Executes all the steps to create and save a backup of the #             rsa_keys.
#==============================================================================#
backup_rsa_keys(){
  # Evaluation of the time to perform this task: worst case scenario
  # Start time: every first of the month at 1AM
  echo "${TODAY} [INFO] RSA keys backup start..." | tee -a ${LOG_FILE}

  # Compress the files to a TAR archive
  OBJECT=$(date +%m)_rsa_keys.tar.gz
  echo "${TODAY} [INFO] tar -zcvf ${OBJECT} persistence/rsa_key*"
  tar -zcvf ${OBJECT} persistence/rsa_key*

  # S3 bucket - Move the file to the backup directory
  echo "${TODAY} [INFO] aws s3 mv ${OBJECT} s3://${S3_BUCKET}/${CONTAINER_NAME}/rsa_keys/" | tee -a ${LOG_FILE}
  aws s3 mv ${OBJECT} s3://${S3_BUCKET}/${CONTAINER_NAME}/rsa_keys/

  echo "${TODAY} [INFO] Successful backup!" | tee -a ${LOG_FILE}
  echo "#===============================================================#" | tee -a ${LOG_FILE}
}

#==============================================================================#
#FUNCTION: backup_icon_cache
#DESCRIPTION: Executes all the steps to create and save a backup of the #             icon_cache.
#==============================================================================#
backup_icon_cache(){
  # Evaluation of the time to perform this task: worst case scenario
  # Start time: every first of the month at 1AM
  echo "${TODAY} [INFO] Icon cache backup start..." | tee -a ${LOG_FILE}

  if [[ -d "persistence/icon_cache" ]]; then
    # Compress the directory to a TAR archive
    OBJECT=$(date +%m)_icon_cache.tar.gz
    echo "${TODAY} [INFO] tar -zcvf ${OBJECT} persistence/icon_cache"
    tar -zcvf ${OBJECT} persistence/icon_cache

    # S3 bucket - Move the file to the backup directory
    echo "${TODAY} [INFO] aws s3 mv ${OBJECT} s3://${S3_BUCKET}/${CONTAINER_NAME}/icon_cache/"
    aws s3 mv ${OBJECT} s3://${S3_BUCKET}/${CONTAINER_NAME}/icon_cache/

    echo "${TODAY} [INFO] Successful backup!" | tee -a ${LOG_FILE}
    echo "#===============================================================#" | tee -a ${LOG_FILE}
  fi
}

#==============================================================================#
#FUNCTION: backup_docker_image
#DESCRIPTION:
#==============================================================================#
backup_docker_image(){
  true
}

#==============================================================================#
#FUNCTION: main
#==============================================================================#
main(){
  BACKUP_STRATEGY="S3"
  CONTAINER_NAME="bitwarden"
  TASK=$1

  # Get the date
  TODAY=$(date +%Y%m%d_%H%M)

  # Logging
  LOG_FILE="${LOG_HOME}/${CONTAINER_NAME}/backup_${TASK}_$(date +%m).log"
  create_log_file.sh ${LOG_FILE}

  # Current directory
  INIT_PWD=$(pwd)
  cd ${SERVER_HOME}/services/${CONTAINER_NAME}

  if [[ ${TASK} == "all" ]];then
    backup_database
    backup_attachments
    backup_sends
    backup_config
    backup_rsa_keys
    backup_icon_cache
    backup_docker_image

  elif [[ ${TASK} == "database" ]];then
    backup_database

  elif [[ ${TASK} == "attachments" ]];then
    backup_attachments

  elif [[ ${TASK} == "sends" ]];then
    backup_sends

  elif [[ ${TASK} == "config" ]];then
    backup_config

  elif [[ ${TASK} == "rsa_keys" ]];then
    backup_rsa_keys

  elif [[ ${TASK} == "icon_cache" ]];then
    backup_icon_cache

  elif [[ ${TASK} == "docker_image" ]];then
    backup_docker_image
  fi

  cd ${INIT_PWD}
}

source ~/.bash_profile
main $@
