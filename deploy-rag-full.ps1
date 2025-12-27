# Xiaozhi ESP32 Server - Full Module Deployment with RAG Support
# This script automates the deployment of xiaozhi-esp32-server with RAG functionality

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Xiaozhi ESP32 Server - Full Module Deployment" -ForegroundColor Cyan
Write-Host "Includes: Server + Database + Redis + Web Console + RAG" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$ProjectRoot = $PSScriptRoot
$DeploymentDir = Join-Path $ProjectRoot "xiaozhi-server-full"
$MainDir = Join-Path $ProjectRoot "main\xiaozhi-server"

Write-Host "[1/8] Checking prerequisites..." -ForegroundColor Yellow

# Check if Docker is installed
try {
    $dockerVersion = docker --version
    Write-Host "Docker found: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "Docker is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Docker Desktop from: https://www.docker.com/products/docker-desktop" -ForegroundColor Red
    exit 1
}

# Check if docker-compose is available
try {
    docker compose version | Out-Null
    Write-Host "Docker Compose available" -ForegroundColor Green
} catch {
    Write-Host "Docker Compose is not available" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[2/8] Creating deployment directory structure..." -ForegroundColor Yellow

# Create deployment directory
if (Test-Path $DeploymentDir) {
    Write-Host "Deployment directory already exists: $DeploymentDir" -ForegroundColor Yellow
    $response = Read-Host "Do you want to remove it and start fresh? (y/n)"
    if ($response -eq 'y') {
        Remove-Item -Path $DeploymentDir -Recurse -Force
        Write-Host "Removed existing deployment directory" -ForegroundColor Green
    } else {
        Write-Host "Using existing deployment directory" -ForegroundColor Yellow
    }
}

# Create directory structure
New-Item -ItemType Directory -Path $DeploymentDir -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $DeploymentDir "data") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $DeploymentDir "models\SenseVoiceSmall") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $DeploymentDir "mysql\data") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $DeploymentDir "uploadfile") -Force | Out-Null

Write-Host "Directory structure created" -ForegroundColor Green

Write-Host ""
Write-Host "[3/8] Copying configuration files..." -ForegroundColor Yellow

# Copy docker-compose file
$dockerComposeSource = Join-Path $MainDir "docker-compose_all.yml"
$dockerComposeDest = Join-Path $DeploymentDir "docker-compose_all.yml"

if (Test-Path $dockerComposeSource) {
    Copy-Item -Path $dockerComposeSource -Destination $dockerComposeDest -Force
    Write-Host "Copied docker-compose_all.yml" -ForegroundColor Green
} else {
    Write-Host "docker-compose_all.yml not found at: $dockerComposeSource" -ForegroundColor Red
    exit 1
}

# Copy and configure config file
$configSource = Join-Path $MainDir "config_from_api.yaml"
$configDest = Join-Path $DeploymentDir "data\.config.yaml"

