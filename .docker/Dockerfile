FROM registry.gitlab.com/santetis/open_source/santetis_image

MAINTAINER rushio-consulting

RUN git clone https://github.com/rushio-consulting/md2codelab.git /app \
    && cd /app \
    && pub get

VOLUME /app/web

ADD watch.sh /watch.sh

RUN chmod +x /watch.sh

CMD ["/watch.sh"]

