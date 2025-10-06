# Newer versions of Ubuntu just completely fail to work because of some dependency issues
# Not going to bother trying to fix it either, given that 22.04 is still in support
FROM ubuntu:22.04

# Arguments for setting up the image
ARG RUNNER_VERSION="latest"

# Update system, install necessary packages, 
RUN apt-get update && \
    apt-get upgrade && \
    apt-get install git ca-certificates curl unzip sudo && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" \
      | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Create a folder for actions
RUN mkdir /actions-runner
WORKDIR /actions-runner

# Copy install script
COPY ./scripts/install.sh /

# Download and extract the latest runner package
RUN chmod +x /install.sh && /install.sh
RUN rm -f /install.sh

# Set up and runner account for configuration
RUN useradd -ms /bin/bash runner && usermod -aG sudo runner && usermod -aG docker runner
RUN echo 'runner ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN chown -R runner:runner /actions-runner

# Switch to runner user
USER runner

# Install missing dependencies
RUN sudo ./bin/installdependencies.sh

# Clear apt cache
RUN sudo rm -rf /var/lib/apt/lists/*

# Copy init script
COPY ./scripts/init.sh /actions-runner
RUN sudo chmod +rx /actions-runner/init.sh

# Command to run when the container starts
CMD [ "./init.sh" ]
