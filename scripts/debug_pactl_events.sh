#!/bin/bash

pactl subscribe | while read x event y type num; do
    if [ $event == "'new'" -a $type == 'sink-output' ]; then
        echo added $type $event
    fi

    if [ $event == "'remove'" -a $type == 'sink-output' -a $num == "$source_number" ]; then
        echo removed $type $event
    fi
done
