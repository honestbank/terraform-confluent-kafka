#!/bin/bash

# Grep values from the result file
CLUSTER=$(grep '^| Cluster' schema-registry-result.txt | awk -F '|' '{print $3}' | xargs)
ENDPOINT=$(grep '^| Endpoint URL' schema-registry-result.txt | awk -F '|' '{print $3}' | xargs)
REGION=$(grep '^| Service Provider Region' schema-registry-result.txt | awk -F '|' '{print $3}' | xargs)
PACKAGE=$(grep '^| Package' schema-registry-result.txt | awk -F '|' '{print $3}' | xargs)

# Output in JSON
cat <<EOF
{
  "cluster": "$CLUSTER",
  "endpoint": "$ENDPOINT",
  "region": "$REGION",
  "package": "$PACKAGE"
}
EOF
