#!/bin/bash

# # Define environment variables
# REGION="us-east-1"
# ALB_NAME="my-application-load-balancer"
# FRONTEND_TARGET_GROUP="frontend-target-group"
# BACKEND_TARGET_GROUP="backend-target-group"
# FRONTEND_HEALTH_CHECK_PATH="/frontend/health"
# BACKEND_HEALTH_CHECK_PATH="/backend/health"
# INSTANCE_ID="i-03f9177a9ad8424af"  # Replace with your actual instance ID
# VPC_ID="vpc-0add2fb72df39a9c1"  # Replace with your actual VPC ID
# SUBNET_1="subnet-02880d91de224e450"  # Replace with your first subnet ID
# SUBNET_2="subnet-0b5d72be29ca4e2f9"  # Replace with your second subnet ID
# SECURITY_GROUP_ID="sg-0d7a43a04fa8df0c9"  # Replace with your actual security group ID
# AMI_ID="ami-005fc0f236362e99f"  # Replace with your desired AMI ID
# INSTANCE_TYPE="t2.micro"

# # Directory housing your existing Docker Compose files
# DOCKER_COMPOSE_DIR="/home/ubuntu/mybash-bash/MERN_Todo_app"

# # Nginx configuration file path
# NGINX_CONF="/etc/nginx/sites-available/melvinsamuel070.xyz"
# SSL_DIR="/etc/nginx/ssl"
# DOMAIN="melvinsamuel070.xyz"
# FULLCHAIN_FILE="/etc/letsencrypt/live/$DOMAIN/fullchain.pem"
# PRIVKEY_FILE="/etc/letsencrypt/live/$DOMAIN/main-pro.pem"
# SELF_SIGNED_KEY="$SSL_DIR/nginx-selfsigned.key"
# SELF_SIGNED_CRT="$SSL_DIR/nginx-selfsigned.crt"

# # Function to create a self-signed SSL certificate if fullchain.pem is missing
# create_self_signed_cert() {
#     echo "Checking for existing full chain SSL certificate..."
#     if [ -f "$FULLCHAIN_FILE" ] && [ -f "$PRIVKEY_FILE" ]; then
#         echo "Found existing full chain SSL certificate."
#     else
#         echo "Full chain SSL certificate not found. Creating a self-signed SSL certificate..."
#         sudo mkdir -p "$SSL_DIR"
#         sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
#             -keyout "$SELF_SIGNED_KEY" -out "$SELF_SIGNED_CRT" -subj "/CN=$DOMAIN"
#         echo "Self-signed SSL certificate created."
#     fi
# }

# # Function to configure Nginx
# configure_nginx() {
#     echo "Configuring Nginx to use SSL..."

#     # Set SSL certificate and key file paths based on availability
#     if [ -f "$FULLCHAIN_FILE" ] && [ -f "$PRIVKEY_FILE" ]; then
#         CRT_FILE="$FULLCHAIN_FILE"
#         KEY_FILE="$PRIVKEY_FILE"
#     else
#         CRT_FILE="$SELF_SIGNED_CRT"
#         KEY_FILE="$SELF_SIGNED_KEY"
#     fi

#     # Create Nginx configuration
#     sudo tee "$NGINX_CONF" > /dev/null <<EOF
# # Redirect HTTP to HTTPS
# server {
#     listen 80;
#     server_name $DOMAIN www.$DOMAIN;

#     return 301 https://\$host\$request_uri;
# }

# # Main server block for handling HTTPS
# server {
#     listen 443 ssl;
#     server_name $DOMAIN www.$DOMAIN;

#     # SSL configuration
#     ssl_certificate $CRT_FILE;
#     ssl_certificate_key $KEY_FILE;

#     # Location block for the frontend
#     location /frontend {
#         proxy_pass http://23.21.83.242:3000;  # Backend for frontend application
#         proxy_set_header Host \$host;
#         proxy_set_header X-Real-IP \$remote_addr;
#         proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
#         proxy_set_header X-Forwarded-Proto \$scheme;
#     }

#     # Location block for the backend
#     location /backend {
#         proxy_pass http://23.21.83.242:3500;  # Backend for backend application
#         proxy_set_header Host \$host;
#         proxy_set_header X-Real-IP \$remote_addr;
#         proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
#         proxy_set_header X-Forwarded-Proto \$scheme;
#     }

