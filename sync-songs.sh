#!/bin/bash
DIR=~/radio

#Activate .venv
source $DIR/.venv/bin/activate

cd $DIR
echo Syncing songs... >> sync.log
ZOTIFY="zotify --config-location $DIR/zotify-config.json"

# Syncing songs
cd $DIR/music

echo 'Syncing hits...'
$ZOTIFY https://open.spotify.com/playlist/0iHSvFHgT4iarY5QfK7rLR --root-path hits

echo 'Syncing all...'
$ZOTIFY https://open.spotify.com/playlist/17ZDg6lQ20DHhAkoMOnyKC --root-path all

echo "Syncing rock'n hip-hop..."
$ZOTIFY https://open.spotify.com/playlist/33eyugEph52Fk6ERcNuFUI --root-path rock-n-hiphop
$ZOTIFY https://open.spotify.com/playlist/4bBDiufYLrd6NUIU5olwRi --root-path rock-n-hiphop

echo "Syncing chill..."
$ZOTIFY https://open.spotify.com/playlist/7j5As2UovGH410LtfnrplH --root-path chill

# Locating songs
echo 'Locating songs...'
cd $DIR
./locate-songs.sh

# Saving stats
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
