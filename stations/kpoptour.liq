#!/usr/bin/liquidsoap
# Log dir
#log.file.path.set("/tmp/liquidsoap.log")

def source_tag(s,tag) =
  def f(_)
    [("source_tag",(tag:string))]
  end
  map_metadata(id=tag,insert_missing=true,f,s)
end

def transition(a,b)
  # If old or new source is not music, no fade
  if a.metadata["source_tag"] != "music" or b.metadata["source_tag"] != "music" then
    sequence([a.source, b.source])
  else
    # Else, apply the standard smart transition
    cross.smart(a, b)
  end
end

# Music
music_reload_time = 3600
hits_playlist = playlist("~/radio/playlists/hits.m3u", reload=music_reload_time)
all_playlist = playlist("~/radio/playlists/all.m3u", reload=music_reload_time)
rock_n_hiphop_playlist = playlist("~/radio/playlists/rock-n-hiphop.m3u", reload=music_reload_time)

# Some jingles
jingles_reload_time = 24 * 3600
hits_jingles = playlist("~/radio/sounds/jingles.m3u", reload=jingles_reload_time)
all_jingles = playlist("~/radio/sounds/jingles.m3u", reload=jingles_reload_time)
rock_n_hiphop_jingles = playlist("~/radio/sounds/jingles.m3u", reload=jingles_reload_time)

# Tag sources
hits_playlist = source_tag(hits_playlist, "music")
all_playlist = source_tag(all_playlist, "music")
rock_n_hiphop_playlist = source_tag(rock_n_hiphop_playlist, "music")

hits_jingles = source_tag(hits_jingles, "jingles")
all_jingles = source_tag(all_jingles, "jingles")
rock_n_hiphop_jingles = source_tag(rock_n_hiphop_jingles, "jingles")

# Start building the feed with music
hits_radio = hits_playlist
all_radio = all_playlist
rock_n_hiphop_radio = rock_n_hiphop_playlist

# Add jingles
jingles_frequency = 10
hits_radio = rotate(weights=[1, jingles_frequency], [hits_jingles, hits_radio])
all_radio = rotate(weights=[1, jingles_frequency], [all_jingles, all_radio])
rock_n_hiphop_radio = rotate(weights=[1, jingles_frequency], [rock_n_hiphop_jingles, rock_n_hiphop_radio])

# Add crossfade
crossfade_duration = 5.
hits_radio = cross(duration=crossfade_duration, transition, hits_radio)
all_radio = cross(duration=crossfade_duration, transition, all_radio)
rock_n_hiphop_radio = cross(duration=crossfade_duration, transition, rock_n_hiphop_radio)

# Add the security
hits_radio = mksafe(hits_radio)
all_radio = mksafe(all_radio)
rock_n_hiphop_radio = mksafe(rock_n_hiphop_radio)

# Stream it out
host = "localhost"
port = 8000
password = getenv("SOURCE_PASSWORD")
#codec = %vorbis.abr(samplerate=44100, channels=2, bitrate=160, max_bitrate=240, min_bitrate=80)
codec = %ffmpeg(
          format="ogg",
          %audio(codec="libvorbis", q="6")
        )

output.icecast(
  codec,
  host=host,
  port=port,
  password=password,
  mount="hits.ogg",
  name="K-Pop Tour | Hits",
  description="Greatest k-pop girl group hits!",
  genre="K-pop, K-Pop Girl Group",
  hits_radio
)

output.icecast(
  codec,
  host=host,
  port=port,
  password=password,
  mount="all.ogg",
  name="K-Pop Tour | All",
  description="Infinite amout of k-pop girl group songs!",
  genre="K-pop, K-Pop Girl Group",
  all_radio
)

output.icecast(
  codec,
  host=host,
  port=port,
  password=password,
  mount="rock-n-hiphop.ogg",
  name="K-Pop Tour | Rock'n Hip-Hop",
  description="Korean girl rock and hip-hop",
  genre="K-Pop, K-Pop Girl Group, K-Rock, Korean Hip-hop",
  rock_n_hiphop_radio
)
