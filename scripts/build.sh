#!/usr/bin/env bash

if [ $# -eq 0 ]; then
  echo "Usage: build [development|release]"
  exit 1
fi

mode=$1

export COMPOSE_BAKE=true

if [ "$mode" == "release" ]; then
  docker compose build invidious --build-arg release=1
fi

if [ "$mode" == "development" ]; then
  docker compose build invidious --build-arg release=0
fi

docker image prune --filter=label=com.docker.compose.project=invidious -f
