#! /usr/bin/env bash

source config.sh

if [ -z "$URL" ]; then
    echo "Error: Must set URL in config.sh."; exit 1;
fi

if [ -z "$TOKEN" ]; then
    echo "Error: Must set TOKEN in config.sh."; exit 1;
fi

if [ -z "$NAME" ]; then
    echo "Error: Must set NAME in config.sh."; exit 1;
fi

docker run -it --rm \
	--mount type=volume,src=nixrunner-store,dst=/nix \
	--mount type=bind,src=$(pwd)/work,dst=/home/nixrunner/work \
    --mount type=bind,src=$(pwd)/ssh,dst=/home/nixrunner/.ssh \
    nixrunner "./action-runner/config.sh --unattended --url $URL --token $TOKEN --name $NAME --replace && ./action-runner/run.sh"
