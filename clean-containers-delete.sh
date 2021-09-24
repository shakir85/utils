#!/bin/bash

echo "Enter container name..."
read container

echo "Stopping & removing container..."
docker container stop $container
docker container rm $container

echo "Deleting dangling images & volumes (all)..."
CHECK_VOL=$(docker volume ls -qf dangling=true)

if [[ ! -z $CHECK_VOL ]] ; then
    docker volume rm $(docker volume ls -qf dangling=true)
    else
    echo "No dangling volumes."
fi

CHECK_IMG=$(docker volume ls -qf dangling=true)

if [[ ! -z $CHECK ]] ; then
    docker image rm $(docker image ls -qf dangling=true)
    else
    echo "No dangling images."
fi

echo "Done."
