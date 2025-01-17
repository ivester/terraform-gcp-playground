-- merge tableA into tableB
MERGE `terraform_test_ives_7.presence_portal.monthly_merged_top_10_search_term_impressions` B USING (
  SELECT
    EntityID,
    Month,
    Total,
    RawSearchTerm,
    AboveMaxDate,
    hasChanges
  FROM
    `terraform-test-ives.presence_portal.monthly_merged_top_10_search_term_impressions`
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

-- Set hasChanges to false in TableA
UPDATE
  `terraform-test-ives.presence_portal.monthly_merged_top_10_search_term_impressions`
SET
  hasChanges = FALSE
WHERE
  hasChanges = TRUE;
