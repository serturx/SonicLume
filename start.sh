#!/bin/bash

function cleanup {
    sudo docker compose down
}

function is_already_connected {
    BLUETOOTH_NAME=$(pactl list sinks | grep -m 1 'Name: bluez' | awk -F ': ' '{print $2}')
    if [ -n "$BLUETOOTH_NAME" ]; then
        return 0
    else
        return 1
    fi
}

trap cleanup EXIT

mkdir -p ./audio
sudo docker compose up -d bt-ctl 

if is_already_connected; then
    echo "Bluetooth audio device already connected, running load script..."
    ./scripts/load_airplay.sh &
fi

echo "Waiting for bluetooth audio device to connect..."

pactl subscribe | while read; do
    if [[ $REPLY =~ ^Event\ \'(.*)\'\ on\ card\ \#([0-9]+)$ ]]; then
        event="${BASH_REMATCH[1]}"
        card="${BASH_REMATCH[2]}"
        if [[ $event == new ]]; then
            echo "Bluetooth audio device detected, running load script..."
            ./scripts/load_airplay.sh &

        fi
        
        if [[ $event == remove ]]; then
            echo "Removed bluetooth audio device, running unload script..."
            ./scripts/unload_airplay.sh &
        fi
    fi
done
