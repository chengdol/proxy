#!/usr/bin/env bash

## run envoy config yaml file as specified in environment variable
/usr/local/bin/envoy -c "/etc/envoy/config/${ENVOY_CONFIG_YAML}" --service-cluster front-proxy --log-level trace
