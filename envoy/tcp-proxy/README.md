Envoy prod [docker image repo](https://hub.docker.com/r/envoyproxy/envoy/tags).

To access Envoy admin portal, in your browser:
```bash
http://localhost:9901
```

# Envoy TCP Proxy with TCP Echo Server
```bash
docker run --rm -it \
-v "$(pwd)/envoy_tcp_proxy_echo.yaml:/envoy_tcp_proxy_echo.yaml" \
-p 9901:9901 \
-p 10000:10000 \
envoyproxy/envoy:v1.24.1 \
-c "/envoy_tcp_proxy_echo.yaml" \
-l "debug"

# The upstream in configuration is tcpbin.com:4242 echo server.
# Using nc as the tcp client and connect to localhost envoy port 10000
nc localhost 10000
# You will get anything you input from the server response.
```

# Envoy TCP Proxy with HTTP Server
```bash
docker run --rm -it \
-v "$(pwd)/envoy_tcp_proxy_http.yaml:/envoy_tcp_proxy_http.yaml" \
-p 9901:9901 \
-p 10000:10000 \
envoyproxy/envoy:v1.24.1 \
-c "/envoy_tcp_proxy_http.yaml" \
-l "debug"

# Or using telnet
nc localhost 10000
# Construct HTTP request with path /ip
GET /ip HTTP/1.1
HOST: www.httpbin.org
```

# Envoy TCP Proxy with HTTPS Server
```bash
docker run --rm -it \
-v "$(pwd)/envoy_tcp_proxy_https.yaml:/envoy_tcp_proxy_https.yaml" \
-p 9901:9901 \
-p 10000:10000 \
envoyproxy/envoy:v1.24.1 \
-c "/envoy_tcp_proxy_https.yaml" \
-l "debug"

# Or using telnet
nc localhost 10000
# Construct HTTP request with path /ip
GET /ip HTTP/1.1
HOST: www.httpbin.org
```
