#WORK IN PROGRESS NOT WORKING YET!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Ollama Web + API for Pterodactyl

A GitHub-based Pterodactyl egg that runs **Ollama** with a **FastAPI web interface**.  
Users can select models dynamically, chat with AI, and the egg automatically downloads the default model on startup.

---

## Features

- GitHub-based installation — no Docker Hub image required  
- Automatically downloads a **default model** on first startup  
- Dynamic **model dropdown** in the web UI showing all installed models  
- Configurable **ports** for web UI and Ollama API  
- Multi-user capable — multiple users can chat simultaneously  
- Easy updates — push commits to GitHub, and new servers pull latest code  

---

## Repository Structure

ollama-pterodactyl/
├── startup.sh # Pulls default model, starts Ollama API + Web UI
├── requirements.txt # Python dependencies
├── app.py # FastAPI web app
├── templates/
│ └── index.html # Web UI
├── static/
│ └── style.css # Styling
├── README.md # This file


---

## Pterodactyl Egg Setup

1. Go to **Pterodactyl Panel → Nests → Eggs → Import Egg**  
2. Upload the `egg-ollama-web.json` file  
3. Configure variables when creating a server:

| Variable       | Description                     | Example  |
|----------------|---------------------------------|----------|
| `WEB_PORT`     | Port for the web frontend        | 8000     |
| `OLLAMA_PORT`  | Port for Ollama API              | 11434    |
| `DEFAULT_MODEL`| Model to auto-download at startup| llama3   |

4. Start the server. The egg will:

- Clone this repository into the container  
- Install Python dependencies (`pip install -r requirements.txt`)  
- Install Ollama  
- Download the **default model** if not present  
- Start Ollama API and FastAPI Web UI  

---

## Accessing the Web UI

1. Open your server’s allocated `WEB_PORT` in a browser (provided by Pterodactyl).  
2. Select a model from the **dropdown** (populated dynamically with installed models).  
3. Type your question and press **Enter** or click **Ask**.  
4. AI responses appear live in the chat.  

---

## Local Testing (Optional)

You can test without Pterodactyl:

```bash
# Clone the repo
git clone https://github.com/N0tMilk/ollama-pterodactyl.git
cd ollama-pterodactyl

# Install Python dependencies
pip3 install --no-cache-dir -r requirements.txt

# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Make startup executable
chmod +x startup.sh

# Start locally
WEB_PORT=8000 OLLAMA_PORT=11434 DEFAULT_MODEL=llama3 ./startup.sh

Visit http://localhost:8000 to use the web UI.

Updating the Server

Push commits to GitHub to update the code.

New servers automatically pull the latest version.

Existing servers can update manually via SSH:

cd /app
git pull
pip3 install --no-cache-dir -r requirements.txt


Adding New Models

Change the DEFAULT_MODEL variable in Pterodactyl and restart the server → automatically pulls the model.

Or SSH into the container:

ollama pull new-model-name
The web UI dropdown updates automatically.


License