#     # Location block for Prometheus
#     location /prometheus {
#         proxy_pass http://localhost:9090;  # Updated to Prometheus port 9090
#         proxy_set_header Host \$host;
#         proxy_set_header X-Real-IP \$remote_addr;
#         proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
#         proxy_set_header X-Forwarded-Proto \$scheme;
#     }

#     # Optional: Error handling
#     error_page 404 /404.html;  # Customize your 404 error page
#     location = /404.html {
#         internal;
#     }
# }
# EOF

#     # Remove existing symbolic link if it exists
#     if [ -L /etc/nginx/sites-enabled/melvinsamuel070.xyz ]; then
#         sudo rm /etc/nginx/sites-enabled/melvinsamuel070.xyz
#         echo "Removed existing symbolic link for Nginx configuration."
#     fi

#     # Link the configuration and reload Nginx
#     sudo ln -s "$NGINX_CONF" /etc/nginx/sites-enabled/
#     sudo nginx -t && sudo systemctl reload nginx
#     echo "Nginx configured and reloaded successfully."
# }

# # Create SSL certificate and configure Nginx
# create_self_signed_cert
# configure_nginx

# # Navigate to your Docker Compose directory
# cd "$DOCKER_COMPOSE_DIR" || { echo "Directory not found: $DOCKER_COMPOSE_DIR"; exit 1; }

# # Step 1: Create Application Load Balancer
# echo "Creating Application Load Balancer..."
# ALB_ARN=$(aws elbv2 create-load-balancer \
#     --name "$ALB_NAME" \
#     --subnets "$SUBNET_1" "$SUBNET_2" \
#     --security-groups "$SECURITY_GROUP_ID" \
#     --scheme internet-facing \
#     --region "$REGION" \
#     --query "LoadBalancers[0].LoadBalancerArn" \
#     --output text)

# echo "ALB created: $ALB_ARN"

# # Step 2: Create Target Group for Frontend
# echo "Creating Target Group for Frontend..."
# FRONTEND_TARGET_GROUP_ARN=$(aws elbv2 create-target-group \
#     --name "$FRONTEND_TARGET_GROUP" \
#     --protocol HTTP \
#     --port 80 \
#     --vpc-id "$VPC_ID" \
#     --health-check-protocol HTTP \
#     --health-check-path "$FRONTEND_HEALTH_CHECK_PATH" \
#     --health-check-interval-seconds 30 \
#     --health-check-timeout-seconds 5 \
#     --healthy-threshold-count 2 \
#     --unhealthy-threshold-count 2 \
#     --region "$REGION" \
#     --query "TargetGroups[0].TargetGroupArn" \
#     --output text)

# echo "Frontend Target Group created: $FRONTEND_TARGET_GROUP_ARN"

# # Step 3: Create Target Group for Backend
# echo "Creating Target Group for Backend..."
# BACKEND_TARGET_GROUP_ARN=$(aws elbv2 create-target-group \
#     --name "$BACKEND_TARGET_GROUP" \
#     --protocol HTTP \
#     --port 80 \
#     --vpc-id "$VPC_ID" \
#     --health-check-protocol HTTP \
#     --health-check-path "$BACKEND_HEALTH_CHECK_PATH" \
#     --health-check-interval-seconds 30 \
#     --health-check-timeout-seconds 5 \
#     --healthy-threshold-count 2 \
#     --unhealthy-threshold-count 2 \
#     --region "$REGION" \
#     --query "TargetGroups[0].TargetGroupArn" \
#     --output text)

# echo "Backend Target Group created: $BACKEND_TARGET_GROUP_ARN"

# # Step 4: Register targets for Frontend and Backend
# echo "Registering targets for Frontend and Backend..."
# aws elbv2 register-targets --target-group-arn "$FRONTEND_TARGET_GROUP_ARN" --targets Id="$INSTANCE_ID" --region "$REGION"
# aws elbv2 register-targets --target-group-arn "$BACKEND_TARGET_GROUP_ARN" --targets Id="$INSTANCE_ID" --region "$REGION"

