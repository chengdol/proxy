# Envoy TCP Proxy
I use `envoyproxy/envoy-dev:latest` image, you may switch to production release as needed, but sometimes production release image may not have the latest features.

This demo is used to demonstrate Envoy TCP proxy. 

The docker compose cluster consists of one TCP proxy that listening on host port `10000` with admin port `9904` exposed and one TCP socket server, listening on port `8000` in the same network that TCP proxy can access, there is an network test container `network-test-box`, you can run test commands inside it.

The TCP socket server will reply whatever you send to it.

## Steps
Bringing up docker compose cluster:
```bash
# -d: detach
docker-compose up -d
```
Track Envoy log:
```bash
docker logs -f envoy-tcp-proxy
```

Using `nc` command to test:
```bash
# run on host machine
echo "hello world!" | nc localhost 10000

docker exec -it network-test-box sh
# random source port selected
echo "hello world!" | nc envoy-tcp-proxy 10000
# -p: source port
echo "hello world!" | nc -p 60222 envoy-tcp-proxy 10000
```

Or you can run a TCP client and connect it to TCP proxy, see example `client.py`
```bash
python3 client.py
```

The access log from Envlo output will be something like:
```js
[2021-06-09T03:13:34.576Z] address of the client: (origin)"172.31.0.2:60222" (proxy)"172.31.0.
2:60222" request: "- - -" bytes rx: "13" bytes tx: "13" duration: "1" upstream host: "172.31.0.
3:8000"
```

To access Envoy admin portal, in your browser:
```bash
http://localhost:9904
```

Remove docker-compose cluster:
```bash
## --rmi all: remove all built images
docker-compose down [--rmi all]
```





