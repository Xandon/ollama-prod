#!/bin/bash

BACKUP_DIR="../backups"
DATE=$(date +%Y%m%d_%H%M%S)

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Backup Ollama data
docker run --rm \
    --volumes-from ollama \
    -v $BACKUP_DIR:/backup \
    alpine tar czf /backup/ollama_data_$DATE.tar.gz /root/.ollama

# Backup Nginx configuration
tar czf $BACKUP_DIR/nginx_conf_$DATE.tar.gz ../nginx/conf.d ../nginx/templates

# Backup SSL certificates
tar czf $BACKUP_DIR/certs_$DATE.tar.gz ../certs

# Cleanup old backups (keep last 7 days)
find $BACKUP_DIR -type f -mtime +7 -delete

echo "Backup completed: $DATE" 