#!/bin/bash

# Variables
LOCUST_HOST="http://localhost"   # URL of your service
TOTAL_USERS=100                 # Number of concurrent users
SPAWN_RATE=10                   # Hatch rate (users spawned per second)
LOG_FILE="locust_output.log"    # Log file to store Locust output

# Check if Locust is installed
if ! command -v locust &> /dev/null; then
    echo "Locust is not installed. Installing Locust..."
    sudo pip3 install locust
fi

# Check if locustfile.py exists
if [ ! -f "locustfile.py" ]; then
    echo "locustfile.py not found. Please ensure it is in the current directory."
    exit 1
fi

# Ensure the host is reachable
echo "Checking if the host ($LOCUST_HOST) is reachable..."
if ! curl --silent --head --fail "$LOCUST_HOST"; then
    echo "Host $LOCUST_HOST is not reachable. Please check your service."
    exit 1
fi

# Run Locust in headless mode (no web UI) and specify the number of users and spawn rate
echo "Starting stress test using Locust..."
locust -f locustfile.py --host=$LOCUST_HOST --users=$TOTAL_USERS --spawn-rate=$SPAWN_RATE --headless | tee $LOG_FILE

# Completion message
echo "Stress test completed. Results are stored in $LOG_FILE."
