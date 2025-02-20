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























