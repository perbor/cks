#!/bin/bash
echo " *** master node  mock-5  k8s-8"
export KUBECONFIG=/root/.kube/config
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl taint nodes --all node-role.kubernetes.io/control-plane-

# source: tasks/cks/mock/02/k8s-7/scripts/task1.yaml
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Namespace
metadata:
  name: blue-team
  labels:
    name: blue-team
---
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: deployment1
  name: deployment1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: deployment1
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: deployment1
    spec:
      nodeSelector:
        work_type: falco
      containers:
      - image: viktoruj/cks-lab:cks_mock2_12_app1
        name: deployment


---
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: deployment1
  name: deployment1
  namespace: blue-team
spec:
  replicas: 1
  selector:
    matchLabels:
      app: deployment1
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: deployment1
    spec:
      nodeSelector:
        work_type: falco
      containers:
      - image: viktoruj/cks-lab:cks_mock2_12_app2
        name: deployment


---
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: deployment2
  name: deployment2
spec:
  replicas: 1
  selector:
    matchLabels:
      app: deployment2
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: deployment2
    spec:
      nodeSelector:
        work_type: falco
      containers:
      - image: viktoruj/ping_pong
        name: deployment


---
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: deployment3
  name: deployment3
spec:
  replicas: 1
  selector:
    matchLabels:
      app: deployment3
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: deployment3
    spec:
      nodeSelector:
        work_type: falco
      containers:
      - image: viktoruj/ping_pong:alpine
        name: deployment


---
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: deployment4
  name: deployment4
spec:
  replicas: 1
  selector:
    matchLabels:
      app: deployment4
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: deployment4
    spec:
      nodeSelector:
        work_type: falco
      containers:
      - image: nginx
        name: deployment

EOF
