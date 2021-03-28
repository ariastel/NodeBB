
.PHONY: template
template:
	helm template nodebb \
		-n local \
		-f values-local.yaml \
		. > generated.yaml

.PHONY: install
install:
	helm upgrade nodebb \
		-n local \
		-f values-local.yaml \
		--install \
		.

.PHONY: delete
delete:
	helm uninstall nodebb \
		-n local
