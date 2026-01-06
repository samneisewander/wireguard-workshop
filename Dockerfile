# Use the specific Nginx version requested
FROM nginx:1.29.4

# Install WireGuard and networking tools
RUN apt-get update && apt-get install -y \
    wireguard \
    iproute2 \
    iptables \
    && rm -rf /var/lib/apt/lists/*

# Copy your local config to the container
COPY keys/wg0.conf /etc/wireguard/wg0.conf
COPY html /usr/share/nginx/html

# Expose the port for VPN traffic
# Note: WireGuard usually uses UDP
EXPOSE 8080/udp

# Use a custom entrypoint script to start WireGuard before Nginx
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
