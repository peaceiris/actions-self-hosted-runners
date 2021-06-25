# actions-self-hosted-runners

## Getting Started

```sh
git clone https://github.com/peaceiris/actions-self-hosted-runners.git
cd ./actions-self-hosted-runners
vim .env
vagrant up --provider=virtualbox
```

Create `.env` file as follows:

```rb
REPOSITORY_URL = 'https://github.com/[owner]/[repo]'
RUNNER_TOKEN = 'token_here'
```
