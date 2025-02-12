#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 5 ]; then
  echo "Usage: $0 <dataset_id> <table_id> <schema_file> <clustering_field> <partitioning_field>"
  exit 1
fi

# Assign arguments to variables
DATASET_ID=$1
TABLE_ID=$2
SCHEMA_FILE=$3
CLUSTERING_FIELD=$4
PARTITIONING_FIELD=$5

# Check if the table exists
if bq show --format=prettyjson "$DATASET_ID.$TABLE_ID" > /dev/null 2>&1; then
  echo "Table '$DATASET_ID.$TABLE_ID' already exists. Updating schema..."
  
  # Update the table schema
  bq update --schema "$SCHEMA_FILE" "$DATASET_ID.$TABLE_ID"
else
  echo "Table '$DATASET_ID.$TABLE_ID' does not exist. Creating table..."
  
  # Create the table using bq CLI
  if [ -n "$CLUSTERING_FIELD" ]; then
    bq mk --table \
      --time_partitioning_type=DAY \
      --time_partitioning_field=$PARTITIONING_FIELD \
      --clustering_fields="$CLUSTERING_FIELD" \
      "$DATASET_ID.$TABLE_ID" \
      "$SCHEMA_FILE"
  else
    bq mk --table \
      --time_partitioning_type=DAY \
      --time_partitioning_field=$PARTITIONING_FIELD \
      "$DATASET_ID.$TABLE_ID" \
      "$SCHEMA_FILE"
  fi
fi
