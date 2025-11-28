# Smart Console Huoshan Dual-Streaming TTS + Voice Cloning Configuration Tutorial

This tutorial is divided into 4 stages: Preparation, Configuration, Cloning, and Usage. It mainly introduces the process of configuring Huoshan Dual-Streaming TTS + Voice Cloning through the Smart Console.

## Stage 1: Preparation
The super administrator should first activate the Huoshan Engine service and obtain the App ID and Access Token. By default, Huoshan Engine will provide one voice resource for free. This voice resource needs to be copied to this project.

If you want to clone multiple voices, you need to purchase and activate multiple voice resources. Simply copy each voice resource's Voice ID (S_xxxxx) to this project, then assign them to system accounts for use. Detailed steps are as follows:

### 1. Activate Huoshan Engine Service
Visit https://console.volcengine.com/speech/app and create an application in Application Management. Check "TTS Large Model" and "Voice Cloning Large Model".

### 2. Obtain Voice Resource ID
Visit https://console.volcengine.com/speech/service/9999 and copy three items: App ID, Access Token, and Voice ID (S_xxxxx). See image below.

![Obtain Voice Resource](images/image-clone-integration-01.png)

## Stage 2: Configure Huoshan Engine Service

### 1. Fill in Huoshan Engine Configuration

Log in to the Smart Console using the super administrator account, click [Model Configuration] at the top, then click [Text-to-Speech] on the left side of the Model Configuration page, search for "Huoshan Dual-Streaming TTS", click Modify, fill your Huoshan Engine's `App Id` into the [Application ID] field, and fill the `Access Token` into the [Access Token] field. Then save.

### 2. Assign Voice Resource ID to System Account

Log in to the Smart Console using the super administrator account, click [Voice Cloning] and [Voice Resources] at the top.

Click the Add button, select "Huoshan Dual-Streaming TTS" in [Platform Name];

Fill in your Huoshan Engine's Voice Resource ID (S_xxxxx) in [Voice Resource ID], press Enter after filling;

Select the system account you want to assign to in [Assigned Account], you can assign it to yourself. Then click Save.

## Stage 3: Cloning Stage

If after logging in, you click [Voice Cloning] >> [Voice Cloning] at the top and see "Your account has no voice resources, please contact administrator to assign voice resources", it means you haven't assigned voice resource IDs to this account in Stage 2. Then go back to Stage 2 and assign voice resources to the corresponding account.

If after logging in, you click [Voice Cloning] >> [Voice Cloning] at the top and can see the corresponding voice list, please continue.

In the list, you will see the corresponding voice resources. Select one voice resource and click the [Upload Audio] button. After uploading, you can preview the sound or clip a certain segment. After confirmation, click the [Upload Audio] button.
![Upload Audio](images/image-clone-integration-02.png)

After uploading audio, you will see the corresponding voice in the list change to "Pending Cloning" status. Click the [Clone Now] button. Wait 1~2 seconds for the result.

If cloning fails, hover your mouse over the "Error Message" icon to see the failure reason.

If cloning succeeds, you will see the corresponding voice in the list change to "Training Successful" status. At this point, you can click the Modify button in the [Voice Name] column to rename the voice resource for easier selection later.

## Stage 4: Usage Stage

Click [Agent Management] at the top, select any agent, and click the [Configure Role] button.

For Text-to-Speech (TTS), select "Huoshan Dual-Streaming TTS". In the list, find the voice resource with "Cloned Voice" in its name (see image), select it, and click Save.
![Select Voice](images/image-clone-integration-03.png)

Next, you can wake up Xiaozhi and talk to it.
