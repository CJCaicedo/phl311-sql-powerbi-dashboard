CREATE OR REPLACE VIEW phl311.vw_phl311_clean AS
SELECT objectid,
       CASE WHEN service_request_id IS NULL OR TRIM(service_request_id) = '' THEN NULL 
	   ELSE TRIM(service_request_id)
		END AS service_request_id,
	   CASE WHEN subject IS NULL OR TRIM(subject) = '' THEN 'Unknown'
	   	ELSE TRIM(subject)
		   END AS subject,
		CASE 
			WHEN status IS NULL OR TRIM(status) = '' THEN 'Unknown'
			 WHEN LOWER(TRIM(status)) = 'closed' THEN 'Closed'
			 WHEN LOWER(TRIM(status)) = 'open' THEN 'Open'
			 ELSE 'Unknown'
		END AS status,
		CASE WHEN status_notes IS NULL OR TRIM(status_notes) = '' THEN NULL
			ELSE TRIM(status_notes)
			END AS status_notes,
		CASE WHEN service_name IS NULL OR TRIM(service_name) = '' THEN 'Unknown'
			ELSE TRIM(service_name)
			END AS service_name,
		CASE WHEN service_code IS NULL OR TRIM(service_code) = '' THEN NULL
			ELSE TRIM(service_code)
			END AS service_code,
		CASE WHEN agency_responsible IS NULL OR TRIM(agency_responsible) = '' 
			THEN 'Unknown' 
			ELSE TRIM(agency_responsible)
			END AS agency_responsible,
		CASE WHEN service_notice IS NULL OR TRIM(service_notice) = '' THEN NULL
			ELSE TRIM(service_notice)
			END AS service_notice,
		CASE WHEN requested_datetime IS NULL OR TRIM(requested_datetime) = ''
			THEN NULL
			ELSE requested_datetime::TIMESTAMPTZ
			END AS requested_at,
		CASE WHEN updated_datetime IS NULL OR TRIM(updated_datetime) = ''
			THEN NULL
			ELSE updated_datetime::TIMESTAMPTZ
			END AS updated_at,
		CASE WHEN expected_datetime IS NULL OR TRIM(expected_datetime) = ''
			THEN NULL
			ELSE expected_datetime::TIMESTAMPTZ
			END AS expected_at,
		CASE WHEN closed_datetime IS NULL OR TRIM(closed_datetime) = ''
			THEN NULL
			ELSE closed_datetime::TIMESTAMPTZ
			END AS closed_at,
		CASE WHEN address IS NULL OR TRIM(address) = '' THEN NULL
			ELSE TRIM(address)
			END AS address,
		CASE WHEN zipcode IS NULL OR TRIM(zipcode) = '' THEN NULL
			ELSE TRIM(zipcode)
			END AS zipcode,
		CASE WHEN media_url IS NULL OR TRIM(media_url) = '' THEN NULL
			ELSE TRIM(media_url)
			END AS media_url,
		lat,
		lon
FROM phl311.raw_phl311;

		