# # Step 5: Create Listeners for the ALB
# echo "Creating listener for the ALB to forward traffic to the Frontend..."
# FRONTEND_LISTENER_ARN=$(aws elbv2 create-listener \
#     --load-balancer-arn "$ALB_ARN" \
#     --protocol HTTP \
#     --port 80 \
#     --default-actions Type=forward,TargetGroupArn="$FRONTEND_TARGET_GROUP_ARN" \
#     --region "$REGION" \
#     --query "Listeners[0].ListenerArn" \
#     --output text)

# echo "ALB listener for Frontend created."

# # Create Listener Rule for Backend (path-based routing)
# echo "Creating listener rule for Backend..."
# aws elbv2 create-rule \
#     --listener-arn "$FRONTEND_LISTENER_ARN" \
#     --priority 1 \
#     --conditions Field=path-pattern,Values="/backend/*" \
#     --actions Type=forward,TargetGroupArn="$BACKEND_TARGET_GROUP_ARN" \
#     --region "$REGION"

# echo "ALB listener rule for Backend created."

# # Step 6: Check if the launch template already exists
# LAUNCH_TEMPLATE_NAME="my-launch-template"
# EXISTING_TEMPLATE_ID=$(aws ec2 describe-launch-templates \
#     --launch-template-names "$LAUNCH_TEMPLATE_NAME" \
#     --region "$REGION" \
#     --query "LaunchTemplates[0].LaunchTemplateId" \
#     --output text)

# if [ "$EXISTING_TEMPLATE_ID" ]; then
#     echo "Using existing launch template: $EXISTING_TEMPLATE_ID"
# else
#     # Step 6: Create Launch Template
#     echo "Creating Launch Template..."
#     LAUNCH_TEMPLATE_ID=$(aws ec2 create-launch-template \
#         --launch-template-name "$LAUNCH_TEMPLATE_NAME" \
#         --version-description "Initial version" \
#         --launch-template-data "{\"ImageId\":\"$AMI_ID\", \"InstanceType\":\"$INSTANCE_TYPE\", \"SecurityGroupIds\":[\"$SECURITY_GROUP_ID\"]}" \
#         --region "$REGION" \
#         --query "LaunchTemplate.LaunchTemplateId" \
#         --output text)

#     echo "Launch Template created: $LAUNCH_TEMPLATE_ID"
# fi

# # Step 7: Create Auto Scaling Group
# echo "Creating Auto Scaling Group..."
# if [ -z "$EXISTING_TEMPLATE_ID" ]; then
#     # Use $Latest if the template is newly created
#     LAUNCH_TEMPLATE_VERSION="$LAUNCH_TEMPLATE_ID"
# else
#     # Use the latest version of the existing template
#     LAUNCH_TEMPLATE_VERSION="$EXISTING_TEMPLATE_ID"
#     LAUNCH_TEMPLATE_VERSION="$(
#         aws ec2 describe-launch-template-versions \
#             --launch-template-id "$EXISTING_TEMPLATE_ID" \
#             --query 'sort_by(LaunchTemplateVersions,&VersionNumber)[-1].[VersionNumber]' \
#             --output text
#     )"
# fi

# aws autoscaling create-auto-scaling-group \
#     --auto-scaling-group-name "my-auto-scaling-group" \
#     --launch-template "LaunchTemplateName=$LAUNCH_TEMPLATE_NAME,Version=$LAUNCH_TEMPLATE_VERSION" \
#     --min-size 1 \
#     --max-size 3 \
#     --desired-capacity 1 \
#     --vpc-zone-identifier "$SUBNET_1,$SUBNET_2" \
#     --region "$REGION"

# echo "Auto Scaling Group created."

# # Final confirmation
# echo "Setup complete. Application Load Balancer and Auto Scaling Group are configured."

# # Step 9: Start Docker Compose
# echo "Starting Docker containers with Docker Compose..."
# docker compose up -d

# echo "Docker containers are up and running."


#!/bin/bash

# Enable debugging and set error handling
set -e
set -x
trap 'echo "Error on line $LINENO"; exit 1' ERR

