# Frequently Asked Questions ❓

### 1. Why does Xiaozhi recognize a lot of Korean, Japanese, and English when I speak? 🇰🇷

Suggestion: Check whether there is a `model.pt` file in `models/SenseVoiceSmall`. If not, you need to download it. See here [Download Speech Recognition Model File](Deployment_EN.md#model-file)

### 2. Why does "TTS task error file does not exist" appear? 📁

Suggestion: Check whether you have correctly installed the `libopus` and `ffmpeg` libraries using `conda`.

If not installed, install them:

```
conda install conda-forge::libopus
conda install conda-forge::ffmpeg
```

### 3. TTS often fails and often times out ⏰

Suggestion: If `EdgeTTS` often fails, please first check whether you are using a proxy (VPN). If so, please try turning off the proxy and try again;  
If you are using Volcengine Doubao TTS and it often fails, it is recommended to use the paid version, as the test version only supports 2 concurrent connections.

### 4. Can connect to self-built server using Wifi, but cannot connect in 4G mode 🔐

Reason: Xiage's firmware requires a secure connection in 4G mode.

Solutions: There are currently two methods to solve this. Choose one:

1. Modify the code. Refer to this video solution https://www.bilibili.com/video/BV18MfTYoE85

2. Use nginx to configure SSL certificate. Refer to the tutorial https://icnt94i5ctj4.feishu.cn/docx/GnYOdMNJOoRCljx1ctecsj9cnRe

### 5. How to improve Xiaozhi's dialogue response speed? ⚡

The default configuration of this project is a low-cost solution. It is recommended that beginners first use the default free models to solve the "can run" problem, then optimize for "runs fast".  
If you need to improve response speed, you can try replacing each component. Starting from version `0.5.2`, the project supports streaming configuration. Compared to earlier versions, response speed improved by about `2.5 seconds`, significantly enhancing user experience.

| Module Name | Entry-level Free Setup | Streaming Configuration |
|:---:|:---:|:---:|
| ASR (Speech Recognition) | FunASR (Local) | 👍FunASR (Local GPU Mode) |
| LLM (Large Language Model) | ChatGLMLLM (Zhipu glm-4-flash) | 👍AliLLM (qwen3-235b-a22b-instruct-2507) or 👍DoubaoLLM (doubao-1-5-pro-32k-250115) |
| VLLM (Vision Language Model) | ChatGLMVLLM (Zhipu glm-4v-flash) | 👍QwenVLVLLM (Qwen qwen2.5-vl-3b-instructh) |
| TTS (Text-to-Speech) | ✅LinkeraiTTS (Lingxi Streaming) | 👍HuoshanDoubleStreamTTS (Huoshan Dual-Streaming TTS) or 👍AliyunStreamTTS (Aliyun Streaming TTS) |
| Intent (Intent Recognition) | function_call (Function Calling) | function_call (Function Calling) |
| Memory (Memory Function) | mem_local_short (Local Short-term Memory) | mem_local_short (Local Short-term Memory) |

If you care about the latency of each component, please refer to [Xiaozhi Component Performance Test Report](https://github.com/xinnan-tech/xiaozhi-performance-research). You can test in your environment according to the testing methods in the report.

### 6. I speak slowly, and Xiaozhi always interrupts when I pause 🗣️

Suggestion: Find the following section in the configuration file and increase the value of `min_silence_duration_ms` (for example, change it to `1000`):

```yaml
VAD:
  SileroVAD:
    threshold: 0.5
    model_dir: models/snakers4_silero-vad
    min_silence_duration_ms: 700  # If you have long pauses when speaking, increase this value
```

### 7. Deployment Related Tutorials
1. [How to perform minimal deployment](./Deployment_EN.md)<br/>
2. [How to perform full module deployment](./Deployment_all_EN.md)<br/>
3. [How to deploy MQTT gateway to enable MQTT+UDP protocol](./mqtt-gateway-integration_EN.md)<br/>
4. [How to automatically pull the latest code from this project for automatic compilation and startup](./dev-ops-integration_EN.md)<br/>
5. [How to integrate with Nginx](https://github.com/xinnan-tech/xiaozhi-esp32-server/issues/791)<br/>

### 9. Firmware Compilation Related Tutorials
1. [How to compile Xiaozhi firmware yourself](./firmware-build_EN.md)<br/>
2. [How to modify OTA address based on Xiage's compiled firmware](./firmware-setting_EN.md)<br/>

### 10. Extension Related Tutorials
1. [How to enable mobile phone number registration for Smart Console](./ali-sms-integration_EN.md)<br/>
2. [How to integrate HomeAssistant to achieve smart home control](./homeassistant-integration_EN.md)<br/>
3. [How to enable vision model to achieve photo recognition](./mcp-vision-integration_EN.md)<br/>
4. [How to deploy MCP endpoint](./mcp-endpoint-enable_EN.md)<br/>
5. [How to access MCP endpoint](./mcp-endpoint-integration_EN.md)<br/>
6. [How MCP method obtains device information](./mcp-get-device-info_EN.md)<br/>
7. [How to enable voiceprint recognition](./voiceprint-integration_EN.md)<br/>
8. [News plugin source configuration guide](./newsnow_plugin_config_EN.md)<br/>

### 11. Voice Cloning and Local Voice Deployment Related Tutorials
1. [How to clone voices in Smart Console](./huoshan-streamTTS-voice-cloning_EN.md)<br/>
2. [How to deploy and integrate index-tts local voice](./index-stream-integration_EN.md)<br/>
3. [How to deploy and integrate fish-speech local voice](./fish-speech-integration_EN.md)<br/>
4. [How to deploy and integrate PaddleSpeech local voice](./paddlespeech-deploy_EN.md)<br/>

### 12. Performance Testing Tutorials
1. [Component speed testing guide](./performance_tester_EN.md)<br/>
2. [Regularly published test results](https://github.com/xinnan-tech/xiaozhi-performance-research)<br/>

### 13. For more questions, you can contact us for feedback 💬

You can submit your questions in [issues](https://github.com/xinnan-tech/xiaozhi-esp32-server/issues).
