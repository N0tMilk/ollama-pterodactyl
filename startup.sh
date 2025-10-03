#!/bin/bash
set -e

WEB_PORT="${WEB_PORT:-8000}"
OLLAMA_PORT="${OLLAMA_PORT:-11434}"
DEFAULT_MODEL="${DEFAULT_MODEL:-llama3.1}"

echo "Starting Ollama API on port $OLLAMA_PORT..."
# Start Ollama in the background
ollama serve --port "$OLLAMA_PORT" &

# Wait a few seconds for Ollama to start
sleep 5

# Pull model if not installed
if ! ollama list | grep -q "$DEFAULT_MODEL"; then
    echo "Pulling default model $DEFAULT_MODEL..."
    ollama pull "$DEFAULT_MODEL"
else
    echo "Model $DEFAULT_MODEL already exists."
fi

# Start FastAPI Web UI
echo "Starting Web UI on port $WEB_PORT..."
uvicorn app:app --host 0.0.0.0 --port "$WEB_PORT"

wait
