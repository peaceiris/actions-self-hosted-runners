#!/usr/bin/env bash

# fail on unset variables and command errors
set -eu -o pipefail # -x: is for debugging

vagrant ssh << EOS
set -x
docker version
docker compose version
python3 -V
python3 -m pip -V
gcloud --version
google-chrome --version
chromedriver --version
terraform version
hadolint --version
node -v
npm -v
yarn -v
vercel --version
netlify --version
ansible --version
ansible-lint --version
trivy --version
go version
golangci-lint --version
goreleaser --version
mage --version
poetry --version

bash --version
clang-format --version
gcc --version
gh --version
git --version
git-lfs --version
jq --version
make --version
nkf --version
shellcheck --version
tree --version
wget --version
yamllint --version
zstd --version

deno --version
EOS
