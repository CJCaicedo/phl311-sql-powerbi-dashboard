-- =========================================================
-- DATA QUALITY CHECKS – Philadelphia 311 Clean View
-- =========================================================

-- 1) Missing IDs after cleaning
SELECT COUNT(*)
FROM  phl311.vw_phl311_clean
WHERE service_request_id IS NULL;

-- 2) Remaining "Unknown" classifications
SELECT
  SUM(CASE WHEN subject = 'Unknown' THEN 1 ELSE 0 END) AS unknown_subjects,
  SUM(CASE WHEN status = 'Unknown' THEN 1 ELSE 0 END) AS unknown_statuses
FROM phl311.vw_phl311_clean;

-- 3) Duplicate IDs (list)
SELECT service_request_id, COUNT(*) AS duplicate_service_req_id
FROM phl311.vw_phl311_clean
WHERE service_request_id IS NOT NULL
GROUP BY service_request_id
HAVING COUNT(*) > 1;

-- 4) Date coverage
SELECT
  MIN(requested_at),
  MAX(requested_at)
FROM phl311.vw_phl311_clean;


-- =========================================================
-- EXECUTIVE DATA QUALITY SUMMARY
-- =========================================================

SELECT COUNT(*) AS total_rows,
	   SUM(CASE WHEN service_request_id IS NULL THEN 1 ELSE 0 END) AS null_service_req_id,
	   COUNT(DISTINCT service_request_id) AS distinct_service_request_id, 
	   SUM(CASE WHEN subject = 'Unknown' THEN 1 ELSE 0 END) AS unknown_subjects,
	   SUM(CASE WHEN status = 'Unknown' THEN 1 ELSE 0 END) AS unknown_statuses,
	   MIN(requested_at) AS earliest_requested_at,
	   MAX(requested_at) AS latest_requested_at
FROM phl311.vw_phl311_clean;
