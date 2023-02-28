#!/bin/bash

#==============================================================================#
#AUTHOR: Clement Deltel
#DATE: 2023/02/28
#DESCRIPTION: One method to create the log file for all type of tasks executed.
#==============================================================================#

#==============================================================================#
#FUNCTION: main
#DESCRIPTION: Create the log file with the date of today if it does not already
#             exist.
#==============================================================================#
main(){
  LOG_FILE=$1

  if [[ ! -f ${LOG_FILE} || $(date +%d) == "01" ]]; then
    > ${LOG_FILE}
    echo "Log file successfully created!"
  else
    echo "Log file already exist. Skipping creation!"
  fi
}

main $@
