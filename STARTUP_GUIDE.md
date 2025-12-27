# 🚀 STARTUP GUIDE - Xiaozhi ESP32 Server on Docker

## Step-by-Step to Get Running in 15 Minutes

### Prerequisites Check (2 minutes)
```powershell
# Verify Docker is installed
docker --version
# Expected: Docker version 20.10+

# Verify Docker Compose
docker compose version
# Expected: Docker Compose v2.x+
```

---

## Method 1: Automated Setup (Recommended)

### Step 1: Download the Speech Model (~15 minutes)
```powershell
cd c:\Users\JN\.gits\xiaozhi-esp32-server
.\setup-docker.ps1 -ModelDownload
```

⏳ This downloads a ~1GB file and may take 10-30 minutes depending on internet speed.

**Expected output:**
```
=== Downloading Model ===
Downloading (~1GB, may take 10-30 min)...
[OK] Model downloaded
```

### Step 2: Start the Server (~1 minute)
```powershell
.\setup-docker.ps1 -StartServer
```

**Expected output:**
```
=== Starting Server (Simplified) ===
[OK] Server started
WebSocket: ws://localhost:8000
HTTP: http://localhost:8003
```

### Step 3: Verify It's Running (~1 minute)
```powershell
.\setup-docker.ps1 -CheckStatus
```

**Expected output:**
```
=== Docker Status ===
Running containers:
NAMES                       STATUS      PORTS
xiaozhi-esp32-server        Up X mins   0.0.0.0:8000->8000/tcp, 0.0.0.0:8003->8003/tcp
```

### Done! 🎉
Your server is now running on:
- **WebSocket**: `ws://localhost:8000`
- **HTTP API**: `http://localhost:8003`
- **Health Check**: `http://localhost:8003/health`

---

## Method 2: Manual Docker Commands

### Step 1: Create Directories
```powershell
cd c:\Users\JN\.gits\xiaozhi-esp32-server
mkdir data, models\SenseVoiceSmall, mysql\conf, mysql\init, uploadfile, logs
```

### Step 2: Download Model Files
Visit: https://www.modelscope.cn/models/iic/SenseVoiceSmall/files
- Download `model.pt` (~1GB)
- Save to: `models\SenseVoiceSmall\model.pt`

### Step 3: Copy Configuration
```powershell
# If not done by script
Copy-Item .env.example .env
Copy-Item main\xiaozhi-server\config.yaml data\.config.yaml
```

### Step 4: Start with Docker Compose
```powershell
# Simplified (Server only)
docker compose -f main\xiaozhi-server\docker-compose.yml up -d

# OR Full deployment (with web console)
docker compose -f docker-compose.prod.yml up -d
```

### Step 5: Check Logs
```powershell
docker logs -f xiaozhi-esp32-server
```

---

## 🔍 How to Verify It's Working

### Test 1: Check Container Status
```powershell
docker ps
```

### Test 2: Health Check
```powershell
# Using PowerShell
(Invoke-WebRequest -Uri http://localhost:8003/health).StatusCode
# Should return: 200

# Using curl (if installed)
curl http://localhost:8003/health
```

### Test 3: Check Logs
```powershell
docker logs -f xiaozhi-esp32-server

# You should see:
# - Configuration loaded
# - WebSocket server running on port 8000
# - HTTP server running on port 8003
```

### Test 4: WebSocket Connection
```powershell
# For advanced testing, use wscat or similar WebSocket client
# ws://localhost:8000
```

---

## 🛑 When Something Goes Wrong

### Container won't start?
```powershell
# View full error
docker logs xiaozhi-esp32-server

# Check if ports are available
netstat -ano | findstr :8000
netstat -ano | findstr :8003

# Restart Docker
Restart-Service docker -Force
```

### Port already in use?
```powershell
# Find what's using the port
netstat -ano | findstr :8000

# Kill the process (replace <PID>)
taskkill /PID <PID> /F
```

