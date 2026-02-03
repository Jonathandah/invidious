#!/usr/bin/env bash

cd build || exit

git checkout .
git restore .
git reset
git clean -fd

# Switch to master branch before pulling to avoid detached HEAD issues
git checkout master
git pull --recurse-submodules

