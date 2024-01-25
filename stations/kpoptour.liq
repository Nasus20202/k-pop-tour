#!/usr/bin/liquidsoap
# Log dir
#log.file.path.set("/tmp/liquidsoap.log")

# Music
hits_playlist = playlist("~/radio/playlists/hits.m3u", reload_mode="watch")
all_playlist = playlist("~/radio/playlists/all.m3u", reload_mode="watch")

# Some jingles
jingles = playlist("~/radio/sounds/jingles.m3u", reload_mode="watch")

# Start building the feed with music
hits_radio = hits_playlist
all_radio = all_playlist

# Add songs crossfade
hits_radio = crossfade(hits_radio)
all_radio = crossfade(all_radio)

# Add jingles
hits_radio = random(weights=[1, 10], [jingles, hits_radio])
all_radio = random(weights=[1, 10], [jingles, all_radio])

# Add the security
hits_radio = mksafe(hits_radio)
all_radio = mksafe(all_radio)

# Stream it out
output.icecast(
  %vorbis.abr(samplerate=44100, channels=2, bitrate=160, max_bitrate=240, min_bitrate=80),
  host="localhost",
  port=8000,
  password="icecast-password",
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
  password="icecast-password",
  mount="all.ogg",
  name="K-Pop Tour",
  description="Infinite amout of k-pop girl group songs!",
  genre="K-pop",
  all_radio
)
