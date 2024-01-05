IMAGE_NAME := ccr.ccs.tencentyun.com/farfalle/copilot-openai:latest
.PHONY: build-image
build-image:
	docker buildx build \
		--push \
		--platform linux/amd64 \
		--progress plain \
		-t $(IMAGE_NAME) .

.PHONY: deploy
deploy:
	helm -n chatgpt upgrade copilot-gpt ./.chart/copilot-gpt4-service --install --create-namespace --wait --timeout 5m --kube-context=kiila
