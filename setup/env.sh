#!/bin/bash

export GRAFANA_DISABLE_ENV=yes
eval "optbin -s /opt/grafana/bin"

# grafana-cli
export GF_PLUGIN_DIR=/opt/grafana/plugins
export GF_PLUGIN_REPO=https://grafana.com/api/plugins

