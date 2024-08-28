#!/bin/bash

ZOTIFY="zotify --config-location /app/zotify-config.json --username $SPOTIFY_USER --password $SPOTIFY_PASSWORD"

# Syncing songs
echo "Syncing songs..."
cd $DIR/music

echo "Syncing hits..."
$ZOTIFY https://open.spotify.com/playlist/0iHSvFHgT4iarY5QfK7rLR --root-path hits

echo "Syncing all..."
$ZOTIFY https://open.spotify.com/playlist/17ZDg6lQ20DHhAkoMOnyKC --root-path all

echo "Syncing rock'n hip-hop..."
$ZOTIFY https://open.spotify.com/playlist/33eyugEph52Fk6ERcNuFUI --root-path rock-n-hiphop
$ZOTIFY https://open.spotify.com/playlist/4bBDiufYLrd6NUIU5olwRi --root-path rock-n-hiphop

echo "Syncing chill..."
$ZOTIFY https://open.spotify.com/playlist/7j5As2UovGH410LtfnrplH --root-path chill

# Locating songs
echo "Locating songs..."
/app/locate-songs.sh

# Saving stats
cd $DIR
SYNC_DATE=$(date "+%F %H:%M:%S")
HITS_COUNT=$(find ./music/hits -type f -name "*.mp3" -o -name "*.ogg" | wc -l)
ALL_COUNT=$(find ./music/all -type f -name "*.mp3" -o -name "*.ogg" | wc -l)
ROCK_N_HIPHOP_COUNT=$(find ./music/rock-n-hiphop -type f -name "*.mp3" -o -name "*.ogg" | wc -l)
CHILL_COUNT=$(find ./music/chill -type f -name "*.mp3" -o -name "*.ogg" | wc -l)

echo
echo "Syncing done: $SYNC_DATE"
echo "Songs in hits playlist: $HITS_COUNT"
echo "Songs in all playlist: $ALL_COUNT"
echo "Songs in rock\'n hip-hop playlist: $ROCK_N_HIPHOP_COUNT"
echo "Songs in chill playlist: $CHILL_COUNT"
echo
