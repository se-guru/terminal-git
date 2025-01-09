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

# Set the working directory to workspace
WORKDIR /workspace

# Create a script to initialize the workspace
RUN echo '#!/bin/bash\n\
mkdir -p /workspace\n\
cd /workspace\n\
# Add your repository cloning commands here\n\
git clone https://github.com/se-guru/ProjectOne.git || true\n\
git clone https://github.com/se-guru/ProjectTwo.git || true\n\
\n\
# Start the services\n\
ungit --port 8448 --no-b --ungitBindIp 0.0.0.0 --forcedLaunchPath=/workspace --allowCheckoutFiles 1 & \n\
ttyd -W -t fontSize=14 bash -c "cd /workspace && exec bash"' > /init-workspace.sh && \
chmod +x /init-workspace.sh

# Expose the ports for ttyd and Ungit
EXPOSE 7681 8448

# Use tini for process management
ENTRYPOINT ["/usr/bin/tini", "--"]

# Start the initialization script
CMD ["/init-workspace.sh"]
