#!/bin/bash

#==============================================================================#
#AUTHOR: Clement Deltel
#DATE: 2023/02/27
#DESCRIPTION: Lists all the methods to restore all services.
#==============================================================================#

#==============================================================================#
#FUNCTION: main
#==============================================================================#
main(){
    # Restore Bitwarden
    ./${SERVER_HOME}/scripts/restore/bitwarden.sh all
}

source ~/.bashrc
main $@
