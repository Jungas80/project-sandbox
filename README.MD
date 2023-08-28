# Project Sandbox: Unified GitHub and AWS Workflow

This repository contains a set of Bash scripts designed to automate the setup of a GitHub repository along with AWS resources. These scripts will create a new GitHub repository, set GitHub Actions secrets, and set up an S3 bucket for Terraform state files.

## Prerequisites

- GitHub CLI (`gh`)
- AWS CLI (`aws`)
- Git

## Scripts Included

1. `1_unified-workflow.sh`: Main script to set up GitHub repository and AWS resources.
2. `5_delete-repository.sh`: Script to delete the GitHub repository. (Note: This is a placeholder; actual implementation may vary.)
3. `wrapper.sh`: A wrapper script to set environment variables.

### Actions Workflows Templates

- `actions_workflows/terraform_actions.yml`: GitHub Actions workflow template for Terraform.
- `actions_workflows/terragrunt_actions.yml`: GitHub Actions workflow template for Terragrunt.

## Usage

1. Clone this repository to your local machine.

    ```bash
    git clone https://github.com/YourUsername/YourRepo.git
    ```

2. Navigate to the project directory.

    ```bash
    cd YourRepo
    ```

3. Run the main script.

    ```bash
    ./1_unified-workflow.sh
    ```

    Follow the on-screen prompts to configure your GitHub repository and AWS resources.

4. (Optional) To set environment variables, run:

    ```bash
    source ./wrapper.sh
    ```


