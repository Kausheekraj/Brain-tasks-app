#!/usr/bin/env bash
# Stopping any existing containers
echo " Stopping any existing containers"
docker compose down 
echo "Deploying New Nginx Container..."
docker compose up --build -d
