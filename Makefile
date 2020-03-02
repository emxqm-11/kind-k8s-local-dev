# =========================
# ASM
ASM_VERSION=istio-1.4.5-asm.0

asm.download: ##Download Istio from Google
	@echo "Download ASM"
	@curl -LO https://storage.googleapis.com/gke-release/asm/$(ASM_VERSION)-osx.tar.gz

asm.verify:
	@curl -LO https://storage.googleapis.com/gke-release/asm/$(ASM_VERSION)-osx.tar.gz.1.sig
	openssl dgst -verify - -signature $(ASM_VERSION)-osx.tar.gz.1.sig $(ASM_VERSION)-osx.tar.gz <<'EOF'
	-----BEGIN PUBLIC KEY-----
	MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEWZrGCUaJJr1H8a36sG4UUoXvlXvZ
	wQfk16sxprI2gOJ2vFFggdq3ixF2h4qNBt0kI7ciDhgpwS8t+/960IsIgw==
	-----END PUBLIC KEY-----
	EOF

asm.extract:
	@tar xzf $(ASM_VERSION)-osx.tar.gz

asm.install:
	@./$(ASM_VERSION)/bin/istioctl manifest apply -f ./istio-manifests/generated.yaml

asm.generate:
	@./$(ASM_VERSION)/bin/istioctl manifest generate --set profile=asm-onprem \
	--set values.mixer.telemetry.enabled=false \
	--set values.telemetry.enabled=false \
	--set values.telemetry.v2.enabled=false \
	--set values.tracing.enabled=false \
	--set values.mixer.policy.enabled=false \
	--set values.global.disablePolicyChecks=false \
	--set values.gateways.istio-ingressgateway.enabled=false \
	--set values.gateways.istio-ingressgateway.sds.enabled=false \
	--set values.gateways.istio-egressgateway.enabled=false \
	--set values.global.mtls.auto=true \
  	--set values.global.mtls.enabled=false \
	--set values.pilot.resources.requests.cpu=30m > ./istio-manifests/generated.yaml

asm.set_profile:
	@./$(ASM_VERSION)/bin/istioctl manifest apply --set profile=asm-onprem \
	--set values.mixer.telemetry.enabled=false \
	--set values.telemetry.enabled=false \
	--set values.telemetry.v2.enabled=false \
	--set values.tracing.enabled=false \
	--set values.mixer.policy.enabled=false \
	--set values.global.mtls.auto=true \
  	--set values.global.mtls.enabled=false \
	--set values.pilot.resources.requests.cpu=30m

asm.proxy_status:
	@./$(ASM_VERSION)/bin/istioctl proxy-status
	
asm.delete:
	@./$(ASM_VERSION)/bin/istioctl manifest generate --set profile=asm-onprem | kubectl delete -f -

asm.validate_install:
	@kubectl get pod -n ${ISTIO_NAMESPACE}

asm.patch_lb:
	@kubectl patch svc ${ISTIO_INGRESS_NAME} -n istio-system --patch 'spec:\n  loadBalancerIP: ${ISTIO_LB_IP}'

asm.patch_lb_with_snippet:
	@kubectl patch svc istio-ingressgateway -n istio-system -p "$(cat istio-patch.yaml)"

asm.install_sample_app:
	@$(ASM_VERSION)/bin/istioctl kube-inject -f $(ASM_VERSION)/samples/bookinfo/platform/kube/bookinfo.yaml | kubectl apply -n $(TARGET_NAMESPACE) -f -

asm.verify_sample_app:
	@kubectl get pods -n $(TARGET_NAMESPACE)
	@kubectl get svc -n $(TARGET_NAMESPACE)

asm.install_sample_ingress:
	@kubectl apply -f $(ASM_VERSION)/samples/bookinfo/networking/bookinfo-gateway.yaml -n $(TARGET_NAMESPACE)

asm.delete_sample: asm.delete_sample_app asm.delete_sample_ingress

asm.delete_sample_app:
	@$(ASM_VERSION)/bin/istioctl kube-inject -f $(ASM_VERSION)/samples/bookinfo/platform/kube/bookinfo.yaml | kubectl delete -n $(TARGET_NAMESPACE) -f -
	
asm.delete_sample_ingress:
	@kubectl delete -n $(TARGET_NAMESPACE) -f $(ASM_VERSION)/samples/bookinfo/networking/bookinfo-gateway.yaml 

