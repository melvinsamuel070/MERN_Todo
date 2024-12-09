#!/bin/bash

# # Variables
# AWS_REGION="us-east-1"
# VPC_ID="vpc-06349688cec80497a"                       # Replace with your VPC ID
# SUBNET_1="subnet-096394880b9a77904"
# SUBNET_2="subnet-0afa998e4cb61fc10"                  # Two subnets in different AZs
# SUBNET_IDS="${SUBNET_1},${SUBNET_2}"                 # Comma-separated list of subnets
# SECURITY_GROUP_ID="sg-0cf064343aed6695f"             # Replace with your Security Group ID
# EXISTING_INSTANCE_ID="i-0f1ed4688cf5c4fe1"           # Replace with your instance ID
# AMI_ID="ami-0866a3c8686eaeeba"                       # Replace with your AMI ID
# INSTANCE_TYPE="t2.micro"                             # Adjust instance type as needed
# KEY_PAIR="main-pro.pem"                              # Replace with your Key Pair
# FRONTEND_PORT=3000                                   # Adjust frontend port if different
# BACKEND_PORT=3500                                    # Adjust backend port if different
# ALERT_THRESHOLD=5                                    # Example alert threshold for scaling

# set -e
# set -x
# trap 'echo "Error on line $LINENO"; exit 1' ERR

# # Make sure these variables have been set from earlier operations
# # These should have been returned when creating resources
# LAUNCH_TEMPLATE_NAME="YourLaunchTemplateName"  # Set to actual Launch Template name
# FRONTEND_TG_ARN="YourFrontendTargetGroupARN"   # Set to actual Frontend Target Group ARN
# BACKEND_TG_ARN="YourBackendTargetGroupARN"     # Set to actual Backend Target Group ARN
# ALB_ARN="YourLoadBalancerARN"                  # Set to actual Load Balancer ARN
# LISTENER_ARN="YourListenerARN"                 # Set to actual Listener ARN

# # Delete Auto Scaling Group
# AUTO_SCALING_GROUP_NAME="MyAutoScalingGroup"
# echo "Deleting Auto Scaling Group: $AUTO_SCALING_GROUP_NAME"
# aws autoscaling delete-auto-scaling-group \
#     --region $AWS_REGION \
#     --auto-scaling-group-name "$AUTO_SCALING_GROUP_NAME" \
#     --force-delete

# # Delete Launch Template
# echo "Deleting Launch Template: $LAUNCH_TEMPLATE_NAME"
# aws ec2 delete-launch-template \
#     --region $AWS_REGION \
#     --launch-template-name "$LAUNCH_TEMPLATE_NAME"

# # Delete Target Groups
# echo "Deleting Target Groups: FrontendTG and BackendTG"
# aws elbv2 delete-target-group \
#     --region $AWS_REGION \
#     --target-group-arn "$FRONTEND_TG_ARN"
# aws elbv2 delete-target-group \
#     --region $AWS_REGION \
#     --target-group-arn "$BACKEND_TG_ARN"

# # Delete Load Balancer
# echo "Deleting Load Balancer: $ALB_ARN"
# aws elbv2 delete-load-balancer \
#     --region $AWS_REGION \
#     --load-balancer-arn "$ALB_ARN"

# # Delete Listener
# echo "Deleting Listener: $LISTENER_ARN"
# aws elbv2 delete-listener \
#     --region $AWS_REGION \
#     --listener-arn "$LISTENER_ARN"

# # Remove Target Registration for Existing Instance
# echo "Deregistering Existing Instance from Target Groups"
# aws elbv2 deregister-targets \
#     --region $AWS_REGION \
#     --target-group-arn "$FRONTEND_TG_ARN" \
#     --targets Id=$EXISTING_INSTANCE_ID
# aws elbv2 deregister-targets \
#     --region $AWS_REGION \
#     --target-group-arn "$BACKEND_TG_ARN" \
#     --targets Id=$EXISTING_INSTANCE_ID

