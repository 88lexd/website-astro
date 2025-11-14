CONTAINER_NAME := website-astro-dev

wsl-ip:
	@IP=$$(ip -4 -o addr show eth0 | awk '{print $$4}' | cut -d/ -f1); \
		echo "WSL IP: $${IP}"

dev:
	cd $(CURDIR)
	docker run --rm --name $(CONTAINER_NAME) -v $(CURDIR):/app -p 80:4321 -it node:18 /bin/bash -c "cd /app/astro; npm install -g pnpm@latest-7; pnpm install && pnpm dev"

dev-shell:
	docker exec -it $(CONTAINER_NAME) /bin/bash
