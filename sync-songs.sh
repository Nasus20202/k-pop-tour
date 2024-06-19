#!/bin/bash
DIR=~/radio

#Activate .venv
source $DIR/.venv/bin/activate

cd ~/radio
echo Syncing songs... >> sync.log

echo 'Syncing hits...'
cd $DIR/music/hits
zotify https://open.spotify.com/playlist/0iHSvFHgT4iarY5QfK7rLR --config-location ~/radio/zotify-config.json

echo 'Syncing all...'
cd $DIR/music/all
zotify https://open.spotify.com/playlist/17ZDg6lQ20DHhAkoMOnyKC --config-location ~/radio/zotify-config.json

echo "Syncing rock'n hip-hop..."
cd ~/radio/music/rock-n-hiphop
zotify https://open.spotify.com/playlist/33eyugEph52Fk6ERcNuFUI --config-location ~/radio/zotify-config.json
zotify https://open.spotify.com/playlist/4bBDiufYLrd6NUIU5olwRi --config-location ~/radio/zotify-config.json

echo "Syncing chill..."
cd $DIR/music/chill
zotify https://open.spotify.com/playlist/7j5As2UovGH410LtfnrplH?si=10824c56a12443e9 --config-location ~/radio/zotify-config.json

echo 'Locating songs...'
cd $DIR
./locate-songs.sh

echo 'Saving stats...'
cd $DIR
SYNC_DATE=$(date "+%F %H:%M:%S")
HITS_COUNT=$(find ./music/hits -type f -name "*.mp3" -o -name "*.ogg" | wc -l)
ALL_COUNT=$(find ./music/all -type f -name "*.mp3" -o -name "*.ogg" | wc -l)
ROCK_N_HIPHOP_COUNT=$(find ./music/rock-n-hiphop -type f -name "*.mp3" -o -name "*.ogg" | wc -l)
CHILL_COUNT=$(find ./music/chill -type f -name "*.mp3" -o -name "*.ogg" | wc -l)

echo Syncing done: $SYNC_DATE >> sync.log
echo Songs in hits playlist: $HITS_COUNT >> sync.log
echo Songs in all playlist: $ALL_COUNT >> sync.log
echo Songs in rock\'n hip-hop playlist: $ROCK_N_HIPHOP_COUNT >> sync.log
echo Songs in chill playlist: $CHILL_COUNT >> sync.log
echo >> sync.log
