# Weather Plugin Usage Guide

## Overview

The weather plugin `get_weather` is one of the core features of the Xiaozhi ESP32 voice assistant, supporting voice queries for weather information across the country. The plugin is based on the QWeather API and provides real-time weather and 7-day weather forecast functionality.

## API Key Application Guide

### 1. Register QWeather Account

1. Visit [QWeather Console](https://console.qweather.com/)
2. Register an account and complete email verification
3. Log in to the console

### 2. Create Application to Obtain API Key

1. After entering the console, click ["Project Management"](https://console.qweather.com/project?lang=zh) on the right → "Create Project"
2. Fill in project information:
   - **Project Name**: e.g., "Xiaozhi Voice Assistant"
3. Click Save
4. After the project is created, click "Create Credential" in that project
5. Fill in credential information:
    - **Credential Name**: e.g., "Xiaozhi Voice Assistant"
    - **Authentication Method**: Select "API Key"
6. Click Save
7. Copy the `API Key` in the credential. This is the first key configuration information

### 3. Obtain API Host

1. Click ["Settings"](https://console.qweather.com/setting?lang=zh) → "API Host" in the console
2. View your exclusive `API Host` address. This is the second key configuration information

The above operations will give you two important configuration information: `API Key` and `API Host`

## Configuration Method (Choose One)

### Method 1: If You Used Smart Console Deployment (Recommended)

1. Log in to Smart Console
2. Enter the "Role Configuration" page
3. Select the agent to configure
4. Click the "Edit Functions" button
5. Find the "Weather Query" plugin in the right parameter configuration area
6. Check "Weather Query"
7. Fill the first key configuration `API Key` you copied into `Weather Plugin API Key`
8. Fill the second key configuration `API Host` you copied into `Developer API Host`
9. Save the configuration, then save the agent configuration

### Method 2: If You Only Deployed the Single Module xiaozhi-server

Configure in `data/.config.yaml`:

1. Fill the first key configuration `API Key` you copied into `api_key`
2. Fill the second key configuration `API Host` you copied into `api_host`
3. Fill your city into `default_location`, e.g., `Guangzhou`

```yaml
plugins:
  get_weather:
    api_key: "Your QWeather API Key"
    api_host: "Your QWeather API Host Address"
    default_location: "Your Default Query City"
```
