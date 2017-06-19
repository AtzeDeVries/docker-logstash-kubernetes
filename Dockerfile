FROM openjdk:8
MAINTAINER atze.devries@naturalis.nl

ENV LOGSTASH_VERSION 5.3.0

## https://artifacts.elastic.co/downloads/logstash/logstash-5.3.0.tar.gz

RUN apt-get update && apt-get install curl bash ca-certificates
#RUN apk add --update curl bash ca-certificates
RUN \
  ( curl -Lskj https://artifacts.elastic.co/downloads/logstash/logstash-$LOGSTASH_VERSION.tar.gz | \
  gunzip -c - | tar xf - ) && \
  mv logstash-$LOGSTASH_VERSION /logstash && \
  mkdir /logstash/conf && \
  mkdir /logstash/cert && \ 
  rm -rf $(find /logstash | egrep "(\.(exe|bat)$|sigar/.*(dll|winnt|x86-linux|solaris|ia64|freebsd|macosx))") && \
  apt-get remove --purge -y curl

ADD patterns /logstash/patterns
ADD logstash.conf /logstash/config/logstash.conf
#ADD jvm.options /logstash/config/jvm.options
ADD logstash-template.json /logstash/config/logstash-template.json
WORKDIR /logstash/config
CMD ["/logstash/bin/logstash", "--log.level=info",  "-f", "/logstash/config/logstash.conf"]

