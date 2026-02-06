# Config Map

### Goal
Deploy an app that prints evns in kubernetes with Deployment, Service and ConfigMap.

### Tasks
1. Create a Deployment manifest file named `configmap-deployment.yaml` that pulls a simple fastapi container from dockerhub and prints envs.
2. Create a ConfigMap manifest file named `configmap.yaml` that contains some envs.
3. Run the `configmap.yaml` first then `configmap-deployment.yaml`.
4. Exposee with a Service.
5. Deploy and curl it from the cluster.

### Broke
1. Not creating the ConfigMap before the Deployment.
2. Not mounting the ConfigMap to the Deployment.
3. Leaving out some env in deployment
4. missing key

### commands used
```bash
# create a deployment
kubectl apply -f k8s/configmap-deployment.yaml
# create a configmap
kubectl apply -f k8s/configmap.yaml
# check the deployment
kubectl get deployments -o wide
# check the service
kubectl get services -o wide
# check logs from the pod
kubectl logs -l app=configmap-deployment
# expose the service and curl
minikube service configmap-svc -p vm-cluster
curl -v "$(minikube service configmap-svc -p vm-cluster --url)"