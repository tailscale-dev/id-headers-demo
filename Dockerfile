FROM python:3.12

WORKDIR /app
ADD requirements.txt /app
RUN pip3 install -r requirements.txt

ADD . /app
EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "listener:app"]