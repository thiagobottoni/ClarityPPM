-- It shows users who have not logged in to Clarity for over 90 days
SELECT  user_name, 
        user_uid,
        external_id,
        first_name, 
        last_name,
        email_address, LAST_LOGGED_IN_DATE
FROM    cmn_sec_users
WHERE   user_status_id = 200 
    AND user_name NOT IN ('admin', 'xog')
    AND (TRUNC(CURRENT_DATE) - TRUNC(last_logged_in_date) > 90 OR last_logged_in_date IS NULL)
ORDER BY user_name
