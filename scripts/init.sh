#!/bin/bash

# Configure GitHub Actions
echo "Configuring GitHub Actions runner for '${RUNNER_USER}' with name '${RUNNER_NAME}' ..."
./config.sh --unattended \
    --url "https://github.com/${RUNNER_USER}" \
    --token "${RUNNER_TOKEN}" \
    --replace --name "${RUNNER_NAME}"

# Run GitHub Actions
echo "Starting GitHub Actions runner..."
exec ./run.sh
