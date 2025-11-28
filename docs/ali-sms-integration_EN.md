# Aliyun SMS Integration Guide

Log in to Aliyun Console and enter the "SMS Service" page: https://dysms.console.aliyun.com/overview

## Step 1: Add Signature
![Steps](images/alisms/sms-01.png)
![Steps](images/alisms/sms-02.png)

After the above steps, you will get a signature. Please write it to the Smart Console parameter `aliyun.sms.sign_name`

## Step 2: Add Template
![Steps](images/alisms/sms-11.png)

After the above steps, you will get a template code. Please write it to the Smart Console parameter `aliyun.sms.sms_code_template_code`

Note: The signature requires 7 working days to wait for the operator to successfully file it before it can be sent successfully.

Note: The signature requires 7 working days to wait for the operator to successfully file it before it can be sent successfully.

Note: The signature requires 7 working days to wait for the operator to successfully file it before it can be sent successfully.

You can wait until the filing is successful before continuing with the next steps.

## Step 3: Create SMS Account and Enable Permissions

Log in to Aliyun Console and enter the "Access Control" page: https://ram.console.aliyun.com/overview?activeTab=overview

![Steps](images/alisms/sms-21.png)
![Steps](images/alisms/sms-22.png)
![Steps](images/alisms/sms-23.png)
![Steps](images/alisms/sms-24.png)
![Steps](images/alisms/sms-25.png)

After the above steps, you will get access_key_id and access_key_secret. Please write them to the Smart Console parameters `aliyun.sms.access_key_id` and `aliyun.sms.access_key_secret`

## Step 4: Enable Mobile Phone Registration Function

1. Normally, after filling in all the above information, you will have this effect. If not, you may have missed a step.

![Steps](images/alisms/sms-31.png)

2. Enable non-administrator users to register by setting the parameter `server.allow_user_register` to `true`

3. Enable mobile phone registration function by setting the parameter `server.enable_mobile_register` to `true`
![Steps](images/alisms/sms-32.png)
