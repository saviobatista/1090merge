#!/bin/bash

HOST="$1"
PORT="30003"
LOG_FILE="/data/adsb.csv"
MAX_RETRIES=5
RETRY_DELAY=30

echo "Starting capture for host: $HOST"

while true; do
    echo "$(date): Attempting to connect to $HOST:$PORT"
    
    # Try to connect with timeout and retry logic
    for attempt in $(seq 1 $MAX_RETRIES); do
        if nc -w 10 "$HOST" "$PORT" >> "$LOG_FILE" 2>/dev/null; then
            echo "$(date): Successfully connected to $HOST:$PORT"
            break
        else
            echo "$(date): Connection attempt $attempt/$MAX_RETRIES failed for $HOST:$PORT"
            if [ $attempt -lt $MAX_RETRIES ]; then
                echo "$(date): Retrying in $RETRY_DELAY seconds..."
                sleep $RETRY_DELAY
            fi
        fi
    done
    
    # If we get here, all retries failed
    echo "$(date): All connection attempts failed for $HOST:$PORT. Waiting 60 seconds before retrying..."
    sleep 60
done