SHELL := /bin/sh -e
IMAGE_NAME ?= mlops-app-text-embeddings-inference
IMAGE_TAG ?= latest
CHART_DIR := charts/app-text-embeddings-inference
PACKAGE_DIR := .apolo/src/apolo_apps_text_embeddings_inference

.PHONY: all
all: lint test

.PHONY: test
test: test-unit test-helm

.PHONY: install setup
install setup:
	poetry config virtualenvs.in-project true
	poetry install --with dev
	poetry run pre-commit install;

.PHONY: format
format:
ifdef CI
	poetry run pre-commit run --all-files --show-diff-on-failure
else
	poetry run pre-commit run --all-files || poetry run pre-commit run --all-files
endif

.PHONY: lint
lint: format
	poetry run mypy --strict .apolo/src

.PHONY: test-unit
test-unit:
	poetry run pytest -vvs --cov=.apolo --cov-report xml:.coverage.unit.xml .apolo/tests/unit

.PHONY: test-helm
test-helm:
	for values in $(CHART_DIR)/values.yaml $(CHART_DIR)/values-*.yaml; do \
		helm lint $(CHART_DIR) -f $$values; \
		helm template text-embeddings-inference $(CHART_DIR) -f $$values > /dev/null; \
	done

.PHONY: build-hook-image
build-hook-image:
	docker build \
		--build-arg APP_IMAGE_TAG=$(IMAGE_TAG) \
		-t $(IMAGE_NAME):latest \
		-f hooks.Dockerfile \
		.;

.PHONY: push-hook-image
push-hook-image:
	docker tag $(IMAGE_NAME):latest ghcr.io/neuro-inc/$(IMAGE_NAME):$(IMAGE_TAG)
	docker push ghcr.io/neuro-inc/$(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: gen-types-schemas
gen-types-schemas:
	for schema in Inputs Outputs; do \
		poetry run app-types dump-types-schema $(PACKAGE_DIR) "TextEmbeddingsInferenceApp$$schema" "$(PACKAGE_DIR)/schemas/TextEmbeddingsInference$$schema.json"; \
	done
