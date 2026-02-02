#!/usr/bin/env bash

cd build || exit

# Sort patches numerically to apply in order
for p in $(ls ../patches/*.patch | sort -V); do
  echo "applying ${p}..."
  git apply --check $p && git apply $p
done
