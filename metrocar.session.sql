--How many users signed up on the app?
SELECT COUNT(DISTINCT user_id)
FROM signups
;

--How many users signed up on the app?
SELECT COUNT(DISTINCT user_id)
FROM signups
;

--Rides requested and completed through the app?
SELECT
  COUNT(DISTINCT ride_id) AS rides_requested,
  COUNT(DISTINCT CASE WHEN cancel_ts IS NULL THEN ride_id END) AS rides_completed
FROM ride_requests
;

--How many rides were requested and how many unique users requested a ride?
SELECT
  COUNT(DISTINCT ride_id) AS rides_requested,
  COUNT(DISTINCT user_id) AS users_requested
FROM ride_requests
;

--What is the average time of a ride from pick up to drop off?
SELECT AVG(dropoff_ts - pickup_ts) AS pickup_dropoff_time_avg
FROM ride_requests
;

--How many rides were accepted by a driver?
SELECT COUNT(DISTINCT ride_id) AS rides_accepted
FROM ride_requests
WHERE accept_ts is not null
;

--How many rides did we successfully collect payments and how much was collected?
SELECT COUNT(DISTINCT ride_id) AS num_rides,
                    SUM(purchase_amount_usd) as total_payments
FROM transactions
WHERE charge_status = 'Approved'
;

--How many ride requests happened on each platform?
SELECT 
a.platform, 
COUNT(DISTINCT r.ride_id) AS ride_requests
FROM app_downloads a
LEFT JOIN signups s ON a.app_download_key = s.session_id
LEFT JOIN ride_requests r ON s.user_id = r.user_id
GROUP BY 1
;

--What is the drop-off from users signing up to users requesting a ride?
SELECT (1 -(COUNT(DISTINCT user_id)/(SELECT COUNT(DISTINCT user_id)::float
FROM signups)))*100 AS signup_to_request_per
FROM ride_requests
;

--How many unique users requested a ride through the Metrocar app?
SELECT COUNT(DISTINCT user_id) AS total_ride_requesters
FROM ride_requests
;

--How many unique users completed a ride through the Metrocar app?
SELECT COUNT(DISTINCT user_id) AS total_ride_completers
FROM ride_requests
WHERE cancel_ts is null
;

--the users that signed up on the app, what percentage these users requested a ride?
SELECT COUNT(DISTINCT user_id)*100/(SELECT COUNT(DISTINCT user_id)::float
FROM signups) AS signup_to_request_per
FROM ride_requests
;

--The users that signed up on the app, what percentage these users completed a ride? This question is required.
SELECT (SELECT COUNT(DISTINCT user_id)
FROM ride_requests
WHERE cancel_ts is null)*100 / COUNT(DISTINCT user_id)::float AS percentage_completers
FROM signups
;

--Using the percent of previous approach, what are the user-level conversion rates for the first 3 stages of the funnel (app download to signup and signup to ride requested)?
SELECT COUNT(DISTINCT user_id)*100/(SELECT COUNT(app_download_key)::float
FROM app_downloads) as download_to_signup_per,
(SELECT COUNT(DISTINCT user_id)*100/(SELECT COUNT(DISTINCT user_id)::float
FROM signups) FROM ride_requests) AS signup_to_request_per
FROM signups
;

--Using the percent of top approach, what are the user-level conversion rates for the first 3 stages of the funnel (app download to signup and signup to ride requested)? This question is required.
SELECT COUNT(DISTINCT user_id)*100/(SELECT COUNT(app_download_key)::float
FROM app_downloads) as download_to_signup_per,
(SELECT COUNT(DISTINCT user_id)*100/(SELECT COUNT(app_download_key)::float
FROM app_downloads)
FROM ride_requests) AS download_to_request_per
FROM signups
;

--Using the percent of previous approach, what are the user-level conversion rates for the following 3 stages of the funnel? 1. signup, 2. ride requested, 3. ride completed
SELECT COUNT(DISTINCT user_id)*100/(SELECT COUNT(DISTINCT user_id)::float
FROM signups) AS signup_to_request_per,
(SELECT COUNT(DISTINCT user_id)
FROM ride_requests
WHERE cancel_ts is null)*100 / COUNT(DISTINCT user_id)::float AS percentage_completers
FROM ride_requests
;

--Using the percent of top *approach, what are the user-level conversion rates for the
--following 3 stages of the funnel? 1. signup, 2. ride requested, 3. ride completed (hint: signup is the 
--top of this funnel) This question is required.
SELECT COUNT(DISTINCT user_id)*100/(SELECT COUNT(DISTINCT user_id)::float
FROM signups) AS signup_to_request_per,
(SELECT (SELECT COUNT(DISTINCT user_id)
FROM ride_requests
WHERE cancel_ts is null)*100 / COUNT(DISTINCT user_id)::float
FROM signups) AS percentage_completers
FROM ride_requests
;

