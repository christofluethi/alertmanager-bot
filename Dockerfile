FROM golang:alpine AS build-env
RUN apk add git make build-base bzr
RUN git clone https://github.com/christofluethi/alertmanager-bot /alertmanager-bot
WORKDIR /alertmanager-bot
RUN make release

FROM alpine:latest
ENV TEMPLATE_PATHS=/templates/default.tmpl
RUN apk add --update ca-certificates

COPY --from=build-env ./default.tmpl /templates/default.tmpl
COPY --from=build-env ./alertmanager-bot /usr/bin/alertmanager-bot

EXPOSE 8080

ENTRYPOINT ["/usr/bin/alertmanager-bot"]
