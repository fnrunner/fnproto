# Get the currently used golang install path (in GOPATH/bin, unless GOBIN is set)
ifeq (,$(shell go env GOBIN))
GOBIN=$(shell go env GOPATH)/bin
else
GOBIN=$(shell go env GOBIN)
endif

# Setting SHELL to bash allows bash commands to be executed by recipes.
# This is a requirement for 'setup-envtest.sh' in the test target.
# Options are set to exit when a recipe line exits non-zero or a piped command fails.
SHELL = /usr/bin/env bash -o pipefail
.SHELLFLAGS = -ec

all :$(generate)

.PHONY: generate
generate: protoc-gen-gofast protoc-gen-go-grpc
	echo $(GOBIN)
	protoc -I . $(shell find ./pkg/ -name '*.proto') --gofast_out=. --gofast_opt=paths=source_relative  --go-grpc_out=. --go-grpc_opt=paths=source_relative


##@ Build Dependencies

## Location to install dependencies to
LOCALBIN ?= $(shell pwd)/bin
$(LOCALBIN):
	mkdir -p $(LOCALBIN)

## Tool binaries
PROTOC_GO_FAST ?= $(LOCALBIN)/protoc-gen-gofast
PROTOC_GO_GRPC ?= $(LOCALBIN)/protoc-gen-go-grpc

## Tool Versions
PROTOC_GO_FAST_VERSION ?= latest
PROTOC_GO_GRPC_VERSION ?= latest


.PHONY: protoc-gen-gofast
protoc-gen-gofast: $(PROTOC_GO_FAST) ## Download protoc-gen-gofast locally if necessary.
$(PROTOC_GO_FAST): $(LOCALBIN)
	test -s $(LOCALBIN)/protoc-gen-gofast || GOBIN=$(LOCALBIN) go install -v github.com/gogo/protobuf/protoc-gen-gofast@$(PROTOC_GO_FAST_VERSION)

.PHONY: protoc-gen-go-grpc
protoc-gen-gogrpc: $(PROTOC_GO_GRPC) ## Download protoc-gen-golang-grpc locally if necessary.
$(PROTOC_GO_GRPC): $(LOCALBIN)
	test -s $(LOCALBIN)/protoc-gen-go-grpc || GOBIN=$(LOCALBIN) go install -v google.golang.org/grpc/cmd/protoc-gen-go-grpc@$(PROTOC_GO_GRPC_VERSION)
