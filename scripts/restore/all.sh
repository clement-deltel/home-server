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
    # Restore Vaultwarden
    ./${SERVER_HOME}/scripts/restore/vaultwarden.sh all
}

source ~/.bashrc
main $@
