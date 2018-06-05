#!/bin/bash
#============================================================================================================#
#title           :  compil.sh
#description     :  App Compilation
#author		     :  bwnyasse
#===========================================================================================================#
set -e

readonly BASEDIR=$( cd $( dirname $0 ) && pwd )
readonly SRC="$BASEDIR/.."

echo "Build md2codelab lib"
pub get \
    && pub run test || exit 1

echo "Build md2codelab ui"
cd extra/ui
pub get \
    && pub global activate webdev \
    && pub get \
    && export PATH="$PATH":"~/.pub-cache/bin" \
    && webdev build --release || exit 1
