#!/bin/bash
set -e

WEB_PORT="${WEB_PORT:-8000}"
OLLAMA_PORT="${OLLAMA_PORT:-11434}"
DEFAULT_MODEL="${DEFAULT_MODEL:-llama3}"

echo "Using default model: $DEFAULT_MODEL"

# Pull model if not installed
if ! ollama list | grep -q "$DEFAULT_MODEL"; then
    echo "Pulling default model $DEFAULT_MODEL..."
    ollama pull "$DEFAULT_MODEL"
else
    echo "Model $DEFAULT_MODEL already exists."
fi

# Start Ollama API
echo "Starting Ollama API on port $OLLAMA_PORT..."
ollama serve --port "$OLLAMA_PORT" &

# Activate virtual environment and start Web UI
. /mnt/server/venv/bin/activate
echo "Starting Web UI on port $WEB_PORT..."
uvicorn app:app --host 0.0.0.0 --port "$WEB_PORT"

wait
