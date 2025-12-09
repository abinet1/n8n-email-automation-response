# n8n Email Automation System

An intelligent email automation system that monitors Gmail, classifies incoming messages using AI, and sends contextually appropriate automated responses.

## Quick Start

### 1. Install Docker (if not installed)

```bash
# Update packages
sudo apt-get update

# Install prerequisites
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Add Docker GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Verify
docker --version
docker compose version
```

### 2. Configure Environment

Edit `.env` file with your credentials:

```env
N8N_USER=admin
N8N_PASSWORD=your_secure_password_here
```

### 3. Start n8n

```bash
docker compose up -d
```

Access n8n at: **http://localhost:5678**

### 4. Set Up Gmail API

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project
3. Enable **Gmail API** (APIs & Services → Library)
4. Create OAuth 2.0 credentials:
   - Type: Web application
   - Redirect URI: `http://localhost:5678/rest/oauth2-credential/callback`
5. Configure OAuth consent screen:
   - Add scope: `https://mail.google.com/`
   - Add your email as test user

### 5. Set Up OpenAI API

1. Get API key from [OpenAI Platform](https://platform.openai.com/api-keys)
2. Add to n8n credentials

### 6. Import & Configure Workflow

1. In n8n, click **Import** → **From File**
2. Select `email-workflow.json`
3. Configure credentials in each node
4. **Activate** the workflow

## Testing

Send these test emails from a different account:

| Test Email Subject/Body | Expected Category |
|------------------------|-------------------|
| "What are your prices?" | PRICING |
| "Partnership opportunity" | PARTNERSHIP |
| "I need help with an issue" | SUPPORT |
| "General inquiry" | GENERAL |

## Commands

```bash
# Start
docker compose up -d

# Stop
docker compose down

# View logs
docker logs -f n8n

# Restart
docker compose restart
```

## Project Structure

```
├── docker-compose.yml    # n8n deployment config
├── .env                  # Environment variables
├── email-workflow.json   # n8n workflow export
├── explanation.md        # Technical documentation
├── README.md            # This file
└── n8n-data/            # Persistent data (auto-created)
```

## Features

- Gmail monitoring with OAuth2 authentication
- AI-powered email classification (OpenAI GPT-3.5)
- Keyword-based fallback detection
- Professional response templates for 4 categories
- Thread-based replies
- Automatic read status update

## License

This project was created for the AI Frontend Developer Technical Assessment.
