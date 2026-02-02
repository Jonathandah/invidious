#!/usr/bin/env bash

if [ $# -eq 0 ]; then
  echo "Usage: build [development|release]"
  exit 1
fi

mode=$1

export COMPOSE_BAKE=true

CURRENT_COMMIT=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
CURRENT_VERSION=$(git log -1 --format=%ci 2>/dev/null | awk '{print $1}' | sed s/-/./g || echo "unknown")
CURRENT_TAG=$(git tag --points-at HEAD 2>/dev/null || echo "unknown")

if [ "$mode" == "release" ]; then
  docker compose build invidious --build-arg release=1 --build-arg CURRENT_COMMIT="$CURRENT_COMMIT" --build-arg CURRENT_BRANCH="$CURRENT_BRANCH" --build-arg CURRENT_VERSION="$CURRENT_VERSION" --build-arg CURRENT_TAG="$CURRENT_TAG"
fi

if [ "$mode" == "development" ]; then
  docker compose build invidious --build-arg release=0 --build-arg CURRENT_COMMIT="$CURRENT_COMMIT" --build-arg CURRENT_BRANCH="$CURRENT_BRANCH" --build-arg CURRENT_VERSION="$CURRENT_VERSION" --build-arg CURRENT_TAG="$CURRENT_TAG"
fi

docker image prune --filter=label=com.docker.compose.project=invidious -f
