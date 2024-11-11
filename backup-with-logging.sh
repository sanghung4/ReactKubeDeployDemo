#!/bin/bash

echo "Initiating database backup at $(date)"

# Log in to Heroku CLI using the API key
echo "$HEROKU_API_KEY" | heroku auth:token --no-browser

# Capture the backup
heroku pg:backups:capture --app react-app-heroku-example

echo "Database backup completed at $(date)"
