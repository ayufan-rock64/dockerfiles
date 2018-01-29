REPO := ayufan/rock64-dockerfiles
TARGETS := arm64 x86_64

all: $(TARGETS)

.PHONY: $(TARGETS)

$(TARGETS):
	docker build -t $(REPO):$@ $@/
	docker push $(REPO):$@
