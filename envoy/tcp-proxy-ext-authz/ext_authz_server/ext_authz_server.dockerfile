# https://docs.docker.com/language/golang/build-images/
FROM golang:1.20rc1-alpine

WORKDIR /app
COPY server.go ./

RUN go mod init envoy_tcp_proxy_ext_authz
RUN go mod tidy
RUN go mod download

RUN go build -o /ext_authz_server
EXPOSE 10004

CMD ["/ext_authz_server"]