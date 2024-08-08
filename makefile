PACK_CMD?=pack
DOCKER_CMD?=docker
TAG_REGISTRY?=registry.cn-hangzhou.aliyuncs.com/dubbo-test
TAG?=noble
DOCKER_HOST="unix://$(shell $(DOCKER_CMD) info -f '{{.Host.RemoteSocket.Path}}')"

build: go-bases go-builder

go-bases: go-base-run go-base-build

go-base-run:
	@echo "> Building 'go-base-run' image"
	${DOCKER_CMD} build -t "${TAG_REGISTRY}/go-base-run:${TAG}" -f go-run.dockerfile .

go-base-build:
	@echo "> Building 'go-base-build' image"
	${DOCKER_CMD} build -t "${TAG_REGISTRY}/go-base-build:${TAG}" -f go-builder.dockerfile .

go-builder:
	@echo "> Building 'buildpacks' image"
	DOCKER_HOST="${DOCKER_HOST}" ${PACK_CMD} builder create "${TAG_REGISTRY}/go-builder" --config builder.toml

.PHONY: build go-bases go-base-run go-base-build go-builder
