# RAG Full Module Deployment - Complete! ✅

## ✅ Deployment Status

Your xiaozhi-esp32-server with RAG support has been deployed successfully!

**Deployment Directory:** `c:\Users\SonNT\.github\Xiaozhi MCP\xiaozhi-esp32-server\xiaozhi-esp32-server\xiaozhi-server-full`

---

## 🌐 Service URLs

### Web Console (Smart Control Console)
- **Local:** http://localhost:8002
- **LAN Access:** http://172.31.224.1:8002

### WebSocket Server (for ESP32)
- **Local:** ws://localhost:8000/xiaozhi/v1/
- **LAN Access:** ws://172.31.224.1:8000/xiaozhi/v1/

### Other Services
- **OTA Endpoint:** http://localhost:8002/xiaozhi/ota/
- **Vision API:** http://localhost:8003/mcp/vision/explain
- **API Documentation:** http://localhost:8002/xiaozhi/doc.html

---

## 📦 Running Services

| Service | Container Name | Status |
|---------|---------------|--------|
| MySQL Database | xiaozhi-esp32-server-db | ✅ Running |
| Redis Cache | xiaozhi-esp32-server-redis | ✅ Running |
| Web Console | xiaozhi-esp32-server-web | ✅ Running |
| Server | xiaozhi-esp32-server | ⚠️ Waiting for configuration |

**Database Connection:**
- Host: xiaozhi-esp32-server-db:3306
- Database: xiaozhi_esp32_server
- Username: root
- Password: 123456

---

## 🔧 REQUIRED NEXT STEPS

### Step 1: Register Super Admin (FIRST PRIORITY)

1. Open web console: http://localhost:8002
2. Click "Register" to create first account
3. **First account becomes Super Administrator**
4. Login with your new account

### Step 2: Configure server.secret (CRITICAL - Server won't start without this)

**The server is currently stopped because it needs the server.secret!**

1. Login to Web Console as super admin
2. Navigate to: **Parameter Management** (参数管理)
3. Find parameter: **server.secret**
4. Copy the **Parameter Value** (a UUID like: 12345678-xxxx-xxxx-xxxx-123456789000)
5. Edit configuration file:
   ```
   c:\Users\SonNT\.github\Xiaozhi MCP\xiaozhi-esp32-server\xiaozhi-esp32-server\xiaozhi-server-full\data\.config.yaml
   ```
6. Find this section:
   ```yaml
   manager-api:
     url: http://xiaozhi-esp32-server-web:8002/xiaozhi
     secret: 你的server.secret值
   ```
7. Replace `你的server.secret值` with the UUID you copied
8. Save the file
9. Restart server:
   ```powershell
   docker restart xiaozhi-esp32-server
   ```

### Step 3: Configure AI Models

1. Go to: **Model Configuration** (模型配置)
2. Configure **LLM** (Large Language Model):
   - Click on "Zhipu AI" (智谱AI)
   - Enter your ChatGLM API key: `51b4487a5a4f4b369f7b1f2d56e30ce4.uAmcHOBE5hcq6bw2`
   - Save

3. Configure **ASR** (Speech Recognition):
   - You selected OpenaiASR
   - Configure OpenAI API key
   - Or switch to FunASR if you have the model

4. Configure **TTS** (Text-to-Speech):
   - OpenAITTS with your API key: `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`
   - Or use LinkeraiTTS (free)

5. Configure **VLLM** (Vision Model) - Optional:
   - ChatGLMVLLM for image understanding
   - Configure API key

### Step 4: Configure RAG (Knowledge Base) 🎯

**This is the RAG functionality you requested!**

1. Navigate to: **Knowledge Base** section in web console
2. Click: **RAG Configuration** or **Model Configuration** → **RAG Models**
3. Add RAGFlow Configuration:
   ```
   Base URL: [Your RAGFlow instance URL]
   API Key: [Your RAGFlow API key]
   Adapter Type: ragflow
   ```

4. **Create Knowledge Base:**
   - Go to Knowledge Base section
   - Click "Create Dataset"
   - Enter dataset name and description
   - Configure parsing settings:
     - Chunk size (recommended: 512-1024 tokens)
     - Chunk overlap (recommended: 50-100 tokens)

5. **Upload Documents:**
   - Select your dataset
   - Click "Upload Document"
   - Supported formats: PDF, TXT, DOCX, MD
   - Wait for parsing to complete

6. **Test RAG Retrieval:**
   - Use "Retrieval Test" feature
   - Enter a question
   - Check if relevant chunks are retrieved
   - Adjust parameters if needed

### Step 5: Configure System Parameters

1. Go to: **Parameter Management** (参数管理)
2. Set **server.websocket**:
   ```
   ws://172.31.224.1:8000/xiaozhi/v1/
   ```
3. Set **server.ota**:
   ```
   http://172.31.224.1:8002/xiaozhi/ota/
   ```

### Step 6: Verify Server Startup

After configuring server.secret, check server logs:

```powershell
docker logs -f xiaozhi-esp32-server
```

Look for these success messages:
```
✓ ASR Component initialized
✓ LLM Component initialized
✓ TTS Component initialized
✓ WebSocket server started
✓ Websocket地址是 ws://xxx.xx.xx.xx:8000/xiaozhi/v1/
```

---

## 📚 RAG System Architecture

Your deployment includes:

