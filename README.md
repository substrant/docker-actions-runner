# actions-runner-docker

Docker image for setting up a self-hosted GitHub Actions service.

Learn more at [GitHub Actions Runner](https://github.com/actions/runner/releases).

## Image Arguments

- `RUNNER_VERSION` - The version of the actions runner to install. Default is `latest`.
- `RUNNER_TOKEN` - The token to use to register the runner.
- `RUNNER_USER` - The GitHub user/organization to register the runner under.
- `RUNNER_NAME` - The name of the runner to use.

## Usage

### Docker Compose

Environment variables are substituted for the image arguments in the provided
`docker-compose.yml` file. The following example shows how to run the image
using the provided `docker-compose.yml` file.

```
env RUNNER_VERSION=latest \
    RUNNER_TOKEN=... \
    RUNNER_USER=... \
    RUNNER_NAME=... \
    docker-compose up -d
```

Additionally, you can edit `docker-compose.yml' to set the image arguments directly.

### Docker

The image takes various build arguments to configure the runner. The following
example shows how to build and run the image.

```
docker build -t actions-runner . \
    --build-arg RUNNER_VERSION=latest \
    --build-arg RUNNER_TOKEN= \
    --build-arg RUNNER_USER=... \
    --build-arg RUNNER_NAME=...
docker run -d --name actions-runner --restart always
```
