CONTAINER_NAME := website-astro-dev

dev:
	cd $(CURDIR)
	docker run --rm --name $(CONTAINER_NAME) -v $(CURDIR):/app -p 80:4321 -it node:18 /bin/bash -c "cd /app/astro; npm install -g pnpm@latest-7; pnpm install && pnpm dev"

dev-shell:
	docker exec -it $(CONTAINER_NAME) /bin/bash
