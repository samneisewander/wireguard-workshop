#!/bin/bash

# Bring up the WireGuard interface
wg-quick up wg0

# Start Nginx in the foreground
nginx -g "daemon off;"
