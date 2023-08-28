#!/bin/bash

# Save the original directory
original_dir=$(pwd)

# Read the Personal Access Token from GitHub CLI config
pat=$(gh auth status --show-token 2>&1 | awk -F'Token: ' '/Token:/ { print $2 }')

# Default repository name and owner
default_repo="project-sandbox"
owner="Jungas80"

# Prompt for repository name with default as project-sandbox
read -p "Enter repository name [$default_repo]: " repo_name
repo_name=${repo_name:-$default_repo}

# Ask for repository visibility: private (1) or public (2)
read -p "Should the repository be private (1) or public (2)? [1/2]: " visibility_choice

# Set visibility based on user input
if [[ $visibility_choice == "1" ]]; then
  visibility="private"
elif [[ $visibility_choice == "2" ]]; then
  visibility="public"
else
  echo "Invalid choice. Exiting."
  exit 1
fi

# Prompt for AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
read -p "Enter AWS_ACCESS_KEY_ID: " aws_access_key_id
read -s -p "Enter AWS_SECRET_ACCESS_KEY: " aws_secret_access_key
echo ""

# Export the AWS credentials
export AWS_ACCESS_KEY_ID=$aws_access_key_id
export AWS_SECRET_ACCESS_KEY=$aws_secret_access_key

# Generate a random string for the S3 bucket name using date and shasum
random_str=$(date | shasum | head -c 8)
bucket_name="tfstate-$random_str"

# Create the S3 bucket for Terraform state files
if ! aws s3api create-bucket --bucket "$bucket_name" --region us-east-1; then
  echo "Failed to create S3 bucket. Exiting."
  exit 1
fi

# Create the GitHub repository if it doesn't exist
if ! gh repo view "$owner/$repo_name" > /dev/null 2>&1; then
  gh repo create "$repo_name" --${visibility}
fi

# Set GitHub Actions secrets
gh secret set AWS_ACCESS_KEY_ID --body="$aws_access_key_id" --repo="$owner/$repo_name"
gh secret set AWS_SECRET_ACCESS_KEY --body="$aws_secret_access_key" --repo="$owner/$repo_name"

# Create a temporary shell script to hold the environment variables
echo "export AWS_ACCESS_KEY_ID=$aws_access_key_id" > temp_aws_keys.sh
echo "export AWS_SECRET_ACCESS_KEY=$aws_secret_access_key" >> temp_aws_keys.sh
echo "export TF_BUCKET_NAME=$bucket_name" >> temp_aws_keys.sh

# Clone the repository
https_repo_url="https://x-access-token:$pat@github.com/$owner/$repo_name.git"
git clone "$https_repo_url"

# Navigate into the cloned repository
cd "$repo_name"

# Create GitHub Workflows directory
mkdir -p .github/workflows

# Ask the user for the type of GitHub Actions workflow they want
read -p "Do you want to set up GitHub Actions for Terraform (1) or Terragrunt (2)? [1/2]: " workflow_choice

# Based on user choice, copy the respective YAML file
if [[ $workflow_choice == "1" ]]; then
  cp "$original_dir/actions_workflows/terraform_actions.yml" .github/workflows/
elif [[ $workflow_choice == "2" ]]; then
  cp "$original_dir/actions_workflows/terragrunt_actions.yml" .github/workflows/
else
  echo "Invalid choice. Exiting."
  exit 1
fi

# Commit and push the new workflow
git add .github/workflows/*.yml
git commit -m "Add GitHub Actions workflow"
git push origin main

# Change back to the original directory
cd "$original_dir"

# Final messages
echo "GitHub repository and Actions workflow have been set up successfully."
echo -e "Terraform state will be stored in S3 bucket: $bucket_name"
echo -e "To set the environment variables, run: \033[0;32msource ./wrapper.sh\033[0m"
