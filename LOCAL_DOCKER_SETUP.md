# Local Docker Deployment Guide - Xiaozhi ESP32 Server

This guide walks you through deploying the Xiaozhi ESP32 Server locally using Docker on Windows.

## 📋 Prerequisites

- **Docker Desktop** installed and running
- **Docker Compose** V2
- At least **4GB RAM** available for Docker
- **20GB free disk space**
- A stable internet connection for downloading images

## ✅ Step 1: Verify Docker Installation

Open PowerShell and verify Docker is running:

```powershell
docker --version
docker compose version
```

Expected output:
- Docker version 20.10+ 
- Docker Compose v2.x+

## 📁 Step 2: Create Directory Structure

Run the following commands in PowerShell to create the necessary folders:

```powershell
# Navigate to your project directory
cd c:\Users\JN\.gits\xiaozhi-esp32-server

# Create required directories
mkdir -p data, models/SenseVoiceSmall, mysql/conf, mysql/init, uploadfile, logs
```

This creates:
```
xiaozhi-esp32-server/
├── data/                          # Configuration files
├── models/
│   └── SenseVoiceSmall/          # Speech recognition models
│       └── model.pt              # (to be downloaded)
├── mysql/
│   ├── conf/                     # MySQL configuration
│   └── init/                     # Database initialization
├── uploadfile/                   # File uploads
├── logs/                         # Application logs
└── ...
```

## 📥 Step 3: Download Required Model Files

The SenseVoiceSmall model (~1GB) is required for speech recognition.

### Option A: Manual Download (Recommended)
1. Visit: https://www.modelscope.cn/models/iic/SenseVoiceSmall/files
2. Download `model.pt`
3. Place it in `models/SenseVoiceSmall/model.pt`

### Option B: Using PowerShell Download

```powershell
# Note: This may take several minutes due to file size
$ModelUrl = "https://www.modelscope.cn/models/iic/SenseVoiceSmall/resolve/master/model.pt"
$OutputPath = "models/SenseVoiceSmall/model.pt"

# Using Invoke-WebRequest (built-in PowerShell)
Invoke-WebRequest -Uri $ModelUrl -OutFile $OutputPath -UseBasicParsing
```

**⏱️ This download may take 10-30 minutes depending on your internet speed.**

## ⚙️ Step 4: Configure Environment

### 4.1 Create .env file

```powershell
# Copy the example environment file
Copy-Item ".env.example" -Destination ".env"
```

### 4.2 Edit .env (Optional - defaults are fine for local testing)

Edit `.env` with your preferred editor:
```env
DB_PASSWORD=xiaozhi2024
REDIS_PASSWORD=
TZ=Asia/Shanghai
SERVER_PORT=8000
HTTP_PORT=8003
WEB_PORT=8002
MYSQL_PORT=3306
REDIS_PORT=6379
```

## 🔧 Step 5: Configure Application

### 5.1 Create Configuration File

```powershell
# Copy example config to data folder
Copy-Item "main\xiaozhi-server\config.yaml" -Destination "data\.config.yaml"
```

### 5.2 Edit Configuration (Optional)

Open `data\.config.yaml` and configure:
- **ASR (Speech Recognition)**: Default uses local FunASR
- **LLM (Language Model)**: Add API keys if using external services
- **TTS (Speech Synthesis)**: Configure synthesis service

**Default Settings** (free, local options):
- ASR: FunASR (Local)
- LLM: ChatGLM (Zhipu - requires free API key)
- TTS: EdgeTTS (Free)

> 💡 Tip: For initial testing, keep default settings. Models use free APIs or local processing.

## 🐳 Step 6: Choose Deployment Option

### Option A: Simplified Deployment (Server Only)

For just the Python server without database:

```powershell
# Start the container
docker compose -f main/xiaozhi-server/docker-compose.yml up -d

# Check logs
docker logs -f xiaozhi-esp32-server
```

**Ports:**
- `8000`: WebSocket service
- `8003`: HTTP service (OTA, vision)

### Option B: Full Deployment (Server + Web Console + Database)

For complete functionality with database and management console:

```powershell
# Start all services
docker compose -f docker-compose.prod.yml up -d

# Check logs
docker compose -f docker-compose.prod.yml logs -f
```

