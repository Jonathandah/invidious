#!/bin/bash

# Used to create restart invidious service as suggested by invidious developers
# https://docs.invidious.io/installation/#is-your-platform-not-listed-podman-bsd-lxc-and-more
#
# Cron job example:
#
# sudo apt-get install cron
# sudo systemctl start cron
# sudo systemctl enable cron  # To start cron on boot
#
# Add cron job to run this script every day at midnight
# 0 0 * * * /$USER/home/docker/invidious/restart.sh

docker compose restart invidious
