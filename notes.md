
#On Mac

## Enable Docker BuildKit:
Before you start, ensure that Docker BuildKit is enabled. You can do this by setting the environment variable DOCKER_BUILDKIT=1.

### Install and Set Up Docker Buildx:
Docker buildx is a CLI plugin that extends the Docker command with the full support of the features provided by Moby BuildKit builder toolkit. It's included in Docker Desktop and Docker for Mac but might need to be installed separately in other environments.

### Create a New Builder Instance:


Start up the Builder:
Start the builder with

```
# create a new builder instance and switch to it
docker buildx create --name mybuilder --use
# This instance allows you to build for multiple architectures.

# Start up the Builder:
docker buildx inspect --bootstrap

# You can now use the builder to build multi-arch images:
invoke build 6.2
invoke push 6.2

# list all the builders
docker buildx ls

# remove the builder
docker buildx rm mybuilder
```
