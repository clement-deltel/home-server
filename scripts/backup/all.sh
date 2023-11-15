#!/bin/bash

#==============================================================================#
#AUTHOR: Clement Deltel
#DATE: 2023/02/27
#DESCRIPTION: Lists all the methods to backup all services based on the #             frequency.
#==============================================================================#

#==============================================================================#
#FUNCTION: main
#==============================================================================#
main(){
  TIME=$1

  # Every hour of every day
  if [[ ${TIME} = 'hourly' ]];then
    echo "Hourly backup activities done!"

  # Every day at 4:00AM CST
  elif [[ ${TIME} = 'daily' ]];then
    ${SERVER_HOME}/scripts/backup/vaultwarden.sh all
    echo "Daily backup activities done!"

  # Every Monday at 03:00AM CST
  elif [[ ${TIME} = 'weekly' ]];then
    echo "Weekly backup activities done!"

  # Every 1st of the month at 2:00AM CST
  elif [[ ${TIME} = 'monthly' ]];then
    ${SERVER_HOME}/scripts/backup/jellyfin.sh all
    echo "Monthly backup activities done!"

  # Every January 1st at 1:00AM CST
  elif [[ ${TIME} = 'yearly' ]];then
    echo "Quarter backup activities done!"
  fi
}

source ~/.bashrc
main $@
