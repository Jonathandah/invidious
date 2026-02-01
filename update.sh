#!/usr/bin/env bash

cd build || exit

git checkout .
git restore .
git reset
git clean -fd

git pull --recurse-submodules
