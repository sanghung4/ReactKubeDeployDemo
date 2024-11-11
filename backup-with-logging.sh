#!/bin/bash

# Log the start of the backup process
echo "Initiating database backup at $(date)" 

# Capture the backup
heroku pg:backups:capture --app react-app-heroku-example

# Log the completion of the backup process
echo "Database backup completed at $(date)"