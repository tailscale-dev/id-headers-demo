FROM lsiobase/alpine:3.17

WORKDIR /app
ADD requirements.txt /app

# environment settings
ENV S6_STAGE2_HOOK=/init-hook

RUN \
  apk add --no-cache python3 && \
  python3 -m venv /lsiopy && \
  pip install -U --no-cache-dir pip && \
  pip install -U --no-cache-dir -r /app/requirements.txt

ADD . /app
EXPOSE 5000

# add local files
COPY root/ /

CMD ["/init-app"]