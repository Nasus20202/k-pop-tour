FROM python:3.12.5-alpine3.20

WORKDIR /app

RUN apk add bash ffmpeg git --no-cache

RUN python -m pip install git+https://zotify.xyz/zotify/zotify.git

COPY *.sh *.json /app/

COPY spotify-cron /etc/cron.d/spotify-cron

RUN chmod 0644 /etc/cron.d/spotify-cron

RUN crontab /etc/cron.d/spotify-cron

RUN touch /var/log/cron.log

CMD ["crond", "&&", "tail", "-f", "/var/log/cron.log"]
