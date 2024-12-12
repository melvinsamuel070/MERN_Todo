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

# Create a log file for debugging
LOG_FILE="test_log_$(date +'%Y%m%d_%H%M%S').log"
exec > >(tee -i "$LOG_FILE") 2>&1

# Function to run tests
run_tests() {
    local dir="$1"
    local name="$2"
    
    echo "Running $name tests in directory: $dir..."
    cd "$dir" || { echo "$name directory not found!"; exit 1; }
    npm install
    npm test -- --detectOpenHandles --verbose || { echo "$name tests failed"; exit 1; }
}

# Run tests sequentially to avoid race conditions
run_tests "$1" "Frontend"
run_tests "$2" "Backend"

echo "All tests completed successfully!"
