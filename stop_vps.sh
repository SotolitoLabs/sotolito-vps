#!/bin/bash

# Stop systemd container
# (for some reason we have to send SIGKILL)

echo "Stopping $1 VPS"
runc exec $1 shutdown -h now
runc kill $1 KILL

