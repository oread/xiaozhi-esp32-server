# 🐳 Xiaozhi ESP32 Server - Local Docker Deployment Complete

## ✅ Setup Status

Your local Docker environment has been successfully prepared! Here's what was done:

### Files & Directories Created:
- ✅ `data/` - Configuration directory
- ✅ `data/.config.yaml` - Application configuration
- ✅ `.env` - Environment variables
- ✅ `models/SenseVoiceSmall/` - Speech recognition models directory
- ✅ `mysql/conf/` - MySQL configuration directory
- ✅ `mysql/init/` - Database initialization scripts directory
- ✅ `uploadfile/` - File uploads directory
- ✅ `logs/` - Application logs directory

### Setup Scripts Created:
- ✅ `setup-docker.ps1` - PowerShell automation script
- ✅ `setup-local-docker.bat` - Batch automation script
- ✅ `LOCAL_DOCKER_SETUP.md` - Detailed guide
- ✅ `QUICK_START.md` - Quick reference

---

## 🚀 Next Steps (Choose One):

### **Option A: Quick Start (5 minutes)**

1. **Download the speech recognition model** (~1GB, takes 10-30 min):
   ```powershell
   cd c:\Users\JN\.gits\xiaozhi-esp32-server
   .\setup-docker.ps1 -ModelDownload
   ```

2. **Start the simplified server** (Python server only):
   ```powershell
   .\setup-docker.ps1 -StartServer
   ```

3. **Check if it's running**:
   ```powershell
   .\setup-docker.ps1 -CheckStatus
   ```

### **Option B: Full Deployment** (with web console and database)

1. **Download the model**:
   ```powershell
   .\setup-docker.ps1 -ModelDownload
   ```

2. **Start full deployment**:
   ```powershell
   .\setup-docker.ps1 -StartFull
   ```

3. **Access the web console**:
   ```
   http://localhost:8002
   ```

---

## 📚 Available Resources

### Documentation:
- **[LOCAL_DOCKER_SETUP.md](LOCAL_DOCKER_SETUP.md)** - Complete detailed guide (read this first)
- **[QUICK_START.md](QUICK_START.md)** - Quick reference card
- **[docs/Deployment.md](docs/Deployment.md)** - Official deployment guide (Chinese)
- **[docs/Deployment_all.md](docs/Deployment_all.md)** - Full module deployment (Chinese)

### Setup Scripts:
- **setup-docker.ps1** - PowerShell script with full automation
- **setup-local-docker.bat** - Batch script for Windows
- **docker-compose.yml** - Simplified deployment config
- **docker-compose.prod.yml** - Full deployment config

---

## 🔗 Access Points

### After Starting Server:

| Service | Address | Port |
|---------|---------|------|
| WebSocket API | `ws://localhost:8000` | 8000 |
| HTTP API | `http://localhost:8003` | 8003 |
| Health Check | `http://localhost:8003/health` | 8003 |

### After Full Deployment (add these):

| Service | Address | Port |
|---------|---------|------|
| Web Console | `http://localhost:8002` | 8002 |
| MySQL | `localhost:3306` | 3306 |
| Redis | `localhost:6379` | 6379 |

---

## 🔧 Configuration

### `.env` File
Located at: `c:\Users\JN\.gits\xiaozhi-esp32-server\.env`

Edit for custom settings:
```env
DB_PASSWORD=xiaozhi2024      # Change for production
REDIS_PASSWORD=              # Optional
TZ=Asia/Shanghai
SERVER_PORT=8000
HTTP_PORT=8003
WEB_PORT=8002
```

### `data/.config.yaml` File
Located at: `c:\Users\JN\.gits\xiaozhi-esp32-server\data\.config.yaml`

Configure:
- **ASR** (Speech Recognition) - Default: FunASR (local, free)
- **LLM** (Language Model) - Requires API key
- **TTS** (Text-to-Speech) - Default: EdgeTTS (free)
- **VLLM** (Vision Model) - Optional

> 💡 For testing, default free settings work fine!

---

## 📊 Deployment Comparison

Choose based on your needs:

### Simplified (Server Only)
```bash
docker compose -f main\xiaozhi-server\docker-compose.yml up -d
```
- ✅ WebSocket & HTTP services
- ✅ ~5GB disk usage
- ✅ 2-4GB RAM
- ❌ No web console
- ❌ No database persistence

### Full (Complete System)
```bash
docker compose -f docker-compose.prod.yml up -d
```
- ✅ All features above
- ✅ Web management console
- ✅ MySQL database
- ✅ Redis cache
- ✅ User management
- ✅ Device management
- ⚠️ ~20GB disk usage
- ⚠️ 4-8GB RAM required

---

