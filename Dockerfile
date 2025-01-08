# Use the existing ttyd image as the base
FROM tsl0922/ttyd:latest

# Install additional tools and dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    httpie \
    bash \
    nano \
    apache2-utils \
    # Install Node.js (required for Ungit)
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    # Install Ungit globally
    && npm install -g ungit \
    # Clean up to reduce image size
    && rm -rf /var/lib/apt/lists/*

# Create a workspace directory for persistent data
RUN mkdir -p /workspace && \
    # Initialize git config with safe directory
    git config --system --add safe.directory /workspace

# Create a script to handle user workspace creation and management
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Set the working directory to workspace
WORKDIR /workspace

# Expose the ports for ttyd and Ungit
EXPOSE 7681 8448

# Use tini for process management
# ENTRYPOINT ["/usr/bin/tini", "--"]

# Start both Ungit and ttyd
# CMD bash -c "ungit --port 8448 --no-b --ungitBindIp 0.0.0.0 --forcedLaunchPath=/workspace --allowCheckoutFiles 1 & ttyd -W bash"

ENTRYPOINT ["/start.sh"]
