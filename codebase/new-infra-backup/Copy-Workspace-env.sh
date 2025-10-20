#!/bin/bash
# Set your variables
set -euo pipefail
ORG_NAME="BankiFi"
SRC_WS="tf-wsp-central"
DEST_WS="tf-wsp-baseline-ukwest"
TFC_TOKEN="UVy8yiZ1USzfew.atlasv1.t6fzDUNVGA55y65hwzsDuCW4dKHzYLcyxUNIA6SAPdknT37JZ9Rd9BltiAshKUi9c5E"

# ----------------------------------------
# Script starts
# ----------------------------------------

echo "Fetching workspace IDs..."
SRC_WS_ID=$(curl -s \
  --header "Authorization: Bearer $TFC_TOKEN" \
  https://app.terraform.io/api/v2/organizations/$ORG_NAME/workspaces/$SRC_WS \
  | jq -r .data.id)

DEST_WS_ID=$(curl -s \
  --header "Authorization: Bearer $TFC_TOKEN" \
  https://app.terraform.io/api/v2/organizations/$ORG_NAME/workspaces/$DEST_WS \
  | jq -r .data.id)

if [ -z "$SRC_WS_ID" ] || [ -z "$DEST_WS_ID" ]; then
  echo "❌ Could not find source or destination workspace. Check org and workspace names."
  exit 1
fi

echo "Source: $SRC_WS ($SRC_WS_ID)"
echo "Destination: $DEST_WS ($DEST_WS_ID)"
echo "-------------------------------------------"

# Fetch all vars from source
VARS=$(curl -s \
  --header "Authorization: Bearer $TFC_TOKEN" \
  https://app.terraform.io/api/v2/workspaces/$SRC_WS_ID/vars \
  | jq -c '.data[]')

# Loop over and copy
echo "$VARS" | while read -r var; do
  KEY=$(echo "$var" | jq -r '.attributes.key')
  VALUE=$(echo "$var" | jq -r '.attributes.value' | jq -Rs .)
  CATEGORY=$(echo "$var" | jq -r '.attributes.category')
  HCL=$(echo "$var" | jq -r '.attributes.hcl')
  SENSITIVE=$(echo "$var" | jq -r '.attributes.sensitive')

  # Handle sensitive vars (value is not returned by API)
  if [ "$SENSITIVE" = "true" ]; then
    VALUE="\"\""   # empty placeholder
  fi

  echo "→ Copying $KEY (category=$CATEGORY, hcl=$HCL, sensitive=$SENSITIVE)"

  curl -s \
    --header "Authorization: Bearer $TFC_TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    --request POST \
    --data "{
      \"data\": {
        \"type\":\"vars\",
        \"attributes\": {
          \"key\":\"$KEY\",
          \"value\":$VALUE,
          \"category\":\"$CATEGORY\",
          \"hcl\":$HCL,
          \"sensitive\":$SENSITIVE
        }
      }
    }" \
    https://app.terraform.io/api/v2/workspaces/$DEST_WS_ID/vars > /dev/null

done

echo "✅ All variables copied successfully!"