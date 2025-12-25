# 🎉 Xiaozhi ESP32 Server - Docker Deployment Successful!

## ✅ Deployment Status: RUNNING

The Xiaozhi ESP32 Server has been successfully deployed to Docker Desktop locally.

### Quick Info

**Service Status:** Running ✅  
**Container Name:** xiaozhi-esp32-server  
**Image:** ghcr.nju.edu.cn/xinnan-tech/xiaozhi-esp32-server:server_latest  
**Deployment Type:** Simplified (Server only, no web console or database)

---

## 📍 Access Points

### WebSocket (Device Connection)
- **Address:** `ws://localhost:8000/xiaozhi/v1/`
- **Purpose:** Real-time communication with ESP32 devices
- **Note:** This address is for LAN access; update for remote access

### HTTP API
- **Base URL:** `http://localhost:8003/`
- **OTA Interface:** `http://localhost:8003/xiaozhi/ota/`
- **Vision Analysis:** `http://localhost:8003/mcp/vision/explain`

### Docker Container Access
- **Container IP:** 172.18.0.2 (within Docker network)
- **Host IP:** localhost or 127.0.0.1

---

## 🚀 Start/Stop Server

### Start Server
```bash
cd c:\Users\JN\.gits\xiaozhi-esp32-server
docker compose -f docker-compose.local.yml up -d
```

### Stop Server
```bash
docker compose -f docker-compose.local.yml down
```

### View Logs
```bash
docker logs xiaozhi-esp32-server -f
```

### Restart Server
```bash
docker compose -f docker-compose.local.yml restart
```

---

## ⚙️ Configuration

**Config File Location:** `data/.config.yaml`

### Current Configuration
- **ASR Module:** BaiduASR (cloud-based, no model download needed)
- **LLM Module:** ChatGLMLLM
- **TTS Module:** EdgeTTS
- **VAD Module:** SileroVAD
- **Intent Module:** function_call

### Modify Configuration
1. Edit `data/.config.yaml`
2. Restart container: `docker compose -f docker-compose.local.yml restart`

---

## 📝 Important Notes

### ✅ What's Ready
- ✅ Docker container running
- ✅ WebSocket server on port 8000
- ✅ HTTP API server on port 8003
- ✅ Configuration file set up
- ✅ VAD (Voice Activity Detection) - SileroVAD
- ✅ ASR (Automatic Speech Recognition) - BaiduASR (API-based)
- ✅ LLM (Language Model) - ChatGLMLLM
- ✅ TTS (Text-to-Speech) - EdgeTTS

### ⚠️ Optional Setup (Not Required for Basic Testing)
- **Speech Recognition Model:** SenseVoiceSmall model not downloaded
  - Current config uses BaiduASR API (cloud-based)
  - To use local model instead: Download the ~1GB SenseVoiceSmall model and update config

- **API Keys Configuration:** 
  - Some services require API keys (LLM, ASR, TTS)
  - Free/default configurations are currently set
  - Update `data/.config.yaml` with your API keys for production use

---

## 🔧 Troubleshooting

### Container Won't Start
```bash
# Check logs
docker logs xiaozhi-esp32-server

# Check if ports are in use
netstat -ano | findstr :8000
netstat -ano | findstr :8003

# Restart Docker service
docker system prune
```

### Connection Refused
- Ensure Docker Desktop is running
- Check firewall settings
- Verify ports 8000 and 8003 are not blocked

### WebSocket Connection Issues
- Use `ws://localhost:8000/xiaozhi/v1/` for local connections
- For remote access, use the actual IP/domain instead of localhost
- Update server config if network topology changes

---

## 📚 Next Steps

### Option 1: Test with Web Interface
1. Look for test HTML files in the project
2. Open in browser and connect to `ws://localhost:8000/xiaozhi/v1/`

### Option 2: Connect ESP32 Device
1. Flash the ESP32 device with Xiaozhi firmware
2. Configure device with server address: `ws://your-ip:8000/xiaozhi/v1/`
3. Start recording and speaking

### Option 3: API Testing
```bash
# Test OTA endpoint
curl http://localhost:8003/xiaozhi/ota/

# Test vision endpoint (POST with image data)
curl -X POST http://localhost:8003/mcp/vision/explain
```

---

## 🎯 Production Deployment

When ready for production:
1. Configure API keys in `data/.config.yaml`
2. Update WebSocket address to actual IP/domain
3. Consider using `docker-compose.prod.yml` for full deployment (with database, web console)
4. Set up SSL/TLS for secure connections
5. Configure reverse proxy (nginx) if needed

---

## 📞 Support

- Project Repository: https://github.com/xinnan-tech/xiaozhi-esp32-server
- Documentation: See `docs/` directory
- Issues: Check GitHub issues for solutions

---

**Deployment Completed:** 2025-12-25  
**Configuration Style:** Simplified (Server Only)  
**Status:** Ready for Testing ✅