# # Delete Scaling Policies
# echo "Deleting Scaling Policies for Auto Scaling Group"
# aws autoscaling delete-policy \
#     --region $AWS_REGION \
#     --auto-scaling-group-name "$AUTO_SCALING_GROUP_NAME" \
#     --policy-name "ScaleUpPolicy"
# aws autoscaling delete-policy \
#     --region $AWS_REGION \
#     --auto-scaling-group-name "$AUTO_SCALING_GROUP_NAME" \
#     --policy-name "ScaleDownPolicy"

# # Delete Cron Job (Stress Test)
# echo "Deleting Cron Job"
# crontab -l | grep -v "curl -s http://MyApplicationLoadBalancer" | crontab -

# # Remove Prometheus, Alertmanager, and Grafana configurations
# echo "Cleaning up Prometheus, Alertmanager, and Grafana configurations"
# sudo rm -rf /etc/prometheus
# sudo rm -rf /etc/alertmanager
# sudo rm -rf /etc/grafana

# # Clean up AWS resources (Optional)
# # Clean up any other AWS resources such as EC2 instances, EBS volumes, etc., as needed.
# echo "Clean up AWS resources if necessary"
# # aws ec2 terminate-instances --region $AWS_REGION --instance-ids $EXISTING_INSTANCE_ID
# # aws ec2 delete-volume --region $AWS_REGION --volume-id <volume_id>

# echo "Cleanup complete."







#!/bin/bash

# Variables
AWS_REGION="us-east-1"
VPC_ID="vpc-06349688cec80497a"
SUBNET_1="subnet-096394880b9a77904"
SUBNET_2="subnet-0afa998e4cb61fc10"
SUBNET_IDS="${SUBNET_1},${SUBNET_2}"
SECURITY_GROUP_ID="sg-0cf064343aed6695f"
EXISTING_INSTANCE_ID="i-0f1ed4688cf5c4fe1"
AMI_ID="ami-0866a3c8686eaeeba"
INSTANCE_TYPE="t2.micro"
KEY_PAIR="main-pro.pem"
FRONTEND_PORT=3000
BACKEND_PORT=3500
ALERT_THRESHOLD=5

set -e
set -x
trap 'echo "Error on line $LINENO"; exit 1' ERR

# Set to actual Launch Template name
LAUNCH_TEMPLATE_NAME="my-launch-template"

# Set to actual ARNs from your setup
FRONTEND_TG_ARN="YourFrontendTargetGroupARN"
BACKEND_TG_ARN="YourBackendTargetGroupARN"
ALB_ARN="YourLoadBalancerARN"
LISTENER_ARN="YourListenerARN"

AUTO_SCALING_GROUP_NAME="MyAutoScalingGroup"
if aws autoscaling describe-auto-scaling-groups \
    --region us-east-1 \
    --auto-scaling-group-names "$AUTO_SCALING_GROUP_NAME" \
    | grep -q '"AutoScalingGroups": \[\]'; then
    echo "Auto Scaling Group '$AUTO_SCALING_GROUP_NAME' not found. Skipping deletion."
else
    echo "Deleting Auto Scaling Group: $AUTO_SCALING_GROUP_NAME"
    aws autoscaling delete-auto-scaling-group \
        --region us-east-1 \
        --auto-scaling-group-name "$AUTO_SCALING_GROUP_NAME" \
        --force-delete
fi


# Delete Launch Template
echo "Deleting Launch Template: $LAUNCH_TEMPLATE_NAME"
if aws ec2 describe-launch-templates --region "$AWS_REGION" --launch-template-names "$LAUNCH_TEMPLATE_NAME" &> /dev/null; then
    aws ec2 delete-launch-template \
        --region "$AWS_REGION" \
        --launch-template-name "$LAUNCH_TEMPLATE_NAME"
else
    echo "Launch Template '$LAUNCH_TEMPLATE_NAME' not found. Skipping deletion."
fi

