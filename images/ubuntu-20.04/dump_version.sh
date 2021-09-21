#!/usr/bin/env bash

# fail on unset variables and command errors
set -eu -o pipefail # -x: is for debugging

vagrant ssh << EOS
set -x
docker version
docker-compose version
python3 -V
python3 -m pip -V
gcloud --version
google-chrome --version
chromedriver --version
terraform version
node -v
npm -v
yarn -v

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
