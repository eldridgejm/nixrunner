#! /usr/bin/env bash

if [ ! -e ./action-runner/.credentials ]; then
    echo "must configure runner with ./config.sh before running"
    exit 1
fi

docker run --rm \
	--mount type=volume,src=nixrunner-store,dst=/nix \
	--mount type=bind,src=$(pwd)/action-runner,dst=/home/nixrunner/action-runner \
	--mount type=bind,src=$(pwd)/work,dst=/home/nixrunner/work \
	--mount type=bind,src=/etc/localtime,dst=/etc/localtime \
    --mount type=bind,src=$(pwd)/ssh,dst=/home/nixrunner/.ssh \
    nixrunner "./action-runner/run.sh"
