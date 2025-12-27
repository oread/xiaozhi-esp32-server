@echo off
REM Xiaozhi ESP32 Server - Local Docker Setup Script (Windows)
REM This script automates the setup process for local Docker deployment

setlocal enabledelayedexpansion
color 0A

echo.
echo ============================================
echo  Xiaozhi ESP32 Server - Docker Setup
echo ============================================
echo.

REM Check if Docker is installed
echo [1/5] Checking Docker installation...
docker --version >nul 2>&1
if errorlevel 1 (
    echo.
    echo ERROR: Docker is not installed or not in PATH
    echo Please install Docker Desktop from: https://www.docker.com/products/docker-desktop
    echo.
    pause
    exit /b 1
)
echo OK: Docker found
echo.

REM Check if Docker Compose is available
echo [2/5] Checking Docker Compose...
docker compose version >nul 2>&1
if errorlevel 1 (
    echo.
    echo ERROR: Docker Compose is not installed
    echo Please ensure Docker Desktop includes Docker Compose (v2.x or later)
    echo.
    pause
    exit /b 1
)
echo OK: Docker Compose found
echo.

REM Create directory structure
echo [3/5] Creating directory structure...
mkdir data 2>nul
mkdir models\SenseVoiceSmall 2>nul
mkdir mysql\conf 2>nul
mkdir mysql\init 2>nul
mkdir uploadfile 2>nul
mkdir logs 2>nul
echo OK: Directories created
echo.

REM Check if .env exists, if not copy from example
echo [4/5] Checking environment configuration...
if not exist ".env" (
    if exist ".env.example" (
        copy .env.example .env >nul
        echo OK: Created .env from template
    ) else (
        echo WARNING: .env.example not found, skipping .env creation
    )
) else (
    echo OK: .env already exists
)
echo.

REM Check if config.yaml exists in data folder
echo [5/5] Checking application configuration...
if not exist "data\.config.yaml" (
    if exist "main\xiaozhi-server\config.yaml" (
        copy "main\xiaozhi-server\config.yaml" "data\.config.yaml" >nul
        echo OK: Created .config.yaml in data folder
    ) else (
        echo WARNING: config.yaml template not found
    )
) else (
    echo OK: .config.yaml already exists
)
echo.

echo ============================================
echo  Setup Complete!
echo ============================================
echo.
echo Next steps:
echo.
echo 1. Download the SenseVoiceSmall model (~1GB):
echo    - Visit: https://www.modelscope.cn/models/iic/SenseVoiceSmall/files
echo    - Download model.pt to: models\SenseVoiceSmall\model.pt
echo.
echo 2. (Optional) Edit configuration files:
echo    - .env - Environment variables
echo    - data\.config.yaml - Application settings
echo.
echo 3. Start Docker containers:
echo    Option A - Simplified (Server only):
echo      docker compose -f main\xiaozhi-server\docker-compose.yml up -d
echo.
echo    Option B - Full (Server + Web + Database):
echo      docker compose -f docker-compose.prod.yml up -d
echo.
echo 4. Check status:
echo    docker ps
echo    docker logs -f xiaozhi-esp32-server
echo.
echo 5. Access services:
echo    WebSocket: ws://localhost:8000
echo    HTTP API: http://localhost:8003
echo    Health: http://localhost:8003/health
echo    Web Console (full only): http://localhost:8002
echo.
echo For detailed instructions, see: LOCAL_DOCKER_SETUP.md
echo.
pause
