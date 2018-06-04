FROM bwnyasse/dart:2.0.0-dev.54.0

MAINTAINER bwnyasse

ARG proxy

ENV http_proxy ${proxy}
ENV https_proxy ${proxy}

RUN git clone https://github.com/bwnyasse/md2codelab.git /app \
    && cd /app \
    && pub get

#ADD watch.sh /watch.sh

VOLUME /app/web

ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]

#CMD ["/bin/true"]  # Default Command

