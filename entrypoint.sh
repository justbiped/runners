#!/bin/bash
set -e

if [ -z "$GITHUB_TOKEN" ]; then
  echo "Error: GITHUB_TOKEN environment variable is not set."
  exit 1
fi

if [ -z "$GITHUB_URL" ]; then
  echo "Error: GITHUB_URL environment variable is not set."
  exit 1
fi

if [ -z "$RUNNER_NAME" ]; then
  echo "Error: RUNNER_NAME environment variable is not set."
  exit 1
fi

# Optional: Set labels
RUNNER_LABELS="${RUNNER_LABELS:-}"

# Configure the runner
./config.sh --unattended \
  --url "$GITHUB_URL" \
  --token "$GITHUB_TOKEN" \
  --name "$RUNNER_NAME" \

# Run the runner
./run.sh