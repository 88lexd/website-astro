wsl-ip:
	@echo "Use the follow IP to access argo"
	@IP=$$(ip -4 -o addr show eth0 | awk '{print $$4}' | cut -d/ -f1); echo "http://$${IP}:8080"; echo "================================"

port-forward-argo: wsl-ip
	kubectl port-forward --address 0.0.0.0 -n argocd services/argocd-server 8080:80
