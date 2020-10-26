# TCP Proxy
I use `envoyproxy/envoy-dev:latest` image, you may switch to production release as needed, but sometimes production release image may not have the latest features.

This demo demonstrates Envoy TCP proxy functionality. It consists of one TCP proxy that listening on host port `10000` and one TCP socket server, listening on port `8000` in docker compose network that only TCP proxy can accesso.

The TCP socket server is a echo server that will reply whatever you send to it.

## Steps
Bringing up docker compose cluster
```bash
docker-compose up [-d]
```

Using `nc` command to test:
```bash
echo "hello world!" | nc localhost 10000
```
Or you can run a TCP client and connect it to TCP proxy, see example `client.py`
```bash
python3 client.py
```




