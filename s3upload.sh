#!/bin/bash

# Author: Mishal
# Description: Shell script to upload Jenkins logs to s3 bucket
# version: v1

JENKINS_HOME="/var/lib/jenkins"
S3_BUCKET="s3://jenkins-cost-optimization"
DATE=$(date +%Y-%m-%d)
# check if aws cli is installed 
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. please install it and try agin later"
    exit 1
fi

# iterate through all the job directories
for job_dir in "JENKINS_HOME/jobs/"*/; do 
    job_name=$(basename "$job_dir")

    #iterate through build directories for all the jobs
    for build_dir in "$job_dir/builds/"*/; do
    #get build number and log file path
        build_number=$(basename "$build_dir")
        log_file="$build_dir/log"
        # Check if log file exists and was created today
        if [ -f "$log_file" ] && [ "$(date -r "$log_file" +%Y-%m-%d)" == "$DATE" ]; then
            # Upload log file to S3 with the build number as the filename
            aws s3 cp "$log_file" "$S3_BUCKET/$job_name-$build_number.log" --only-show-errors
            
            if [ $? -eq 0 ]; then
                echo "Uploaded: $job_name/$build_number to $S3_BUCKET/$job_name-$build_number.log"
            else
                echo "Failed to upload: $job_name/$build_number"
            fi
        fi
    done
done