-- =========================================================
-- TIMELINESS / RESOLUTION 
-- Source: 05_timeliness_resolution_phl311
-- =========================================================

-- 1)What is the average number of days required to close a service request, by subject?
SELECT service_name,
COUNT(*) AS closed_count,
AVG( (closed_at::DATE - requested_at::DATE)) AS average_days
FROM phl311.vw_phl311_clean
WHERE status = 'Closed' 
AND closed_at IS NOT NULL
AND requested_at IS NOT NULL
AND (closed_at::date - requested_at::date) >= 0
GROUP BY service_name
ORDER BY average_days DESC;

-- 2)What is the median number of days required to close a service request, by subject?
SELECT service_name,
COUNT(*) AS closed_count,
PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY (closed_at::DATE - requested_at::DATE))  AS median_days
FROM phl311.vw_phl311_clean
WHERE status = 'Closed' 
AND closed_at IS NOT NULL
AND requested_at IS NOT NULL
AND (closed_at::DATE - requested_at::DATE) >=0
GROUP BY service_name
ORDER BY median_days DESC ;

-- 3)What percentage of service requests are closed within 7, 14, and 30 days?
WITH closed_duration AS(
SELECT (closed_at::DATE - requested_at::DATE) AS days_to_close
FROM phl311.vw_phl311_clean
WHERE status  = 'Closed' 
AND closed_at IS NOT NULL
AND requested_at IS NOT NULL
AND (closed_at::DATE - requested_at::DATE) >=0
),
days AS( 
SELECT 
COUNT(*) AS total_closed,
SUM(CASE WHEN days_to_close <= 7 THEN 1 ELSE 0 END) AS seven_days,
SUM(CASE WHEN days_to_close <= 14 THEN 1 ELSE 0 END) AS fourteen_days,
SUM(CASE WHEN days_to_close <= 30 THEN 1 ELSE 0 END) AS thirty_days
FROM closed_duration
)

SELECT total_closed,
	   seven_days,
	   fourteen_days,
	   thirty_days,
	   ROUND((100.0 * seven_days / NULLIF(total_closed, 0)),2) AS pct_7_days,
	   ROUND((100.0 * fourteen_days / NULLIF(total_closed, 0)),2) AS pct_14_days,
	   ROUND((100.0 * thirty_days / NULLIF(total_closed, 0)),2) AS pct_40_days
FROM days;