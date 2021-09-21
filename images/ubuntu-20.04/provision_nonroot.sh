#!/usr/bin/env bash

# fail on unset variables and command errors
set -eu -o pipefail # -x: is for debugging

npm i -g npm

# Install deno
curl -fsSL https://deno.land/x/install/install.sh | sh
echo "export PATH=\"\${HOME}/.deno/bin:\${PATH}\"" >> ~/.profile
echo "export PATH=\"\${HOME}/.deno/bin:\${PATH}\"" >> ~/.bash_profile
