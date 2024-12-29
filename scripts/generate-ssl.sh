#!/bin/bash

# Check if domain is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

DOMAIN=$1
EMAIL=${SSL_EMAIL:-"admin@$DOMAIN"}
STAGING=${LETSENCRYPT_STAGING:-0}

# Install certbot if not present
if ! command -v certbot &> /dev/null; then
    apt-get update
    apt-get install -y certbot
fi

# Generate certificates
if [ "$STAGING" = "1" ]; then
    certbot certonly --standalone --test-cert -d $DOMAIN --email $EMAIL --agree-tos -n
else
    certbot certonly --standalone -d $DOMAIN --email $EMAIL --agree-tos -n
fi

# Copy certificates to nginx certs directory
mkdir -p ../certs
cp /etc/letsencrypt/live/$DOMAIN/fullchain.pem ../certs/
cp /etc/letsencrypt/live/$DOMAIN/privkey.pem ../certs/

echo "SSL certificates generated and copied to certs directory" 