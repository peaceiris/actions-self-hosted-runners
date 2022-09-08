#!/usr/bin/env bash

# fail on unset variables and command errors
set -eu -o pipefail # -x: is for debugging

apt-get update
apt-get upgrade -y
apt-get install -y software-properties-common
add-apt-repository --yes --update ppa:git-core/ppa
apt-get install -y \
  bash \
  build-essential \
  clang-format \
  git \
  git-lfs \
  jq \
  libffi-dev \
  libssl-dev \
  nkf \
  python3 \
  python3-dev \
  python3-pip \
  python3-venv \
  shellcheck \
  tree \
  wget \
  yamllint \
  zstd

# Install gh
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
apt-get update -y
apt-get install -y gh

# Install docker
apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io
groupadd docker || true
gpasswd -a vagrant docker
newgrp docker
systemctl restart docker

# Install google-cloud-sdk (gcloud)
sudo apt-get install -y unzip xvfb libxi6 libgconf-2-4 default-jdk
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update -y
sudo apt-get install -y google-cloud-sdk

# Install Google Chrome
sudo curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add
echo "deb [arch=amd64]  http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee -a /etc/apt/sources.list.d/google-chrome.list
sudo apt-get update -y
sudo apt-get install -y google-chrome-stable

# Install ChromeDriver
CHROMEDRIVER_TEMPDIR=$(mktemp -d)
wget -O "${CHROMEDRIVER_TEMPDIR}/LATEST_RELEASE" http://chromedriver.storage.googleapis.com/LATEST_RELEASE
CHROMEDRIVER_LATEST_VERSION=$(cat "${CHROMEDRIVER_TEMPDIR}/LATEST_RELEASE")
wget -O "${CHROMEDRIVER_TEMPDIR}/chromedriver.zip" "http://chromedriver.storage.googleapis.com/${CHROMEDRIVER_LATEST_VERSION}/chromedriver_linux64.zip"
sudo unzip "${CHROMEDRIVER_TEMPDIR}/chromedriver.zip" chromedriver -d /usr/local/bin/

# Install terraform
TERRAFORM_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)
curl -sLO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
unzip -qq "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -d /usr/local/bin
rm -f "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

# Install hadolint
HADOLINT_VERSION=$(curl -fsi "https://github.com/hadolint/hadolint/releases/latest" | awk -F/ '/^(L|l)ocation:/ {print $(NF)}' | tr -d '\r')
wget "https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-Linux-x86_64"
mv hadolint-Linux-x86_64 /usr/local/bin/hadolint
chmod 755 /usr/local/bin/hadolint

# Install node, npm, and yarn
curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
apt-get install -y nodejs
npm install -g npm
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
apt-get update && apt-get install -y yarn

# npm install -g
npm install -g vercel netlify-cli

# ansible
apt-add-repository --yes --update ppa:ansible/ansible
apt-get install -y ansible ansible-lint

# trivy
apt-get install -y wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
apt-get update
apt-get install -y trivy

# golang
add-apt-repository --yes --update ppa:longsleep/golang-backports
apt-get install -y golang
export GOPATH="${HOME}/go"
export PATH="${GOPATH}/bin:${PATH}"
echo "export GOPATH=${HOME}/go" >> "${HOME}/.bashrc"
echo "export PATH=${GOPATH}/bin:${PATH}" >> "${HOME}/.bashrc"

# golangci-lint
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "$(go env GOPATH)/bin" v1.40.1

# goreleaser
echo 'deb [trusted=yes] https://repo.goreleaser.com/apt/ /' | sudo tee /etc/apt/sources.list.d/goreleaser.list
apt-get update
apt-get install -y goreleaser

# mage
go install github.com/magefile/mage@latest

# poetry
curl -sSL https://install.python-poetry.org | python3 -

# Cleanup
apt-get autoremove -y
