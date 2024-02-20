#!/usr/bin/liquidsoap
settings.frame.video.height.set(1080)
settings.frame.video.width.set(1920)
settings.protocol.youtube_dl.path.set("yt-dlp")

tv = playlist("youtube-pl:PLjGxP4zgfFsAea4KjKifa0VUVMbxuwX2B", reload=86400)
tv = fallback([tv, single("../sounds/fallback.webm")])

output.icecast(
        %ffmpeg(format="mpegts",
            %audio(codec="ac3",channel_coupling=0),
            %video(codec="libx264",b="6000k",
            "x264-params"="scenecut=0:open_gop=0:min-keyint=150:keyint=150",
            preset="fast")),
        icy_metadata="true",
        host="localhost",
        port=8000,
        password=getenv("SOURCE_PASSWORD"),
        name="K-Pop Tour | TV",
        description="K-Pop Girl Group MVs",
        genre="K-Pop Girl Group",
        mount="/tv",
        tv)
