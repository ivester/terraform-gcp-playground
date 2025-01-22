-- merge tableA into tableB
MERGE `terraform-test-ives-9.presence_portal.monthly_merged_customer_actions` B USING (
  SELECT
    EntityID,
    Month,
    Total,
    Category,
    AboveMaxDate,
    hasChanges
  FROM
    `terraform-test-ives.presence_portal.monthly_merged_customer_actions`
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
  `terraform-test-ives.presence_portal.monthly_merged_customer_actions`
SET
  hasChanges = FALSE
WHERE
  hasChanges = TRUE;
