#!/bin/bash
#============================================================================================================#
#title           :  compil.sh
#description     :  App Compilation
#author		     :  bwnyasse
#===========================================================================================================#
set -e


echo "Launch compilation in docker container"

docker run -v $PWD:/app \
    registry.gitlab.com/santetis/open_source/santetis_image \
    bash -c "cd /app &&  ./.jobs/compil.sh"