#!/bin/bash

if ! command -v docker &> /dev/null; then
  echo "Error: docker is required but not installed."
  echo "Please install docker by visiting https://www.docker.com/"
  exit 1
fi

docker pull mcr.microsoft.com/azure-sql-edge
