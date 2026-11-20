#!/bin/bash
echo " *** master node  mock-5  k8s-6"
export KUBECONFIG=/root/.kube/config
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl taint nodes --all node-role.kubernetes.io/control-plane-

# source: tasks/cks/mock/02/k8s-6/scripts/task20.yaml
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Namespace
metadata:
  creationTimestamp: null
  name: team-20
spec: {}
status: {}

---
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: team20
  name: team20
  namespace: team-20
spec:
  replicas: 1
  selector:
    matchLabels:
      app: team20
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: team20
    spec:
      containers:
      - image: viktoruj/ping_pong:alpine
        name: app
        ports:
        - containerPort: 8080

EOF
