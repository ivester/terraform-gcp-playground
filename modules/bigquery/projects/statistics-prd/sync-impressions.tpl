-- merge tableA into tableB
MERGE `${project_id}.${dataset_id}.${table_id}` B USING (
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
    `${project_id_source}.${dataset_id}.${table_id}`
  WHERE
    Month >= DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH)
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
  (${columns})
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

-- Set hasChanges to false in TableA only if the entry exists in TableB
UPDATE
  `${project_id_source}.${dataset_id}.${table_id}` A
SET
  hasChanges = FALSE
WHERE
  hasChanges = TRUE
  AND Month >= DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH)
  AND EXISTS (
    SELECT
      1
    FROM
      `${project_id}.${dataset_id}.${table_id}` B
    WHERE
      B.EntityID = A.EntityID
      AND B.Month = A.Month
      AND B.Total = A.Total
      AND B.Branded = A.Branded
      AND B.Unbranded = A.Unbranded
      AND B.Unspecified = A.Unspecified
      AND B.AboveMaxDate = A.AboveMaxDate
  );
