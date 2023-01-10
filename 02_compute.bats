#!/usr/bin/env bats

setup() {
  load 'common-setup'
  _common_setup
}

setup_file() {
  export testinstance="test-instance-bats-$(date '+%Y%m%d%H%M%S')"
}

@test "list instances" {
  run openstack server list
  assert_success
  assert_output -p 'ACTIVE'
}

@test "create instance" {
  openstack server create --wait --image cirros-0.5.2-1 --flavor s --network external $testinstance
}

@test "instance is running" {
  run openstack server show $testinstance -c status -f value
  assert_success
  assert_output "ACTIVE"
}

@test "get instance console url" {
  run openstack console url show -c url -f value $testinstance
  assert_success
  assert_output --regexp 'https://'
  run curl -sI $output
  assert_success
  assert_output --regexp 'HTTP/[0-9]+\.[0-9]+ 200 OK'
}

@test "ping instance" {
  ip=$(openstack server show -c addresses -f value $testinstance | sed "s/'/\"/g" | jq -r '.external[0]')
  ping -c 4 $ip
}

@test "get instance console" {
  run openstack console log show $testinstance
  assert_success
  assert_output -p "login:"
}

@test "reboot instance" {
  openstack server reboot --wait $testinstance
}

@test "rebuild instance" {
  openstack server rebuild --wait $testinstance
}

@test "resize instance" {
  openstack server resize --wait --flavor m $testinstance
  run openstack server show $testinstance -c status -f value
  assert_success
  assert_output "VERIFY_RESIZE"
  openstack server resize confirm $testinstance
  run openstack server show $testinstance -c status -f value
  assert_success
  assert_output "ACTIVE"
}

@test "lock instance" {
  openstack server lock $testinstance
}

@test "unlock instance" {
  openstack server unlock $testinstance
}

@test "create instance snapshot" {
  openstack server image create --wait $testinstance
}

@test "instance snapshot is active" {
  run openstack image show $testinstance -c status -f value
  assert_success
  assert_output "active"
}

@test "delete instance snapshot" {
  openstack image delete $testinstance
}

teardown_file() {
    if openstack server show $testinstance >/dev/null; then
      openstack server delete --wait $testinstance
    fi
    if openstack image show $testinstance >/dev/null; then
      openstack image delete $testinstance
    fi
}
