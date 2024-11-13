#!/bin/bash

echo "Initiating database backup at $(date)"

USER_IP="172.11.135.100"  # Replace with dynamic IP retrieval

LOCATION=$(curl -s "https://ipinfo.io/$USER_IP?token=880624c671d97c" | jq -r '.city + ", " + .region + ", " + .country')

AUTHORIZED_LOCATIONS=("New York, NY, US" "San Francisco, CA, US" "Dallas, TX, US")

echo "User location: $LOCATION"
echo "Authorized locations: ${AUTHORIZED_LOCATIONS[@]}"

if [[ ! " ${AUTHORIZED_LOCATIONS[@]} " =~ "$LOCATION" ]]; then
    echo "Unauthorized location detected: $LOCATION"

    # Send email alert for unauthorized location
    SUBJECT="Alert: Unauthorized Database Backup Attempt"
    MESSAGE="A database backup was attempted from an unauthorized location: $LOCATION (IP: $USER_IP) at $(date)"
    # echo "$MESSAGE" | mail -s "$SUBJECT" email@example.com

    # Log unauthorized access attempt to Papertrail
    echo "Unauthorized backup attempt from IP: $USER_IP at location: $LOCATION" | logger -t database_backup

    exit 1
fi

# Log in to Heroku CLI using the API key
echo "$HEROKU_API_KEY" | heroku auth:token --no-browser

# Capture the backup and log the action to Papertrail
heroku pg:backups:capture --app react-app-heroku-example
echo "Database backup completed at $(date) from location: $LOCATION (IP: $USER_IP)" | logger -t database_backup

echo "Database backup completed at $(date)"
