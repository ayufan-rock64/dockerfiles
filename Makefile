REPO := ayufan/rock64-dockerfiles
TARGETS := arm64 x86_64
VERSION := v2

all: $(TARGETS)

.PHONY: $(TARGETS)

arm32: DOCKER_ARCH=arm32v7/
arm64: DOCKER_ARCH=arm64v8/
x86_64: DOCKER_ARCH=amd64/

$(TARGETS):
	docker build --build-arg DOCKER_ARCH=$(DOCKER_ARCH) --tag $(REPO):$(VERSION)-$@ .
	docker push $(REPO):$@

latest:
	-rm -rf ~/.docker/manifests
	docker manifest create $(REPO):$(VERSION) \
		$(addprefix $(REPO):$(VERSION)-, $(TARGETS))
	docker manifest create $(REPO):latest \
		$(addprefix $(REPO):$(VERSION)-, $(TARGETS))
	docker manifest push $(REPO):$(VERSION)
	docker manifest push $(REPO):latest
