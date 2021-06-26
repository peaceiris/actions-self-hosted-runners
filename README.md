# actions-self-hosted-runners

[![CI](https://github.com/peaceiris/actions-self-hosted-runners/actions/workflows/ci.yml/badge.svg?event=push)](https://github.com/peaceiris/actions-self-hosted-runners/actions/workflows/ci.yml)

GitHub Actions self-hosted runner on VirtualBox with Vagrant.

- [actions/runner](https://github.com/actions/runner): The Runner for GitHub Actions
- [actions/virtual-environments](https://github.com/actions/virtual-environments): GitHub Actions virtual environments


## Getting Started

```sh
git clone https://github.com/peaceiris/actions-self-hosted-runners.git
cd ./actions-self-hosted-runners/images/ubuntu-20.04
git checkout v0.2.0
vim .env
vagrant plugin install dotenv
VAGRANT_EXPERIMENTAL="disks" vagrant up
```

Create `.env` file as follows.

```rb
REPOSITORY_URL = 'https://github.com/[owner]/[repo]'
RUNNER_TOKEN = 'token_here'
```