if (Test-Path $configSource) {
    Copy-Item -Path $configSource -Destination $configDest -Force
    
    # Update the config file for Docker deployment
    $configContent = Get-Content $configDest -Raw
    $configContent = $configContent -replace 'url:\s*http://127\.0\.0\.1:8002/xiaozhi', 'url: http://xiaozhi-esp32-server-web:8002/xiaozhi'
    $configContent = $configContent -replace 'vision_explain:\s*http://你的ip或者域名:端口号/mcp/vision/explain', 'vision_explain: http://host.docker.internal:8003/mcp/vision/explain'
    Set-Content -Path $configDest -Value $configContent -NoNewline
    
    Write-Host "Created .config.yaml (manager-api URL configured for Docker)" -ForegroundColor Green
} else {
    Write-Host "config_from_api.yaml not found at: $configSource" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[4/8] Checking ASR model configuration..." -ForegroundColor Yellow

# Ask about ASR model
Write-Host ""
Write-Host "ASR (Speech Recognition) Options:" -ForegroundColor Cyan
Write-Host "1. OpenaiASR - Uses OpenAI API (no model download, 2GB RAM, costs money)" -ForegroundColor White
Write-Host "2. FunASR - Local model (requires 1.5GB download, 4GB RAM, offline)" -ForegroundColor White
Write-Host ""

$asrChoice = Read-Host "Select ASR option (1 or 2, default: 1)"
if ([string]::IsNullOrWhiteSpace($asrChoice)) { $asrChoice = "1" }

if ($asrChoice -eq "2") {
    Write-Host ""
    Write-Host "FunASR requires downloading SenseVoiceSmall model" -ForegroundColor Yellow
    Write-Host "Download from:" -ForegroundColor White
    Write-Host "  Option 1: https://modelscope.cn/models/iic/SenseVoiceSmall/resolve/master/model.pt" -ForegroundColor White
    Write-Host "  Option 2: Baidu Pan - https://pan.baidu.com/share/init?surl=QlgM58FHhYv1tFnUT_A8Sg&pwd=qvna" -ForegroundColor White
    Write-Host ""
    Write-Host "After downloading, place model.pt in: $DeploymentDir\models\SenseVoiceSmall\" -ForegroundColor Yellow
    Write-Host ""
    
    $modelPath = Join-Path $DeploymentDir "models\SenseVoiceSmall\model.pt"
    if (Test-Path $modelPath) {
        Write-Host "FunASR model found" -ForegroundColor Green
    } else {
        Write-Host "Model file not found. You'll need to download it before starting." -ForegroundColor Yellow
        Read-Host "Press Enter to continue..."
    }
} else {
    Write-Host "Using OpenaiASR (no model download needed)" -ForegroundColor Green
    Write-Host "Note: Make sure you have OpenAI API key configured in the web console" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[5/8] Stopping existing containers (if any)..." -ForegroundColor Yellow

# Stop and remove existing containers
Set-Location $DeploymentDir

docker compose -f docker-compose_all.yml down 2>$null | Out-Null
docker stop xiaozhi-esp32-server 2>$null | Out-Null
docker rm xiaozhi-esp32-server 2>$null | Out-Null
docker stop xiaozhi-esp32-server-web 2>$null | Out-Null
docker rm xiaozhi-esp32-server-web 2>$null | Out-Null
docker stop xiaozhi-esp32-server-db 2>$null | Out-Null
docker rm xiaozhi-esp32-server-db 2>$null | Out-Null
docker stop xiaozhi-esp32-server-redis 2>$null | Out-Null
docker rm xiaozhi-esp32-server-redis 2>$null | Out-Null

Write-Host "Cleaned up existing containers" -ForegroundColor Green

Write-Host ""
Write-Host "[6/8] Starting Docker containers..." -ForegroundColor Yellow
Write-Host "This will start: MySQL, Redis, Web Console, and Server" -ForegroundColor White
Write-Host ""

# Start containers
docker compose -f docker-compose_all.yml up -d

if ($LASTEXITCODE -eq 0) {
    Write-Host "Docker containers started successfully" -ForegroundColor Green
} else {
    Write-Host "Failed to start Docker containers" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[7/8] Waiting for services to initialize..." -ForegroundColor Yellow

# Wait for web console to be ready
$maxWaitTime = 120
$waitInterval = 5
$elapsedTime = 0

Write-Host "Waiting for Web Console to start (may take 30-60 seconds)..." -ForegroundColor White

while ($elapsedTime -lt $maxWaitTime) {
    $logs = docker logs xiaozhi-esp32-server-web 2>&1
    if ($logs -match "Started AdminApplication") {
        Write-Host "Web Console is ready!" -ForegroundColor Green
        break
    }
    
    Start-Sleep -Seconds $waitInterval
    $elapsedTime += $waitInterval
    Write-Host "." -NoNewline
}

Write-Host ""

if ($elapsedTime -ge $maxWaitTime) {
    Write-Host "Web Console startup timeout. Check logs: docker logs xiaozhi-esp32-server-web" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[8/8] Deployment Summary" -ForegroundColor Yellow
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# Get local IP
try {
    $localIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notlike "*Loopback*" -and $_.IPAddress -notlike "169.254.*" } | Select-Object -First 1).IPAddress
} catch {
    $localIP = "YOUR_LOCAL_IP"
}

Write-Host "Deployment completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Services:" -ForegroundColor Cyan
Write-Host "  Web Console:        http://localhost:8002" -ForegroundColor White
Write-Host "  Web Console (LAN):  http://$localIP:8002" -ForegroundColor White
Write-Host "  WebSocket Server:   ws://localhost:8000/xiaozhi/v1/" -ForegroundColor White
Write-Host "  WebSocket (LAN):    ws://$localIP:8000/xiaozhi/v1/" -ForegroundColor White
Write-Host "  OTA Endpoint:       http://localhost:8002/xiaozhi/ota/" -ForegroundColor White
Write-Host "  Vision API:         http://localhost:8003/mcp/vision/explain" -ForegroundColor White
Write-Host ""
Write-Host "Database:" -ForegroundColor Cyan
Write-Host "  MySQL:     xiaozhi-esp32-server-db:3306" -ForegroundColor White
Write-Host "  Database:  xiaozhi_esp32_server" -ForegroundColor White
Write-Host "  Username:  root" -ForegroundColor White
Write-Host "  Password:  123456" -ForegroundColor White
Write-Host "  Redis:     xiaozhi-esp32-server-redis:6379" -ForegroundColor White
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Register First User (Super Admin)" -ForegroundColor Yellow
Write-Host "   -> Open: http://localhost:8002" -ForegroundColor White
Write-Host "   -> Register the first account (becomes super admin)" -ForegroundColor White
Write-Host ""

Write-Host "2. Configure server.secret" -ForegroundColor Yellow
Write-Host "   -> Login to Web Console" -ForegroundColor White
Write-Host "   -> Go to: Parameter Management" -ForegroundColor White
Write-Host "   -> Find: server.secret" -ForegroundColor White
Write-Host "   -> Copy the Parameter Value" -ForegroundColor White
Write-Host "   -> Edit: $configDest" -ForegroundColor White
Write-Host "   -> Paste the secret value" -ForegroundColor White
Write-Host "   -> The URL should already be: http://xiaozhi-esp32-server-web:8002/xiaozhi" -ForegroundColor White
Write-Host ""

Write-Host "3. Configure AI Models" -ForegroundColor Yellow
Write-Host "   -> Go to: Model Configuration" -ForegroundColor White
Write-Host "   -> Configure LLM (e.g., ChatGLM with your API key)" -ForegroundColor White
Write-Host "   -> Configure ASR (OpenaiASR or FunASR)" -ForegroundColor White
Write-Host "   -> Configure TTS (OpenAITTS or other)" -ForegroundColor White
Write-Host "   -> Configure VLLM for vision (optional)" -ForegroundColor White
Write-Host ""

Write-Host "4. Configure RAG (Knowledge Base)" -ForegroundColor Yellow
Write-Host "   -> Go to: Knowledge Base section" -ForegroundColor White
Write-Host "   -> Add RAG Configuration:" -ForegroundColor White
Write-Host "     - base_url: Your RAGFlow API endpoint" -ForegroundColor White
Write-Host "     - api_key: Your RAGFlow API key" -ForegroundColor White
Write-Host "     - adapter_type: ragflow" -ForegroundColor White
Write-Host "   -> Create datasets and upload documents" -ForegroundColor White
Write-Host ""

Write-Host "5. Restart Server" -ForegroundColor Yellow
Write-Host "   -> Run: docker restart xiaozhi-esp32-server" -ForegroundColor White
Write-Host "   -> Check logs: docker logs -f xiaozhi-esp32-server" -ForegroundColor White
Write-Host ""

Write-Host "6. Configure Endpoints in Web Console" -ForegroundColor Yellow
Write-Host "   -> Go to: Parameter Management" -ForegroundColor White
Write-Host "   -> Set server.websocket: ws://$localIP:8000/xiaozhi/v1/" -ForegroundColor White
Write-Host "   -> Set server.ota: http://$localIP:8002/xiaozhi/ota/" -ForegroundColor White
Write-Host ""

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Useful Commands:" -ForegroundColor Cyan
Write-Host "  View logs:           docker logs -f xiaozhi-esp32-server" -ForegroundColor White
Write-Host "  View web logs:       docker logs -f xiaozhi-esp32-server-web" -ForegroundColor White
Write-Host "  Restart server:      docker restart xiaozhi-esp32-server" -ForegroundColor White
Write-Host "  Stop all:            docker compose -f docker-compose_all.yml down" -ForegroundColor White
Write-Host "  Start all:           docker compose -f docker-compose_all.yml up -d" -ForegroundColor White
Write-Host ""
Write-Host "Deployment directory: $DeploymentDir" -ForegroundColor White
Write-Host ""

# Ask if user wants to open web console
$openBrowser = Read-Host "Open Web Console in browser now? (y/n)"
if ($openBrowser -eq 'y') {
    Start-Process "http://localhost:8002"
}

Write-Host ""
Write-Host "Setup complete! Follow the Next Steps above." -ForegroundColor Green
Write-Host ""
