#!/bin/sh

set -e

client_id=$(yq -r .clientId "$HOME/.config/msstore.yml")
client_secret=$(yq -r .clientSecret "$HOME/.config/msstore.yml")
tenant_id=$(yq -r .tenantId "$HOME/.config/msstore.yml")
api="https://manage.devcenter.microsoft.com"

access_token=$(curl -X POST "https://login.microsoftonline.com/$tenant_id/oauth2/token" \
  -H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" \
  -d "grant_type=client_credentials" \
  -d "client_id=$client_id" \
  -d "client_secret=$client_secret" \
  -d "resource=$api" | jq -r .access_token)

app_id=$(yq -r .msix_config.msstore_appId pubspec.yaml)

submission_response=$(curl -X POST "$api/v1.0/my/applications/$app_id/submissions" \
  -H "Authorization: Bearer $access_token" \
  -H "Content-Type: application/json" \
  -H "Content-Length: 0")
submission_id=$(echo "$submission_response" | jq .id)
file_upload_url=$(echo "$submission_response" | jq .fileUploadUrl)

if [ -z "$submission_id" ]; then
  echo "Submission failed to create"
  exit 1
fi

curl -X PUT "$file_upload_url" \
  -H "Content-Type: application/octet-stream" \
  -H "x-ms-blob-type: BlockBlob" \
  --data-binary "@$1"

curl -X POST "$api/v1.0/my/applications/$app_id/submissions/commit" \
  -H "Authorization: Bearer $access_token" \
  -H "Content-Type: application/json" \
  -H "Content-Length: 0"
