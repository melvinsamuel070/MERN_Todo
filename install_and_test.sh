#!/bin/bash

set -e

# Run frontend tests
echo "Running frontend tests..."
cd "$1" || exit
npm install
npm test

# Run backend tests
echo "Running backend tests..."
cd "$2" || exit
npm install
npm test
