#!/bin/bash

###########################################
#author : Mishal
#Version: v1
# Script to automate the process of listing all the resources in an AWS account
#
# Below are the services that are supported by this script:
# 1. EC2
# 2. RDS
# 3. S3
# 4. CloudFront
# 5. VPC
# 6. IAM
# 7. Route53
# 8. CloudWatch
# 9. CloudFormation
# 10. Lambda
# 11. DynamoDB
# 12. VPC
# 13. EBS
#
# The script will prompt the user to enter the AWS region and the service for which the resources need to be listed.
#
# Usage: ./aws_resource_list.sh  <aws_region> <aws_service>
############################################

# check if the required number of arguments are passed
if [$# -ne 2]; then
    echo "Usage: ./aws_details.sh <aws_region> <aws_service>"
    exit 1
fi

#assign the arguments to variables and convert to lower cases
aws_region=$1
aws_service=$2
aws_service=$(echo "$2" | tr '[:upper:]' '[:lower:]')

# Check if the AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install the AWS CLI and try again."
    exit 1
fi

# Check if AWS is configured

if [ ! -d ~/ .aws]; then
    echo "AWS CLI is not configured"
    exit 1
fi

# List the resources based on the service
case $aws_service in
    ec2) 
        echo "Listing EC2 instance in $aws_region"
        aws ec2 describe-instances --region $aws_region
        ;;
    rds)
        echo "Listing RDS instances in $aws_region"
        aws rds describe-db-instances --region $aws_region
        ;;
    s3)
        echo "Listing s3 buckets in $aws_region"
        aws s3api list-buckets --region $aws_region
        ;;
    cloudfront) 
        echo "Listing cloudfront distributions in $aws_region"
        aws cloudfront list-distributions --region $aws_region
        ;;
    vpc)
        echo "Listing VPC in $aws_region"
        aws ec2 describe-vpcs --region $aws_region
        ;;
        iam)
        echo "Listing IAM Users in $aws_region"
        aws iam list-users --region $aws_region
        ;;
    route5)
        echo "Listing Route53 Hosted Zones in $aws_region"
        aws route53 list-hosted-zones --region $aws_region
        ;;
    cloudwatch)
        echo "Listing CloudWatch Alarms in $aws_region"
        aws cloudwatch describe-alarms --region $aws_region
        ;;
    cloudformation)
        echo "Listing CloudFormation Stacks in $aws_region"
        aws cloudformation describe-stacks --region $aws_region
        ;;
    lambda)
        echo "Listing Lambda Functions in $aws_region"
        aws lambda list-functions --region $aws_region
        ;;
    dynamodb)
        echo "Listing DynamoDB Tables in $aws_region"
        aws dynamodb list-tables --region $aws_region
        ;;
    ebs)
        echo "Listing EBS Volumes in $aws_region"
        aws ec2 describe-volumes --region $aws_region
        ;;
    *)
        echo "Invalid service. Please enter a valid service."
        exit 1
        ;;
esac