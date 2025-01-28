-- merge tableA into tableB
MERGE `${project_id}.${dataset_id}.monthly_merged_top_10_search_term_impressions` B USING (
  SELECT
    EntityID,
    Month,
    Total,
    RawSearchTerm,
    AboveMaxDate,
    hasChanges
  FROM
    `${project_id_source}.${dataset_id}.monthly_merged_top_10_search_term_impressions`
  WHERE
    Month >= DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH)
) A ON B.EntityID = A.EntityID
WHEN MATCHED
AND A.hasChanges = TRUE THEN
UPDATE
SET
  B.Month = A.Month,
  B.Total = A.Total,
  B.RawSearchTerm = A.RawSearchTerm,
  B.AboveMaxDate = A.AboveMaxDate,
  B.hasChanges = FALSE
  WHEN NOT MATCHED THEN
INSERT
  (
    EntityID,
    Month,
    Total,
    RawSearchTerm,
    AboveMaxDate,
    hasChanges
  )
VALUES
  (
    A.EntityID,
    A.Month,
    A.Total,
    A.RawSearchTerm,
    A.AboveMaxDate,
    FALSE
  );

-- Set hasChanges to false in TableA only if the entry exists in TableB
UPDATE
  `${project_id_source}.${dataset_id}.monthly_merged_top_10_search_term_impressions` A
SET
  hasChanges = FALSE
WHERE
  hasChanges = TRUE
  AND Month >= DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH)
  AND EXISTS (
    SELECT
      1
    FROM
      `${project_id}.${dataset_id}.monthly_merged_top_10_search_term_impressions` B
    WHERE
      B.EntityID = A.EntityID
      AND B.Month = A.Month
      AND B.Total = A.Total
      AND B.RawSearchTerm = A.RawSearchTerm
      AND B.AboveMaxDate = A.AboveMaxDate
  );