# Delete Target Groups
echo "Deleting Target Groups"
if aws elbv2 describe-target-groups --region "$AWS_REGION" --target-group-arns "$FRONTEND_TG_ARN" &> /dev/null; then
    aws elbv2 delete-target-group \
        --region "$AWS_REGION" \
        --target-group-arn "$FRONTEND_TG_ARN"
else
    echo "Frontend Target Group not found. Skipping deletion."
fi

if aws elbv2 describe-target-groups --region "$AWS_REGION" --target-group-arns "$BACKEND_TG_ARN" &> /dev/null; then
    aws elbv2 delete-target-group \
        --region "$AWS_REGION" \
        --target-group-arn "$BACKEND_TG_ARN"
else
    echo "Backend Target Group not found. Skipping deletion."
fi

# Delete Load Balancer
echo "Deleting Load Balancer: $ALB_ARN"
if aws elbv2 describe-load-balancers --region "$AWS_REGION" --load-balancer-arns "$ALB_ARN" &> /dev/null; then
    aws elbv2 delete-load-balancer \
        --region "$AWS_REGION" \
        --load-balancer-arn "$ALB_ARN"
else
    echo "Load Balancer not found. Skipping deletion."
fi

# Delete Listener
echo "Deleting Listener: $LISTENER_ARN"
if aws elbv2 describe-listeners --region "$AWS_REGION" --listener-arns "$LISTENER_ARN" &> /dev/null; then
    aws elbv2 delete-listener \
        --region "$AWS_REGION" \
        --listener-arn "$LISTENER_ARN"
else
    echo "Listener not found. Skipping deletion."
fi

# Deregister Existing Instance
echo "Deregistering Existing Instance from Target Groups"
if aws elbv2 describe-target-health --region "$AWS_REGION" --target-group-arn "$FRONTEND_TG_ARN" --targets Id="$EXISTING_INSTANCE_ID" &> /dev/null; then
    aws elbv2 deregister-targets \
        --region "$AWS_REGION" \
        --target-group-arn "$FRONTEND_TG_ARN" \
        --targets Id="$EXISTING_INSTANCE_ID"
fi

if aws elbv2 describe-target-health --region "$AWS_REGION" --target-group-arn "$BACKEND_TG_ARN" --targets Id="$EXISTING_INSTANCE_ID" &> /dev/null; then
    aws elbv2 deregister-targets \
        --region "$AWS_REGION" \
        --target-group-arn "$BACKEND_TG_ARN" \
        --targets Id="$EXISTING_INSTANCE_ID"
fi

# Delete Scaling Policies
echo "Deleting Scaling Policies"
if aws autoscaling describe-policies --region "$AWS_REGION" --auto-scaling-group-name "$AUTO_SCALING_GROUP_NAME" --policy-names "ScaleUpPolicy" &> /dev/null; then
    aws autoscaling delete-policy \
        --region "$AWS_REGION" \
        --auto-scaling-group-name "$AUTO_SCALING_GROUP_NAME" \
        --policy-name "ScaleUpPolicy"
fi

if aws autoscaling describe-policies --region "$AWS_REGION" --auto-scaling-group-name "$AUTO_SCALING_GROUP_NAME" --policy-names "ScaleDownPolicy" &> /dev/null; then
    aws autoscaling delete-policy \
        --region "$AWS_REGION" \
        --auto-scaling-group-name "$AUTO_SCALING_GROUP_NAME" \
        --policy-name "ScaleDownPolicy"
fi

# Delete Cron Job
echo "Deleting Cron Job"
crontab -l | grep -v "curl -s http://MyApplicationLoadBalancer" | crontab -

# Remove Monitoring Configurations
echo "Cleaning up Monitoring Configurations"
sudo rm -rf /etc/prometheus
sudo rm -rf /etc/alertmanager
sudo rm -rf /etc/grafana

# Clean up Additional AWS Resources (Optional)
echo "Clean up AWS resources if necessary"
# aws ec2 delete-volume --region "$AWS_REGION" --volume-id <volume_id>

echo "Cleanup complete."
