.PHONY: install
install:
	vagrant plugin install dotenv

.PHONY: up
up: install
	VAGRANT_EXPERIMENTAL="disks" vagrant up

.PHONY: vagrant-validate
vagrant-validate: install
	vagrant validate

.PHONY: shellcheck
shellcheck:
	shellcheck provision_root.sh
	shellcheck provision_nonroot.sh

.PHONY: dump-version
dump-version:
	bash dump_version.sh
