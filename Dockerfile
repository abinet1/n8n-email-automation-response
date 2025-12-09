# n8n Email Automation System
# Base image: Official n8n image
FROM docker.n8n.io/n8nio/n8n:latest

# Set labels for documentation
LABEL maintainer="AI Frontend Developer Test"
LABEL description="n8n workflow automation for email classification and auto-reply"
LABEL version="1.0"

# Set environment variables
ENV NODE_ENV=production
ENV N8N_PORT=5678
ENV GENERIC_TIMEZONE=Africa/Addis_Ababa
ENV TZ=Africa/Addis_Ababa

# Create workflows directory
USER root
RUN mkdir -p /home/node/workflows && \
    chown -R node:node /home/node/workflows

# Switch back to node user for security
USER node

# Set working directory
WORKDIR /home/node

# Expose n8n port
EXPOSE 5678

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD wget --spider -q http://localhost:5678/healthz || exit 1

# Default command (inherited from base image)
# n8n starts automatically
