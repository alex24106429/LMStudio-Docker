#!/bin/bash
set -e

# Clean up any leftover locks
rm -f /tmp/.X0-lock

# 1. Start X virtual framebuffer
echo "Starting Xvfb..."
Xvfb :0 -screen 0 ${RESOLUTION} -nolisten tcp &
sleep 2

# 2. Start Openbox Window Manager (prevents UI glitches)
echo "Starting Openbox..."
openbox-session &

# 3. Start VNC server
echo "Starting x11vnc..."
x11vnc -display :0 -nopw -forever -shared -bg

# 4. Start NoVNC (Web UI)
echo "Starting NoVNC..."
websockify --web /usr/share/novnc 8080 localhost:5900 &

# 5. Start LM Studio wrapped in a clean D-Bus Session
echo "Starting LM Studio..."
export APPDIR=/app/squashfs-root

exec dbus-run-session /app/squashfs-root/AppRun --disable-dev-shm-usage --no-sandbox
