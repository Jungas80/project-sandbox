#!/bin/bash

# Default owner (Replace this with your GitHub username)
owner="Jungas80"

# Ask for the GitHub repository name
read -p "Enter the GitHub repository name: " repo_name

# Concatenate owner and repository name
full_repo_name="$owner/$repo_name"

# Prompt for new AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
read -p "Enter new AWS_ACCESS_KEY_ID: " new_aws_access_key_id
read -s -p "Enter new AWS_SECRET_ACCESS_KEY: " new_aws_secret_access_key
echo ""

# Export the AWS credentials
export AWS_ACCESS_KEY_ID=$new_aws_access_key_id
export AWS_SECRET_ACCESS_KEY=$new_aws_secret_access_key

# Generate a random string for the new S3 bucket name using date and shasum
random_str=$(date | shasum | head -c 8)
new_bucket_name="tfstate-$random_str"

# Create a new S3 bucket
if ! aws s3api create-bucket --bucket "$new_bucket_name" --region us-east-1; then
  echo "Failed to create new S3 bucket. Exiting."
  exit 1
fi

# Update GitHub Actions secrets
gh secret set AWS_ACCESS_KEY_ID --body="$new_aws_access_key_id" --repo="$full_repo_name"
gh secret set AWS_SECRET_ACCESS_KEY --body="$new_aws_secret_access_key" --repo="$full_repo_name"

echo "Successfully updated AWS credentials and created a new S3 bucket: $new_bucket_name"

# Create a temporary shell script to hold the new environment variables
echo "export AWS_ACCESS_KEY_ID=$new_aws_access_key_id" > temp_aws_keys.sh
echo "export AWS_SECRET_ACCESS_KEY=$new_aws_secret_access_key" >> temp_aws_keys.sh
echo "export TF_BUCKET_NAME=$new_bucket_name" >> temp_aws_keys.sh

echo "To set the new environment variables, run:"
echo "source ./wrapper.sh"
