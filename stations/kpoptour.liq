#!/usr/bin/liquidsoap

music_reload_time = 3600
jingles_reload_time = 24 * 3600
jingles_frequency = 10
crossfade_duration = 5.

host = "localhost"
port = 8000
password = getenv("SOURCE_PASSWORD")
#codec_vorbis = %vorbis.abr(samplerate=44100, channels=2, bitrate=160, max_bitrate=240, min_bitrate=80)
codec_vorbis = %ffmpeg(format="ogg", %audio(codec="libvorbis", q="6"))
#codec_mp3 = %mp3.abr(bitrate=128, max_bitrate=192, id3v2=true)
codec_mp3 = %ffmpeg(format="mp3", %audio(codec="libmp3lame", q="4"))

hits_config = {
    name = "K-Pop Tour | Hits",
    desc = "Greatest k-pop girl group hits!",
    genre = "K-pop, K-Pop Girl Group",
    mount = "hits",
    playlist_file = "~/radio/playlists/hits.m3u",
    jingles_file = "~/radio/sounds/jingles.m3u"
}

all_config = {
    name = "K-Pop Tour | All",
    desc = "Infinite amout of k-pop girl group songs!",
    genre = "K-pop, K-Pop Girl Group",
    mount = "all",
    playlist_file = "~/radio/playlists/all.m3u",
    jingles_file = "~/radio/sounds/jingles.m3u"
}

rock_n_hiphop_config = {
    name = "K-Pop Tour | Rock'n Hip-Hop",
    desc = "Korean girl rock and hip-hop",
    genre = "K-Pop, K-Pop Girl Group, K-Rock, Korean Hip-hop",
    mount = "rock-n-hiphop",
    playlist_file = "~/radio/playlists/rock-n-hiphop.m3u",
    jingles_file = "~/radio/sounds/jingles.m3u"
}

chill_config = {
    name = "K-Pop Tour | Chill",
    desc = "Korean chill vibes",
    genre = "K-Pop, K-Pop Girl Group",
    mount = "chill",
    playlist_file = "~/radio/playlists/chill.m3u",
    jingles_file = "~/radio/sounds/jingles.m3u"
}

configs = [hits_config, all_config, rock_n_hiphop_config, chill_config]

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

def prepare_radio(config)
    # Load the playlist and jingles
    music_playlist = playlist(config.playlist_file, reload=music_reload_time)
    jingles_playlist = playlist(config.jingles_file, reload=jingles_reload_time)

    # Tag sources
    music_playlist = source_tag(music_playlist, "music")
    jingles_playlist = source_tag(jingles_playlist, "jingles")

    # Start building the feed with music
    radio = music_playlist

    # Add jingles
    radio = rotate(weights=[1, jingles_frequency], [jingles_playlist, radio])

    # Add crossfade
    radio = cross(duration=crossfade_duration, transition, radio)

    # Add the security
    radio = mksafe(radio)

    # Add the radio tag and return
    config.{radio=radio}
end

def stream(config)
  output.icecast(
    codec_mp3,
    host=host,  port=port, password=password,
    mount=config.mount,
    name=config.name, description=config.desc, genre=config.genre, config.radio
  )
  output.icecast(
    codec_vorbis,
    host=host,  port=port, password=password,
    mount=config.mount ^ ".ogg",
    name=config.name, description=config.desc, genre=config.genre, config.radio
  )
end

configs = list.map(prepare_radio, configs)
print(configs)

list.iter(
    fun(config) -> stream(config),
    configs
)

