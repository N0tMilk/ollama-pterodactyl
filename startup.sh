#!/bin/bash
set -e

echo "=== Checking root privileges ==="
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run as root. Try: sudo ./startup.sh"
  exit 1
fi

echo "=== Updating system packages ==="
apt update -y && apt upgrade -y

echo "=== Installing dependencies ==="
apt install -y curl git python3 python3-pip python3-venv ca-certificates build-essential psmisc net-tools

echo "=== Installing Ollama ==="
if ! command -v ollama &> /dev/null; then
  curl -fsSL https://ollama.com/install.sh | sh
else
  echo "Ollama already installed"
fi

echo "=== Setting up web app ==="

APP_DIR="/opt/ollama-web"
if [ ! -d "$APP_DIR" ]; then
  git clone https://github.com/N0tMilk/ollama-pterodactyl.git "$APP_DIR"
fi

cd "$APP_DIR"

echo "=== Setting up Python virtual environment ==="
python3 -m venv venv
source venv/bin/activate

echo "=== Installing Python dependencies ==="
pip install -r requirements.txt

echo "=== Starting Ollama service ==="
ollama serve --port 11434 &
sleep 5

echo "=== Starting web server ==="
uvicorn app:app --host 0.0.0.0 --port 8000
