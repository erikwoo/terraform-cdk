PWD=$$(pwd)
DOCKER_IMAGE="hashicorp/terraform-website:full"
DOCKER_IMAGE_LOCAL="terraform-website-local"
DOCKER_RUN_FLAGS=--interactive \
		--rm \
		--tty \
		--volume "$(shell pwd)/website:/website/preview" \
		--publish "3000:3000" \
		-e "IS_CONTENT_PREVIEW=true" \
		-e "PREVIEW_FROM_REPO=terraform-cdk" \
		-e "NAV_DATA_DIRNAME=./preview/data" \
		-e "CONTENT_DIRNAME=./preview/docs" \
		-e "CURRENT_GIT_BRANCH=$$(git rev-parse --abbrev-ref HEAD)"

# Default: run this if working on the website locally to run in watch mode.
website:
	@echo "==> Downloading latest Docker image..."
	@docker pull ${DOCKER_IMAGE}
	@echo "==> Starting website in Docker..."
	@docker run ${DOCKER_RUN_FLAGS} ${DOCKER_IMAGE} npm start

website/local:
	@echo "==> Starting website in Docker..."
	@docker run ${DOCKER_RUN_FLAGS} ${DOCKER_IMAGE_LOCAL} npm start

.PHONY: website/build-local
website/build-local:
	@echo "==> Building local Docker image"
	@docker build https://github.com/hashicorp/terraform-website.git\#master \
		-t $(DOCKER_IMAGE_LOCAL)

.DEFAULT_GOAL := website
.PHONY: website website/local website/build-local