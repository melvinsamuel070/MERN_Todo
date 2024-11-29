# #!/bin/bash

# # Variables
# EC2_PUBLIC_IP="34.239.220.27"
# DOCKER_COMPOSE_DIR="/home/melvin/MERN_Todo/docker-compose.yaml"
# NGINX_CONF_PATH="/etc/nginx/sites-available/melvinsamuel070.xyz"
# INSTANCE_TYPE="t2.micro"
# MIN_CONTAINERS=1
# MAX_CONTAINERS=5
# STRESS_TEST_URL="http://34.239.220.27"
# FRONTEND_PORT=3000
# BACKEND_PORT=3500
# EMAIL="kingsamuel412@gmail.com"
# HEALTH_CHECK_INTERVAL="* * * * *" # Every minute
# HEALTH_CHECK_SCRIPT="/home/melvin/MERN_Todo/setup.sh"
# PROMETHEUS_CONFIG_PATH="/home/melvin/MERN_Todo/prometheus/prometheus.yml"

# # Debugging Helper
# log_debug() {
#     echo "[DEBUG] $1"
# }

# # Function to check if port is in use
# is_port_in_use() {
#     netstat -tuln | grep ":$1" > /dev/null
#     return $?
# }

# # Check and assign available port for frontend
# while is_port_in_use $FRONTEND_PORT; do
#     FRONTEND_PORT=$((FRONTEND_PORT + 1))
#     log_debug "Port $FRONTEND_PORT is in use. Trying a new port."
# done

# # Check and assign available port for backend
# while is_port_in_use $BACKEND_PORT; do
#     BACKEND_PORT=$((BACKEND_PORT + 1))
#     log_debug "Port $BACKEND_PORT is in use. Trying a new port."
# done


# # Step 1: Install Dependencies
# log_debug "Installing required dependencies..."
# sudo apt-get update
# sudo apt-get install -y nginx apache2-utils curl mailutils ca-certificates

# # Add Docker's official GPG key:
# sudo install -m 0755 -d /etc/apt/keyrings
# sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
# sudo chmod a+r /etc/apt/keyrings/docker.asc

# # Add Docker repository to Apt sources
# echo \
#   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
#   $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
#   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# # Install Docker and Docker Compose
# sudo apt-get update
# sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# # Step 2: Pull the latest Docker images
# log_debug "Pulling the latest Docker images..."
# docker pull melvinsamuel070/frontend1:latest
# docker pull melvinsamuel070/backend:latest
# docker pull prom/prometheus:latest
# docker pull grafana/grafana:latest

# # Step 3: Configure Nginx as reverse proxy
# log_debug "Configuring Nginx reverse proxy..."

# # Nginx configuration file path
# NGINX_CONF_PATH="/etc/nginx/sites-available/melvinsamuel070.xyz"

# if [ -f "$NGINX_CONF_PATH" ]; then
#     log_debug "Nginx configuration already exists. Using the existing configuration."
# else
#     log_debug "Nginx configuration does not exist. Creating a new one..."

#     # Create Nginx configuration for your domain (HTTP only, no SSL)
#     sudo tee "$NGINX_CONF_PATH" > /dev/null <<EOL
# server {
#     listen 80;
#     server_name $EC2_PUBLIC_IP;

#     # Frontend routing (React app)
#     location /frontend {
#         proxy_pass http://$EC2_PUBLIC_IP:3000;  # Frontend service
#         proxy_set_header Host \$host;
#         proxy_set_header X-Real-IP \$remote_addr;
#         proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
#     }

#     # Backend routing (Express API)
#     location /backend {
#         proxy_pass http://$EC2_PUBLIC_IP:3500;  # Backend service
#         proxy_set_header Host \$host;
#         proxy_set_header X-Real-IP \$remote_addr;
#         proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
#     }

#     # Prometheus routing
#     location /prometheus {
#         proxy_pass http://localhost:9090;
#         proxy_set_header Host \$host;
#         proxy_set_header X-Real-IP \$remote_addr;
#         proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
#     }

#     # Optional: Error handling
#     error_page 404 /404.html;
#     location = /404.html {
#         internal;
#     }
# }
# EOL

#     # Create a symbolic link from sites-available to sites-enabled
#     sudo ln -s "$NGINX_CONF_PATH" /etc/nginx/sites-enabled/

#     log_debug "Nginx configuration created and symbolic link established."
# fi

# # Test Nginx configuration
# log_debug "Testing Nginx configuration..."
# sudo nginx -t || { echo "Nginx configuration is invalid! Please check."; exit 1; }

