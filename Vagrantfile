# -*- mode: ruby -*-
# vi: set ft=ruby :

Dotenv.load

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "generic/ubuntu2004"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    vb.name = "vb-github-actions-self-hosted-runner"

    # Display the VirtualBox GUI when booting the machine
    vb.gui = false

    # Customize the amount of memory on the VM:
    vb.memory = "10240"

    # Fix https://www.virtualbox.org/ticket/15705
    vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    apt update -y
    apt upgrade -y
    apt install -y jq wget \
      python3 python3-dev python3-pip python3-venv build-essential libssl-dev libffi-dev

    # Install docker
    apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt update -y
    apt install -y docker-ce docker-ce-cli containerd.io
    groupadd docker
    gpasswd -a vagrant docker
    newgrp docker
    systemctl restart docker

    # Install docker-compose
    export DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r '.tag_name')
    curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

    # Install node
    curl -fsSL https://rpm.nodesource.com/setup_14.x | bash -

    # Install google-cloud-sdk (gcloud)
    sudo apt install -y unzip xvfb libxi6 libgconf-2-4 default-jdk
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    sudo apt update -y
    sudo apt install -y google-cloud-sdk

    # Install Google Chrome
    sudo curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add
    sudo echo "deb [arch=amd64]  http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
    sudo apt update -y
    sudo apt install -y google-chrome-stable

    # Install ChromeDriver
    export CHROMEDRIVER_TEMPDIR=$(mktemp -d)
    wget -O ${CHROMEDRIVER_TEMPDIR}/LATEST_RELEASE http://chromedriver.storage.googleapis.com/LATEST_RELEASE
    export CHROMEDRIVER_LATEST_VERSION=$(cat ${CHROMEDRIVER_TEMPDIR}/LATEST_RELEASE)
    wget -O ${CHROMEDRIVER_TEMPDIR}/chromedriver.zip "http://chromedriver.storage.googleapis.com/${CHROMEDRIVER_LATEST_VERSION}/chromedriver_linux64.zip"
    sudo unzip ${CHROMEDRIVER_TEMPDIR}/chromedriver.zip chromedriver -d /usr/local/bin/

    # Install terraform
    TERRAFORM_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)
    curl -LO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
    unzip -qq "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -d /usr/local/bin
    rm -f "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
  SHELL

  config.vm.provision :vagrant_user, type: "shell", privileged: false, inline: <<-SHELL
    docker run --rm hello-world

    # install Linuxbrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
    test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
    echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
    brew doctor
    brew update
    brew install \
      git \
      bash \
      make \
      gcc \
      hadolint \
      poetry \
      kubectl \
      kustomize \
      skaffold \
      kind \
      helm \
      minikube \
      gh \
      netlify-cli \
      vercel \
      cloudflare/cloudflare/cloudflared \
      awscli \
      clang-format \
      direnv \
      node \
      go \
      golangci-lint \
      mage \
      goreleaser/tap/goreleaser \
      hyperfine \
      nkf \
      pyenv \
      qrencode \
      rbenv \
      shellcheck \
      tree \
      yarn \
      wget \
      jq \
      aquasecurity/trivy/trivy \
      zstd
    git lfs install
    npm i -g npm

    # Install deno
    curl -fsSL https://deno.land/x/install/install.sh | sh

    # Install actions/runner
    mkdir ~/actions-runner && cd ~/actions-runner
    GHA_RUNNER_VERSION="2.278.0"
    curl -o actions-runner-linux-x64-${GHA_RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${GHA_RUNNER_VERSION}/actions-runner-linux-x64-${GHA_RUNNER_VERSION}.tar.gz
    tar xzf ./actions-runner-linux-x64-${GHA_RUNNER_VERSION}.tar.gz
    ./config.sh --url #{ENV['REPOSITORY_URL']} --token #{ENV['RUNNER_TOKEN']}
    nohup ./run.sh &
  SHELL
end
