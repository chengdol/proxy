# https://hub.docker.com/r/envoyproxy/envoy/tags
FROM envoyproxy/envoy:v1.24.1

WORKDIR /etc/envoy
COPY ./envoy_http_proxy_ext_authz.yaml ./envoy_http_proxy_ext_authz.yaml
# https://github.com/envoyproxy/envoy/issues/12747#issuecomment-677485704
RUN chmod 644 ./envoy_http_proxy_ext_authz.yaml

EXPOSE 9901
EXPOSE 10000

CMD ["-c" , "/etc/envoy/envoy_http_proxy_ext_authz.yaml", "-l", "debug"]
