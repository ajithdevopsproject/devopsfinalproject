FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
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

# Create necessary directories and Prometheus user
RUN useradd --no-create-home --shell /bin/false prometheus && \
    mkdir -p /etc/prometheus /etc/alertmanager /var/lib/prometheus

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

# Install Grafana using APT repository
RUN apt-get update && apt-get install -y gnupg2 curl && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://apt.grafana.com/gpg.key | gpg --dearmor -o /etc/apt/keyrings/grafana.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" > /etc/apt/sources.list.d/grafana.list && \
    apt-get update && apt-get install -y grafana && \
    rm -rf /var/lib/apt/lists/*

# Remove default nginx config
RUN rm -f /etc/nginx/sites-enabled/default

# Copy nginx configuration
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Copy React static files to NGINX web root
COPY build/ /var/www/html/

# Copy Prometheus and Alertmanager configs
COPY prometheus/prometheus.yml /etc/prometheus/
COPY alertmanager/alertmanager.yml /etc/alertmanager/

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose required ports
EXPOSE 80 9090 9093 3000

# Start all services
CMD ["/start.sh"]
