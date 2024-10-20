#!/bin/bash

BLUETOOTH_NAME=$(pactl list sinks | grep -m 1 'Name: bluez' | awk -F ': ' '{print $2}')
AUDIODIR=./audio

if [ -n "$BLUETOOTH_NAME" ]; then
    echo "Bluetooth device name: $BLUETOOTH_NAME"
else
    echo "No Bluetooth sink found."
    exit 0
fi

sudo rm /tmp/bt.audio
sudo rm $AUDIODIR/*

mkdir $AUDIODIR
mkfifo -m a+rw $AUDIODIR/ledfx.audio $AUDIODIR/shairport.audio

pactl load-module module-pipe-source file=/tmp/bt.audio
pactl load-module module-loopback source=fifo_input sink=$BLUETOOTH_NAME

./scripts/readloop.sh &

sudo docker compose up -d