### Model file won't download?
- Check internet connection
- Try VPN if blocked in your region
- Download manually from: https://www.modelscope.cn/models/iic/SenseVoiceSmall/files
- Place file at: `models\SenseVoiceSmall\model.pt`

### Out of disk space?
```powershell
# Clean up old Docker resources
docker system prune -a

# Check usage
docker system df
```

---

## 📡 Test the Service

### Option 1: Web Browser (Health Check)
```
http://localhost:8003/health
```
Should show: `{"status":"ok"}` or similar

### Option 2: PowerShell WebSocket Test
```powershell
# Simple test script
$uri = "ws://localhost:8000"
$ws = New-WebSocket -Uri $uri
# If successful, connection is established
```

### Option 3: Use Test Tool
The project includes a test page:
```
File: main\xiaozhi-server\test\test_page.html
Open with: Google Chrome browser
```

---

## 🔄 Stop the Services

### Using Script
```powershell
.\setup-docker.ps1 -StopAll
# Choose option 1 for simplified, 2 for full deployment
```

### Using Docker Manually
```powershell
# Simplified
docker compose -f main\xiaozhi-server\docker-compose.yml down

# Full deployment
docker compose -f docker-compose.prod.yml down
```

---

## 📊 Different Deployment Options

### Option A: Server Only (Lightweight)
```powershell
docker compose -f main\xiaozhi-server\docker-compose.yml up -d
```
- ✅ 5GB disk, 2-4GB RAM
- ✅ WebSocket service
- ✅ HTTP API
- ❌ No web console
- ❌ No database

**Best for**: Testing, development, single machine

### Option B: Full System (Complete)
```powershell
docker compose -f docker-compose.prod.yml up -d
```
- ✅ All services
- ✅ Web console at `http://localhost:8002`
- ✅ Database (MySQL)
- ✅ Cache (Redis)
- ✅ User management
- ⚠️ 20GB disk, 4-8GB RAM

**Best for**: Production, multiple users, complete management

---

## 🎯 Quick Reference

| Task | Command |
|------|---------|
| Full automatic setup | `.\setup-docker.ps1 -ModelDownload` then `.\setup-docker.ps1 -StartServer` |
| Start server | `.\setup-docker.ps1 -StartServer` |
| Start with web console | `.\setup-docker.ps1 -StartFull` |
| Check status | `.\setup-docker.ps1 -CheckStatus` |
| Stop services | `.\setup-docker.ps1 -StopAll` |
| View logs | `docker logs -f xiaozhi-esp32-server` |
| List containers | `docker ps` |
| Clean up | `docker system prune -a` |

---

## 📚 Need More Help?

- **Quick Reference**: See [QUICK_START.md](QUICK_START.md)
- **Detailed Guide**: See [LOCAL_DOCKER_SETUP.md](LOCAL_DOCKER_SETUP.md)
- **Troubleshooting**: See [DEPLOYMENT_READY.md](DEPLOYMENT_READY.md)
- **Official Docs**: See `docs/Deployment.md`
- **GitHub Issues**: https://github.com/xinnan-tech/xiaozhi-esp32-server/issues

---

## ✨ Success Checklist

- [ ] Docker is installed and running
- [ ] All directories are created
- [ ] `.env` file exists
- [ ] `.config.yaml` file exists
- [ ] Model file downloaded (~1GB)
- [ ] Container is running (`docker ps`)
- [ ] Health check returns 200
- [ ] Can access WebSocket at `ws://localhost:8000`
- [ ] Can access HTTP API at `http://localhost:8003`
- [ ] Logs show no errors

---

**Ready to deploy?**

```powershell
# Run this now:
cd c:\Users\JN\.gits\xiaozhi-esp32-server
.\setup-docker.ps1 -ModelDownload
```

Then in about 15 minutes:
```powershell
.\setup-docker.ps1 -StartServer
```

Enjoy! 🚀
