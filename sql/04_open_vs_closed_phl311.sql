-- =========================================================
-- OPEN VS CLOSED REQUESTS 
-- Source: 04_open_vs_closed_phl311.sql
-- =========================================================

-- 1) How many requests are open versus closed each month?
SELECT DATE_TRUNC('month',requested_at) AS month,
	   SUM(CASE WHEN status = 'Open' THEN 1 ELSE 0 END) AS requests_open,
	   SUM(CASE WHEN status = 'Closed' THEN 1 ELSE 0 END) AS requests_closed
FROM phl311.vw_phl311_clean
GROUP BY 1
ORDER BY month ASC;

-- 2) What is the current number of open service requests (current backlog)?
SELECT COUNT(*) AS open_services
FROM phl311.vw_phl311_clean
WHERE status  = 'Open';

-- 3) Which subjects contribute the most to the current open backlog?
SELECT  service_name,
		COUNT(*) AS open_status
FROM phl311.vw_phl311_clean
WHERE status = 'Open'
GROUP BY service_name
ORDER BY open_status DESC
LIMIT 10;
