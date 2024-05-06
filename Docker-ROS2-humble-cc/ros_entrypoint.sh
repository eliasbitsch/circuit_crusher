#!/bin/bash

set -e

DEFAULT_USER_ID=1000

#
# Ensure host and container have the same user ID. This is to allow both sides
# to read and write the shared directories.
#
if [ -v USER_ID ] && [ "$USER_ID" != "$DEFAULT_USER_ID" ]; then
    echo "Changing circuit_crusher user ID to match your host's user ID ($USER_ID)." 
    echo "This operation can take a while..."

    usermod --uid $USER_ID circuit_crusher

    # Ensure all files in the home directory are owned by the new user ID
    find /home/circuit_crusher -user $DEFAULT_USER_ID -exec chown -h $USER_ID {} \;
fi

cd /home/circuit_crusher

# If no command is provided, set bash to start interactive shell
if [ -z "$1" ]; then
    set - "/bin/bash" -l
fi

source /opt/ros/humble/setup.bash
if [ -f /home/circuit_crusher/catkin_ws/install/setup.bash ]; then
    source /home/circuit_crusher/dev_ws/install/setup.bash
fi

# Run the provided command using user 'circuit_crusher'
exec gosu circuit_crusher "$@"
