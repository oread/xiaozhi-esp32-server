@echo off
setlocal enabledelayedexpansion

REM Xiaozhi ESP32 Server - Quick Setup Script for Windows
REM This script automates the Docker setup process

echo ========================================
echo Xiaozhi ESP32 Server - Docker Setup
echo ========================================
echo.

REM Check if Docker is installed
docker --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker is not installed. Please install Docker Desktop first.
    echo Visit: https://docs.docker.com/desktop/install/windows-install/
    pause
    exit /b 1
)

REM Check if Docker Compose is available
docker compose version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker Compose is not available. Please update Docker Desktop.
    pause
    exit /b 1
)

echo [OK] Docker and Docker Compose are installed
echo.

REM Create directory structure
echo Creating directory structure...
if not exist "data" mkdir data
if not exist "models\SenseVoiceSmall" mkdir models\SenseVoiceSmall
if not exist "mysql\conf" mkdir mysql\conf
if not exist "mysql\init" mkdir mysql\init
if not exist "uploadfile" mkdir uploadfile
if not exist "logs" mkdir logs

echo [OK] Directories created
echo.

REM Check if .env exists
if not exist ".env" (
    echo Creating .env file from template...
    copy .env.example .env >nul
    echo [WARNING] Please edit .env file and set your passwords
) else (
    echo [OK] .env file already exists
)

REM Check if model file exists
if not exist "models\SenseVoiceSmall\model.pt" (
    echo [WARNING] Model file not found: models\SenseVoiceSmall\model.pt
    echo.
    echo Please download the model file manually:
    echo 1. Visit: https://www.modelscope.cn/models/iic/SenseVoiceSmall/files
    echo 2. Download model.pt (approx 1GB)
    echo 3. Place it in models\SenseVoiceSmall\model.pt
    echo.
    pause
    
    if not exist "models\SenseVoiceSmall\model.pt" (
        echo [ERROR] Model file still not found. Exiting.
        pause
        exit /b 1
    )
)

echo [OK] Model file found
echo.

REM Check if config file exists
if not exist "data\.config.yaml" (
    echo Creating configuration file...
    if exist "main\xiaozhi-server\config.yaml" (
        copy main\xiaozhi-server\config.yaml data\.config.yaml >nul
        echo [WARNING] Please edit data\.config.yaml and configure your API keys
    ) else (
        echo [ERROR] Template config file not found
        pause
        exit /b 1
    )
) else (
    echo [OK] Configuration file already exists
)

echo.
echo Building Docker images...
docker compose -f docker-compose.prod.yml build

if errorlevel 1 (
    echo [ERROR] Failed to build Docker images
    pause
    exit /b 1
)

echo.
echo [OK] Docker images built successfully
echo.

REM Ask if user wants to start services
set /p START="Do you want to start the services now? (Y/N): "
if /i "%START%"=="Y" (
    echo Starting services...
    docker compose -f docker-compose.prod.yml up -d
    
    echo.
    echo [OK] Services started successfully!
    echo.
    echo Service URLs:
    echo   - Web Management Console: http://localhost:8002
    echo   - WebSocket Service: ws://localhost:8000
    echo   - HTTP/OTA Service: http://localhost:8003
    echo.
    echo View logs with:
    echo   docker compose -f docker-compose.prod.yml logs -f
    echo.
    echo Check service status with:
    echo   docker compose -f docker-compose.prod.yml ps
) else (
    echo.
    echo To start services later, run:
    echo   docker compose -f docker-compose.prod.yml up -d
)

echo.
echo [OK] Setup complete!
echo.
echo For more information, see DOCKER_SETUP.md
echo.
pause
