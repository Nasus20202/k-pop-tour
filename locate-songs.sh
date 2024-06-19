#!/bin/bash
DIR=~/radio

locate_in_folder() {
    echo Locating songs for $1 radio
    find $DIR/music/$1/ -type f -name "*.mp3" -o -name "*.ogg" > $1.m3u.tmp
    mv $1.m3u.tmp $1.m3u
}

cd $DIR/playlists
locate_in_folder all
locate_in_folder hits
locate_in_folder rock-n-hiphop
locate_in_folder chill
