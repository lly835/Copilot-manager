# Dockerfile for Copilot-manager with Docker
# Usage: docker build -t copilot-manager .
FROM lbjlaq/antigravity-manager:latest
COPY dist/ /app/dist
