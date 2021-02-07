#!/bin/bash -e

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash

exec bash -l

nvm install --lts --latest-npm

npm install -g yarn
npm install -g @bazel/bazelisk
bazel