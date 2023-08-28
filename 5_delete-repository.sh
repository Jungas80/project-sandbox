#!/bin/bash

# Default owner (GitHub username)
owner="Jungas80"  # Replace this with your GitHub username

# Prompt for the name of the repository to delete
read -p "Enter the name of the repository to delete: " repo_name

# Double-check with the user
read -p "Are you sure you want to delete the repository '$owner/$repo_name'? This action cannot be undone. [y/N]: " confirmation

# Proceed to delete if confirmed
if [[ $confirmation == "y" || $confirmation == "Y" ]]; then
  gh repo delete "$owner/$repo_name" --confirm
  echo "Repository '$owner/$repo_name' has been deleted."
else
  echo "Operation cancelled."
fi
