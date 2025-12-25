# Xiaozhi ESP32 Server - Docker Setup
param([switch]$ModelDownload,[switch]$StartServer,[switch]$StartFull,[switch]$CheckStatus,[switch]$StopAll)
$ErrorActionPreference = "Continue"
function Write-Success { Write-Host "[OK] $($args[0])" -ForegroundColor Green }
function Write-Warning { Write-Host "[!] $($args[0])" -ForegroundColor Yellow }
function WriteErr { Write-Host "[ERROR] $($args[0])" -ForegroundColor Red }
function Write-Header { Write-Host "`n=== $($args[0]) ===" -ForegroundColor Cyan }

function Check-Docker {
    Write-Header "Checking Docker"
    try {
        docker --version | Out-Null
        Write-Success "Docker found"
        docker compose version | Out-Null
        Write-Success "Docker Compose found"
        return $true
    } catch {
        WriteErr "Docker not found. Install from https://www.docker.com/products/docker-desktop"
        return $false
    }
}

function Setup-Directories {
    Write-Header "Creating Directories"
    $dirs = @("data", "models/SenseVoiceSmall", "mysql/conf", "mysql/init", "uploadfile", "logs")
    foreach ($dir in $dirs) {
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
    }
    Write-Success "Directories created"
}

function Setup-Config {
    Write-Header "Setting Up Configuration"
    if (-not (Test-Path ".env")) {
        if (Test-Path ".env.example") {
            Copy-Item ".env.example" ".env"
            Write-Success "Created .env"
        }
    } else {
        Write-Success ".env already exists"
    }
    
    if (-not (Test-Path "data\.config.yaml")) {
        if (Test-Path "main\xiaozhi-server\config.yaml") {
            Copy-Item "main\xiaozhi-server\config.yaml" "data\.config.yaml"
            Write-Success "Created .config.yaml"
        }
    } else {
        Write-Success ".config.yaml already exists"
    }
}

function Download-Model {
    Write-Header "Downloading Model"
    $modelPath = "models\SenseVoiceSmall\model.pt"
    if (Test-Path $modelPath) {
        Write-Warning "Model already exists"
        return
    }
    
    $url = "https://www.modelscope.cn/models/iic/SenseVoiceSmall/resolve/master/model.pt"
    Write-Host "Downloading (~1GB, may take 10-30 min)..." -ForegroundColor Blue
    try {
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $url -OutFile $modelPath -UseBasicParsing
        Write-Success "Model downloaded"
    } catch {
        WriteErr "Download failed. Download manually from modelscope website"
    }
}

function Start-Server {
    Write-Header "Starting Server (Simplified)"
    docker compose -f main\xiaozhi-server\docker-compose.yml up -d
    Write-Success "Server started"
    Write-Host "WebSocket: ws://localhost:8000" -ForegroundColor Green
    Write-Host "HTTP: http://localhost:8003" -ForegroundColor Green
}

function Start-Full {
    Write-Header "Starting Full Deployment"
    docker compose -f docker-compose.prod.yml up -d
    Write-Success "Services started"
    Write-Host "WebSocket: ws://localhost:8000" -ForegroundColor Green
    Write-Host "HTTP: http://localhost:8003" -ForegroundColor Green
    Write-Host "Web Console: http://localhost:8002" -ForegroundColor Green
}

function Check-Status {
    Write-Header "Docker Status"
    Write-Host "Running containers:" -ForegroundColor Blue
    docker ps --format "table {{.Names}}`t{{.Status}}`t{{.Ports}}"
    Write-Host "`nRecent logs:" -ForegroundColor Blue
    docker logs --tail 10 xiaozhi-esp32-server 2>$null
}

function Stop-All {
    Write-Header "Stopping Containers"
    Write-Host "Stop 1=simple, 2=full:" -NoNewline
    $choice = Read-Host " "
    if ($choice -eq "1") {
        docker compose -f main\xiaozhi-server\docker-compose.yml down
    } elseif ($choice -eq "2") {
        docker compose -f docker-compose.prod.yml down
    }
    Write-Success "Stopped"
}

if (-not (Check-Docker)) { exit 1 }
Setup-Directories
Setup-Config

if ($ModelDownload) { Download-Model }
if ($StartServer) { Start-Server }
if ($StartFull) { Start-Full }
if ($CheckStatus) { Check-Status }
if ($StopAll) { Stop-All }

if (-not ($ModelDownload -or $StartServer -or $StartFull -or $CheckStatus -or $StopAll)) {
    Write-Header "Setup Complete"
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. Download model: .\setup-docker.ps1 -ModelDownload"
    Write-Host "2. Start server:   .\setup-docker.ps1 -StartServer"
    Write-Host "3. Check status:   .\setup-docker.ps1 -CheckStatus"
}
