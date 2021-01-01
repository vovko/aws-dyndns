FROM python:3.8.5-slim-buster

RUN \
  apt-get update -qq \
  && apt-get install -y build-essential \
  && mkdir /app

COPY . /app

WORKDIR /app
COPY requirements.txt requirements.txt 
RUN pip3 install -r requirements.txt

ENV TERM=xterm
ENTRYPOINT [ "python3", "dns_update.py" ]