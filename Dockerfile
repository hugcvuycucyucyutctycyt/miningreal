# Use an official NVIDIA CUDA base image
# Choose a version compatible with the T-Rex release you intend to use.
# Check T-Rex documentation/release notes for CUDA version requirements.
# 12.1.1 should be fine for recent T-Rex versions.
FROM nvidia/cuda:12.1.1-runtime-ubuntu22.04
# Note: Switched to -runtime as we don't need the full dev kit to RUN t-rex

# Set non-interactive frontend for package installs
ARG DEBIAN_FRONTEND=noninteractive

# Define T-Rex version and download URL using ARGs for flexibility
ARG TREX_VERSION=0.26.8  # <-- UPDATE THIS to the desired T-Rex version
ARG TREX_URL=https://github.com/trexminer/T-Rex/releases/download/${TREX_VERSION}/t-rex-${TREX_VERSION}-linux.tar.gz

# Install necessary utilities: wget to download, tar to extract, ca-certificates for HTTPS
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
    tar \
    # Add any other runtime dependencies T-Rex might need, if any (usually minimal)
    && rm -rf /var/lib/apt/lists/*

# --- Download and Set up T-Rex Miner ---
WORKDIR /app

# Download the T-Rex binary release
RUN wget -O t-rex.tar.gz "${TREX_URL}" && \
    # Extract the archive
    tar -zxvf t-rex.tar.gz && \
    # Remove the downloaded archive
    rm t-rex.tar.gz && \
    # Ensure the t-rex binary is executable
    chmod +x /app/t-rex

# --- Final Setup ---
# Copy the start script into the container
COPY start.sh /start.sh

# Ensure the start script is executable
RUN chmod +x /start.sh

# Set environment variables needed by the NVIDIA runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

# Set the working directory for execution
WORKDIR /app

# Define the default command to run when the container starts
# This will execute the start script, which in turn runs t-rex
CMD ["/start.sh"]
