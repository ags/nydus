REGISTRY       = agsmith
PROJECT        = nydus
TAG           ?= dev
IMAGE          = $(REGISTRY)/$(PROJECT):$(TAG)

.PHONY: build shell repl

build: Dockerfile
	docker build --rm -t $(IMAGE) .

shell:
	docker run -it \
		--name $(PROJECT)-shell \
		-v $(PWD):/src \
		$(IMAGE) \
		bash

repl:
	docker run --rm -it $(IMAGE) cabal repl
