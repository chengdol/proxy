FROM envoyproxy/envoy-dev:latest

WORKDIR /etc/envoy

COPY ./config ./config
COPY ./run_envoy.sh ./run_envoy.sh

RUN chown -R envoy:envoy ./*
RUN chmod +x ./run_envoy.sh

CMD ./run_envoy.sh
