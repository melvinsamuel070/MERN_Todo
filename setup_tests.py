# import os
# import subprocess
# import sys
# from datetime import datetime

# # Set default directories if arguments are not provided
# DEFAULT_FRONTEND_DIR = "./frontend"
# DEFAULT_BACKEND_DIR = "./backend"

# # Validate arguments or use defaults
# frontend_dir = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_FRONTEND_DIR
# backend_dir = sys.argv[2] if len(sys.argv) > 2 else DEFAULT_BACKEND_DIR

# # Create a log file for debugging
# log_file = f"test_log_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"
# with open(log_file, "w") as log:

#     def run_tests(directory, name):
#         print(f"Running {name} tests in directory: {directory}...")
#         log.write(f"Running {name} tests in directory: {directory}...\n")
#         if not os.path.exists(directory):
#             log.write(f"{name} directory not found!\n")
#             print(f"{name} directory not found!")
#             sys.exit(1)
#         try:
#             os.chdir(directory)
#             subprocess.run(["npm", "install"], check=True)
#             subprocess.run(["npm", "test", "--", "--detectOpenHandles", "--verbose"], check=True)
#         except subprocess.CalledProcessError as e:
#             log.write(f"{name} tests failed\n")
#             print(f"{name} tests failed")
#             sys.exit(1)
#         finally:
#             os.chdir("..")

#     # Run tests for frontend and backend
#     run_tests(frontend_dir, "Frontend")
#     run_tests(backend_dir, "Backend")

#     print("All tests completed successfully!")
#     log.write("All tests completed successfully!\n")



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
            # Change to the directory and install dependencies
            os.chdir(directory)
            subprocess.run(["npm", "install"], check=True)

            # Ensure Babel and Jest are set up
            subprocess.run(["npm", "install", "--save-dev", "@babel/core", "@babel/preset-env", "@babel/preset-react", "babel-jest"], check=True)

            # Create Babel config file (babel.config.js)
            babel_config = """module.exports = {
  presets: [
    "@babel/preset-env",  // for modern JavaScript
    "@babel/preset-react",  // for React JSX
  ],
};
"""
            with open("babel.config.js", "w") as babel_file:
                babel_file.write(babel_config)
                log.write("Babel config created.\n")

            # Create Jest config file (jest.config.js) to handle ES modules if necessary
            jest_config = """module.exports = {
  transformIgnorePatterns: [
    "/node_modules/(?!axios)/"  // Make sure axios is transpiled
  ],
};
"""
            with open("jest.config.js", "w") as jest_file:
                jest_file.write(jest_config)
                log.write("Jest config created.\n")

            # Run tests
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
