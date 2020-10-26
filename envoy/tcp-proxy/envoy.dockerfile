FROM envoyproxy/envoy-dev:latest
LABEL maintainer="hhgjlcd@gmail.com"

WORKDIR /etc/envoy
COPY envoy-tcp-proxy.yaml ./

CMD ["envoy", "-c", "./envoy-tcp-proxy.yaml", "--log-level", "trace"]
