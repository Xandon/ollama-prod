# Ollama Production Environment

A production-ready Docker environment for running Ollama with Nginx as a reverse proxy, featuring robust security, monitoring, and backup solutions.

## Project Structure

The project is organized into the following directories:

- nginx/ - Contains Nginx configuration files and templates
- scripts/ - Houses utility scripts for SSL, backups, and deployment
- config/ - Stores configuration files
- certs/ - Contains SSL certificates
- backups/ - Stores system backups
- docs/ - Project documentation including deployment, security, and monitoring guides

## Features

- Secure SSL/TLS configuration with automatic certificate generation
- Rate limiting and DDoS protection
- Health monitoring and logging
- Automated backup system
- Docker-based deployment with docker-compose
- Reverse proxy with Nginx
- Security headers and CORS configuration

## Prerequisites

Before starting, ensure you have:

- Docker (20.10.0+)
- Docker Compose (2.0.0+)
- A domain name pointing to your server
- Root/sudo access on your server

## Installation

1. Clone the repository and create project structure:
   First, clone the repository to your server and run the setup script.

2. Configure environment variables:
   Copy the template file .env.template to .env and edit it with your settings:
   - Set your domain name
   - Configure CORS settings
   - Adjust other settings as needed

3. Generate SSL certificates:
   Run the SSL generation script with your domain name.

4. Start the services:
   Launch the environment using docker-compose.

5. Verify the deployment:
   Test the health endpoint to ensure everything is running correctly.

## Configuration

### Environment Variables

Important settings in your .env file include:

- DOMAIN: Your domain name (required)
- NGINX_PORT: HTTPS port (default: 443)
- NGINX_HTTP_PORT: HTTP port (default: 80)
- ALLOWED_ORIGINS: CORS allowed origins
- OLLAMA_MODELS: Models to preload
- LETSENCRYPT_STAGING: SSL testing mode

### Nginx Configuration

The Nginx setup includes:

- SSL/TLS settings
- Security headers
- Rate limiting
- Gzip compression
- Proxy settings
- Logging configuration

## Security Features

Our security implementation includes:

- TLS 1.2/1.3 with modern cipher configuration
- HTTP to HTTPS redirection
- Rate limiting to prevent abuse
- Security headers (HSTS, XSS Protection, etc.)
- Container isolation
- Regular security updates via Docker images

## Backup and Restore

### Creating Backups

The system performs automatic daily backups. Manual backups can be created using the backup script.

Backups include:
- Ollama data
- Nginx configuration
- SSL certificates

### Restoring from Backup

To restore from a backup:

1. Stop the services
2. Extract the backup files
3. Restart the services

## Monitoring

### Health Checks

Monitor your system through:
- Ollama health endpoint
- Nginx status checks
- Docker health checks

### Logs

Access logs are available at:
- Nginx access and error logs
- Docker container logs

## Maintenance

### SSL Certificate Renewal

Certificates automatically renew via certbot. Manual renewal is also available when needed.

### Updates

Keep your system updated by pulling new Docker images and restarting services periodically.

## Troubleshooting

### Common Issues

1. SSL certificate errors:
   - Check domain DNS settings
   - Verify certificate paths
   - Ensure proper certificate generation

2. Connection refused:
   - Verify service status
   - Check port configurations
   - Review firewall settings

3. Rate limiting issues:
   - Adjust rate limits as needed
   - Monitor access logs

### Debug Mode

Enable detailed logging by setting LOG_LEVEL=debug in your environment configuration.

## Contributing

We welcome contributions:

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License.

## Support

For assistance:
- Create an issue in the repository
- Check the documentation
- Contact the maintainers

## Acknowledgments

Special thanks to:
- Ollama team for their model serving platform
- Nginx for their reverse proxy
- Docker for containerization 