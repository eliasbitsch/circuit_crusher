#!/bin/sh

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.X11-unix
SHARED_DIR=/home/circuit_crusher/dev_ws/src
HOST_DIR=$(pwd)/dev_ws/src

echo "Allowing connections from all hosts to X server"
xhost +

echo -e "\e[32mMounting folder:
    $HOST_DIR    to
    $SHARED_DIR\e[0m"

docker run \
    -it --rm \
    --volume=$XSOCK:$XSOCK:rw \
    --volume=$XAUTH:$XAUTH:rw \
    --volume=$HOST_DIR:$SHARED_DIR:rw \
    --env="XAUTHORITY=${XAUTH}" \
    --env="DISPLAY=${DISPLAY}" \
    --privileged -v /dev/bus/usb:/dev/bus/usb \
    --net=host \
    --name "ros2-humble" \
    ros2-humble /bin/bash

echo "Revoking permission for connections to X server"
xhost -
