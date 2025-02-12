#!/bin/bash

# Declare variables
PROJECT_ID="terraform-test-ives-19"
PROJECT_ID_SOURCE="terraform-test-ives"
LOCATION="europe-west6"
DATASET_ID="presence_portal"
DATA_TRANSFER_SCHEDULE="every 24 hours"
DATA_TRANSFER_START="2025-02-11T07:00:00Z"

TABLE_IDS=(
  "monthly_merged_impressions_stats"
  "monthly_merged_customer_actions"
  "monthly_merged_top_10_search_term_impressions"
)
COLUMNS=(
  "EntityID, Month, Total, Branded, Unbranded, Unspecified, FacebookPaidImpressions, AboveMaxDate"
  "EntityID, Month, Total, Category, AboveMaxDate"
  "EntityID, Month, Total, RawSearchTerm, AboveMaxDate"
)
SCHEMA_FILES=(
  "./schema-impressions.json"
  "./schema-interactions.json"
  "./schema-top-10-terms.json"
)
LOG_TABLE_IDS=(
  "monthly_merged_impressions_stats_log"
  "monthly_merged_customer_actions_log"
  "monthly_merged_top_10_search_term_impressions_log"
)
CLUSTERING_FIELD="EntityID"
