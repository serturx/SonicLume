#!/bin/bash

AUDIODIR=./audio
echo $$ > ./LOOP_PID

while true; do cat $AUDIODIR/shairport.audio | tee /tmp/bt.audio > $AUDIODIR/ledfx.audio; done
