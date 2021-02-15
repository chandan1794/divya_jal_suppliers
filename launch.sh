#!/usr/bin/env bash
if [[ $* == "" ]]; then
    echo "Insert launch path"
    exit -1
fi

PROJECT_DIR=$1
ENV=$2

source ${PROJECT_DIR}/config/${ENV}.sh
source ${PROJECT_DIR}/config/env.sh

python3 -m flask run
