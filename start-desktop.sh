#!/bin/bash
set -e

export DISPLAY=:1
export HOME=/home/desktop
export XDG_RUNTIME_DIR=/tmp/runtime-desktop

mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"

rm -f /tmp/.X1-lock
rm -f /tmp/.X11-unix/X1

mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

Xvfb :1 -screen 0 1920x1080x24 -ac +extension GLX +render -noreset &

sleep 2

dbus-launch --exit-with-session startxfce4 >/tmp/xfce.log 2>&1 &

sleep 5

x11vnc \
    -display :1 \
    -forever \
    -shared \
    -rfbport 5900 \
    -nopw \
    -listen 0.0.0.0 \
    >/tmp/x11vnc.log 2>&1 &

sleep 2

websockify \
    --web=/usr/share/novnc \
    0.0.0.0:6080 \
    127.0.0.1:5900 \
    >/tmp/novnc.log 2>&1 &

echo "Linux XFCE desktop is ready."
echo "Open port 6080 in the Codespaces PORTS panel."

wait
