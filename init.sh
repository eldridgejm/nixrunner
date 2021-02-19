#! /usr/bin/env bash

source config.sh

docker run -it --rm \
	--mount type=volume,src=nixrunner-store,dst=/nix \
	--mount type=bind,src=$(pwd)/work,dst=/home/nixrunner/work \
    --mount type=bind,src=$(pwd)/ssh,dst=/home/nixrunner/.ssh \
    nixrunner "./action-runner/config.sh --unattended --url $URL --token $TOKEN --name $NAME --replace && ./action-runner/run.sh"
