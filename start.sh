#!/bin/bash

# Create ttyd directory
mkdir -p /etc/ttyd
touch /etc/ttyd/passwd

# Function to create a new user workspace
create_workspace() {
    local username=$1
    local workspace="/workspace/$username"
    
    # Create user workspace if it doesn't exist
    if [ ! -d "$workspace" ]; then
        mkdir -p "$workspace"
        chmod 755 "$workspace"
    fi
}

# Start ttyd with authentication and workspace management
exec ttyd \
    -c "admin:admin" \
    -W \
    -m 50 \
    -t fontSize=14 \
    -t theme={"background":"#000000"} \
    bash -c 'cd "/workspace/$TTYD_USERNAME" && bash'
