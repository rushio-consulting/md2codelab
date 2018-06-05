#!/bin/bash
#============================================================================================================#
#title           :  dockerhub.sh
#description     :  Push to docker hub
#author		     :  bwnyasse
#===========================================================================================================#
set -e

if  [[ "$TRAVIS_BRANCH" == "master" ]]
then
  echo " Docker Hub deployment for master branch"
  docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD"
  docker tag ${DOCKER_REPOSITORY}:latest
  docker push ${DOCKER_REPOSITORY}:latest
fi

exit 0