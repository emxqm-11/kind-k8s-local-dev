.SILENT:

.DEFAULT_GOAL := help

include Makefile

KIND_VERSION?=v0.7.0

## installs kind with brew for macOS only
kind.install_macOS: 
	@brew install kind

## installs kind with golang
kind.install_go:
	@GO111MODULE="on" go get sigs.k8s.io/kind@$(KIND_VERSION)

## creates a multi node cluster
kind.deploy_multinode:
	@kind create cluster --config ./manifests/kind-multi-node-cluster.yaml

## creates a multi node cluster with HA control planes
kind.deploy_control_plane_HA:
	@kind create clsuter --config ./manifests/multi-control-plane.yaml

## export kind cluster logs to the logs directory
kind.logs:
	@kind export logs ./logs

## deploy istio into kind cluster 
kind.deploy_istio: asm.download asm.extract asm.generate asm.install
	
kind.delete_istio: asm.delete

kind.delete_cluster:
	@kind delete cluster