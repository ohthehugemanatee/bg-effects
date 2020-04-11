#!/bin/sh

# create a network
docker network create --driver bridge fakecam

# start the bodypix app
docker run -d \
  --name=bodypix \
  --network=fakecam \
  --gpus=all --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 \
  bodypix

# start the camera, note that we need to pass through video devices,
# and we want our user ID and group to have permission to them
# you may need to `sudo groupadd $USER video`
docker run -d \
  --name=fakecam \
  --network=fakecam \
  -p 8080:8080 \
  -u "$(id -u):$(getent group video | cut -d: -f3)" \
  $(find /dev -name 'video*' -printf "--device %p ") \
  fakecam
