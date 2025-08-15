#!/usr/bin/env bash
set -euo pipefail

NAMESPACE=openstack

echo "create namespace $NAMESPACE (if not exists)"
kubectl create ns $NAMESPACE || true

echo "add helm repo openstack-helm (example)"
helm repo add openstack-helm https://openstack-helm.github.io/openstack-helm || true
helm repo update

echo "install common deps (contoh minimal)"
helm install mariadb openstack-helm/mariadb -n $NAMESPACE -f ../k8s/helm-values/openstack-values.yaml || true
helm install rabbitmq openstack-helm/rabbitmq -n $NAMESPACE -f ../k8s/helm-values/openstack-values.yaml || true

echo "install keystone"
helm install keystone openstack-helm/keystone -n $NAMESPACE -f ../k8s/helm-values/openstack-values.yaml || true

echo "install glance"
helm install glance openstack-helm/glance -n $NAMESPACE -f ../k8s/helm-values/openstack-values.yaml || true

echo "install nova"
helm install nova openstack-helm/nova -n $NAMESPACE -f ../k8s/helm-values/openstack-values.yaml || true

echo "done. watch pods: kubectl get pods -n $NAMESPACE"
