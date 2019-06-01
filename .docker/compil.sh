#!/bin/bash
#============================================================================================================#
#title           :  dockerhub.sh
#description     :  Push to docker hub
#author		     :  bwnyasse
#===========================================================================================================#
set -e

# Check current docker engine version
docker --version

# set env vars in the build settings to interact with repositories
# see https://docs.travis-ci.com/user/environment-variables/#Defining-Variables-in-Repository-Settings
echo "Testing Docker Hub credentials"
docker login -u=$DOCKER_USERNAME -p=$DOCKER_PASSWORD
bash $CURRENT/.jobs/compil-in-docker.sh

exit 0
