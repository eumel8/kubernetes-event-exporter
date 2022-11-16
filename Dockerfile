FROM golang:1.18 AS builder

ADD . /app
WORKDIR /app
RUN CGO_ENABLED=0 GOOS=linux GO11MODULE=on go build -a -o /main .


FROM alpine:3.15

RUN addgroup -S appgroup && adduser -S appuser -G appgroup -h /home/appuser
WORKDIR /home/appuser


COPY --from=builder --chown=appuser:appuser /main /kubernetes-event-exporter

USER appuser

ENTRYPOINT ["/kubernetes-event-exporter"]
