#!/usr/bin/env sh
set -e
if [[ -n "${IS_ECS_EC2}" ]]; then
    export DD_AGENT_HOST=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
fi
npm start
