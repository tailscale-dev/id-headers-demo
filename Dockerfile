#FROM python:3.12
FROM lsiobase/alpine:3.17

WORKDIR /app
ADD requirements.txt /app

RUN \
  apk add --no-cache python3 && \
  python3 -m venv /lsiopy && \

  # upgrade pip as OS pip is always old
  pip install -U --no-cache-dir pip && \
  pip install -U --no-cache-dir -r /app/requirements.txt

ADD . /app
EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "listener:app"]