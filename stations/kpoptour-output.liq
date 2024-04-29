# Stream it out! 
hits_config = {
    name = "K-Pop Tour | Hits",
    desc = "Greatest k-pop girl group hits!",
    genre = "K-pop, K-Pop Girl Group",
    mount = "hits",
    radio = hits_radio
}

all_config = {
    name = "K-Pop Tour | All",
    desc = "Infinite amout of k-pop girl group songs!",
    genre = "K-pop, K-Pop Girl Group",
    mount = "all",
    radio = all_radio
}

rock_n_hiphop_config = {
    name = "K-Pop Tour | Rock'n Hip-Hop",
    desc = "Korean girl rock and hip-hop",
    genre = "K-Pop, K-Pop Girl Group, K-Rock, Korean Hip-hop",
    mount = "rock-n-hiphop",
    radio = rock_n_hiphop_radio
}

chill_config = {
    name = "K-Pop Tour | Chill",
    desc = "Korean chill vibes",
    genre = "K-Pop, K-Pop Girl Group",
    mount = "chill",
    radio = chill_radio
}

configs = [hits_config, all_config, rock_n_hiphop_config, chill_config]

host = "localhost"
port = 8000
password = getenv("SOURCE_PASSWORD")
#codec_vorbis = %vorbis.abr(samplerate=44100, channels=2, bitrate=160, max_bitrate=240, min_bitrate=80)
codec_vorbis = %ffmpeg(format="ogg", %audio(codec="libvorbis", q="6"))
codec_mp3 = %ffmpeg(format="mp3", %audio(codec="libmp3lame", q="4"))

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

list.iter(
    fun(config) -> stream(config),
    configs
)


