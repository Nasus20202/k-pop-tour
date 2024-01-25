#!/bin/bash

cd ~/radio
echo Syncing songs... >> sync.log

echo 'Syncing hits...'
cd ~/radio/music/hits
zotify https://open.spotify.com/playlist/0iHSvFHgT4iarY5QfK7rLR --config-location ~/radio/zotify-config.json

echo 'Syncing all...'
cd ~/radio/music/all
zotify https://open.spotify.com/playlist/17ZDg6lQ20DHhAkoMOnyKC --config-location ~/radio/zotify-config.json

echo 'Locating songs...'
cd ~/radio
./locate-songs.sh

echo 'Saving stats...'
cd ~/radio
SYNC_DATE=$(date "+%F %H:%M:%S")
HITS_COUNT=$(find ./music/hits -type f -name "*.mp3" -o -name "*.ogg" | wc -l)
ALL_COUNT=$(find ./music/all -type f -name "*.mp3" -o -name "*.ogg" | wc -l)

echo Syncing done: $SYNC_DATE >> sync.log
echo Songs in hits playlist: $HITS_COUNT >> sync.log
echo Songs in all playlist: $ALL_COUNT >> sync.log
echo >> sync.log
