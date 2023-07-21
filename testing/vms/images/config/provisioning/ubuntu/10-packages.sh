#!/bin/env -S bash -ex

echo "${USER_PASSWORD}" | sudo -S apt-get update
echo "${USER_PASSWORD}" | sudo -S apt-get upgrade -y
