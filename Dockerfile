# Use the Debian Linux base image
# Alpine's musl libc does not play nice with GitHub Actions
FROM debian:latest

# Arguments for setting up the image
ARG RUNNER_VERSION="latest"
ARG RUNNER_TOKEN
ARG RUNNER_USER
ARG RUNNER_NAME

# Update package repositories and install any necessary packages
RUN apt-get update && apt-get install -y curl sudo

# Create a folder for actions
RUN mkdir /actions-runner
WORKDIR /actions-runner

# Download and extract the latest runner package
COPY ./install.sh /
RUN chmod +x /install.sh && /install.sh
RUN rm -f /install.sh

# Set up and admin account for configuration
RUN useradd -ms /bin/bash admin && adduser admin sudo
RUN echo 'admin ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN chown -R admin:admin /actions-runner

# Switch to admin user
USER admin

# Install missing dependencies and set up the runner
RUN sudo ./bin/installdependencies.sh
RUN ./config.sh --unattended \
    --url https://github.com/${RUNNER_USER} \
    --token ${RUNNER_TOKEN} \
    --replace --name ${RUNNER_NAME}

# Clear apt cache
RUN sudo rm -rf /var/lib/apt/lists/*

# Command to run when the container starts
CMD [ "./run.sh" ]