# Voiceprint Recognition Activation Guide

This tutorial contains 3 parts:
- 1. How to deploy the voiceprint recognition service
- 2. How to configure voiceprint recognition interface for full module deployment
- 3. How to configure voiceprint recognition for minimal deployment

# 1. How to Deploy the Voiceprint Recognition Service

## Step 1: Download the Voiceprint Recognition Project Source Code

Open [Voiceprint Recognition Project Address](https://github.com/xinnan-tech/voiceprint-api) in your browser.

After opening, find a green button labeled `Code`, click on it, and then you will see the `Download ZIP` button.

Click it to download the project source code archive. After downloading to your computer, extract it. At this point, it may be named `voiceprint-api-main`, and you need to rename it to `voiceprint-api`.

## Step 2: Create Database and Tables

Voiceprint recognition requires a `mysql` database. If you have already deployed the `Smart Console`, it means you have already installed `mysql`. You can share it.

You can try using the `telnet` command on the host machine to see if you can normally access the `mysql` `3306` port.
```
telnet 127.0.0.1 3306
```
If you can access port 3306, please ignore the following content and proceed directly to Step 3.

If you cannot access it, you need to recall how your `mysql` was installed.

If your mysql was installed using an installation package yourself, it means your `mysql` has network isolation. You may need to solve the problem of accessing mysql's `3306` port first.

If your `mysql` was installed through this project's `docker-compose_all.yml`, you need to find the `docker-compose_all.yml` file you used to create the database and modify the following content:

Before modification:
```
  xiaozhi-esp32-server-db:
    ...
    networks:
      - default
    expose:
      - "3306:3306"
```

After modification:
```
  xiaozhi-esp32-server-db:
    ...
    networks:
      - default
    ports:
      - "3306:3306"
```

Note that you need to change `expose` under `xiaozhi-esp32-server-db` to `ports`. After the change, you need to restart. The following are commands to restart mysql:

```
# Enter the folder where docker-compose_all.yml is located, for example mine is xiaozhi-server
cd xiaozhi-server
docker compose -f docker-compose_all.yml down
docker compose -f docker-compose.yml up -d
```

After startup, use the `telnet` command on the host machine again to see if you can normally access mysql's `3306` port.
```
telnet 127.0.0.1 3306
```
Normally, you should be able to access it now.

## Step 3: Create Database and Tables
If your host machine can normally access the mysql database, then create a database named `voiceprint_db` and a `voiceprints` table in mysql.

```
CREATE DATABASE voiceprint_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE voiceprint_db;

CREATE TABLE voiceprints (
    id INT AUTO_INCREMENT PRIMARY KEY,
    speaker_id VARCHAR(255) NOT NULL UNIQUE,
    feature_vector LONGBLOB NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_speaker_id (speaker_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

## Step 4: Configure Database Connection

Enter the `voiceprint-api` folder and create a folder named `data`.

Copy `voiceprint.yaml` from the root directory of `voiceprint-api` to the `data` folder and rename it to `.voiceprint.yaml`

Next, you need to focus on configuring the database connection in `.voiceprint.yaml`.

```
mysql:
  host: "127.0.0.1"
  port: 3306
  user: "root"
  password: "your_password"
  database: "voiceprint_db"
```

Note! Since your voiceprint recognition service is deployed using docker, `host` needs to be filled with the `LAN IP of the machine where mysql is located`.

Note! Since your voiceprint recognition service is deployed using docker, `host` needs to be filled with the `LAN IP of the machine where mysql is located`.

Note! Since your voiceprint recognition service is deployed using docker, `host` needs to be filled with the `LAN IP of the machine where mysql is located`.

## Step 5: Start the Program
This project is a very simple project, it is recommended to run it with docker. However, if you don't want to run it with docker, you can refer to [this page](https://github.com/xinnan-tech/voiceprint-api/blob/main/README.md) to run it from source code. The following is the docker running method:

```
# Enter the project source code root directory
cd voiceprint-api

# Clear cache
docker compose -f docker-compose.yml down
docker stop voiceprint-api
docker rm voiceprint-api
docker rmi ghcr.nju.edu.cn/xinnan-tech/voiceprint-api:latest

# Start docker container
docker compose -f docker-compose.yml up -d
# View logs
docker logs -f voiceprint-api
```

At this point, the logs will output logs similar to the following:
```
250711 INFO-🚀 Start: Production environment service startup (Uvicorn), listening address: 0.0.0.0:8005
250711 INFO-============================================================
250711 INFO-Voiceprint API address: http://127.0.0.1:8005/voiceprint/health?key=abcd
250711 INFO-============================================================
```

Please copy the voiceprint API address:

Since you are deploying with docker, do not directly use the above address!

Since you are deploying with docker, do not directly use the above address!

Since you are deploying with docker, do not directly use the above address!

First copy the address and put it in a draft. You need to know what your computer's LAN IP is. For example, my computer's LAN IP is `192.168.1.25`, then
my original API address
```
http://127.0.0.1:8005/voiceprint/health?key=abcd

```
should be changed to
```
http://192.168.1.25:8005/voiceprint/health?key=abcd
```

After the modification, please use a browser to directly access the `voiceprint API address`. When the browser shows code similar to this, it means success.
```
{"total_voiceprints":0,"status":"healthy"}
```

Please keep the modified `voiceprint API address`, it will be used in the next step.

# 2. How to Configure Voiceprint Recognition for Full Module Deployment

## Step 1: Configure API
If you are doing full module deployment, use the administrator account to log in to the Smart Console, click `Parameter Dictionary` at the top, and select the `Parameter Management` function.

Then search for parameter `server.voice_print`. At this point, its value should be `null`.
Click the Modify button and paste the `voiceprint API address` obtained in the previous step into the `Parameter Value`. Then save.

If it can be saved successfully, it means everything went smoothly, and you can go to the agent to see the effect. If it fails, it means the Smart Console cannot access voiceprint recognition. It is very likely a network firewall issue, or the correct LAN IP was not filled in.

## Step 2: Set Agent Memory Mode

Enter your agent's role configuration and set the memory to `Local Short-term Memory`, and make sure to enable `Upload Text + Voice`.

## Step 3: Chat with Your Agent

Power on your device and chat with it using normal speech speed and tone.

## Step 4: Set Voiceprint

In the Smart Console, on the `Agent Management` page, there is a `Voiceprint Recognition` button on the agent panel. Click it. There is an `Add button` at the bottom. You can register voiceprints for what a certain person said.
In the pop-up box, it is recommended to fill in the `Description` attribute, which can include this person's occupation, personality, and hobbies. This facilitates the agent's analysis and understanding of the speaker.

## Step 5: Chat with Your Agent Again

Power on your device and ask it, "Do you know who I am?" If it can answer, it means the voiceprint recognition function is working properly.

# 3. How to Configure Voiceprint Recognition for Minimal Deployment

## Step 1: Configure API
Open the `xiaozhi-server/data/.config.yaml` file (create it if it doesn't exist), then add/modify the following content:

```
# Voiceprint recognition configuration
voiceprint:
  # Voiceprint API address
  url: your_voiceprint_API_address
  # Speaker configuration: speaker_id,name,description
  speakers:
    - "test1,Zhang San,Zhang San is a programmer"
    - "test2,Li Si,Li Si is a product manager"
    - "test3,Wang Wu,Wang Wu is a designer"
```

Paste the `voiceprint API address` obtained in the previous step into `url`. Then save.

Add `speakers` parameters according to your needs. Note the `speaker_id` parameter here, which will be used for voiceprint registration later.

## Step 2: Register Voiceprint
If you have already started the voiceprint service, visit `http://localhost:8005/voiceprint/docs` in your local browser to view the API documentation. Here we only explain how to use the voiceprint registration API.

The voiceprint registration API address is `http://localhost:8005/voiceprint/register`, and the request method is POST.

The request header needs to include Bearer Token authentication. The token is the part after `?key=` in the `voiceprint API address`. For example, if my voiceprint registration address is `http://127.0.0.1:8005/voiceprint/health?key=abcd`, then my token is `abcd`.

The request body includes the speaker ID (speaker_id) and WAV audio file (file). Request example:

```
curl -X POST \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -F "speaker_id=your_speaker_id_here" \
  -F "file=@/path/to/your/file" \
  http://localhost:8005/voiceprint/register
```

Here `file` is the audio file of the speaker's speech to be registered, and `speaker_id` needs to be consistent with the `speaker_id` configured in the first step. For example, if I need to register Zhang San's voiceprint, and the `speaker_id` filled in `.config.yaml` for Zhang San is `test1`, then when registering Zhang San's voiceprint, the `speaker_id` filled in the request body is `test1`, and `file` is the audio file of Zhang San saying something.

## Step 3: Start Service

Start the Xiaozhi server and voiceprint service to use normally.
