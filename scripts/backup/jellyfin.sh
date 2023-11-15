#!/bin/bash

#==============================================================================#
#AUTHOR: Clement Deltel
#DATE: 2023/09/29
#DESCRIPTION: Lists all the methods to backup all elements of Jellyfin.
#==============================================================================#

#==============================================================================#
#FUNCTION: backup_config
#DESCRIPTION: Executes all the steps to create and save a backup of the
#             config directory.
#==============================================================================#
backup_config(){
  # Evaluation of the time to perform this task: worst case scenario 15s
  echo "${TODAY} [INFO] Configuration directory backup start..." | tee -a ${LOG_FILE}

  # Copy configuration file from persitence directory for formatting
  OBJECT=$(date +%m)_config.tar.gz
  echo "${TODAY} [INFO] tar -zcvf ${OBJECT} persistence/library" | tee -a ${LOG_FILE}
  tar -zcvf ${OBJECT} persistence/library

  # S3 bucket - Move the file to the backup directory
  echo "${TODAY} [INFO] aws s3 mv ${OBJECT} s3://${S3_BUCKET}/${CONTAINER_NAME}/config/" | tee -a ${LOG_FILE}
  aws s3 mv ${OBJECT} s3://${S3_BUCKET}/${CONTAINER_NAME}/config/

  echo "${TODAY} [INFO] Successful backup!" | tee -a ${LOG_FILE}
  echo "#===============================================================#" | tee -a ${LOG_FILE}
}

#==============================================================================#
#FUNCTION: main
#==============================================================================#
main(){
  BACKUP_STRATEGY="S3"
  CONTAINER_NAME="jellyfin"
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
    backup_config
  fi

  cd ${INIT_PWD}
}

source ~/.bashrc
main $@
