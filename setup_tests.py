import os
import subprocess
import sys
from datetime import datetime

# Set default directories if arguments are not provided
DEFAULT_FRONTEND_DIR = "./frontend"
DEFAULT_BACKEND_DIR = "./backend"

# Validate arguments or use defaults
frontend_dir = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_FRONTEND_DIR
backend_dir = sys.argv[2] if len(sys.argv) > 2 else DEFAULT_BACKEND_DIR

# Create a log file for debugging
log_file = f"test_log_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"
with open(log_file, "w") as log:

    def run_tests(directory, name):
        print(f"Running {name} tests in directory: {directory}...")
        log.write(f"Running {name} tests in directory: {directory}...\n")
        if not os.path.exists(directory):
            log.write(f"{name} directory not found!\n")
            print(f"{name} directory not found!")
            sys.exit(1)
        try:
            os.chdir(directory)
            subprocess.run(["npm", "install"], check=True)
            subprocess.run(["npm", "test", "--", "--detectOpenHandles", "--verbose"], check=True)
        except subprocess.CalledProcessError as e:
            log.write(f"{name} tests failed\n")
            print(f"{name} tests failed")
            sys.exit(1)
        finally:
            os.chdir("..")

    # Run tests for frontend and backend
    run_tests(frontend_dir, "Frontend")
    run_tests(backend_dir, "Backend")

    print("All tests completed successfully!")
    log.write("All tests completed successfully!\n")
