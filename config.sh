#! /usr/bin/env bash

# the repository URL
URL=https://github.com/USER/REPO

# the runner token; get this from the settings page of the repo
TOKEN=

# the name used to identify the runner. can be anything.
NAME=


if [ -z "$URL" ]; then
    echo "Error: Must set URL in config.sh."; exit 1;
fi

if [ -z "$TOKEN" ]; then
    echo "Error: Must set TOKEN in config.sh."; exit 1;
fi

if [ -z "$NAME" ]; then
    echo "Error: Must set NAME in config.sh."; exit 1;
fi


read -d '' command <<- EOF
    if [ ! -e ./action-runner/.credentials ]; then
        cp -r action-runner-base/* action-runner/
        cd action-runner
        ./config.sh --unattended --url $URL --token $TOKEN --name $NAME --replace
    else
        echo "action runner already configured"
    fi
EOF

docker run -it --rm \
	--mount type=volume,src=nixrunner-store,dst=/nix \
	--mount type=bind,src=$(pwd)/work,dst=/home/nixrunner/work \
	--mount type=bind,src=$(pwd)/action-runner,dst=/home/nixrunner/action-runner \
    --mount type=bind,src=$(pwd)/ssh,dst=/home/nixrunner/.ssh \
    nixrunner "$command"
