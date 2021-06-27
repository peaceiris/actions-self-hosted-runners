#!/usr/bin/env bash

# fail on unset variables and command errors
set -eu -o pipefail # -x: is for debugging


# https://github.com/actions/virtual-environments/blob/win19/20210620.1/images/linux/scripts/helpers/etc-environment.sh

function getEtcEnvironmentVariable {
    variable_name="$1"
    # remove `variable_name=` and possible quotes from the line
    grep "^${variable_name}=" /etc/environment |sed -E "s%^${variable_name}=\"?([^\"]+)\"?.*$%\1%"
}

function addEtcEnvironmentVariable {
    variable_name="$1"
    variable_value="$2"

    echo "$variable_name=$variable_value" | sudo tee -a /etc/environment
}

function replaceEtcEnvironmentVariable {
    variable_name="$1"
    variable_value="$2"

    # modify /etc/environemnt in place by replacing a string that begins with variable_name
    sudo sed -i -e "s%^${variable_name}=.*$%${variable_name}=\"${variable_value}\"%" /etc/environment
}

function setEtcEnvironmentVariable {
    variable_name="$1"
    variable_value="$2"

    if grep "$variable_name" /etc/environment > /dev/null; then
        replaceEtcEnvironmentVariable "${variable_name}" "${variable_value}"
    else
        addEtcEnvironmentVariable "${variable_name}" "${variable_value}"
    fi
}

function prependEtcEnvironmentVariable {
    variable_name="$1"
    element="$2"
    # TODO: handle the case if the variable does not exist
    existing_value=$(getEtcEnvironmentVariable "${variable_name}")
    setEtcEnvironmentVariable "${variable_name}" "${element}:${existing_value}"
}

function appendEtcEnvironmentVariable {
    variable_name="$1"
    element="$2"
    # TODO: handle the case if the variable does not exist
    existing_value=$(getEtcEnvironmentVariable "${variable_name}")
    setEtcEnvironmentVariable "${variable_name}" "${existing_value}:${element}"
}

function prependEtcEnvironmentPath {
    element="$1"
    prependEtcEnvironmentVariable PATH "${element}"
}

function appendEtcEnvironmentPath {
    element="$1"
    appendEtcEnvironmentVariable PATH "${element}"
}

# Process /etc/environment as if it were shell script with `export VAR=...` expressions
#    The PATH variable is handled specially in order to do not override the existing PATH
#    variable. The value of PATH variable read from /etc/environment is added to the end
#    of value of the exiting PATH variable exactly as it would happen with real PAM app read
#    /etc/environment
#
# TODO: there might be the others variables to be processed in the same way as "PATH" variable
#       ie MANPATH, INFOPATH, LD_*, etc. In the current implementation the values from /etc/evironments
#       replace the values of the current environment
function  reloadEtcEnvironment {
    # add `export ` to every variable of /etc/environemnt except PATH and eval the result shell script
    eval "$(grep -v '^PATH=' /etc/environment | sed -e 's%^%export %')"
    # handle PATH specially
    etc_path=$(getEtcEnvironmentVariable PATH)
    export PATH="$PATH:$etc_path"
}

# Install Linuxbrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
echo "eval \$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" >> ~/.profile
echo "eval \$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" >> ~/.bash_profile
echo "eval \$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" >> ~/.bashrc
brew doctor
brew update

# Update /etc/environemnt
## Put HOMEBREW_* variables
brew shellenv|grep 'export HOMEBREW'|sed -E 's/^export (.*);$/\1/' | sudo tee -a /etc/environment
# add brew executables locations to PATH
brew_path=$(brew shellenv|grep  '^export PATH' |sed -E 's/^export PATH="([^$]+)\$.*/\1/')
prependEtcEnvironmentPath "$brew_path"
setEtcEnvironmentVariable HOMEBREW_NO_AUTO_UPDATE 1
setEtcEnvironmentVariable HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS 3650

# Validate the installation ad hoc
echo "Validate the installation reloading /etc/environment"
reloadEtcEnvironment

# Install additional brew packages
brew install \
  ansible \
  ansible-lint \
  aquasecurity/trivy/trivy \
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
