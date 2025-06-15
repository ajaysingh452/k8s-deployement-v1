#!/bin/bash

set -e

# Load .env if available
[[ -f .env ]] && source .env

# Prompt for missing values
read -p "Namespace [${NAMESPACE:-default}]: " input_namespace
NAMESPACE="${input_namespace:-${NAMESPACE:-default}}"

read -p "App Name [${APP_NAME:-welcome-web}]: " input_app
APP_NAME="${input_app:-${APP_NAME:-welcome-web}}"

read -p "Ingress Host [${INGRESS_HOST:-inichepro.in}]: " input_host
INGRESS_HOST="${input_host:-${INGRESS_HOST:-inichepro.in}}"

read -p "Ingress Path [/${INGRESS_PATH:-hi}]: " input_path
INGRESS_PATH="/${input_path:-${INGRESS_PATH:-hi}}"

# Build Docker image
docker build -t ${APP_NAME}:latest .

# Create Kubernetes resources
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${APP_NAME}
  namespace: ${NAMESPACE}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ${APP_NAME}
  template:
    metadata:
      labels:
        app: ${APP_NAME}
    spec:
      containers:
      - name: ${APP_NAME}
        image: ${APP_NAME}:latest
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: ${APP_NAME}
  namespace: ${NAMESPACE}
spec:
  selector:
    app: ${APP_NAME}
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ${APP_NAME}-ingress
  namespace: ${NAMESPACE}
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
    - host: ${INGRESS_HOST}
      http:
        paths:
          - path: ${INGRESS_PATH}
            pathType: Prefix
            backend:
              service:
                name: ${APP_NAME}
                port:
                  number: 80
EOF
