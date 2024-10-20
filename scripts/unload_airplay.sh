#!/bin/bash

LOOP_PID=$(cat ./LOOP_PID)

kill $LOOP_PID
rm ./LOOP_PID

sudo docker compose down

pactl unload-module module-loopback
pactl unload-module module-pipe-source

