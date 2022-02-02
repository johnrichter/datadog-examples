#!/bin/env sh

docker build -t konga:v0.14.9 deps/konga
docker build -t nodejs-docker:latest deps/nodejs-docker
