#!/bin/bash
set -e

WEB_PORT="${WEB_PORT:-8000}"
OLLAMA_PORT="${OLLAMA_PORT:-11434}"
DEFAULT_MODEL="${DEFAULT_MODEL:-llama3.1}"

echo "Starting Ollama and Web UI..."
echo "Model: $DEFAULT_MODEL | Ollama Port: $OLLAMA_PORT | Web Port: $WEB_PORT"

# Start Ollama in background
/usr/local/bin/ollama serve --port "$OLLAMA_PORT" &
sleep 5

# Pull model if not available
if ! /usr/local/bin/ollama list | grep -q "$DEFAULT_MODEL"; then
    echo "Pulling model $DEFAULT_MODEL..."
    /usr/local/bin/ollama pull "$DEFAULT_MODEL" || echo "Failed to pull model."
fi

# Start FastAPI Web Interface
uvicorn app:app --host 0.0.0.0 --port "$WEB_PORT"
