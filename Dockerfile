
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

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

RUN useradd --no-create-home --shell /bin/false prometheus && \
    mkdir /etc/prometheus /var/lib/prometheus
RUN wget https://github.com/prometheus/prometheus/releases/download/v2.51.2/prometheus-2.51.2.linux-amd64.tar.gz && \
    tar xvf prometheus-2.51.2.linux-amd64.tar.gz && \
    mv prometheus-2.51.2.linux-amd64/prometheus /usr/local/bin/ && \
    mv prometheus-2.51.2.linux-amd64/promtool /usr/local/bin/ && \
    mv prometheus-2.51.2.linux-amd64/consoles /etc/prometheus/ && \
    mv prometheus-2.51.2.linux-amd64/console_libraries /etc/prometheus/

RUN wget https://github.com/prometheus/alertmanager/releases/download/v0.27.0/alertmanager-0.27.0.linux-amd64.tar.gz && \
    tar xvf alertmanager-0.27.0.linux-amd64.tar.gz && \
    mv alertmanager-0.27.0.linux-amd64/alertmanager /usr/local/bin/ && \
    mv alertmanager-0.27.0.linux-amd64/amtool /usr/local/bin/

RUN wget https://dl.grafana.com/oss/release/grafana_10.4.2_amd64.deb && \
    dpkg -i grafana_10.4.2_amd64.deb

COPY build/ /var/www/html/
RUN rm -rf /var/www/html/index.nginx-debian.html

COPY prometheus/prometheus.yml /etc/prometheus/
COPY alertmanager/alertmanager.yml /etc/alertmanager/
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80 9090 9093 3000

CMD ["/start.sh"]
