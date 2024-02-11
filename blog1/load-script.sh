#!/bin/bash

# URL of the service to test
SERVICE_URL="http://your-service-url"

# Duration in seconds for how long to run the script
DURATION=120

# End time calculation
END_TIME=$((SECONDS+DURATION))

echo "Sending requests to $SERVICE_URL for $DURATION seconds..."

# Loop until the duration is met
while [ $SECONDS -lt $END_TIME ]; do
    curl -s $SERVICE_URL > /dev/null
    echo -n "."
    # Sleep for 1 second between requests
    sleep 1
done

echo "Load test completed."
