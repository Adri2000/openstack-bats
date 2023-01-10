#!/usr/bin/env bats

setup() {
  load 'common-setup'
  _common_setup
}

setup_file() {
  export testcontainer="test-container-bats-$(date '+%Y%m%d%H%M%S')"
}

@test "list containers" {
  run openstack container list
  assert_success
}

@test "create container" {
  openstack container create $testcontainer
}

@test "delete container" {
  openstack container delete $testcontainer
}

teardown_file() {
    if openstack container show $testcontainer >/dev/null; then
      openstack container delete $testcontainer
    fi
}
