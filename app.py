import os
from fastapi import FastAPI, Form
from fastapi.responses import StreamingResponse, HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
import httpx
import json

app = FastAPI()

OLLAMA_PORT = os.getenv("OLLAMA_PORT", "11434")
OLLAMA_API_URL = f"http://localhost:{OLLAMA_PORT}/api"

app.mount("/static", StaticFiles(directory="static"), name="static")
templates = Jinja2Templates(directory="templates")


def get_models():
    try:
        r = httpx.get(f"{OLLAMA_API_URL}/models")
        r.raise_for_status()
        data = r.json()
        return [m["name"] for m in data.get("models", [])]
    except Exception:
        return [os.getenv("DEFAULT_MODEL", "llama3")]


def generate_stream(model: str, prompt: str):
    payload = {"model": model, "prompt": prompt, "stream": True}
    with httpx.stream("POST", f"{OLLAMA_API_URL}/generate", json=payload) as r:
        r.raise_for_status()
        for line in r.iter_lines():
            if line:
                data = json.loads(line.decode("utf-8"))
                if "response" in data:
                    yield f"data: {data['response']}\n\n"
                if data.get("done", False):
                    break


@app.get("/", response_class=HTMLResponse)
async def index():
    models = get_models()
    return templates.TemplateResponse("index.html", {"request": {}, "models": models})


@app.post("/chat", response_class=StreamingResponse)
async def chat(model: str = Form(...), prompt: str = Form(...)):
    return StreamingResponse(generate_stream(model, prompt), media_type="text/event-stream")
