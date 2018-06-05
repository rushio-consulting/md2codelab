FROM bwnyasse/dart:2.0.0-dev.54.0

MAINTAINER bwnyasse

#ARG proxy
#
#ENV http_proxy ${proxy}
#ENV https_proxy ${proxy}

RUN git clone https://github.com/bwnyasse/md2codelab.git /app \
    && cd /app \
    && pub get

VOLUME /app/web

ADD watch.sh /watch.sh

RUN chmod +x /watch.sh

CMD ["/watch.sh"]

