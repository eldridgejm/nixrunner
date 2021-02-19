nixrunner
=========

A Dockerized self-hosted GitHub action runner that comes with Nix installed.


Setup
-----

1. Clone this repository
2. Run `make` to build the Docker image. It will be named `nixrunner`.
3. Edit `config.sh`, filling in the values as necessary using those provided by GitHub.
4. (Optional) copy a machine user's private key to `ssh/id_rsa`.
5. Run `./init.sh` to start the runner.


Conventions
-----------

The `init.sh` script will create a docker volume named `nixrunner-store`. This volume
contains the Nix store for the image. This makes is easy to share a Nix store between
containers.

The `init.sh` script also bind mounts the `work` directory to `~/work` inside the
container. GitHub actions can take advantage of this to store persistent values.
