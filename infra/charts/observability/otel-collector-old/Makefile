wsl-ip:
	@echo "Use the follow IP to access via browser"
	@IP=$$(ip -4 -o addr show eth0 | awk '{print $$4}' | cut -d/ -f1); echo "http://$${IP}:8080"; echo "================================"


port-forward-ta: wsl-ip
	kubectl port-forward svc/otel-collector-targetallocator 8080:80 -n monitoring --address 0.0.0.0
