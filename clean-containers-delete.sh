#!/bin/bash

echo "Enter container name..."
read container

echo "Stopping & removing container..."
docker container stop $container
docker container rm $container

echo "Deleting dangling images & volumes (all)..."
docker volume rm $(docker volume ls -qf dangling=true)

CHECK=$(docker volume ls -qf dangling=true)

if [[ ! -z $CHECK ]] ; then
    docker image rm $(docker volume ls -qf dangling=true)
    else
    echo "No dangling images."
fi

echo "Done."