# # Restart Nginx
# log_debug "Restarting Nginx..."
# sudo systemctl restart nginx || { echo "Failed to restart Nginx!"; exit 1; }


# # Define the Docker Compose directory
# DOCKER_COMPOSE_DIR="/home/melvin/MERN_Todo/docker-compose"  # Change to your correct directory path

# # Step 1: Deploy services using Docker Compose
# log_debug "Deploying services using Docker Compose..."

# # Navigate to the Docker Compose directory
# cd "$DOCKER_COMPOSE_DIR" || { echo "Docker Compose directory not found!"; exit 1; }

# # Tear down existing services if any and start fresh
# docker-compose down || { echo "Failed to bring down existing services!"; exit 1; }

# # Step 2: Scale the frontend and backend services
# docker-compose up -d --scale frontend=2 --scale backend=2 || { echo "Failed to deploy services!"; exit 1; }

# # Step 3: Start Prometheus and Grafana for monitoring
# echo "Starting Prometheus and Grafana for monitoring..."
# docker-compose up -d prometheus grafana || { echo "Failed to start Prometheus and Grafana!"; exit 1; }

# log_debug "Deployment complete."


# # Step 6: Configure Prometheus
# log_debug "Configuring Prometheus..."
# sudo tee "$PROMETHEUS_CONFIG_PATH" > /dev/null <<EOL
# global:
#   scrape_interval: 15s

# scrape_configs:
#   - job_name: 'frontend'
#     static_configs:
#       - targets: ['$EC2_PUBLIC_IP:$FRONTEND_PORT']

#   - job_name: 'backend'
#     static_configs:
#       - targets: ['$EC2_PUBLIC_IP:$BACKEND_PORT']
# EOL

# docker restart prometheus || { echo "Failed to restart Prometheus!"; exit 1; }

# # Step 7: Configure AlertManager
# log_debug "Configuring AlertManager..."
# ALERTMANAGER_CONFIG="/home/melvin/MERN_Todo/alertmanager/alertmanager.yml"
# sudo tee "$ALERTMANAGER_CONFIG" > /dev/null <<EOL
# global:
#   resolve_timeout: 5m

# route:
#   group_by: ['alertname']
#   group_wait: 10s
#   group_interval: 5m
#   repeat_interval: 3h
#   receiver: 'email'

# receivers:
# - name: 'email'
#   email_configs:
#   - to: kingsamuel412@gmail.com
#     from: 'melvinsamuel070@gmail.com'
#     smarthost: 'smtp.gmail.com:587'
#     auth_username: 'melvinsamuel070@gmail.com'
#     auth_password: 'wetz gzvg rmbm eqqo'
#     send_resolved: true
# EOL

# docker restart alertmanager || { echo "Failed to restart AlertManager!"; exit 1; }

# # Step 8: Perform Stress Test
# log_debug "Performing stress test using Apache Benchmark..."
# ab -n 1000 -c 100 "$STRESS_TEST_URL"

# # Step 9: Create Health Check Script
# log_debug "Creating health check script..."
# sudo tee "$HEALTH_CHECK_SCRIPT" > /dev/null <<EOL
# #!/bin/bash
# FRONTEND_HEALTH=\$(curl -s -o /dev/null -w "%{http_code}" http://$EC2_PUBLIC_IP:$FRONTEND_PORT/health)
# BACKEND_HEALTH=\$(curl -s -o /dev/null -w "%{http_code}" http://$EC2_PUBLIC_IP:$BACKEND_PORT/api/health)

# send_notification() {
#     echo "\$1" | mail -s "Health Check Alert" $EMAIL
# }

# if [ "\$FRONTEND_HEALTH" -ne 200 ]; then
#     send_notification "Frontend service is down (HTTP \$FRONTEND_HEALTH)"
# fi

# if [ "\$BACKEND_HEALTH" -ne 200 ]; then
#     send_notification "Backend service is down (HTTP \$BACKEND_HEALTH)"
# fi
# EOL

# chmod +x "$HEALTH_CHECK_SCRIPT"

# # Step 10: Set up Cron Job
# log_debug "Setting up cron job for periodic health checks..."
# (crontab -l 2>/dev/null; echo "$HEALTH_CHECK_INTERVAL $HEALTH_CHECK_SCRIPT") | crontab -

