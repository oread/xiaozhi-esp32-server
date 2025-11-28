# Local Docker Image Compilation Method

This project now uses GitHub's automatic docker compilation feature. This document is provided for friends who need to compile docker images locally.

1. Install docker
```
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
2. Compile docker image
```
# Enter the project root directory
# Compile server
docker build -t xiaozhi-esp32-server:server_latest -f ./Dockerfile-server .
# Compile web
docker build -t xiaozhi-esp32-server:web_latest -f ./Dockerfile-web .

# After compilation, you can use docker-compose to start the project
# You need to modify docker-compose.yml to your own compiled image version
cd main/xiaozhi-server
docker-compose up -d
```
