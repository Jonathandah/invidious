#!/usr/bin/env bash

if [ $# -eq 0 ]; then
  echo "Usage: create-patch [commit message]"
  exit 1
fi

message=$1

cd build || exit

git add .
git commit -m "$message"

# Get next patch number
patches_dir="../patches"

# Find the highest existing patch number
last_num=$(find "$patches_dir" -name "*.patch" -type f | sed 's/.*\/\([0-9]\+\)-.*/\1/' | sort -n | tail -1)
if [ -z "$last_num" ]; then
  next_num=1
else
  next_num=$((last_num + 1))
fi

# Format with leading zeros (4 digits)
patch_num=$(printf "%04d" $next_num)

git format-patch -1 HEAD --stdout >"$patches_dir/${patch_num}-$(echo "$message" | tr ' ' '-').patch"
