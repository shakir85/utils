#!/bin/bash

# Run k8s default dashboard
# and generate access token

kubectl proxy > /dev/null 2>&1 &

kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"

echo ""
