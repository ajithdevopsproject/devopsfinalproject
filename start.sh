
#!/bin/bash
service nginx start
prometheus --config.file=/etc/prometheus/prometheus.yml &
alertmanager --config.file=/etc/alertmanager/alertmanager.yml &
grafana-server --homepath=/usr/share/grafana &
tail -f /dev/null
