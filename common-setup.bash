#!/usr/bin/env bash

_common_setup() {
  if [ -d test_helper ]; then
    DIR=test_helper
  else
    DIR=/usr/local/lib
  fi
  load "$DIR/bats-support/load"
  load "$DIR/bats-assert/load"
}
