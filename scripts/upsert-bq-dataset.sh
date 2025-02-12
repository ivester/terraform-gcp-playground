#!/bin/bash

# Source the configuration file
source ./bq-config.sh

# Check if the dataset exists
if ! bq show --dataset "$PROJECT_ID:$DATASET_ID" >/dev/null 2>&1; then
  # Create the dataset if it doesn't exist
  bq --location="$LOCATION" mk --dataset "$PROJECT_ID:$DATASET_ID"
else
  echo "Dataset '$PROJECT_ID:$DATASET_ID' already exists."
fi

# create tables
for i in "${!TABLE_IDS[@]}"; do
  TABLE_ID="${TABLE_IDS[$i]}"
  SCHEMA_FILE="${SCHEMA_FILES[$i]}"

  # Run the script to create the table
  ./upsert-bq-table.sh "$PROJECT_ID:$DATASET_ID" "$TABLE_ID" "$SCHEMA_FILE" "$CLUSTERING_FIELD" "Month"
done

# create log tables
for i in "${!LOG_TABLE_IDS[@]}"; do
  LOG_TABLE_ID="${LOG_TABLE_IDS[$i]}"

  # Run the script to create the table
  ./upsert-bq-table.sh "$PROJECT_ID:$DATASET_ID" "$LOG_TABLE_ID" "./schema-log.json" "" "ExecutionDate"
done
