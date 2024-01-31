## K-Pop Tour Radio

Icecast radio that automatically downloads new songs from Spotify playlists.

To sync the songs, you have to run `./sync-songs.sh` script. You can automate it with crontab.
When running the script for the first time, you need to login with (throwaway) Spotify credentials.

There are currently tree audio streams configured (all - 3K+ songs, hits - ~300 songs, rock-n-hiphop - ~250 songs).

To start the radio, you need to have `icecast2` configured and `liquidsoap` installed. 
The radio definition is located in [stations/kpoptour.liq](stations/kpoptour.liq) file.
You can run the statio as a dearmon using this [script](https://github.com/savonet/liquidsoap-daemon). 

Radio jingles are located in [the sounds directory](sounds).