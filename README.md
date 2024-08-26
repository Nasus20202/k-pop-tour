# K-Pop Tour Radio

Icecast radio that automatically downloads new songs from Spotify playlists.

There are currently four radio stations, each with 2 streams (mp3 and ogg) configured (all - 3.5K+ songs, hits - ~300 songs, rock-n-hiphop - ~400 songs, chill - ~500 songs) and 1 video stream (disabled by default).

# Running

The reecommended method is by using docker-compose. Create a `.env` file similar to the [example one](./.env.example) and run this command:
```bash
docker compose up
# or
docker compose up -d
```

You can also run the radio as a dearmon using this [script](https://github.com/savonet/liquidsoap-daemon). 

