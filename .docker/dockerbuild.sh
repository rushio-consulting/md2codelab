#!/bin/bash
#============================================================================================================#
#title           :  dockerhub.sh
#description     :  Push to docker hub
#author		     :  bwnyasse
#===========================================================================================================#
set -e

if  [[ "$TRAVIS_BRANCH" == "master" ]]
then
  echo " Docker build for master branch"
  cd $CURRENT/.docker && \
    docker pull ${DOCKER_REPOSITORY}:latest || true && \
    docker build -t ${DOCKER_REPOSITORY} --pull=true .
fi

exit 0