# Variables
AWS_REGION="us-east-1"
VPC_ID="vpc-06349688cec80497a"                       # Replace with your VPC ID
SUBNET_1="subnet-096394880b9a77904"
SUBNET_2="subnet-0afa998e4cb61fc10"                  # Two subnets in different AZs
SUBNET_IDS="${SUBNET_1},${SUBNET_2}"                 # Comma-separated list of subnets
SECURITY_GROUP_ID="sg-0cf064343aed6695f"             # Replace with your Security Group ID
EXISTING_INSTANCE_ID="i-0f1ed4688cf5c4fe1"           # Replace with your instance ID
AMI_ID="ami-0866a3c8686eaeeba"                       # Replace with your AMI ID
INSTANCE_TYPE="t2.micro"                             # Adjust instance type as needed
KEY_PAIR="main-pro.pem"                              # Replace with your Key Pair
FRONTEND_PORT=3000                                   # Adjust frontend port if different
BACKEND_PORT=3500                                    # Adjust backend port if different
ALERT_THRESHOLD=5                                    # Example alert threshold for scaling

# Create Launch Template
LAUNCH_TEMPLATE_NAME="MyAutoScalingTemplateTest-$(date +%Y%m%d%H%M%S)"
LAUNCH_TEMPLATE_ID=$(aws ec2 create-launch-template \
    --region $AWS_REGION \
    --launch-template-name "$LAUNCH_TEMPLATE_NAME" \
    --version-description "v1" \
    --launch-template-data "{
        \"ImageId\": \"$AMI_ID\",
        \"InstanceType\": \"$INSTANCE_TYPE\",
        \"KeyName\": \"$KEY_PAIR\",
        \"SecurityGroupIds\": [\"$SECURITY_GROUP_ID\"]
    }" \
    --query 'LaunchTemplate.LaunchTemplateId' \
    --output text)

echo "Launch Template ID: $LAUNCH_TEMPLATE_ID"

# Create Target Groups
FRONTEND_TG_ARN=$(aws elbv2 create-target-group \
    --region $AWS_REGION \
    --name "FrontendTG" \
    --protocol HTTP \
    --port $FRONTEND_PORT \
    --vpc-id $VPC_ID \
    --target-type instance \
    --health-check-protocol HTTP \
    --health-check-port "$FRONTEND_PORT" \
    --health-check-path "/health" \
    --query 'TargetGroups[0].TargetGroupArn' \
    --output text)
echo "Frontend Target Group ARN: $FRONTEND_TG_ARN"

BACKEND_TG_ARN=$(aws elbv2 create-target-group \
    --region $AWS_REGION \
    --name "BackendTG" \
    --protocol HTTP \
    --port $BACKEND_PORT \
    --vpc-id $VPC_ID \
    --target-type instance \
    --health-check-protocol HTTP \
    --health-check-port "$BACKEND_PORT" \
    --health-check-path "/todo" \
    --query 'TargetGroups[0].TargetGroupArn' \
    --output text)
echo "Backend Target Group ARN: $BACKEND_TG_ARN"

# Create Application Load Balancer
echo "Creating Application Load Balancer..."
ALB_ARN=$(aws elbv2 create-load-balancer \
    --region $AWS_REGION \
    --name "MyApplicationLoadBalancer" \
    --subnets $SUBNET_1 $SUBNET_2 \
    --security-groups $SECURITY_GROUP_ID \
    --scheme internet-facing \
    --type application \
    --query 'LoadBalancers[0].LoadBalancerArn' \
    --output text)
echo "ALB ARN: $ALB_ARN"

# Create Listener and Add Rules
LISTENER_ARN=$(aws elbv2 create-listener \
    --region $AWS_REGION \
    --load-balancer-arn $ALB_ARN \
    --protocol HTTP \
    --port 80 \
    --default-actions '[{"Type":"fixed-response","FixedResponseConfig":{"StatusCode":"404","ContentType":"text/plain","MessageBody":"Not Found"}}]' \
    --query "Listeners[0].ListenerArn" \
    --output text)
echo "Listener ARN: $LISTENER_ARN"

aws elbv2 create-rule \
    --region $AWS_REGION \
    --listener-arn $LISTENER_ARN \
    --priority 10 \
    --conditions '[{"Field":"path-pattern","PathPatternConfig":{"Values":["/frontend/*"]}}]' \
    --actions '[{"Type":"forward","TargetGroupArn":"'"$FRONTEND_TG_ARN"'"}]'

aws elbv2 create-rule \
    --region $AWS_REGION \
    --listener-arn $LISTENER_ARN \
    --priority 20 \
    --conditions '[{"Field":"path-pattern","PathPatternConfig":{"Values":["/backend/*"]}}]' \
    --actions '[{"Type":"forward","TargetGroupArn":"'"$BACKEND_TG_ARN"'"}]'
