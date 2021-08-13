# actions-self-hosted-runners

[![CI](https://github.com/peaceiris/actions-self-hosted-runners/actions/workflows/ci.yml/badge.svg?event=push)](https://github.com/peaceiris/actions-self-hosted-runners/actions/workflows/ci.yml)

GitHub Actions self-hosted runner on VirtualBox with Vagrant.

- [actions/runner](https://github.com/actions/runner): The Runner for GitHub Actions
- [actions/virtual-environments](https://github.com/actions/virtual-environments): GitHub Actions virtual environments


## Getting Started

```sh
git clone https://github.com/peaceiris/actions-self-hosted-runners.git
cd ./actions-self-hosted-runners/images/ubuntu-20.04
git checkout v0.4.0
vim .env
make up
vagrant ssh
cd actions-runner
./config.sh --url https://github.com/[owner]/[repo] --token [token]
nohup ./run.sh &
```

Create `.env` file as follows.

```rb
VB_CPUS = '4'
VB_MEMORY = '8192'
VB_DISK_SIZE = '30GB'
```
