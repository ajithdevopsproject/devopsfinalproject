#!/bin/bash

# Start NGINX in background
echo "Starting NGINX..."
nginx -g "daemon off;" &

# Start Prometheus
echo "Starting Prometheus..."
prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/var/lib/prometheus &

# Start Alertmanager
echo "Starting Alertmanager..."
alertmanager --config.file=/etc/alertmanager/alertmanager.yml &

# Start Grafana
echo "Starting Grafana..."
grafana-server --homepath=/usr/share/grafana --config=/etc/grafana/grafana.ini &

# Keep container running
tail -f /dev/null
