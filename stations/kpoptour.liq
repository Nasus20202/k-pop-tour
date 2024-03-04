#!/usr/bin/liquidsoap
# Log dir
#log.file.path.set("/tmp/liquidsoap.log")

# Music
hits_playlist = playlist("~/radio/playlists/hits.m3u", reload=3600)
all_playlist = playlist("~/radio/playlists/all.m3u", reload=3600)
rock_n_hiphop_playlist = playlist("~/radio/playlists/rock-n-hiphop.m3u", reload=3600)

# Some jingles
jingles = playlist("~/radio/sounds/jingles.m3u", reload=3600)
	
# Start building the feed with music
hits_radio = hits_playlist
all_radio = all_playlist
rock_n_hiphop_radio = rock_n_hiphop_playlist

# Add jingles
hits_radio = rotate(weights=[1, 10], [jingles, hits_radio])
all_radio = rotate(weights=[1, 10], [jingles, all_radio])
rock_n_hiphop_radio = rotate(weights=[1, 10], [jingles, rock_n_hiphop_radio])

# Add the security
hits_radio = mksafe(hits_radio)
all_radio = mksafe(all_radio)
rock_n_hiphop_radio = mksafe(rock_n_hiphop_radio)

# Stream it out
output.icecast(
  %vorbis.abr(samplerate=44100, channels=2, bitrate=160, max_bitrate=240, min_bitrate=80),
  host="localhost",
  port=8000,
  password=getenv("SOURCE_PASSWORD"),
  mount="hits.ogg",
  name="K-Pop Tour | Hits",
  description="Greatest k-pop girl group hits!",
  genre="K-pop",
  hits_radio
)

output.icecast(
  %vorbis.abr(samplerate=44100, channels=2, bitrate=160, max_bitrate=240, min_bitrate=80),
  host="localhost",
  port=8000,
  password=getenv("SOURCE_PASSWORD"),
  mount="all.ogg",
  name="K-Pop Tour",
  description="Infinite amout of k-pop girl group songs!",
  genre="K-pop",
  all_radio
)

output.icecast(
  %vorbis.abr(samplerate=44100, channels=2, bitrate=160, max_bitrate=240, min_bitrate=80),
  host="localhost",
  port=8000,
  password=getenv("SOURCE_PASSWORD"),
  mount="rock-n-hiphop.ogg",
  name="K-Pop Tour | Rock'n Hip-Hop",
  description="Korean girl rock and hip-hop",
  genre="K-Pop, K-Rock, Korean Hip-hop",
  rock_n_hiphop_radio
)

%include "tv.liq"
