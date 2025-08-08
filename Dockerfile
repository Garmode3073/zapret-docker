FROM debian:trixie-slim
LABEL maintainer="141300243+ma-tecik@users.noreply.github.com"
LABEL authors="matecik"
LABEL org.opencontainers.image.licenses="MIT AND GPL-2.0-or-later"
LABEL org.opencontainers.image.version="1.0.1"
LABEL org.opencontainers.image.revision="zapret-v71.3"
LABEL org.opencontainers.image.authors="matecik"
LABEL org.opencontainers.image.source="https://github.com/ma-tecik/zapret-docker"



RUN apt-get update && apt-get install -yq \
        build-essential tinyproxy wget unzip \
        iproute2 iptables ca-certificates \
    && echo "Port 8888\nLogLevel Info\nConnectPort 443\nConnectPort 563" > /etc/tinyproxy/tinyproxy.conf \
    && touch /first_run \
    && cd /opt \
    && ZAPRET_URL=$(wget -qO- https://api.github.com/repos/bol-van/zapret/releases/latest | grep "browser_download_url.*zip" | cut -d '"' -f 4 | head -n 1) \
    && wget "$ZAPRET_URL" -O zapret.zip \
    && unzip zapret.zip && rm zapret.zip \
    && mv zapret* zapret \
    && apt-get purge -y wget unzip \
    && apt-get clean -y && apt-get autoremove -y && apt-get autoclean -y \
    && rm -rf /tmp/* && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/zapret
RUN echo "1\n" | ./install_prereq.sh && ./install_bin.sh

EXPOSE 8888

COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]