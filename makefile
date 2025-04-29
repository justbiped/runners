build = docker build --platform linux/amd64 -t github-runner .

run = docker run -d -v /var/run/docker.sock:/var/run/docker.sock \
  -e GITHUB_URL="$GITHUB_URL" \
  -e GITHUB_TOKEN="$GITHUB_TOKEN" \
  -e RUNNER_NAME="$RUNNER_NAME" \
  --name github-runner \
  github-runner
