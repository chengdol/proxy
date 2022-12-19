Envoy prod [docker image repo](https://hub.docker.com/r/envoyproxy/envoy/tags).

To access Envoy admin portal, in your browser:
```bash
http://localhost:9901
```

You can also test below proxies with proxy configured browser.

# Envoy HTTP Forward Proxy with Fixed Upstream
```bash
# Forward proxy with specified upstream, key is to rewrite the Host header.
# Note that the proxy to upstream is using HTTPS.
# Redacted from https://github.com/envoyproxy/envoy/blob/367763e5c6/configs/envoy-demo.yaml
docker run --rm -it \
-v "$(pwd)/envoy_fixed_upstream.yaml:/envoy_fixed_upstream.yaml" \
-p 9901:9901 \
-p 10000:10000 \
envoyproxy/envoy:v1.24.1 \
-c "/envoy_fixed_upstream.yaml" \
-l "debug"

# You can use browser to see the result as well.
curl -v localhost:10000/ip
# The original Host header www.example.org will be rewrote to www.httpbin.org
# So it is actually www.httpbin.org/ip.
curl -v -x localhost:10000 "http://www.example.org/ip"
```

# Envoy HTTP Dynamic Forward Proxy without CONNECT
```bash
docker run --rm -it \
-v "$(pwd)/envoy_forward_http_wo_connect.yaml:/envoy_forward_http_wo_connect.yaml" \
-p 9901:9901 \
-p 10000:10000 \
envoyproxy/envoy:v1.24.1 \
-c "/envoy_forward_http_wo_connect.yaml" \
-l "debug"

# 2 forms for dynamics forward, the key is Host header!
curl -v -x localhost:10000 "http://www.httpbin.org/ip"
curl -v -H "Host: www.httpbin.org" localhost:10000/ip

# As no CONNECT in config, the https access will fail.
curl -v -x localhost:10000 "https://www.httpbin.org/ip"
```

# Envoy HTTP Dynamic Forward Proxy with CONNECT
```bash
docker run --rm -it \
-v "$(pwd)/envoy_forward_http_w_connect.yaml:/envoy_forward_http_w_connect.yaml" \
-p 9901:9901 \
-p 10000:10000 \
envoyproxy/envoy:v1.24.1 \
-c "/envoy_forward_http_w_connect.yaml" \
-l "debug"

# As in the config we have both routes match for http/https:
# non-CONNECT HTTP request.
curl -v -x localhost:10000 "http://www.httpbin.org/ip"
curl -v -H "Host: www.httpbin.org" localhost:10000/ip
# Must use -x to specify HTTP proxy to do CONNECT method.
curl -v -x localhost:10000 "https://www.httpbin.org/ip"
```

We can use HTTP tunnel to cover other protocol, such as ftp, check this 
[post](https://everything.curl.dev/usingcurl/proxies/http).
The [online free ftp server](https://test.rebex.net/) for testing purpose.
```bash
# using -p to do tunneling for ftp protocol, without -o option, it will print
# the content of file.
# In the ftp url, includes credential to login ftp server as well as port.
# -p|--proxytunnel: force to use HTTP tunnel.
curl -v -p -x localhost:10000 "ftp://demo:password@test.rebex.net:21/readme.txt" -o readme.txt

The [mmnt.net](https://www.mmnt.net/) can be used to find free ftp servers, for
example:
```bash
# Download file named '512b' to local '512b'
# Actually curl support ftp by default
# https://everything.curl.dev/cmdline/urls/path
curl ftp://ftp.sinn.ru/pub/512b -o 512b
# For proxy testing purpose, using tunnel to do the same thing
curl -v -p -x localhost:10000 "ftp://ftp.sinn.ru/pub/512b" -o 512b
```

# Ingress 
For ingress IP filters, insert it at very beginning of filter_chains, for
example:
```yaml
    filter_chains:
    - filters:
      - name: envoy.filters.network.rbac
        config:
          stat_prefix: ips_blocked
          rules:
            action: DENY
            policies:
              "ips_blocked":
                permissions:
                - any: true
                principals:
                - source_ip:
                    address_prefix: 172.16.0.0
                    prefix_len: 12
                - source_ip:
                    address_prefix: 192.168.0.0
                    prefix_len: 16
```
