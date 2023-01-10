#!/usr/bin/env bash

set -euo pipefail

mkdir -p /etc/openstack/
echo $CLOUDS_YAML | base64 -d > /etc/openstack/clouds.yaml

export OS_CLOUD=default
bats -t .
