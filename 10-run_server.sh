#!/bin/bash

if ! command -v docker &> /dev/null; then
  echo "Error: docker is required but not installed."
  echo "Please install docker by visiting https://www.docker.com/"
  exit 1
fi

# Set default values for environment variables
: "${VOLUME_PATH:=../data}"
: "${CONTAINER_PORT:=1431}"
: "${CONTAINER_NAME:=sqledge}"

if [ -f .env ]; then
  # Load environment variables from the .env file
  set -a
  . .env
  set +a

  docker run --cap-add SYS_PTRACE --env-file .env -v $PWD/$VOLUME_PATH:/var/opt/mssql/data -p $CONTAINER_PORT:1433 --name $CONTAINER_NAME -d mcr.microsoft.com/azure-sql-edge
else
  echo ".env file not found. Using default values for environment variables."
  docker run --cap-add SYS_PTRACE -e 'ACCEPT_EULA=1' -e 'MSSQL_SA_PASSWORD=SomePassword@01' -v $PWD/$VOLUME_PATH:/var/opt/mssql/data -p $CONTAINER_PORT:1433 --name $CONTAINER_NAME -d mcr.microsoft.com/azure-sql-edge
fi
