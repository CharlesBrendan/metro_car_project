--Times Metrocar app_download was downloaded

SELECT COUNT(DISTINCT app_download_key) AS times_downloaded
FROM app_downloads
;

-- Query to fine number of users signed up on the app
SELECT COUNT(DISTINCT user_id)
FROM signups
;

-- Rides requested through the app
SELECT COUNT(DISTINCT ride_id) as rides_requested
FROM ride_requests
;

--Rides requested and completed through the app
SELECT
  COUNT(DISTINCT ride_id) AS rides_requested,
  COUNT(DISTINCT CASE WHEN cancel_ts IS NULL THEN ride_id END) AS rides_completed
FROM ride_requests
;

--rides requested and how many unique users requested a ride
SELECT
  COUNT(DISTINCT ride_id) AS rides_requested,
  COUNT(DISTINCT user_id) AS users_requested
FROM ride_requests
;

--The average time of a ride from pick up to drop off
SELECT AVG(dropoff_ts - pickup_ts) AS pickup_dropoff_time_avg
FROM ride_requests
;

--Rides accepted by a drive
SELECT COUNT(DISTINCT ride_id) AS rides_accepted
FROM ride_requests
WHERE accept_ts is not null
;

--Number of rides with successfully collect payments and how much was collect
SELECT COUNT(DISTINCT ride_id) AS num_rides,
                    SUM(purchase_amount_usd) as total_payments
FROM transactions
WHERE charge_status = 'Approved'
;

-- Ride requests on each platform
SELECT a.platform, COUNT(DISTINCT r.ride_id) AS ride_requests
FROM app_downloads a
LEFT JOIN signups s ON a.app_download_key = s.session_id
LEFT JOIN ride_requests r ON s.user_id = r.user_id
GROUP BY 1
;

--The drop-off from users signing up to users requesting a ride
SELECT (1 -(COUNT(DISTINCT user_id)/(SELECT COUNT(DISTINCT user_id)::float
FROM signups)))*100 AS signup_to_request_per
FROM ride_requests
;