#!/usr/bin/env bash

# fail on unset variables and command errors
set -eu -o pipefail # -x: is for debugging

# Install Linuxbrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
echo "eval \$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" >> ~/.profile
echo "eval \$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" >> ~/.bash_profile
echo "eval \$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" >> ~/.bashrc
brew doctor
brew update

# Install additional brew packages
brew install \
  ansible \
  ansible-lint \
  aquasecurity/trivy/trivy \
  awscli \
  bash \
  clang-format \
  cloudflare/cloudflare/cloudflared \
  direnv \
  gcc \
  gh \
  git \
  git-lfs \
  go \
  golangci-lint \
  goreleaser/tap/goreleaser \
  hadolint \
  helm \
  hyperfine \
  jq \
  kind \
  kubectl \
  kustomize \
  mage \
  make \
  minikube \
  netlify-cli \
  nkf \
  node \
  poetry \
  pyenv \
  qrencode \
  rbenv \
  shellcheck \
  skaffold \
  tree \
  vercel-cli \
  wget \
  yamllint \
  yarn \
  zstd

git lfs install
npm i -g npm
# create symlinks for zstd in /usr/local/bin
find "$(brew --prefix)/bin" -name "*zstd*" -exec sudo sh -c 'ln -s "$1" /usr/local/bin/$(basename "$1")' _ {} \;

# Install deno
curl -fsSL https://deno.land/x/install/install.sh | sh
