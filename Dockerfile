FROM alpine:3.9

RUN apk add --no-cache git

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