# # Deployment Complete
# log_debug "Deployment complete. Services are running at:"
# log_debug "Frontend: http://$EC2_PUBLIC_IP/frontend"
# log_debug "Backend: http://$EC2_PUBLIC_IP/backend"
# log_debug "Prometheus: http://$EC2_PUBLIC_IP/prometheus"
# log_debug "Grafana: http://$EC2_PUBLIC_IP/grafana"







































#!/bin/bash

# Variables
DOMAIN="localhost"        # Local development domain
FRONTEND_PORT=3000        # Port for the frontend application
BACKEND_PORT=3500         # Port for the backend application
CONFIG_PATH="/etc/nginx/sites-available/$DOMAIN"
LINK_PATH="/etc/nginx/sites-enabled/$DOMAIN"
DOCKER_COMPOSE_PATH="/home/melvin/MERN_Todo/backend/docker-compose/docker-compose.yml" # Adjust to the path of your docker-compose.yml

# Check if running as root
if [ $EUID -ne 0 ]; then
   echo "This script must be run as root"
   exit 1
fi

# Install Nginx if not installed
if ! command -v nginx &> /dev/null; then
    echo "Nginx is not installed. Installing Nginx..."
    apt update
    apt install -y nginx
    if [ $? -ne 0 ]; then
        echo "Failed to install Nginx. Exiting..."
        exit 1
    fi
else
    echo "Nginx is already installed."
fi

# Create Nginx configuration file
echo "Creating Nginx configuration for $DOMAIN..."

cat <<EOL > $CONFIG_PATH
server {
    listen 80;
    server_name $DOMAIN;

    # Frontend routing
    location /frontend {
        proxy_pass http://frontend:$FRONTEND_PORT;  # Docker service name for frontend
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    # Backend routing
    location /backend {
        proxy_pass http://backend:$BACKEND_PORT;  # Docker service name for backend
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    # Error handling
    error_page 404 /404.html;
    location = /404.html {
        internal;
    }
}
EOL

if [ $? -eq 0 ]; then
    echo "Nginx configuration created successfully at $CONFIG_PATH."
else
    echo "Failed to create Nginx configuration. Exiting..."
    exit 1
fi

# Enable the configuration
if [ -e $LINK_PATH ]; then
    echo "Removing existing symbolic link at $LINK_PATH..."
    rm $LINK_PATH
fi

ln -s $CONFIG_PATH $LINK_PATH
if [ $? -eq 0 ]; then
    echo "Configuration enabled successfully."
else
    echo "Failed to enable Nginx configuration. Exiting..."
    exit 1
fi

# Test Nginx configuration
echo "Testing Nginx configuration..."
nginx -t

if [ $? -ne 0 ]; then
    echo "Nginx configuration test failed. Please check the configuration."
    EMAIL="melvinsamuel070@gmail.com"
    echo "Nginx configuration test failed for $DOMAIN." | mail -s "Nginx Setup Failed" $EMAIL
    exit 1
else
    echo "Nginx configuration test passed."
fi

# Reload Nginx
echo "Reloading Nginx to apply changes..."
systemctl reload nginx
if [ $? -eq 0 ]; then
    echo "Nginx reloaded successfully."
else
    echo "Failed to reload Nginx. Please check the service status."
    EMAIL="melvinsamuel070@gmail.com"
    echo "Failed to reload Nginx for $DOMAIN." | mail -s "Nginx Reload Failed" $EMAIL
    exit 1
fi

# Verify Docker Compose file exists
if [ ! -f "$DOCKER_COMPOSE_PATH" ]; then
    echo "Docker Compose file not found at $DOCKER_COMPOSE_PATH. Exiting..."
    exit 1
fi

# Start Docker containers using Docker Compose
echo "Starting Docker containers using Docker Compose..."
cd $(dirname "$DOCKER_COMPOSE_PATH") || { echo "Failed to navigate to Docker Compose directory. Exiting..."; exit 1; }
docker-compose -f "$DOCKER_COMPOSE_PATH" up -d

if [ $? -eq 0 ]; then
    echo "Docker containers started successfully."
else
    echo "Failed to start Docker containers. Exiting..."
    EMAIL="melvinsamuel070@gmail.com"
    echo "Failed to start Docker containers for $DOMAIN." | mail -s "Docker Startup Failed" $EMAIL
    exit 1
fi

# Final success message
echo "Reverse proxy setup complete. Frontend available at http://$DOMAIN/frontend and backend at http://$DOMAIN/backend."
EMAIL="melvinsamuel070@gmail.com"
echo "Reverse proxy setup completed successfully for $DOMAIN" | mail -s "Nginx and Docker Setup Success" $EMAIL
