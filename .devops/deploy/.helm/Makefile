
.PHONY: template-development
template-development:
	helm template rt-nodebb-development \
		-n development \
		-f values-development.yaml \
		. > generated.yaml

.PHONY: template-production
template-production:
	helm template rt-nodebb-production \
		-n production \
		-f values-production.yaml \
		. > generated.yaml

.PHONY: install
install:
	helm upgrade rt-nodebb-production \
		-n production \
		-f values-production.yaml \
		--install \
		.

# .PHONY: install
# install:
# 	helm upgrade rt-development \
# 		-n development \
# 		-f values.yaml \
# 		--install \
# 		.

.PHONY: delete
delete:
	helm uninstall rt-nodebb-development \
		-n development
