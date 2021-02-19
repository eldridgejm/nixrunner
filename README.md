nixrunner
=========

A Dockerized self-hosted GitHub action runner that comes with Nix installed.

Requirements
------------
The host machine only needs Docker. It does not need to have nix installed.


Setup
-----

1. Clone this repository
2. Edit `config.sh`, filling in the values as necessary using those provided by GitHub.
3. Run `make` to build the Docker image and configure the runner.
4. (Optional) copy a machine user's private key to `ssh/id_rsa`.
5. Run `./run.sh` to start the runner.


Conventions
-----------

The `init.sh` script will create a docker volume named `nixrunner-store`. This volume
contains the Nix store for the image. This volume is shared between all containers running this
image, thereby caching the Nix store.

The `init.sh` script also bind mounts the `work` directory to `~/work` inside the
container. GitHub actions can take advantage of this to persist values between restarts
of the action runner.

It also binds `action-runner` to `~/action-runner` inside the container. Upon
configuration, the action runner is installed to this bound directory and configured.
In this way, the configuration persists between restarts of the container.
