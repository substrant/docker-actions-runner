#!/bin/bash

# If RUNNER_VERSION is not set, get the latest version
if [ ${RUNNER_VERSION} == "latest" ] || [ -z ${RUNNER_VERSION} ]; then
    echo "Getting latest runner version..."
    final_url=`curl -Ls -o /dev/null -w %{url_effective} https://github.com/actions/runner/releases/latest`
    RUNNER_VERSION=$(echo $final_url | awk -F '/' '{ print $NF }' | cut -d 'v' -f 2)
fi

# Download the binariess from GitHub
echo "Downloading GitHub Actions v${RUNNER_VERSION}..."
curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L \
    https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Extract the runner
echo "Extracting binaries..."
tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Clean up
rm ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz