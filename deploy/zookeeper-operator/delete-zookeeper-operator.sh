#!/usr/bin/env bash
ZOOKEEPER_OPERATOR_NAMESPACE=${ZOOKEEPER_OPERATOR_NAMESPACE:-zookeeper-operator}
kubectl delete ns "$ZOOKEEPER_OPERATOR_NAMESPACE"