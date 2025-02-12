#!/bin/bash

source ./bq-config.sh

bq load --project_id="$PROJECT_ID" --source_format=NEWLINE_DELIMITED_JSON "$DATASET_ID.monthly_merged_impressions_stats" "./test-data.json"
