# Docker Setup Guide for Xiaozhi ESP32 Server

This guide provides comprehensive instructions for deploying the Xiaozhi ESP32 Server using Docker.

## 📋 Prerequisites

- Docker Engine 20.10 or higher
- Docker Compose V2
- At least 4GB RAM (8GB recommended for full features)
- 20GB free disk space

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/xinnan-tech/xiaozhi-esp32-server.git
cd xiaozhi-esp32-server
```

### 2. Prepare Required Files

#### Create Directory Structure

```bash
mkdir -p data models/SenseVoiceSmall mysql/conf mysql/init uploadfile logs
```

Your directory structure should look like:
```
xiaozhi-esp32-server/
├── data/                          # Configuration files
├── models/
│   └── SenseVoiceSmall/
│       └── model.pt              # Download required
├── mysql/
│   ├── conf/                     # MySQL configuration
│   └── init/                     # Database initialization scripts
├── uploadfile/                   # File uploads
├── logs/                         # Application logs
├── docker-compose.prod.yml       # Production docker compose
├── .env                          # Environment variables
└── ...
```

#### Download Model Files

Download the SenseVoice model file:
- **Manual Download**: Visit [ModelScope](https://www.modelscope.cn/models/iic/SenseVoiceSmall/files)
- Download `model.pt` (約 1GB)
- Place it in `models/SenseVoiceSmall/model.pt`

Alternative download methods:
```bash
# Using wget
wget -O models/SenseVoiceSmall/model.pt https://www.modelscope.cn/models/iic/SenseVoiceSmall/resolve/master/model.pt

# Using curl
curl -L -o models/SenseVoiceSmall/model.pt https://www.modelscope.cn/models/iic/SenseVoiceSmall/resolve/master/model.pt
```

### 3. Configure Environment

```bash
# Copy environment template
cp .env.example .env

# Edit configuration
nano .env  # or use your preferred editor
```

Configure your `.env` file:
```env
DB_PASSWORD=your_secure_password
REDIS_PASSWORD=your_redis_password  # Optional
TZ=Asia/Shanghai
```

### 4. Configure Application

Create the configuration file:
```bash
# Copy template configuration
cp main/xiaozhi-server/config.yaml data/.config.yaml

# Edit configuration
nano data/.config.yaml
```

**Important Configuration Items:**
- ASR (Speech Recognition): Configure FunASR or API services
- LLM (Language Model): Add your API keys (ChatGLM, Doubao, etc.)
- TTS (Text-to-Speech): Configure synthesis service
- Network settings and ports

Refer to the [Configuration Documentation](docs/Deployment.md#配置项目) for detailed settings.

### 5. Build and Run

#### Build Docker Images

```bash
# Build all services
docker compose -f docker-compose.prod.yml build

# Or build individual services
docker compose -f docker-compose.prod.yml build xiaozhi-server
docker compose -f docker-compose.prod.yml build xiaozhi-web
```

#### Start Services

```bash
# Start all services
docker compose -f docker-compose.prod.yml up -d

# Check service status
docker compose -f docker-compose.prod.yml ps

# View logs
docker compose -f docker-compose.prod.yml logs -f
```

### 6. Verify Installation

#### Check Service Health

```bash
# Check all containers
docker compose -f docker-compose.prod.yml ps

# Check specific service logs
docker compose -f docker-compose.prod.yml logs xiaozhi-server
docker compose -f docker-compose.prod.yml logs xiaozhi-web
```

#### Access Services

- **Web Management Console**: http://localhost:8002
- **WebSocket Service**: ws://localhost:8000
- **HTTP/OTA Service**: http://localhost:8003
- **Test Tool**: http://localhost:8003/test/

## 🔧 Configuration Details

### Service Ports

| Service | Port | Description |
|---------|------|-------------|
| xiaozhi-server | 8000 | WebSocket service for device communication |
| xiaozhi-server | 8003 | HTTP service for OTA and vision analysis |
| xiaozhi-web | 8002 | Web management console |
| MySQL | 3306 | Database (internal/external) |
| Redis | 6379 | Cache (internal/external) |

### Volume Mappings

| Host Path | Container Path | Purpose |
|-----------|----------------|---------|
| ./data | /opt/xiaozhi-esp32-server/data | Configuration files |
| ./models | /opt/xiaozhi-esp32-server/models | AI models |
| ./logs | /opt/xiaozhi-esp32-server/logs | Application logs |
| ./uploadfile | /uploadfile | Uploaded files |
| mysql-data | /var/lib/mysql | MySQL database files |
| redis-data | /data | Redis persistence |

## 🔄 Maintenance

### Update Services

```bash
# Pull latest changes
git pull origin main

