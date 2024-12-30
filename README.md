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

   ```bash
   # Clone the repository
   git clone https://github.com/Xandon/ollama-prod.git
   
   # Navigate to the project directory
   cd ollama-prod
   
   # Make the setup script executable
   chmod +x create_project.sh
   
   # Run the setup script to create the directory structure
   ./create_project.sh
   ```

   This will create the following directory structure:
   ```
   ollama-prod/
   ├── nginx/
   │   ├── conf.d/          # Nginx configuration files
   │   └── templates/       # Nginx template files
   ├── scripts/            # Utility scripts
   ├── config/            # Configuration files
   ├── certs/             # SSL certificates
   ├── backups/           # Backup storage
   └── docs/              # Documentation
       ├── deployment/    # Deployment guides
       ├── security/      # Security documentation
       └── monitoring/    # Monitoring guides
   ```

   The `create_project.sh` script automatically sets up all necessary directories for:
   - Nginx configuration and templates
   - SSL certificates
   - Backup storage
   - Documentation
   - Scripts and utilities

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

## Windows Installation

If you're installing on Windows, follow these modified instructions:

### Prerequisites for Windows

Before starting, ensure you have:

- Docker Desktop for Windows
- Docker Compose (included with Docker Desktop)
- A domain name pointing to your server
- Git for Windows
- Windows Terminal (recommended) or PowerShell

### Windows Setup Steps

1. Clone the repository and create project structure:

   ```powershell
   # Clone the repository
   git clone https://github.com/Xandon/ollama-prod.git
   
   # Navigate to the project directory
   cd ollama-prod
   
   # Create the directory structure (Windows PowerShell)
   mkdir -p nginx/conf.d, nginx/templates, scripts, config, certs, backups, docs/deployment, docs/security, docs/monitoring
   ```

2. Configure environment variables:
   
   ```powershell
   # Copy the environment template
   copy .env.template .env
   
   # Edit .env file with your preferred text editor
   notepad .env
   # or
   code .env  # if using VS Code
   ```

3. Generate SSL certificates:
   - Install certbot using Windows Subsystem for Linux (WSL2) or
   - Use Windows-compatible alternatives like win-acme
   - Certificates can also be generated on a Linux machine and copied over

4. Start the services:
   ```powershell
   docker-compose up -d
   ```

5. Verify the deployment:
   ```powershell
   curl http://localhost:11434/api/health
   ```

### Windows-Specific Considerations

#### File Permissions
- Windows file permissions work differently from Unix systems
- Ensure proper access rights for Docker volume mounts
- Use Windows ACLs to secure sensitive files

#### Path Formatting
- Use forward slashes (`/`) in Docker and git configurations
- Windows environment variables use different syntax: `%VARIABLE%` instead of `$VARIABLE`

#### Docker Desktop Settings
1. Enable WSL 2 based engine
2. Allocate sufficient resources in Docker Desktop settings
3. Ensure shared drives are properly configured

### Common Windows Issues

1. Line Ending Issues:
   ```powershell
   # Configure Git to handle line endings
   git config --global core.autocrlf true
   ```

2. Volume Mount Problems:
   - Ensure Docker Desktop has permission to access your drives
   - Check Docker Desktop > Settings > Resources > File Sharing

3. WSL 2 Integration:
   - Enable WSL 2 in Windows features
   - Install WSL 2 Linux kernel update
   - Set WSL 2 as default: `wsl --set-default-version 2`

### Windows Backup Script

For Windows systems, use this PowerShell script:

```powershell
# Create backup directory if it doesn't exist
$BackupDir = "..\backups"
$Date = Get-Date -Format "yyyyMMdd_HHmmss"

New-Item -ItemType Directory -Force -Path $BackupDir

# Backup Ollama data
docker run --rm `
    --volumes-from ollama `
    -v ${BackupDir}:/backup `
    alpine tar czf /backup/ollama_data_${Date}.tar.gz /root/.ollama

# Backup Nginx configuration
Compress-Archive -Path ..\nginx\conf.d\*, ..\nginx\templates\* `
    -DestinationPath $BackupDir\nginx_conf_${Date}.zip -Force

# Backup SSL certificates
Compress-Archive -Path ..\certs\* `
    -DestinationPath $BackupDir\certs_${Date}.zip -Force

# Cleanup old backups (keep last 7 days)
Get-ChildItem $BackupDir | Where-Object {
    $_.LastWriteTime -lt (Get-Date).AddDays(-7)
} | Remove-Item

Write-Host "Backup completed: $Date"
```

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