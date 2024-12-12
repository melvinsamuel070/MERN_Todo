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

# Run frontend tests
echo "Running frontend tests..."
cd "$1" || exit
npm install

# Run frontend tests with --detectOpenHandles to check for open asynchronous operations
npm test -- --detectOpenHandles || { echo "Frontend tests failed"; exit 1; }

# Run backend tests
echo "Running backend tests..."
cd "$2" || exit
npm install

# Run backend tests with --detectOpenHandles
npm test -- --detectOpenHandles || { echo "Backend tests failed"; exit 1; }