### RAG Components
- **RAGFlowAdapter** (Java Backend)
  - Dataset CRUD operations
  - Document upload and parsing
  - Chunk management
  - Retrieval testing

- **Python Plugin** (search_from_ragflow)
  - LLM function calling integration
  - Real-time knowledge retrieval
  - Context injection into conversations

- **Database** (MySQL)
  - Table: `ai_rag_dataset`
  - Stores knowledge base metadata
  - Document references and configurations

### How RAG Works
1. User asks a question via ESP32
2. ASR converts speech to text
3. LLM analyzes question and determines if RAG search needed
4. If yes, function calling triggers `search_from_ragflow`
5. RAGFlow retrieves relevant document chunks
6. LLM generates response with retrieved context
7. TTS converts response to speech
8. Audio sent back to ESP32

---

## 🛠️ Useful Commands

### View Logs
```powershell
# Server logs
docker logs -f xiaozhi-esp32-server

# Web console logs
docker logs -f xiaozhi-esp32-server-web

# Database logs
docker logs -f xiaozhi-esp32-server-db
```

### Container Management
```powershell
# Restart server (after config changes)
docker restart xiaozhi-esp32-server

# Restart all services
docker restart xiaozhi-esp32-server xiaozhi-esp32-server-web xiaozhi-esp32-server-db xiaozhi-esp32-server-redis

# Stop all services
cd "c:\Users\SonNT\.github\Xiaozhi MCP\xiaozhi-esp32-server\xiaozhi-esp32-server\xiaozhi-server-full"
docker compose -f docker-compose_all.yml down

# Start all services
docker compose -f docker-compose_all.yml up -d
```

### Access Database
```powershell
docker exec -it xiaozhi-esp32-server-db mysql -uroot -p123456 xiaozhi_esp32_server
```

---

## 🔍 Troubleshooting

### Server won't start
**Error:** "请检查配置manager-api的secret"
**Solution:** You need to configure server.secret (see Step 2 above)

### Port already in use
```powershell
# Find what's using the port
netstat -ano | findstr :8002

# Stop container using the port
docker ps | Select-String "8002"
docker stop [container_name]
```

### Database connection failed
```powershell
# Check database status
docker logs xiaozhi-esp32-server-db

# Restart database
docker restart xiaozhi-esp32-server-db
```

### Web console not loading
```powershell
# Check web console status
docker logs xiaozhi-esp32-server-web

# Restart web console
docker restart xiaozhi-esp32-server-web
```

---

## 📖 RAG Usage Tips

1. **Dataset Organization:**
   - Create separate datasets for different topics
   - Use clear naming conventions
   - Keep related documents together

2. **Document Preparation:**
   - Clean formatting before upload
   - Remove unnecessary headers/footers
   - Use clear section titles

3. **Chunk Settings:**
   - Larger chunks (1024+): Better context, slower search
   - Smaller chunks (256-512): Faster search, may miss context
   - Adjust overlap to prevent information loss

4. **Testing:**
   - Always test retrieval before deploying
   - Try edge case questions
   - Verify answer quality

5. **Performance:**
   - Regularly update knowledge base
   - Remove outdated documents
   - Monitor retrieval latency

---

## 🎯 Next Steps After Setup

1. **Configure ESP32 Device:**
   - Flash firmware with your server URLs
   - WebSocket: ws://172.31.224.1:8000/xiaozhi/v1/
   - OTA: http://172.31.224.1:8002/xiaozhi/ota/

2. **Test Voice Interaction:**
   - Use test tool: `main\xiaozhi-server\test\test_page.html`
   - Open in Chrome browser
   - Test audio recording and playback

3. **Upload Knowledge Documents:**
   - Start with a few test documents
   - Verify parsing and chunking
   - Test retrieval accuracy

4. **Monitor Performance:**
   - Check response times
   - Monitor token usage
   - Track API costs

---

## 📝 Configuration Files

### Main Config
`xiaozhi-server-full\data\.config.yaml`
- Manager API connection settings
- Vision API endpoint
- Must be edited to add server.secret

### Docker Compose
`xiaozhi-server-full\docker-compose_all.yml`
- Service definitions
- Port mappings
- Volume mounts

### Uploaded Files
`xiaozhi-server-full\uploadfile\`
- Documents uploaded via web console
- Images and other media files

### Database Data
`xiaozhi-server-full\mysql\data\`
- MySQL database files
- Backup this folder to preserve data

---

## 🎉 Success Indicators

✅ Web console accessible at http://localhost:8002
✅ All 4 containers running (check with `docker ps`)
✅ Database healthy and initialized
✅ Super admin account created
✅ Server.secret configured (after Step 2)
✅ Server shows "Component initialized" messages
✅ WebSocket connection working
✅ RAG configuration added
✅ Knowledge base created and documents uploaded

---

## 🆘 Getting Help

If you encounter issues:

1. Check this guide's troubleshooting section
2. View container logs for error messages
3. Verify all configuration values
4. Check the official docs: https://github.com/xinnan-tech/xiaozhi-esp32-server
5. Open issue: https://github.com/xinnan-tech/xiaozhi-esp32-server/issues

---

**Deployment completed:** 2025-11-29
**Deployment method:** Docker Full Module with RAG
**ASR Configuration:** OpenaiASR (API-based, no model download)
**Your Local IP:** 172.31.224.1

**Important:** Complete Steps 1-2 immediately to get the server running!
