#!/bin/bash
set -euo pipefail

payload_file="$(mktemp)"
trap 'rm -f "$payload_file"' EXIT
printf '%s' "$TASK_PAYLOAD" > "$payload_file"

task_key="$(oci data-integration task list \
  --workspace-id "$WORKSPACE_ID" \
  --identifier "$TASK_IDENTIFIER" \
  --type OCI_DATAFLOW_TASK \
  --all \
  --query 'data.items[0].key' \
  --raw-output 2>/dev/null || true)"

if [ -n "$task_key" ] && [ "$task_key" != "null" ]; then
  key="$(oci data-integration task get \
    --workspace-id "$WORKSPACE_ID" \
    --task-key "$task_key" \
    --query 'data.key' \
    --raw-output)"

  object_version="$(oci data-integration task get \
    --workspace-id "$WORKSPACE_ID" \
    --task-key "$task_key" \
    --query 'data.objectVersion' \
    --raw-output)"

  oci data-integration task update-task-from-dataflow-task \
    --workspace-id "$WORKSPACE_ID" \
    --task-key "$task_key" \
    --key "$key" \
    --object-version "$object_version" \
    --from-json "file://$payload_file" \
    --force
else
  oci data-integration task create-task-from-dataflow-task \
    --from-json "file://$payload_file"
fi
