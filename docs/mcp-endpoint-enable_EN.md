# MCP Endpoint Deployment and Usage Guide

This tutorial has 3 parts:
- 1) How to deploy the MCP Endpoint service
- 2) How to configure the MCP Endpoint in a full-module deployment
- 3) How to configure the MCP Endpoint in a single-module deployment

# 1) How to deploy the MCP Endpoint service

## Step 1: Download the MCP Endpoint project source code

Open the MCP Endpoint project on GitHub: https://github.com/oread/mcp-endpoint-server

On the page, find the green `Code` button, click it, then choose `Download ZIP`.

Download the ZIP file to your computer and unzip it. The folder name may be `mcp-endpoint-server-main`. Please rename it to `mcp-endpoint-server`.

## Step 2: Start the program
This project is simple and recommended to run with Docker. If you prefer to run from source, follow: https://github.com/oread/mcp-endpoint-server/blob/main/README_dev.md

Run with Docker:

```
# Enter the project root directory
cd mcp-endpoint-server

# Clean caches
docker compose -f docker-compose.yml down
docker stop mcp-endpoint-server
docker rm mcp-endpoint-server
docker rmi ghcr.nju.edu.cn/xinnan-tech/mcp-endpoint-server:latest

# Start the Docker container
docker compose -f docker-compose.yml up -d
# Tail logs
docker logs -f mcp-endpoint-server
```

You should see logs similar to:
```
250705 INFO-===== Below are the Console/Single-Module MCP endpoint addresses =====
250705 INFO-Console MCP config: http://172.22.0.2:8004/mcp_endpoint/health?key=abc
250705 INFO-Single-module MCP endpoint: ws://172.22.0.2:8004/mcp_endpoint/mcp/?token=def
250705 INFO-===== Choose based on your deployment; DO NOT share with anyone =====
```

Please copy the two interface addresses.

Important: because you are deploying with Docker, DO NOT use the container IP addresses directly!

Repeat: DO NOT use the container IP addresses directly!

Once again: DO NOT use the container IP addresses directly!

Copy the addresses to a note, then replace the container IP with your computer's LAN IP. For example, if your PC LAN IP is `192.168.1.25`, then change:
```
Console MCP config: http://172.22.0.2:8004/mcp_endpoint/health?key=abc
Single-module MCP endpoint: ws://172.22.0.2:8004/mcp_endpoint/mcp/?token=def
```
To:
```
Console MCP config: http://192.168.1.25:8004/mcp_endpoint/health?key=abc
Single-module MCP endpoint: ws://192.168.1.25:8004/mcp_endpoint/mcp/?token=def
```

After updating, open the `Console MCP config` URL directly in your browser. If you see a response like this, it is working:
```
{"result":{"status":"success","connections":{"tool_connections":0,"robot_connections":0,"total_connections":0}},"error":null,"id":null,"jsonrpc":"2.0"}
```

Keep these two interface addresses. You will need them in the next steps.

# 2) Configure MCP Endpoint in a full-module deployment

If you deploy all modules, log in to the Console using an admin account. Click `Parameter Dictionary` at the top and select `Parameter Management`.

Search for the parameter `server.mcp_endpoint`. Its value should currently be `null`.
Click the edit button and paste the `Console MCP config` URL from Step 1 into the `parameter value` field, then save.

If it saves successfully, everything is ready. You can now check the Agent behavior. If saving fails, the Console likely cannot reach the MCP endpoint—most commonly due to firewall rules or using the wrong LAN IP.

# 3) Configure MCP Endpoint in a single-module deployment

If you deploy a single module, locate your configuration file at `data/.config.yaml`.
Search for `mcp_endpoint`. If it doesn't exist, add it. For example:
```
server:
  websocket: ws://your-ip-or-domain:port/xiaozhi/v1/
  http_port: 8002
log:
  log_level: INFO

# There may be more config items here...

mcp_endpoint: your MCP endpoint websocket address
```
Now paste the `Single-module MCP endpoint` from Step 1 into `mcp_endpoint`, e.g.:
```
server:
  websocket: ws://your-ip-or-domain:port/xiaozhi/v1/
  http_port: 8002
log:
  log_level: INFO

# More config items...

mcp_endpoint: ws://192.168.1.25:8004/mcp_endpoint/mcp/?token=def
```

After configuring, start the single module; you should see logs like:
```
250705[__main__]-INFO-Initialize component: vad OK SileroVAD
250705[__main__]-INFO-Initialize component: asr OK FunASRServer
250705[__main__]-INFO-OTA endpoint:          http://192.168.1.25:8002/xiaozhi/ota/
250705[__main__]-INFO-Vision analysis:       http://192.168.1.25:8002/mcp/vision/explain
250705[__main__]-INFO-MCP endpoint:          ws://192.168.1.25:8004/mcp_endpoint/mcp/?token=abc
250705[__main__]-INFO-WebSocket address:     ws://192.168.1.25:8000/xiaozhi/v1/
250705[__main__]-INFO-======= Above are WebSocket addresses; DO NOT open in browser =======
250705[__main__]-INFO-For testing WebSocket, open test/test_page.html in Chrome
250705[__main__]-INFO-=============================================================
```

If you see a line like `MCP endpoint: ws://192.168.1.25:8004/mcp_endpoint/mcp/?token=abc`, the configuration is successful.
