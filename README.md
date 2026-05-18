# LM Studio in Docker (with NVIDIA GPU & Web GUI)

This repository allows you to run **LM Studio** inside a Docker container. It uses **NoVNC** to provide a graphical interface directly in your web browser and supports **NVIDIA GPU acceleration** for fast local LLM inference.

This is ideal for running LM Studio on a headless server, a home lab, or a remote machine while accessing the UI from any device.

## Features

*   **🌐 Web-based GUI:** Access the full LM Studio desktop interface via any browser (Port 8080).
*   **🚀 GPU Acceleration:** Full NVIDIA passthrough support for high-performance inference.
*   **🔌 API Access:** Exposes the LM Studio Local Inference Server (Port 1234).
*   **💾 Persistence:** Models and configuration settings are saved to your host machine.
*   **📦 Headless Friendly:** No physical monitor required on the host.

## Prerequisites

1.  **Host OS:** Linux.
2.  **Drivers:** [NVIDIA Drivers](https://www.nvidia.com/download/index.aspx) installed on the host.
3.  **Toolkit:** [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) installed and configured for Docker.
4.  **The AppImage:** You must download the LM Studio Linux AppImage (version `0.4.13-1` or update the Dockerfile version) and place it in the same directory as the Dockerfile.

## File Structure

```text
.
├── Dockerfile
├── docker-compose.yml
├── entrypoint.sh
├── LM-Studio-0.4.13-1-x64.AppImage  <-- Download this from lmstudio.ai
├── lm-models/                       <-- Created automatically (stored models)
└── lm-config/                       <-- Created automatically (app settings)
```

## Setup & Installation

1.  **Download the AppImage:**
    Go to [lmstudio.ai](https://lmstudio.ai/) and download the Linux AppImage. Rename it to match the version in the Dockerfile (e.g., `LM-Studio-0.4.13-1-x64.AppImage`).

2.  **Build and Start:**
    ```bash
    docker compose up -d --build
    ```

3.  **Access the UI:**
    Open your browser and navigate to:
    `http://<your-server-ip>:8080`

4.  **Access the API:**
    Once you start the server inside LM Studio, it will be reachable at:
    `http://<your-server-ip>:1234/v1`

## Configuration

### Persistence
The `docker-compose.yml` maps two volumes to your host:
*   `./lm-models`: This is where your downloaded GGUF files will be stored.
*   `./lm-config`: This stores your application settings and history.

### Resource Limits
The compose file includes a `shm_size: "8g"` and `memlock: -1`. This is critical for large language models to prevent crashes and allow the GPU to access system memory efficiently.

## Troubleshooting

### GPU Not Detected
Ensure you have the `nvidia-container-toolkit` installed. Run `nvidia-smi` inside the container to verify:
```bash
docker exec -it lm-studio nvidia-smi
```

### UI is Laggy
*   The resolution is set to `1600x900` by default. You can change the `RESOLUTION` environment variable in the `Dockerfile`.
*   Ensure your network connection to the server is stable, as VNC performance depends on bandwidth.

### Permissions
If you encounter permission issues with the volumes, ensure the local directories are writable:
```bash
chmod -R 777 ./lm-models ./lm-config
```

## Disclaimer
This project is not affiliated with LM Studio. It is a community-made Docker wrapper. Please ensure you comply with the LM Studio [Terms of Service](https://lmstudio.ai/terms).