## 🎯 Common Commands

```powershell
# Setup and start everything automatically
.\setup-docker.ps1 -All

# Individual operations:
.\setup-docker.ps1 -ModelDownload    # Download ~1GB model
.\setup-docker.ps1 -StartServer      # Start simplified
.\setup-docker.ps1 -StartFull        # Start with web console
.\setup-docker.ps1 -CheckStatus      # View running services
.\setup-docker.ps1 -StopAll          # Stop containers

# Manual Docker commands:
docker ps                                           # List containers
docker logs -f xiaozhi-esp32-server                # View logs
docker compose -f docker-compose.prod.yml logs -f  # View all logs
docker compose -f docker-compose.prod.yml down     # Stop services
docker system df                                    # Check disk usage
```

---

## 🆘 Troubleshooting

### Issue: "Port 8000 already in use"
```powershell
# Find the process
netstat -ano | findstr :8000

# Kill it (replace <PID>)
taskkill /PID <PID> /F
```

### Issue: Docker container won't start
```powershell
# View detailed error logs
docker logs xiaozhi-esp32-server

# Restart Docker service
Restart-Service docker -Force
```

### Issue: Model download fails
1. Try again - network may be temporary
2. Use a VPN if needed
3. Download manually: https://www.modelscope.cn/models/iic/SenseVoiceSmall/files

### Issue: Out of disk space
```powershell
# Clean up unused Docker resources
docker system prune -a --volumes
docker system df
```

---

## 📋 Project Structure

```
c:\Users\JN\.gits\xiaozhi-esp32-server\
├── .env                              # Environment config
├── docker-compose.prod.yml           # Full deployment config
├── data/
│   └── .config.yaml                  # App configuration
├── models/
│   └── SenseVoiceSmall/
│       └── model.pt                  # (~1GB model file - download needed)
├── mysql/
│   ├── conf/                         # MySQL configuration
│   └── init/                         # Database scripts
├── logs/                             # Container logs
├── uploadfile/                       # User uploads
├── main/
│   ├── xiaozhi-server/
│   │   ├── app.py                    # Python server
│   │   ├── config.yaml              # Server config template
│   │   └── docker-compose.yml       # Simplified config
│   └── ...
├── QUICK_START.md                    # This file
└── LOCAL_DOCKER_SETUP.md             # Detailed guide
```

---

## 🎓 Learning Path

1. **Start Here**: Read [QUICK_START.md](QUICK_START.md)
2. **Detailed Setup**: Read [LOCAL_DOCKER_SETUP.md](LOCAL_DOCKER_SETUP.md)
3. **Run Script**: Execute `.\setup-docker.ps1 -ModelDownload`
4. **Start Service**: Execute `.\setup-docker.ps1 -StartServer`
5. **Test Connection**: Check logs with `.\setup-docker.ps1 -CheckStatus`
6. **Configure**: Edit `data/.config.yaml` for your needs
7. **Deploy**: Use `.\setup-docker.ps1 -StartFull` when ready

---

## 🔐 Security Notes

### Development/Testing (Current):
- ✅ Safe for local use
- ✅ Default passwords are fine
- ✅ No SSL/TLS needed on localhost
- ✅ Firewall blocks external access

### For Production:
- ⚠️ Change all default passwords
- ⚠️ Configure SSL/TLS certificates
- ⚠️ Use strong authentication
- ⚠️ Enable firewall rules
- ⚠️ Use environment variables for secrets
- ⚠️ Regular backups

---

## 📞 Support & Resources

- **GitHub Issues**: https://github.com/xinnan-tech/xiaozhi-esp32-server/issues
- **Official Docs**: See `docs/` folder
- **FAQ**: [docs/FAQ.md](docs/FAQ.md)
- **Deployment**: [docs/Deployment.md](docs/Deployment.md) (Chinese)

---

## ✨ What's Next?

1. **Download Model** (if not done):
   ```powershell
   .\setup-docker.ps1 -ModelDownload
   ```

2. **Start Docker**:
   ```powershell
   .\setup-docker.ps1 -StartServer
   ```

3. **Verify It Works**:
   ```powershell
   .\setup-docker.ps1 -CheckStatus
   ```

4. **Test Health**:
   ```powershell
   Invoke-WebRequest http://localhost:8003/health
   ```

5. **Read Detailed Docs**:
   - [LOCAL_DOCKER_SETUP.md](LOCAL_DOCKER_SETUP.md) - Full setup guide
   - [QUICK_START.md](QUICK_START.md) - Command reference
   - [docs/Deployment.md](docs/Deployment.md) - Official guide

---

**You're ready to deploy! 🚀**

Start with: `.\setup-docker.ps1 -ModelDownload`
