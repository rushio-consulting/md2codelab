#!/bin/bash
#============================================================================================================#
#title           :  dockerhub.sh
#description     :  Push to docker hub
#author		     :  bwnyasse
#===========================================================================================================#
set -e

echo " Docker Hub deployment for master branch"
docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD"
docker push ${DOCKER_REPOSITORY}:latest

exit 0
