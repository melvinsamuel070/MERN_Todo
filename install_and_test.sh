# #!/bin/bash

# set -e

# # Run frontend tests
# echo "Running frontend tests..."
# cd "$1" || exit
# npm install
# npm test

# # Run backend tests
# echo "Running backend tests..."
# cd "$2" || exit
# npm install
# npm test













#!/bin/bash

set -e

# Check for required parameters
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <frontend-directory> <backend-directory>"
    exit 1
fi

# Log file for debugging
LOG_FILE="test_log_$(date +'%Y%m%d_%H%M%S').log"
exec > >(tee -i $LOG_FILE) 2>&1

# Run frontend tests
(
    echo "Running frontend tests..."
    cd "$1" || exit
    npm install
    npm test -- --detectOpenHandles --verbose || { echo "Frontend tests failed"; exit 1; }
) &

# Run backend tests
(
    echo "Running backend tests..."
    cd "$2" || exit
    npm install
    npm test -- --detectOpenHandles --verbose || { echo "Backend tests failed"; exit 1; }
) &

wait # Wait for both tests to complete

echo "All tests completed successfully!"
