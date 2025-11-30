#!/bin/bash

FILE="/home/ec2-user/project"

if [ ! -f "$FILE" ]; then
  echo "the is my 1st deployment" > "$FILE"
fi

chmod +x "$FILE"

# Print message every 3 minutes
while true; do
  echo "the is my 1st deployment"
  sleep 180
done
