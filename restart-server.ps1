# Quick Restart Script - After Configuring server.secret
# Run this after you've updated .config.yaml with server.secret from web console

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Restarting Xiaozhi Server" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$DeploymentDir = "c:\Users\SonNT\.github\Xiaozhi MCP\xiaozhi-esp32-server\xiaozhi-esp32-server\xiaozhi-server-full"
$ConfigFile = Join-Path $DeploymentDir "data\.config.yaml"

# Check if config file exists
if (-not (Test-Path $ConfigFile)) {
    Write-Host "Configuration file not found!" -ForegroundColor Red
    Write-Host "Expected: $ConfigFile" -ForegroundColor Yellow
    exit 1
}

# Check if server.secret has been configured
$configContent = Get-Content $ConfigFile -Raw
if ($configContent -match "secret:\s*你的server\.secret值") {
    Write-Host "WARNING: server.secret not configured yet!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please follow these steps:" -ForegroundColor Yellow
    Write-Host "1. Open http://localhost:8002" -ForegroundColor White
    Write-Host "2. Login as super admin" -ForegroundColor White
    Write-Host "3. Go to Parameter Management" -ForegroundColor White
    Write-Host "4. Find 'server.secret' and copy its value" -ForegroundColor White
    Write-Host "5. Edit: $ConfigFile" -ForegroundColor White
    Write-Host "6. Replace '你的server.secret值' with the copied UUID" -ForegroundColor White
    Write-Host "7. Save and run this script again" -ForegroundColor White
    Write-Host ""
    
    $openConfig = Read-Host "Open config file in notepad now? (y/n)"
    if ($openConfig -eq 'y') {
        notepad $ConfigFile
    }
    
    exit 1
}

Write-Host "Config file found and appears configured" -ForegroundColor Green
Write-Host ""

# Restart server
Write-Host "Restarting xiaozhi-esp32-server..." -ForegroundColor Yellow
docker restart xiaozhi-esp32-server

if ($LASTEXITCODE -eq 0) {
    Write-Host "Server restarted successfully!" -ForegroundColor Green
} else {
    Write-Host "Failed to restart server" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Waiting for server to initialize (30 seconds)..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

Write-Host ""
Write-Host "Checking server logs..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

docker logs xiaozhi-esp32-server 2>&1 | Select-Object -Last 30

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check for success indicators
$logs = docker logs xiaozhi-esp32-server 2>&1 | Out-String

if ($logs -match "Component initialized") {
    Write-Host "SUCCESS! Server is running properly" -ForegroundColor Green
    Write-Host ""
    Write-Host "Your services are ready:" -ForegroundColor Cyan
    Write-Host "  Web Console: http://localhost:8002" -ForegroundColor White
    Write-Host "  WebSocket:   ws://172.31.224.1:8000/xiaozhi/v1/" -ForegroundColor White
    Write-Host ""
    Write-Host "Next: Configure RAG in the web console!" -ForegroundColor Yellow
} elseif ($logs -match "Exception|Error|错误") {
    Write-Host "WARNING: Server started but there may be errors" -ForegroundColor Yellow
    Write-Host "Check the logs above for details" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "To view full logs:" -ForegroundColor White
    Write-Host "  docker logs -f xiaozhi-esp32-server" -ForegroundColor Cyan
} else {
    Write-Host "Server is starting... may need more time" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Monitor startup with:" -ForegroundColor White
    Write-Host "  docker logs -f xiaozhi-esp32-server" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "For complete guide, see: RAG_DEPLOYMENT_GUIDE.md" -ForegroundColor Cyan
Write-Host ""
