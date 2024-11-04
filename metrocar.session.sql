--Question 1: How many times was the app downloaded?
SELECT COUNT (DISTINCT app_downloads) AS app_downloaded
FROM app_downloads
;

--Question 2: How many users signed up on the app?
SELECT COUNT (DISTINCT user_id) AS signedup_users
FROM signups
;

--Question 3: How many rides were requested through the app?
SELECT COUNT (DISTINCT ride_id) AS rides_requested
FROM ride_requests
;

