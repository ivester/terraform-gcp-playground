DECLARE dataTeamLogId STRING;

DECLARE oldMaxDate DATE;

DECLARE isSuccess BOOL;

DECLARE latestSuccessLogId STRING;

-- Set the dataset context
SET
  (dataTeamLogId, isSuccess) = (
    SELECT
      AS STRUCT ID,
      IsSuccess
    FROM
      `${project_id_source}.${dataset_id}.${log_table_id}`
    ORDER BY
      ExecutionDate DESC
    LIMIT
      1
  );

IF isSuccess = FALSE THEN RETURN;

END IF;

SET
  latestSuccessLogId = (
    SELECT
      DataTeamLogId
    FROM
      `${project_id}.${dataset_id}.${log_table_id}`
    WHERE
      IsSuccess = TRUE
    ORDER BY
      ExecutionDate DESC
    LIMIT
      1
  );

SET
  oldMaxDate = (
    SELECT
      OldMaxDate
    FROM
      `${project_id_source}.${dataset_id}.${log_table_id}`
    WHERE
      ID = latestSuccessLogId
  );

BEGIN BEGIN TRANSACTION;

DELETE FROM
  `${project_id}.${dataset_id}.${table_id}`
WHERE
  Month >= oldMaxDate;

INSERT INTO
  `${project_id}.${dataset_id}.${table_id}` (${columns})
SELECT
  ${columns}
FROM
  `${project_id_source}.${dataset_id}.${table_id}`
WHERE
  Month >= oldMaxDate;

COMMIT TRANSACTION;

INSERT INTO
  `${project_id}.${dataset_id}.${log_table_id}` (ID, DataTeamLogId, ExecutionDate, IsSuccess)
VALUES
  (
    GENERATE_UUID(),
    dataTeamLogId,
    CURRENT_TIMESTAMP(),
    TRUE
  );

EXCEPTION
WHEN ERROR THEN
INSERT INTO
  `${project_id}.${dataset_id}.${log_table_id}` (ID, DataTeamLogId, ExecutionDate, IsSuccess)
VALUES
  (
    GENERATE_UUID(),
    dataTeamLogId,
    CURRENT_TIMESTAMP(),
    FALSE
  );

END;
