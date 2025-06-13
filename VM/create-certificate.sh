#!/bin/bash
# This script generates a self-signed certificate for HTTPS Ingress Controller

# Create ssh directory only if it doesn't exist
mkdir -p ./tls
chmod 700 ./tls

KEY_PATH=./tls/tls.key

# Generate keys only if they don't exist
if [ ! -f "$KEY_PATH" ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./tls/tls.key -out ./tls/tls.crt -subj "/CN=team18.local/O=team18"
    chmod 600 "$KEY_PATH"
    else
    echo "Certificate already exists at $KEY_PATH"
fi