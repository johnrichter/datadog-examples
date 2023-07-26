#!/bin/env -S bash -ex

IFS=" " read -r -a PACKAGES <<<"${PACKAGES_TO_INSTALL}"
apt-get update
apt-get upgrade -y
apt-get install -y "${PACKAGES[@]}"
