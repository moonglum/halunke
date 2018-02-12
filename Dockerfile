FROM ruby:2-alpine
ADD . /usr/src/
RUN apk add --update git && \
    cd /usr/src && rake install && \
    apk del git libcurl expat pcre2 && \
    rm -rf /var/cache/apk && \
    adduser -D -u 10000 halunke && \
    rm -rf /usr/src
USER halunke
ENTRYPOINT ["/usr/local/bundle/bin/halunke"]
