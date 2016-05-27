#!/usr/bin/env bats

@test "rbenv is installed for vagrant user" {
  sudo su --login vagrant --command "which rbenv"
}

@test "rbenv installed 2.2.x" {
  sudo su --login vagrant --command "rbenv versions | grep 2.2"
}
