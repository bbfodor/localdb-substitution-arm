#!/bin/bash

if ! command -v sqlcmd &> /dev/null; then
  echo "Error: sqlcmd is required but not installed."
  echo "Please install sqlcmd by visiting https://github.com/microsoft/go-sqlcmd"
  exit 1
fi

# Set default values for environment variables
: "${MSSQL_SA_PASSWORD:=SomePassword@01}"
: "${CONTAINER_PORT:=1431}"

: "${VOLUME_PATH:=../data}"
: "${DB_NAME:=DB}"
: "${DB_FILE:=DB.mdf}"
: "${LOG_FILE:=DB_log.ldf}"

if [ -f .env ]; then
  # Load environment variables from the .env file
  set -a
  . .env
  set +a
else
  echo ".env file not found. Using default values for environment variables."
fi

cp ../$DB_FILE $VOLUME_PATH
cp ../$LOG_FILE $VOLUME_PATH

sqlcmd -S localhost,$CONTAINER_PORT -U sa -P "$MSSQL_SA_PASSWORD" -Q "CREATE DATABASE $DB_NAME ON (FILENAME = '/var/opt/mssql/data/$DB_FILE'), (FILENAME = '/var/opt/mssql/data/$LOG_FILE') FOR ATTACH;"
