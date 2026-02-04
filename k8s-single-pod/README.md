# Single Pod

## Goal
Deploy a single Pod in Kubernetes cluster(minikube) and expose it with a cluster.

## Tasks
1. Create a Pod manifest file named `single-pod.yaml` that pulls a simple fastapi container from dockerhub.
2. Expose it with a Service.
3. Deploy and curl it from the cluster.

## Broke
1. Specify a wrong container port when writing the yaml file for the pod.
2. Give it a wrong service selector

## commands used
```bash
# create a pod
kubectl apply -f k8s/single-pod.yaml
# check the pod
kubectl get pods -o wide 

# create a service
kubectl apply -f k8s/single-pod-service.yaml

# check the service
kubectl get services -o wide

# check logs from the pod
kubectl logs single-pod

# edit pod configuration
kubectl edit pod single-pod

#expose the service and curl
minikube service single-pod-service -p vm-cluster
curl -v "$(minikube service single-pod-service -p vm-cluster --url)"
```