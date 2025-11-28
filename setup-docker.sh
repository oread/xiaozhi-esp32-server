#!/bin/bash

# Xiaozhi ESP32 Server - Quick Setup Script
# This script automates the Docker setup process

set -e

echo "🚀 Xiaozhi ESP32 Server - Docker Setup"
echo "======================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed. Please install Docker first.${NC}"
    echo "Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose is not installed. Please install Docker Compose first.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Docker and Docker Compose are installed${NC}"
echo ""

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p data models/SenseVoiceSmall mysql/conf mysql/init uploadfile logs

echo -e "${GREEN}✅ Directories created${NC}"
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo "⚙️  Creating .env file from template..."
    cp .env.example .env
    echo -e "${YELLOW}⚠️  Please edit .env file and set your passwords${NC}"
else
    echo -e "${GREEN}✅ .env file already exists${NC}"
fi

# Check if model file exists
if [ ! -f models/SenseVoiceSmall/model.pt ]; then
    echo -e "${YELLOW}⚠️  Model file not found: models/SenseVoiceSmall/model.pt${NC}"
    echo ""
    echo "Please download the model file manually:"
    echo "1. Visit: https://www.modelscope.cn/models/iic/SenseVoiceSmall/files"
    echo "2. Download model.pt (~1GB)"
    echo "3. Place it in models/SenseVoiceSmall/model.pt"
    echo ""
    read -p "Press Enter when you have downloaded the model file..."
    
    if [ ! -f models/SenseVoiceSmall/model.pt ]; then
        echo -e "${RED}❌ Model file still not found. Exiting.${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✅ Model file found${NC}"
echo ""

# Check if config file exists
if [ ! -f data/.config.yaml ]; then
    echo "⚙️  Creating configuration file..."
    if [ -f main/xiaozhi-server/config.yaml ]; then
        cp main/xiaozhi-server/config.yaml data/.config.yaml
        echo -e "${YELLOW}⚠️  Please edit data/.config.yaml and configure your API keys${NC}"
    else
        echo -e "${RED}❌ Template config file not found${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✅ Configuration file already exists${NC}"
fi

echo ""
echo "🔨 Building Docker images..."
docker compose -f docker-compose.prod.yml build

echo ""
echo -e "${GREEN}✅ Docker images built successfully${NC}"
echo ""

# Ask if user wants to start services
read -p "Do you want to start the services now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Starting services..."
    docker compose -f docker-compose.prod.yml up -d
    
    echo ""
    echo -e "${GREEN}✅ Services started successfully!${NC}"
    echo ""
    echo "📊 Service URLs:"
    echo "  - Web Management Console: http://localhost:8002"
    echo "  - WebSocket Service: ws://localhost:8000"
    echo "  - HTTP/OTA Service: http://localhost:8003"
    echo ""
    echo "📝 View logs with:"
    echo "  docker compose -f docker-compose.prod.yml logs -f"
    echo ""
    echo "🔍 Check service status with:"
    echo "  docker compose -f docker-compose.prod.yml ps"
else
    echo ""
    echo "To start services later, run:"
    echo "  docker compose -f docker-compose.prod.yml up -d"
fi

echo ""
echo -e "${GREEN}✅ Setup complete!${NC}"
echo ""
echo "📚 For more information, see DOCKER_SETUP.md"
