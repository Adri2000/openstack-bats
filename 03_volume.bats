#!/usr/bin/env bats

setup() {
  load 'common-setup'
  _common_setup
}

setup_file() {
  export testvolume="test-volume-bats-$(date '+%Y%m%d%H%M%S')"
}

@test "list volumes" {
  run openstack volume list
  assert_success
}

@test "create volume" {
  openstack volume create --size 5 $testvolume
}

@test "resize volume" {
  openstack volume set --size 10 $testvolume
  run openstack volume show $testvolume -c status -f value
  assert_success
  assert_output 'available'
  run openstack volume show $testvolume -c size -f value
  assert_success
  assert_output '10'
}

@test "resize volume to smaller size (fails)" {
  run openstack volume set --size 5 $testvolume
  assert_failure
  run openstack volume show $testvolume -c status -f value
  assert_success
  assert_output 'available'
  run openstack volume show $testvolume -c size -f value
  assert_success
  assert_output '10'
}

@test "create volume snapshot" {
  openstack volume snapshot create --volume $testvolume snapshot-$testvolume
}

@test "delete volume snapshot" {
  openstack volume snapshot delete snapshot-$testvolume
}

@test "delete volume" {
  openstack volume delete $testvolume
}

teardown_file() {
    if openstack volume show $testvolume >/dev/null; then
      openstack volume delete $testvolume
    fi
    if openstack volume snapshot show snapshot-$testvolume >/dev/null; then
      openstack volume snapshot delete $testvolume
    fi
}
