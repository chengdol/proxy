# Envoy Forward Proxy
I use `envoyproxy/envoy-dev:latest` image, you may switch to production release as needed, but sometimes production release image may not have the latest features.

Comment and uncomment `.env` file to select target configuration one at a time:
- envoy_forward_http.yaml: HTTP forwarding
- envoy_forward_http_auth.yaml: HTTP with Basic Authurization, header Authorization
- envoy_forward_https.yaml: HTTPS (tunnel) forwarding
- envoy_forward_https_auth.yaml: Currently not available


System diagram:
```
network-test-box(client) --------> envoy-forward-proxy ----------> target server
                                           |                         (you specify)
                                           |
                                           |
                                          \|/
                                    http  authz server (port 8081)
```

## Commands
Launch docker compose cluster:
```
docker-compose up [-d]
```

Start process on `network-test-box` container, we issue test commands from here:
```
docker exec -it network-test-box bash
```

For envoy_forward_http.yaml, only HTTP traffic is allowed:
```
curl -v -x envoy-forward-proxy:10000 http://www.httpbin.org/ip
wget --connect-timeout 10 -e http_proxy="envoy-forward-proxy:10000" http://www.httpbin.org/ip
```

For envoy_forward_http_auth.yaml, HTTP traffic with Basic Authz:
```
curl -v -x envoy-forward-proxy:10000 http://www.httpbin.org/ip -u chengdol:123456
wget --connect-timeout 10 -e http_proxy="envoy-forward-proxy:10000" http://www.httpbin.org/ip --http-user=chengdol --http-password=123456 --auth-no-challenge
```

For envoy_forward_https.yaml, only HTTPS traffic is allowed, HTTP is forbidden:
```
curl -v -x envoy-forward-proxy:10000 https://www.httpbin.org/ip
wget --connect-timeout 10 -e https_proxy="envoy-forward-proxy:10000" https://www.httpbin.org/ip
```

For envoy_forward_https_auth.yaml, not support yet.


Remove docker-compose cluster:
```bash
## --rmi all: remove all built images
docker-compose down [--rmi all]
```
