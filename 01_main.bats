#!/usr/bin/env bats

setup() {
  load 'common-setup'
  _common_setup
}

@test "get a keystone token" {
  run openstack token issue -c expires -f value
  assert_success
  assert [ $(date '+%s') -lt $(date -d "$output" '+%s') ]
}
