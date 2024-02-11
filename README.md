# Note

Please check my [article](https://blog.josephvelliah.com/deploying-microservices-on-amazon-eks-with-istio) for more info.

All commands mentioned in this blog post are available here. This ensures you have easy access to copy-paste commands.

## Docker Image Setup

docker login
docker build -t josephvelliah/blog1-service-a:latest .
docker push josephvelliah/blog1-service-a:latest
docker build -t josephvelliah/blog1-service-b:latest .
docker push josephvelliah/blog1-service-b:latest
docker compose up -d
docker compose down --volumes

## Setup EKS Cluster and Validate

eksctl create cluster \
--name aws-eks-istiomesh-cluster \
--version 1.28 \
--region us-east-1 \
--zones us-east-1b,us-east-1d \
--nodegroup-name linux-nodes \
--node-type t3.medium \
--nodes 2

kubectl cluster-info
kubectl get nodes -o wide

## Setting Up istioctl Locally

curl -L <https://istio.io/downloadIstio> | sh -
export PATH=/Users/jvelliah/downloads/istio-1.20.3/bin:$PATH
istioctl version

## Setting Up Istio Mesh on EKS Cluster

istioctl install --set profile=demo -y
istioctl verify-install
kubectl create namespace aws-eks-istiomesh-ns
kubectl label namespace aws-eks-istiomesh-ns istio-injection=enabled
istioctl analyze

## Deploy K8S Manifest

kubectl apply -f k8s-services-deployment.yaml
kubectl get services -n aws-eks-istiomesh-ns
kubectl get pods -n aws-eks-istiomesh-ns

## Deploy Istio Gateway and Virtual Service

kubectl apply -f blog1-gateway.yaml
kubectl describe gateway blog1-gateway
kubectl apply -f blog1-service-a-virtualservice.yaml
kubectl get svc istio-ingressgateway -n istio-system

## Setting Up Kiali for Istio

kubectl apply -f /Users/jvelliah/downloads/istio-1.20.3/samples/addons
kubectl rollout status deployment/kiali -n istio-system
kubectl get services -n istio-system
istioctl dashboard kiali

## Clean Up Your Cluster

kubectl delete -f blog1-gateway.yaml
kubectl delete -f blog1-service-a-virtualservice.yaml
kubectl delete -f k8s-services-deployment.yaml
eksctl delete cluster --name aws-eks-istiomesh-cluster --region=us-east-1 --wait
