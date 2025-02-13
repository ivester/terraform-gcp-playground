#!/bin/bash

# Source the configuration file
source ./bq-config.sh

# Enable the BigQuery Data Transfer API
gcloud services enable bigquerydatatransfer.googleapis.com --project="$PROJECT_ID"

# Wait until the service is enabled
while ! gcloud services list --enabled --project="$PROJECT_ID" | grep -q "bigquerydatatransfer.googleapis.com"; do
  echo "Waiting for BigQuery Data Transfer API to be enabled..."
  sleep 5
done

echo "BigQuery Data Transfer API is enabled."

# Create scheduled queries
for i in "${!TABLE_IDS[@]}"; do
  TABLE_ID=${TABLE_IDS[$i]}
  LOG_TABLE_ID=${LOG_TABLE_IDS[$i]}
  COLUMN=${COLUMNS[$i]}
  TEMPLATE=$(cat sync-template.sql)
  QUERY=$(echo "$TEMPLATE" | sed \
    -e "s/\${project_id}/$PROJECT_ID/g" \
    -e "s/\${project_id_source}/$PROJECT_ID_SOURCE/g" \
    -e "s/\${dataset_id}/$DATASET_ID/g" \
    -e "s/\${table_id}/$TABLE_ID/g" \
    -e "s/\${log_table_id}/$LOG_TABLE_ID/g" \
    -e "s/\${columns}/$COLUMN/g")

  # Ensure the query is properly escaped for JSON
  ESCAPED_QUERY=$(echo "$QUERY" | jq -sRr @json)

  bq mk --transfer_config \
    --project_id="$PROJECT_ID" \
    --data_source="scheduled_query" \
    --display_name="$TABLE_ID" \
    --params="{\"query\":$ESCAPED_QUERY}" \
    --schedule="$DATA_TRANSFER_SCHEDULE" \
    --schedule_start_time="$DATA_TRANSFER_START" \
    --location="$LOCATION"
done
