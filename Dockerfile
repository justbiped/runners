FROM ubuntu:22.04

# Set ARGs with defaults
ARG RUNNER_VERSION="2.311.0"
ARG DOCKER_VERSION="24.0.6"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV RUNNER_HOME=/home/runner

# Install dependencies
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common \
    sudo \
    git \
    jq \
    iputils-ping \
    unzip \
    tar \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create a runner user
RUN useradd -m -s /bin/bash runner && \
    usermod -aG sudo runner && \
    echo "runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install Docker
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
    rm -rf /var/lib/apt/lists/* && \
    usermod -aG docker runner

# Set up the GitHub Actions runner
USER runner
WORKDIR ${RUNNER_HOME}

RUN curl -o actions-runner-linux-x64-2.323.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.323.0/actions-runner-linux-x64-2.323.0.tar.gz
RUN tar xzf ./actions-runner-linux-x64-2.323.0.tar.gz

# Copy entrypoint script and make it executable
COPY --chown=runner:runner entrypoint.sh ${RUNNER_HOME}/entrypoint.sh
RUN sudo chmod +x ${RUNNER_HOME}/entrypoint.sh

# Set environment variables for runner configuration
ENV RUNNER_ALLOW_RUNASROOT=0
ENV RUNNER_WORKDIR=${RUNNER_HOME}/_work

# Switch back to root to enable starting Docker service
USER root

# Entrypoint
ENTRYPOINT ["/home/runner/entrypoint.sh"]