**Ports:**
- `8000`: WebSocket service
- `8003`: HTTP service
- `8002`: Web console (http://localhost:8002)
- `3306`: MySQL (internal)
- `6379`: Redis (internal)

## ✅ Step 7: Verify Deployment

### Check Container Status

```powershell
# List running containers
docker ps

# View container logs
docker logs -f xiaozhi-esp32-server
```

### Expected Log Messages

You should see messages like:
```
Starting xiaozhi-esp32-server...
Loading configuration...
ASR service initialized
WebSocket server running on port 8000
HTTP server running on port 8003
```

### Test the Service

```powershell
# Test WebSocket connectivity
# This will show if the server is running properly
(Invoke-WebRequest -Uri http://localhost:8003/health).StatusCode
```

Expected: `200 OK`

## 🌐 Access Points

### Simplified Deployment:
- **WebSocket**: `ws://localhost:8000`
- **HTTP OTA**: `http://localhost:8003`
- **Health Check**: `http://localhost:8003/health`

### Full Deployment:
- **Web Console**: `http://localhost:8002`
  - Default credentials: `admin/admin` (may vary)
- **WebSocket**: `ws://localhost:8000`
- **HTTP API**: `http://localhost:8003`
- **MySQL**: `localhost:3306`
- **Redis**: `localhost:6379`

## 🛑 Step 8: Stop Services

```powershell
# Stop simplified deployment
docker compose -f main/xiaozhi-server/docker-compose.yml down

# Stop full deployment
docker compose -f docker-compose.prod.yml down

# Stop and remove volumes (careful - deletes data!)
docker compose -f docker-compose.prod.yml down -v
```

## 🔄 Step 9: Update/Restart

### Update to Latest Version

```powershell
# Pull latest images
docker compose -f docker-compose.prod.yml pull

# Restart with new images
docker compose -f docker-compose.prod.yml up -d --force-recreate
```

### Restart Services

```powershell
# Restart all services
docker compose -f docker-compose.prod.yml restart

# Restart specific service
docker compose -f docker-compose.prod.yml restart xiaozhi-server
```

## 🐛 Troubleshooting

### Port Already in Use

```powershell
# Find process using port (example: 8000)
netstat -ano | findstr :8000

# Kill the process (replace PID with actual process ID)
taskkill /PID <PID> /F
```

### Out of Disk Space

The model files are large (~1GB). Ensure you have:
- 20GB+ free space
- Docker's disk allocation set appropriately

### Check Docker Disk Usage

```powershell
docker system df
docker system prune -a  # Clean up unused images
```

### Container Won't Start

```powershell
# View error logs
docker logs xiaozhi-esp32-server

# Inspect container
docker inspect xiaozhi-esp32-server

# Restart Docker
Restart-Service docker -Force
```

### Model Download Issues

If model.pt download fails:
1. Try again - network may be temporary
2. Use a VPN if in restricted region
3. Download manually from: https://www.modelscope.cn/models/iic/SenseVoiceSmall/files

## 📊 Monitoring

### View Real-time Logs

```powershell
# Full deployment
docker compose -f docker-compose.prod.yml logs -f

# Specific service
docker compose -f docker-compose.prod.yml logs -f xiaozhi-server
```

### Performance Statistics

```powershell
# Monitor resource usage
docker stats xiaozhi-esp32-server

# View container details
docker inspect xiaozhi-esp32-server
```

## 🔐 Security Notes

For local development/testing:
- Default passwords are used (change in production)
- Ports are exposed locally only
- No SSL/TLS configured (use for LAN only)

For production deployment:
- Change all default passwords
- Use environment variables for secrets
- Configure proper firewall rules
- Enable SSL/TLS
- Use proper authentication

## 📚 Next Steps

1. **Test the Connection**: Install the ESP32 firmware and connect to `localhost:8000`
2. **Configure Models**: Edit `data/.config.yaml` with your API keys
3. **Explore Web Console**: Visit `http://localhost:8002` (full deployment)
4. **Read Documentation**: See [docs/Deployment.md](docs/Deployment.md) for detailed configuration

## 🆘 Support

- **Issues**: Check [GitHub Issues](https://github.com/xinnan-tech/xiaozhi-esp32-server/issues)
- **Documentation**: See [docs/](docs/) folder
- **FAQ**: See [docs/FAQ.md](docs/FAQ.md)

## ✨ Summary

Your local Docker deployment is ready when you see:
- ✅ All containers running (`docker ps`)
- ✅ No error messages in logs
- ✅ Health check returns 200 OK
- ✅ You can access the web console (if full deployment)

Enjoy your Xiaozhi deployment! 🎉
