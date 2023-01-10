#!/usr/bin/env bats

setup() {
  load 'common-setup'
  _common_setup
}

setup_file() {
  export testfloatingip="test-floatingip-bats-$(date '+%Y%m%d%H%M%S')"
}

@test "create floating ip" {
  run openstack floating ip create --tag $testfloatingip external
  assert_success
}

@test "delete floating ip" {
  id=$(openstack floating ip list --tags $testfloatingip -f value -c 'ID')
  run openstack floating ip delete $id
  assert_success
}

teardown_file() {
  id=$(openstack floating ip list --tags $testfloatingip -f value -c 'ID')
  if [ ! -z $id ]; then
    openstack floating ip delete $id
  fi
}
