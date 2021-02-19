FROM debian:buster
ARG USER_ID=1000
ARG GROUP_ID=100
ARG RUNNER_VERSION="2.277.1"

RUN apt-get update && apt-get install -y curl git bash libicu63 openssl xz-utils python3

# create a "nixrunner" user with the same user ID as host
RUN useradd -u ${USER_ID} -g ${GROUP_ID} -ms /bin/sh nixrunner

# install nix as nixrunner
RUN install -d -m755 -o $(id -u nixrunner) -g $(id -g nixrunner) /nix
USER nixrunner
RUN curl -L https://github.com/numtide/nix-flakes-installer/releases/download/nix-2.4pre20210126_f15f0b8/install | sh
RUN echo "export USER=nixrunner; source /home/nixrunner/.nix-profile/etc/profile.d/nix.sh" > /home/nixrunner/.profile

# install newer version of nix and enable experimental flakes feature
RUN mkdir -p ~/.config/nix
RUN echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# download and extract github runner
RUN cd ~ && mkdir action-runner-base && cd action-runner-base && \
    curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    tar xzf actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    rm -rf actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

USER root
RUN echo \
    '#! /bin/bash\n' \
    'source /home/nixrunner/.profile\n' \
    '[ ! -e ~/.ssh/known_hosts ] && ssh-keyscan github.com > ~/.ssh/known_hosts\n' \
    'bash -c "$@"\n' >> /home/nixrunner/entry.sh
RUN chown nixrunner /home/nixrunner/entry.sh
RUN chmod +x /home/nixrunner/entry.sh
USER nixrunner
ENV SHELL bash

RUN git config --global user.email "nixrunner@localhost"
RUN git config --global user.name "nixrunner"

RUN mkdir /home/nixrunner/work

WORKDIR /home/nixrunner
ENTRYPOINT ["/home/nixrunner/entry.sh"]
CMD ["bash"]
