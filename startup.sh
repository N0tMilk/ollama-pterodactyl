#!/bin/bash
set -e

# --- Load environment variables from Pterodactyl ---
WEB_PORT="${WEB_PORT:-8000}"
OLLAMA_PORT="${OLLAMA_PORT:-11434}"
DEFAULT_MODEL="${DEFAULT_MODEL:-llama3.1}"

echo "--------------------------------------------"
echo " Starting Ollama + Web UI "
echo "--------------------------------------------"
echo "Web UI Port: $WEB_PORT"
echo "Ollama Port: $OLLAMA_PORT"
echo "Default Model: $DEFAULT_MODEL"
echo "--------------------------------------------"

# --- Start Ollama API in background ---
echo "[1/3] Starting Ollama API on port $OLLAMA_PORT..."
ollama serve --port "$OLLAMA_PORT" &
OLLAMA_PID=$!

# Wait a few seconds for Ollama to initialize
sleep 5

# --- Pull model if not already installed ---
if ! ollama list | grep -q "$DEFAULT_MODEL"; then
    echo "[2/3] Pulling model: $DEFAULT_MODEL..."
    ollama pull "$DEFAULT_MODEL" || echo "⚠️ Failed to pull $DEFAULT_MODEL"
else
    echo "[2/3] Model $DEFAULT_MODEL already exists."
fi

# --- Start the web interface (FastAPI / Uvicorn) ---
echo "[3/3] Starting FastAPI web server on port $WEB_PORT..."
uvicorn app:app --host 0.0.0.0 --port "$WEB_PORT" --log-level info

# --- Keep process alive ---
wait $OLLAMA_PID
