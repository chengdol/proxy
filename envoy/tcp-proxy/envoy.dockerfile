FROM envoyproxy/envoy:v1.16.0
LABEL maintainer="hhgjlcd@gmail.com"

WORKDIR /etc/envoy
COPY envoy-tcp-proxy.yaml ./

CMD ["envoy", "-c", "./envoy-tcp-proxy.yaml", "--log-level", "trace"]
