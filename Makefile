REPO := ayufan/rock64-dockerfiles
TARGETS := arm64 x86_64
TAG ?= $(VERSION)
MANIFEST_TAG ?= $(TAG)

ifeq (,$(VERSION))
$(error "Use `make <target> VERSION=bookworm`, or `make <target> VERSION=bullseye`")
endif

-include env.mk

all: $(TARGETS)

.PHONY: $(TARGETS)

arm32: DOCKER_ARCH=arm32v7/
arm64: DOCKER_ARCH=arm64v8/
x86_64: DOCKER_ARCH=amd64/

$(TARGETS):
	docker build --build-arg DOCKER_ARCH=$(DOCKER_ARCH) --build-arg DEBIAN_VERSION=$(VERSION) --tag $(REPO):$(TAG)-$@ .
	docker push $(REPO):$(TAG)-$@

tag:
	-rm -rf ~/.docker/manifests
	docker manifest create $(REPO):$(MANIFEST_TAG) \
		$(addprefix $(REPO):$(TAG)-, $(TARGETS))
	docker manifest push $(REPO):$(MANIFEST_TAG)
	docker pull $(REPO):$(MANIFEST_TAG)
