FROM envoyproxy/envoy:v1.16.0

WORKDIR /etc/envoy

COPY ./config ./config
COPY ./run_envoy.sh ./run_envoy.sh

RUN chown -R envoy:envoy ./*
RUN chmod +x ./run_envoy.sh

CMD ./run_envoy.sh
