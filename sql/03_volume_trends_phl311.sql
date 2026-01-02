-- =========================================================
-- VOLUME TRENDS – Philadelphia 311 Clean View
-- Source: phl311.vw_phl311_clean
-- =========================================================

-- 1) How many 311 service requests are submitted each month over the full available date range?
SELECT
  DATE_TRUNC('month', requested_at) AS month,
  COUNT(*) AS service_requests_num
FROM phl311.vw_phl311_clean
GROUP BY 1
ORDER BY month ASC;

-- 2) How many 311 service requests were submitted in each of the last 12 months?
SELECT
  DATE_TRUNC('month', requested_at) AS month,
  COUNT(*) AS service_requests_num
FROM phl311.vw_phl311_clean
WHERE requested_at >= CURRENT_DATE - INTERVAL '12 months'
GROUP BY 1
ORDER BY month DESC;

-- 3) What are the top 10 most common request subjects overall?
SELECT
  service_name,
  COUNT(*) AS service_requests_num
FROM phl311.vw_phl311_clean
GROUP BY 1
ORDER BY service_requests_num DESC
LIMIT 10;

-- 4) How do the top request subjects vary by month? (Top 10 service_name per month; exactly 10 rows per month)
WITH monthly_service_name_counts AS (
  SELECT
    DATE_TRUNC('month', requested_at) AS month,
    service_name,
    COUNT(*) AS service_name_num
  FROM phl311.vw_phl311_clean
  GROUP BY 1, 2
),
ranked_service_name AS (
  SELECT
    month,
    service_name,
    service_name_num,
    ROW_NUMBER() OVER (PARTITION BY month ORDER BY service_name_num DESC, service_name) AS rn
  FROM monthly_service_name_counts
)
SELECT
  month,
  service_name,
  service_name_num,
  rn
FROM ranked_service_name
WHERE rn <= 10
ORDER BY month DESC, service_name_num DESC, service_name;
