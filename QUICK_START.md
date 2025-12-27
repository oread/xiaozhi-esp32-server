# 🐳 Xiaozhi Docker Quick Reference - Windows

## 🚀 Quick Start (5 Minutes)

### 1. Run Setup Script (Recommended)
```powershell
# Navigate to project
cd c:\Users\JN\.gits\xiaozhi-esp32-server

# Run setup in interactive mode
.\setup-docker.ps1
```

### 2. Download Model (~1GB)
```powershell
.\setup-docker.ps1 -ModelDownload
```

### 3. Start Docker
```powershell
# Option A: Server only (lightweight)
docker compose -f main\xiaozhi-server\docker-compose.yml up -d

# Option B: Full deployment (with web console)
docker compose -f docker-compose.prod.yml up -d
```

### 4. Verify It Works
```powershell
docker ps
docker logs -f xiaozhi-esp32-server
```

---

## 📊 Common Commands

| Command | Purpose |
|---------|---------|
| `.\setup-docker.ps1` | Interactive setup |
| `.\setup-docker.ps1 -All` | Auto setup + download + start |
| `docker ps` | List running containers |
| `docker logs -f xiaozhi-esp32-server` | View live logs |
| `docker compose down` | Stop all containers |
| `docker system df` | Check disk usage |

---

## 🔗 Access Points

### Server Only (Port 8000 & 8003)
- **WebSocket**: `ws://localhost:8000`
- **HTTP API**: `http://localhost:8003`
- **Health**: `http://localhost:8003/health`

### Full Deployment (Add Port 8002 & Database)
- **Web Console**: `http://localhost:8002`
- **WebSocket**: `ws://localhost:8000`
- **HTTP API**: `http://localhost:8003`
- **MySQL**: `localhost:3306`
- **Redis**: `localhost:6379`

---

## 📁 Directory Structure (Auto-created)
```
xiaozhi-esp32-server/
├── .env                           # Environment config
├── data/
│   └── .config.yaml              # App configuration
├── models/SenseVoiceSmall/
│   └── model.pt                  # Speech recognition model (~1GB)
├── mysql/
│   ├── conf/                     # MySQL config
│   └── init/                     # Init scripts
├── uploadfile/                   # File uploads
└── logs/                         # Application logs
```

---

## ✅ Troubleshooting

### Port Already in Use
```powershell
# Find process using port 8000
netstat -ano | findstr :8000

# Kill it (replace <PID> with actual process ID)
taskkill /PID <PID> /F
```

### Container Won't Start
```powershell
# Check detailed error logs
docker logs xiaozhi-esp32-server

# Restart Docker service
Restart-Service docker -Force
```

### Out of Space
```powershell
# Clean up unused images and containers
docker system prune -a --volumes

# Check disk usage
docker system df
```

### Can't Download Model
- Try manual download: https://www.modelscope.cn/models/iic/SenseVoiceSmall/files
- Or use VPN if download blocked
- Or mount existing model file

---

## 🔧 PowerShell Script Usage

```powershell
# Setup everything
.\setup-docker.ps1 -All

# Download model only
.\setup-docker.ps1 -ModelDownload

# Start server (lightweight)
.\setup-docker.ps1 -StartServer

# Start full deployment
.\setup-docker.ps1 -StartFull

# Check status
.\setup-docker.ps1 -CheckStatus

# Stop containers
.\setup-docker.ps1 -StopAll

# Show help
.\setup-docker.ps1 -Help
```

---

## 📋 Configuration Files

### `.env` - Environment Variables
Edit for custom settings:
```env
DB_PASSWORD=your_password
REDIS_PASSWORD=optional
TZ=Asia/Shanghai
```

### `data\.config.yaml` - Application Settings
Configure:
- ASR (Speech Recognition)
- LLM (Language Model) - add API keys here
- TTS (Text-to-Speech)
- Other services

---

## 🆘 Getting Help

- **Docs**: `LOCAL_DOCKER_SETUP.md` (detailed guide)
- **Issues**: https://github.com/xinnan-tech/xiaozhi-esp32-server/issues
- **FAQ**: `docs/FAQ.md`
- **Deployment**: `docs/Deployment.md` or `docs/Deployment_all.md`

---

## 🎯 Deployment Comparison

| Feature | Server Only | Full |
|---------|:----------:|:----:|
| Python Server | ✅ | ✅ |
| WebSocket API | ✅ | ✅ |
| Web Console | ❌ | ✅ |
| Database | ❌ | ✅ |
| User Management | ❌ | ✅ |
| Disk Space | ~5GB | ~20GB |
| RAM Required | 2-4GB | 4-8GB |
| Setup Time | 5 min | 10 min |

---

## 🔐 Default Credentials

**Full Deployment Only:**
- **Web Console**: `admin` / `admin` (may vary)
- **Database**: `root` / `xiaozhi2024`
- **Redis**: No password (default)

⚠️ Change these in production!

---

## 💡 Tips & Tricks

### Monitor in Real-time
```powershell
# All services
docker compose -f docker-compose.prod.yml logs -f

# Specific service
docker compose -f docker-compose.prod.yml logs -f xiaozhi-server
```

### Update to Latest Version
```powershell
docker compose -f docker-compose.prod.yml pull
docker compose -f docker-compose.prod.yml up -d --force-recreate
```

### Backup Configuration
```powershell
# Backup .config.yaml before updates
Copy-Item "data\.config.yaml" -Destination "data\.config.yaml.backup"
```

### Clean Restart
```powershell
# Stop and remove everything
docker compose -f docker-compose.prod.yml down -v

# Start fresh
docker compose -f docker-compose.prod.yml up -d
```

---

**Ready? Start with:** `.\setup-docker.ps1`
