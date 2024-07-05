FROM golang:alpine AS build

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /icecast_exporter

# Final stage
FROM alpine

LABEL author "Markus Lindenberg"
LABEL maintainer "me@maxep.me"
LABEL description "Exporter for Icecast stats"
LABEL org.opencontainers.image.source https://github.com/LYL-Radio/icecast-exporter

COPY --from=build /icecast_exporter /icecast_exporter

EXPOSE 9146
USER nobody
ENTRYPOINT ["/icecast_exporter"]

