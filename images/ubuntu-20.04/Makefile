.PHONY: install
install:
	vagrant plugin install dotenv

.PHONY: up
up: install
	VAGRANT_EXPERIMENTAL="disks" vagrant up

.PHONY: vagrant-validate
vagrant-validate:
	vagrant validate

.PHONY: shellcheck
shellcheck:
	shellcheck provision_root.sh
	shellcheck provision_nonroot.sh

.PHONY: bump-version
bump-version:
	vagrant ssh << EOS
	set -x
	docker version
	docker-compose version
	jq --version
	python3 -V
	python3 -m pip -V
	gcloud --version
	google-chrome --version
	chromedriver --version
	terraform version

	brew --version
	ansible --version
	ansible-lint --version
	trivy --version
	bash --version
	clang-format --version
	direnv --version
	gcc --version
	gh --version
	git --version
	git-lfs --version
	go version
	golangci-lint --version
	goreleaser --version
	hadolint --version
	helm version
	hyperfine --version
	jq --version
	kind version
	kubectl version
	kustomize version
	mage --version
	make --version
	minikube version
	netlify --version
	nkf --version
	node --version
	poetry --version
	pyenv --version
	qrencode --version
	rbenv --version
	shellcheck --version
	skaffold version
	tree --version
	vercel --version
	wget --version
	yamllint --version
	yarn --version
	zstd --version

	npm -v
	deno --version
	EOS
