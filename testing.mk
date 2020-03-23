
nginx.deploy_and_expose:
	@kubectl apply -f ./testing/run-my-nginx.yaml
	@kubectl expose deployment/genesis

nginx.auth:
	@kubectl apply -f ./testing/run-my-nginx-auth.yaml
	@kubectl expose deployment/genesis -n auth

busybox.tty:
	@kubectl run busybox -it --image=busybox --restart=Never --rm

busybox.label:
	@kubectl run busybox -l app=genesis -it --image=busybox --restart=Never --rm 

busybox.coolbeans:
	@kubectl run busybox -l app=coolbeans -it --image=busybox --restart=Never --rm 

busybox.api-gateway:
	@kubectl run busybox -l app=api-gateway -it --image=busybox --restart=Never --rm 

nginx.delete:
	@kubectl delete deployment/my-nginx

hello.web:
	@kubectl run hello-web-2 --labels app=schema-registry \
  	--image=gcr.io/google-samples/hello-app:1.0 --port 8080 --expose

alpine.deploy:
	kubectl run -l app=api-gateway --image=alpine --rm -i -t --restart=Never test-3

np.delete.all:
	k delete networkpolicy --all-namespaces --all