echo "Rules created."

# Create Auto Scaling Group
aws autoscaling create-auto-scaling-group \
    --region $AWS_REGION \
    --auto-scaling-group-name "MyAutoScalingGroup" \
    --launch-template "LaunchTemplateId=$LAUNCH_TEMPLATE_ID,Version=1" \
    --min-size 1 \
    --max-size 3 \
    --desired-capacity 1 \
    --vpc-zone-identifier "$SUBNET_IDS" \
    --target-group-arns $FRONTEND_TG_ARN $BACKEND_TG_ARN \
    --health-check-type "ELB" \
    --health-check-grace-period 300 \
    --query 'AutoScalingGroups[0].AutoScalingGroupName' \
    --output text
echo "Auto Scaling Group created."

# Attach Existing Instance to Target Groups
aws elbv2 register-targets --region $AWS_REGION --target-group-arn $FRONTEND_TG_ARN --targets Id=$EXISTING_INSTANCE_ID
aws elbv2 register-targets --region $AWS_REGION --target-group-arn $BACKEND_TG_ARN --targets Id=$EXISTING_INSTANCE_ID
echo "Existing Instance attached to Target Groups."

# Add Scaling Policies
aws autoscaling put-scaling-policy \
    --region $AWS_REGION \
    --auto-scaling-group-name "MyAutoScalingGroup" \
    --policy-name "ScaleUpPolicy" \
    --adjustment-type ChangeInCapacity \
    --scaling-adjustment 2 \
    --cooldown 2

aws autoscaling put-scaling-policy \
    --region $AWS_REGION \
    --auto-scaling-group-name "MyAutoScalingGroup" \
    --policy-name "ScaleDownPolicy" \
    --adjustment-type ChangeInCapacity \
    --scaling-adjustment -2 \
    --cooldown 2

echo "Scaling policies added."


#!/bin/bash

# Update Prometheus Scrape Configuration
sudo mkdir -p /etc/prometheus
cat <<EOL | sudo tee /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'frontend'
    metrics_path: '/metrics'
    static_configs:
      - targets: ['34.239.220.27:$FRONTEND_PORT']

  - job_name: 'backend'
    metrics_path: '/metrics'
    static_configs:
      - targets: ['34.239.220.27:$BACKEND_PORT']

  - job_name: 'ALB'
    metrics_path: '/metrics'
    static_configs:
      - targets: ['MyApplicationLoadBalancer-1732619967.us-east-1.elb.amazonaws.com:80']
EOL

echo "Prometheus scrape configuration updated."

# Update Alertmanager Configuration
sudo mkdir -p /etc/alertmanager
cat <<EOL | sudo tee /etc/alertmanager/alertmanager.yml
global:
  resolve_timeout: 5m

route:
  receiver: 'email'
  group_by: ['alertname']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 1h

receivers:
- name: 'email'
  email_configs:
  - to: 'kingsamuel412@gmail.com'
    from: 'melvinsamuel070@gmail.com'
    smarthost: 'smtp.gmail.com:587'
    auth_username: 'melvinsamuel070@gmail.com'
    auth_password: 'wetz gzvg rmbm eqqo'
    send_resolved: true
EOL

echo "Alertmanager configuration updated."

# Update Grafana Data Source
sudo mkdir -p /etc/grafana/provisioning/datasources
cat <<EOL | sudo tee /etc/grafana/provisioning/datasources/prometheus.yml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://localhost:9090
    isDefault: true
EOL

echo "Grafana data source configuration updated."


