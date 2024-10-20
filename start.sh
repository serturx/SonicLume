#!/bin/bash

pactl subscribe | while read; do
    if [[ $REPLY =~ ^Event\ \'(.*)\'\ on\ card\ \#([0-9]+)$ ]]; then
        event="${BASH_REMATCH[1]}"
        card="${BASH_REMATCH[2]}"
        if [[ $event == new ]]; then
            echo "added bluetooth speaker, running prepare script"
            ./scripts/prepare_airplay.sh &

        fi
        
        if [[ $event == remove ]]; then
            echo "removed bluetooth speaker, running unload script"
            ./scripts/rpi/unload_airplay.sh &
        fi
    fi
done
