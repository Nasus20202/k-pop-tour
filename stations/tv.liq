#!/usr/bin/liquidsoap
dir = "~/radio"

# In file /usr/share/liquidsoap/libs/protocols.liq
# Change "rm -f $(output) && #{binary} -q -f best --no-playlist -o $(output) -- #{process.quote(arg)}"
#   to   "rm -f $(output) && #{binary} -q -S res:1080 --no-playlist -o $(output) -- #{process.quote(arg)}

settings.frame.video.height.set(1080)
settings.frame.video.width.set(1920)
settings.protocol.youtube_dl.path.set("yt-dlp")

tv = playlist("youtube-pl:PLjGxP4zgfFsAea4KjKifa0VUVMbxuwX2B", reload=86400)
tv = fallback([tv, single(dir^"/sounds/fallback.webm")])

output.icecast(
        %ffmpeg(format="webm",
            %video.copy,
            %audio.copy
        ),
        icy_metadata="false",
        host="localhost",
        port=8000,
        password=getenv("SOURCE_PASSWORD"),
        name="K-Pop Tour | TV",
        description="K-Pop Girl Group MVs",
        genre="K-Pop Girl Group",
        mount="/tv",
        tv)
