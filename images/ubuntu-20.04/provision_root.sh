#!/usr/bin/env bash

# fail on unset variables and command errors
set -eu -o pipefail # -x: is for debugging

apt-get update -y
apt-get upgrade -y
apt-get install -y software-properties-common
add-apt-repository ppa:git-core/ppa
apt-get update -y
apt-get install -y \
  build-essential \
  jq \
  libffi-dev \
  libssl-dev \
  python3 \
  python3-dev \
  python3-pip \
  python3-venv \
  wget \
  git \
  clang-format \
  nkf \
  shellcheck \
  tree \
  yamllint \
  zstd \
  bash

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

# Install docker-compose
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r '.tag_name')
curl -sL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

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

apt-get autoremove -y
