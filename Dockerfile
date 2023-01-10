FROM ubuntu:22.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git python3-pip curl jq iputils-ping && \
    rm -rf /var/lib/apt/lists/*

# bats-core
RUN cd /tmp && git clone https://github.com/bats-core/bats-core.git && cd bats-core && ./install.sh /usr/local
# bats-support
RUN git clone https://github.com/bats-core/bats-support /usr/local/lib/bats-support
# bats-assert
RUN git clone https://github.com/bats-core/bats-assert /usr/local/lib/bats-assert

# openstackclient
RUN pip install python-openstackclient

WORKDIR /root/openstack-bats
ENTRYPOINT ["bats"]
