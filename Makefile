lint:
	terraform fmt --recursive

validate:
	cd ./examples/create-env-cluster-topics;terraform init --upgrade;terraform validate

docs:
	rm -rf examples/*/.terraform examples/*/.terraform.lock.hcl
	rm -rf modules/*/.terraform modules/*/.terraform.lock.hcl
	terraform-docs -c .terraform-docs-examples.yml .
	terraform-docs -c .terraform-docs-modules.yml .

commit: lint validate docs
