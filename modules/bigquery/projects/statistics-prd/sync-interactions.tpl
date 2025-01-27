-- merge tableA into tableB
MERGE `${project_id}.${dataset_id}.monthly_merged_customer_actions` B USING (
  SELECT
    EntityID,
    Month,
    Total,
    Category,
    AboveMaxDate,
    hasChanges
  FROM
    `${project_id_source}.${dataset_id}.monthly_merged_customer_actions`
) A ON B.EntityID = A.EntityID
WHEN MATCHED
AND A.hasChanges = TRUE THEN
UPDATE
SET
  B.Month = A.Month,
  B.Total = A.Total,
  B.Category = A.Category,
  B.AboveMaxDate = A.AboveMaxDate,
  B.hasChanges = FALSE
  WHEN NOT MATCHED THEN
INSERT
  (
    EntityID,
    Month,
    Total,
    Category,
    AboveMaxDate,
    hasChanges
  )
VALUES
  (
    A.EntityID,
    A.Month,
    A.Total,
    A.Category,
    A.AboveMaxDate,
    FALSE
  );

-- Set hasChanges to false in TableA
UPDATE
  `${project_id_source}.${dataset_id}.monthly_merged_customer_actions`
SET
  hasChanges = FALSE
WHERE
  hasChanges = TRUE;
