#!/bin/bash

AUDIODIR=./audio
echo $$ > ./looppid

while true; do cat $AUDIODIR/shairport.audio | tee /tmp/bt.audio > $AUDIODIR/ledfx.audio; done
