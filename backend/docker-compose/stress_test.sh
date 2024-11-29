#!/bin/bash

# Variables
DOMAIN="localhost"
FRONTEND_URL="http://$DOMAIN/frontend"
BACKEND_URL="http://$DOMAIN/backend"
TOTAL_REQUESTS=1000    # Total number of requests to send
CONCURRENCY=50         # Number of concurrent requests
LOG_FILE="stress_test.log"  # Log file to store results

# Check if the service URLs are reachable
echo "Checking if frontend is reachable at $FRONTEND_URL..."
if ! curl --silent --head --fail "$FRONTEND_URL" > /dev/null; then
    echo "Error: Frontend is not reachable at $FRONTEND_URL"
    exit 1
fi

echo "Checking if backend is reachable at $BACKEND_URL..."
if ! curl --silent --head --fail "$BACKEND_URL" > /dev/null; then
    echo "Error: Backend is not reachable at $BACKEND_URL"
    exit 1
fi

# Stress test frontend
echo "Starting stress test for Frontend at $FRONTEND_URL..."
ab -n $TOTAL_REQUESTS -c $CONCURRENCY $FRONTEND_URL | tee -a $LOG_FILE
echo "Frontend stress test complete."

# Send email notification for frontend stress test completion
echo "Stress test completed for frontend." | mail -s "Frontend Stress Test Completed" your-email@example.com

# Stress test backend
echo "Starting stress test for Backend at $BACKEND_URL..."
ab -n $TOTAL_REQUESTS -c $CONCURRENCY $BACKEND_URL | tee -a $LOG_FILE
echo "Backend stress test complete."

# Send email notification for backend stress test completion
echo "Stress test completed for backend." | mail -s "Backend Stress Test Completed" your-email@example.com

echo "Stress test results stored in $LOG_FILE."
