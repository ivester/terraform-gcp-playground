-- merge tableA into tableB
MERGE `${project_id}.${dataset_id}.monthly_merged_impressions_stats` B USING (
  SELECT
    EntityID,
    Month,
    Total,
    Branded,
    Unbranded,
    Unspecified,
    FacebookPaidImpressions,
    AboveMaxDate,
    hasChanges
  FROM
    `${project_id_source}.${dataset_id}.monthly_merged_impressions_stats`
) A ON B.EntityID = A.EntityID
WHEN MATCHED
AND A.hasChanges = TRUE THEN
UPDATE
SET
  B.Month = A.Month,
  B.Total = A.Total,
  B.Branded = A.Branded,
  B.Unbranded = A.Unbranded,
  B.Unspecified = A.Unspecified,
  B.AboveMaxDate = A.AboveMaxDate,
  B.hasChanges = FALSE
  WHEN NOT MATCHED THEN
INSERT
  (
    EntityID,
    Month,
    Total,
    Branded,
    Unbranded,
    Unspecified,
    AboveMaxDate,
    hasChanges
  )
VALUES
  (
    A.EntityID,
    A.Month,
    A.Total,
    A.Branded,
    A.Unbranded,
    A.Unspecified,
    A.AboveMaxDate,
    FALSE
  );

-- Set hasChanges to false in TableA
UPDATE
  `${project_id_source}.${dataset_id}.monthly_merged_impressions_stats`
SET
  hasChanges = FALSE
WHERE
  hasChanges = TRUE;
