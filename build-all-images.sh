#!/bin/bash
#
# example script to build the images

docker buildx rm mybuilder

docker buildx create --name mybuilder --use

docker buildx inspect --bootstrap

docker login --username jameszheng194

cd docker-redis-cluster

# ubuntu:  sudo apt install python3-invoke

invoke build 7.2
invoke build 7.0
invoke build 6.2
invoke build 6.0


docker buildx rm mybuilder


