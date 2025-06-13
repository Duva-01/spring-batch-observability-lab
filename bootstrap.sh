#!/usr/bin/env bash
set -euo pipefail

# --- Parámetros que puedes ajustar ---
CLUSTER_NAME="monitoring-lab"
CPUS=2
MEMORY=4096           # MB
BATCH_TAG="0.1.2"
NAMESPACE="monitoring"
# -------------------------------------

echo ">>> 1) Arrancando Minikube..."
minikube start -p "$CLUSTER_NAME" --driver=docker \
              --cpus="$CPUS" --memory="${MEMORY}m"

echo ">>> 2) Habilitando metrics-server (opcional)..."
minikube -p "$CLUSTER_NAME" addons enable metrics-server || true

echo ">>> 3) Preparando daemon Docker interno..."
eval "$(minikube -p "$CLUSTER_NAME" docker-env)"

echo ">>> 4) Construyendo imagen hello-batch:${BATCH_TAG}..."
docker build -t hello-batch:"$BATCH_TAG" ./hello-batch

echo ">>> 5) Instalando kube-prometheus-stack..."
helm repo add prometheus-community \
     https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
     -n "$NAMESPACE" --wait

echo ">>> 6) Desplegando hello-batch + PodMonitor..."
helm upgrade --install hello-batch ./hello-batch-chart \
     -n "$NAMESPACE" \
     --set image.repository=hello-batch \
     --set image.tag="$BATCH_TAG" --wait

echo ">>> 7) Abriendo Grafana en el navegador..."
minikube -p "$CLUSTER_NAME" service monitoring-grafana -n "$NAMESPACE"
echo "Usuario: admin  |  Contraseña: admin"