# Backup configuration
cp data/.config.yaml data/.config.yaml.backup

# Rebuild and restart
docker compose -f docker-compose.prod.yml down
docker compose -f docker-compose.prod.yml build
docker compose -f docker-compose.prod.yml up -d
```

### Backup Data

```bash
# Backup database
docker exec xiaozhi-esp32-db mysqldump -u root -p xiaozhi_esp32_server > backup.sql

# Backup configuration
tar -czf backup-config.tar.gz data/ uploadfile/
```

### View Logs

```bash
# All services
docker compose -f docker-compose.prod.yml logs -f

# Specific service
docker compose -f docker-compose.prod.yml logs -f xiaozhi-server

# Last 100 lines
docker compose -f docker-compose.prod.yml logs --tail=100 xiaozhi-server
```

### Restart Services

```bash
# Restart all services
docker compose -f docker-compose.prod.yml restart

# Restart specific service
docker compose -f docker-compose.prod.yml restart xiaozhi-server
```

### Stop Services

```bash
# Stop all services
docker compose -f docker-compose.prod.yml stop

# Stop and remove containers
docker compose -f docker-compose.prod.yml down

# Stop and remove everything (including volumes)
docker compose -f docker-compose.prod.yml down -v
```

## 🐛 Troubleshooting

### Container Won't Start

1. Check logs:
```bash
docker compose -f docker-compose.prod.yml logs xiaozhi-server
```

2. Verify configuration:
```bash
# Check if config file exists
ls -la data/.config.yaml

# Validate YAML syntax
python -c "import yaml; yaml.safe_load(open('data/.config.yaml'))"
```

3. Check model file:
```bash
ls -lh models/SenseVoiceSmall/model.pt
```

### Database Connection Issues

```bash
# Test MySQL connection
docker exec -it xiaozhi-esp32-db mysql -u root -p xiaozhi_esp32_server

# Check database logs
docker compose -f docker-compose.prod.yml logs xiaozhi-db
```

### Memory Issues

If running on low-memory systems:
```bash
# Adjust Java heap size in docker-compose.prod.yml
environment:
  - JAVA_OPTS=-Xms256m -Xmx512m
```

### Port Conflicts

If ports are already in use:
```bash
# Check which process is using the port
netstat -tulpn | grep 8000

# Modify ports in .env file
SERVER_PORT=8001
WEB_PORT=8005
```

## 📊 Performance Optimization

### For Low-End Systems (2 cores, 2GB RAM)

Use API-based services instead of local models:
- Configure cloud-based ASR (e.g., Aliyun, Doubao)
- Use lightweight LLM APIs
- Disable unnecessary features

### For High-Performance Systems (4+ cores, 8GB+ RAM)

Enable local models for better performance:
- Use FunASR with GPU acceleration
- Run local TTS services
- Enable vision models

## 🔒 Security Recommendations

1. **Change default passwords** in `.env` file
2. **Use strong passwords** for database and Redis
3. **Limit external port exposure** in production
4. **Enable firewall rules** for production deployments
5. **Regular backups** of data and configuration
6. **Keep Docker images updated**

## 📚 Additional Resources

- [Full Deployment Guide](docs/Deployment.md)
- [FAQ](docs/FAQ.md)
- [Configuration Details](docs/Deployment.md#配置项目)
- [Performance Testing](docs/performance_tester.md)
- [MCP Integration](docs/mcp-endpoint-integration.md)

## 🆘 Getting Help

- **Issues**: [GitHub Issues](https://github.com/xinnan-tech/xiaozhi-esp32-server/issues)
- **Documentation**: [Project Wiki](https://github.com/xinnan-tech/xiaozhi-esp32-server)
- **Video Tutorials**: Check README.md for video links

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
