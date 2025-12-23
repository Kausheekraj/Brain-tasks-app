#!/usr/bin/env bash
set -e 
if [[ "$1" == 'rmi' ]]; then
echo "Removing custom image..."
docker compose down --rmi all --volumes --remove-orphans
else
echo "Stopping Containers..."
docker compose down
fi
echo "cleanup complete."
