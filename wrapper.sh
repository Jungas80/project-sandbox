#!/bin/bash

# Source the temporary file to set the environment variables
if [ -f "./temp_aws_keys.sh" ]; then
  source ./temp_aws_keys.sh
  
  # Optionally, remove the temporary file
  read -p "Do you want to remove the temporary AWS keys file? (y/n): " remove_temp
  if [[ $remove_temp == 'y' || $remove_temp == 'Y' ]]; then
    rm ./temp_aws_keys.sh
  fi

  echo "Environment variables set successfully."
  echo "AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID"
  echo "AWS_SECRET_ACCESS_KEY: [hidden]"
  echo "Terraform S3 bucket: $TF_BUCKET_NAME"
else
  echo "temp_aws_keys.sh file does not exist. Cannot set environment variables."
fi