# Schedule Stress Test with Cron
CRON_JOB="* * * * * curl -s http://MyApplicationLoadBalancer-1854220763.us-east-1.elb.amazonaws.com/frontend/health > /dev/null && curl -s http://MyApplicationLoadBalancer-1854220763.us-east-1.elb.amazonaws.com/backend/todo > /dev/null"
(crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
echo "Cron job added to schedule stress tests."























# ## THE LATEST BASH SCRIPTING     BSD


# #!/bin/bash

# # Enable debugging and set error handling
# set -x
# trap 'echo "Error on line $LINENO"; exit 1' ERR

# # Variables
# AWS_REGION="us-east-1"
# VPC_ID="vpc-06349688cec80497a"                       # Replace with your VPC ID
# SUBNET_1="subnet-096394880b9a77904"
# SUBNET_2="subnet-0afa998e4cb61fc10"                  # Two subnets in different AZs
# SUBNET_IDS="${SUBNET_1},${SUBNET_2}"                 # Comma-separated list of subnets
# SECURITY_GROUP_ID="sg-0cf064343aed6695f"             # Replace with your Security Group ID
# EXISTING_INSTANCE_ID="i-002ac3bf9f31fc7b0"           # Replace with your instance ID
# AMI_ID="ami-0866a3c8686eaeeba"                       # Replace with your AMI ID
# INSTANCE_TYPE="t2.micro"                             # Adjust instance type as needed
# KEY_PAIR="main-pro.pem"                              # Replace with your Key Pair
# FRONTEND_PORT=3000                                   # Adjust frontend port if different
# BACKEND_PORT=3500                                    # Adjust backend port if different
# ALERT_THRESHOLD=5                                    # Example alert threshold for scaling

# # Create Launch Template
# LAUNCH_TEMPLATE_NAME="MyAutoScalingTemplateTest-$(date +%Y%m%d%H%M%S)"
# LAUNCH_TEMPLATE_ID=$(aws ec2 create-launch-template \
#     --region $AWS_REGION \
#     --launch-template-name "$LAUNCH_TEMPLATE_NAME" \
#     --version-description "v1" \
#     --launch-template-data "{
#         \"ImageId\": \"$AMI_ID\",
#         \"InstanceType\": \"$INSTANCE_TYPE\",
#         \"KeyName\": \"$KEY_PAIR\",
#         \"SecurityGroupIds\": [\"$SECURITY_GROUP_ID\"]
#     }" \
#     --query 'LaunchTemplate.LaunchTemplateId' \
#     --output text)

# echo "Launch Template ID: $LAUNCH_TEMPLATE_ID"

# # Create Target Groups
# FRONTEND_TG_ARN=$(aws elbv2 create-target-group \
#     --region $AWS_REGION \
#     --name "FrontendTG" \
#     --protocol HTTP \
#     --port $FRONTEND_PORT \
#     --vpc-id $VPC_ID \
#     --target-type instance \
#     --health-check-protocol HTTP \
#     --health-check-port "$FRONTEND_PORT" \
#     --health-check-path "/health" \
#     --query 'TargetGroups[0].TargetGroupArn' \
#     --output text)
# echo "Frontend Target Group ARN: $FRONTEND_TG_ARN"

# BACKEND_TG_ARN=$(aws elbv2 create-target-group \
#     --region $AWS_REGION \
#     --name "BackendTG" \
#     --protocol HTTP \
#     --port $BACKEND_PORT \
#     --vpc-id $VPC_ID \
#     --target-type instance \
#     --health-check-protocol HTTP \
#     --health-check-port "$BACKEND_PORT" \
#     --health-check-path "/todo" \
#     --query 'TargetGroups[0].TargetGroupArn' \
#     --output text)
# echo "Backend Target Group ARN: $BACKEND_TG_ARN"

# # Create Application Load Balancer
# echo "Creating Application Load Balancer..."
# ALB_ARN=$(aws elbv2 create-load-balancer \
#     --region $AWS_REGION \
#     --name "MyApplicationLoadBalancer" \
#     --subnets $SUBNET_1 $SUBNET_2 \
#     --security-groups $SECURITY_GROUP_ID \
#     --scheme internet-facing \
#     --type application \
#     --query 'LoadBalancers[0].LoadBalancerArn' \
#     --output text)
# echo "ALB ARN: $ALB_ARN"

# # Create Listener and Add Rules
# LISTENER_ARN=$(aws elbv2 create-listener \
#     --region $AWS_REGION \
#     --load-balancer-arn $ALB_ARN \
#     --protocol HTTP \
#     --port 80 \
#     --default-actions '[{"Type":"fixed-response","FixedResponseConfig":{"StatusCode":"404","ContentType":"text/plain","MessageBody":"Not Found"}}]' \
#     --query "Listeners[0].ListenerArn" \
#     --output text)
# echo "Listener ARN: $LISTENER_ARN"

# aws elbv2 create-rule \
#     --region $AWS_REGION \
#     --listener-arn $LISTENER_ARN \
#     --priority 10 \
#     --conditions '[{"Field":"path-pattern","PathPatternConfig":{"Values":["/frontend/*"]}}]' \
#     --actions '[{"Type":"forward","TargetGroupArn":"'"$FRONTEND_TG_ARN"'"}]'

# aws elbv2 create-rule \
#     --region $AWS_REGION \
#     --listener-arn $LISTENER_ARN \
#     --priority 20 \
#     --conditions '[{"Field":"path-pattern","PathPatternConfig":{"Values":["/backend/*"]}}]' \
#     --actions '[{"Type":"forward","TargetGroupArn":"'"$BACKEND_TG_ARN"'"}]'
# echo "Rules created."

# # Create Auto Scaling Group
# aws autoscaling create-auto-scaling-group \
#     --region $AWS_REGION \
#     --auto-scaling-group-name "MyAutoScalingGroup" \
#     --launch-template "LaunchTemplateId=$LAUNCH_TEMPLATE_ID,Version=1" \
#     --min-size 1 \
#     --max-size 3 \
#     --desired-capacity 1 \
#     --vpc-zone-identifier "$SUBNET_IDS" \
#     --target-group-arns $FRONTEND_TG_ARN $BACKEND_TG_ARN
# echo "Auto Scaling Group created."

# # Attach Existing Instance to Target Groups
# aws elbv2 register-targets --region $AWS_REGION --target-group-arn $FRONTEND_TG_ARN --targets Id=$EXISTING_INSTANCE_ID
# aws elbv2 register-targets --region $AWS_REGION --target-group-arn $BACKEND_TG_ARN --targets Id=$EXISTING_INSTANCE_ID
# echo "Existing Instance attached to Target Groups."

# # Add Scaling Policies
# aws autoscaling put-scaling-policy \
#     --region $AWS_REGION \
#     --auto-scaling-group-name "MyAutoScalingGroup" \
#     --policy-name "ScaleUpPolicy" \
#     --adjustment-type ChangeInCapacity \
#     --scaling-adjustment 2 \
#     --cooldown 2

# aws autoscaling put-scaling-policy \
#     --region $AWS_REGION \
#     --auto-scaling-group-name "MyAutoScalingGroup" \
#     --policy-name "ScaleDownPolicy" \
#     --adjustment-type ChangeInCapacity \
#     --scaling-adjustment -2 \
#     --cooldown 2

# echo "Scaling policies added."

# # Schedule Stress Test with Cron
# CRON_JOB="* * * * * curl -s http://MyApplicationLoadBalancer-1854220763.us-east-1.elb.amazonaws.com/frontend/health > /dev/null && curl -s http://MyApplicationLoadBalancer-1854220763.us-east-1.elb.amazonaws.com/backend/todo > /dev/null"
# (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
# echo "Cron job added to schedule stress tests."














# #!/bin/bash

# # Define variables
# KEY_PATH="/home/melvin/Downloads/main-pro.pem"
# USER="ubuntu"
# INSTANCE_IP="34.199.42.249"  # Replace with your instance's actual IP
# TARGET_DIR="/home/ubuntu/project"
# ARCHIVE_NAME="project_files.tar.gz"

# # Create a compressed archive of all files and directories
# echo "Creating archive $ARCHIVE_NAME..."
# tar -czf $ARCHIVE_NAME alertmanager backend bash.sh docker-compose.yaml frontend .git .github .gitignore prometheus prometheus.yml

# # Transfer the archive to the remote server
# echo "Transferring archive to $TARGET_DIR on $INSTANCE_IP"
# scp -i "$KEY_PATH" $ARCHIVE_NAME "$USER@$INSTANCE_IP:$TARGET_DIR"

# # Connect to the remote server, extract the archive, and clean up
# echo "Extracting archive on remote server..."
# ssh -i "$KEY_PATH" "$USER@$INSTANCE_IP" << EOF
#     mkdir -p $TARGET_DIR
#     tar -xzf $TARGET_DIR/$ARCHIVE_NAME -C $TARGET_DIR
#     rm $TARGET_DIR/$ARCHIVE_NAME
# EOF

# # Remove the local archive
# rm $ARCHIVE_NAME

# echo "Files have been transferred and extracted on the remote server."
