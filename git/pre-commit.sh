#!/bin/bash
source "$HOME/colours.sh"

# Array containing all checks/tasks we want to run in hook
hooks=(
  rubocop_hook
)

# Function corresponding to check/task in hooks array
function rubocop_hook() {
  local status length

  # Get all the staged files except deleted files
  files=$(git diff --name-only --cached --diff-filter=d)

  # Get word-length of files
  length=${#files}

  # Run rubocop hook only when length is "not equal" to 0
  if [[ length -ne 0 ]]; then
    echo $files | xargs bundle exec rubocop --extra-details --parallel --force-exclusion
  fi
}

function thanks_hook() {
  echo "Thank YOU"
}

# Run hooks only when SKIP environment variable is not set
if [[ -z "$SKIP" ]]
then
  printf "\n${cyan}${bold}Running pre-commit hooks${nc}\n"

  for hook in "${hooks[@]}"; do
    ${hook}

    # Get exit status of command executed
    status=$?

    # Status is 0 when command exit status when successfully executed
    if [[ $status -eq 0 ]]
    then
      printf "\n${cyan}Check ${bold}$hook${nc} ................................ ${nc}${green}${bold}Passed ✓${nc}\n"
    else
      printf "\n${cyan}Check ${bold}$hook${nc} ................................ ${nc}${red}${bold}Failed ✗${nc}\n"
    fi
  done
else
  printf "\n${red}${bold}⚠  Skipping pre-commit hooks${nc}\n"
fi
printf "\n\n"
