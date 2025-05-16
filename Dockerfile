FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    nginx \
    wget \
    curl \
    unzip \
    gnupg2 \
    software-properties-common \
    adduser \
    libfontconfig1 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create Prometheus user and directories
RUN useradd --no-create-home --shell /bin/false prometheus && \
    mkdir /etc/prometheus /var/lib/prometheus

# Install Prometheus
RUN wget https://github.com/prometheus/prometheus/releases/download/v2.51.2/prometheus-2.51.2.linux-amd64.tar.gz && \
    tar xvf prometheus-2.51.2.linux-amd64.tar.gz && \
    mv prometheus-2.51.2.linux-amd64/prometheus /usr/local/bin/ && \
    mv prometheus-2.51.2.linux-amd64/promtool /usr/local/bin/ && \
    mv prometheus-2.51.2.linux-amd64/consoles /etc/prometheus/ && \
    mv prometheus-2.51.2.linux-amd64/console_libraries /etc/prometheus/ && \
    rm -rf prometheus-2.51.2.linux-amd64*

# Install Alertmanager
RUN wget https://github.com/prometheus/alertmanager/releases/download/v0.27.0/alertmanager-0.27.0.linux-amd64.tar.gz && \
    tar xvf alertmanager-0.27.0.linux-amd64.tar.gz && \
    mv alertmanager-0.27.0.linux-amd64/alertmanager /usr/local/bin/ && \
    mv alertmanager-0.27.0.linux-amd64/amtool /usr/local/bin/ && \
    rm -rf alertmanager-0.27.0.linux-amd64*

# ✅ Install Grafana using official APT repo instead of .deb
RUN apt-get update && apt-get install -y \
    gnupg2 \
    curl \
    && mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://apt.grafana.com/gpg.key | gpg --dearmor -o /etc/apt/keyrings/grafana.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" > /etc/apt/sources.list.d/grafana.list && \
    apt-get update && apt-get install -y grafana && \
    rm -rf /var/lib/apt/lists/*

# Copy web and config files
COPY build/ /var/www/html/
RUN rm -f /var/www/html/index.nginx-debian.html

COPY prometheus/prometheus.yml /etc/prometheus/
COPY alertmanager/alertmanager.yml /etc/alertmanager/
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose services: nginx (80), Prometheus (9090), Alertmanager (9093), Grafana (3000)
EXPOSE 80 9090 9093 3000

CMD ["/start.sh"]
