--It returns the users' full name, current calendar and OBS path

SELECT			res.full_name								"FULL NAME",
            res.unique_name							"RESOURCE ID (XOG)",
            prs.prcalendarid						"CALENDAR ID",
            prc.prbasecalendarid				"BASE CALENDAR ID",
				(
				 SELECT CASE WHEN	prc2.prname IS NOT NULL 
							  THEN	prc2.prname 
							  ELSE 	'Custom Calendar' 
							  END AS IS_CUSTOM 
				 FROM prcalendar prc2 
				 WHERE prc2.prid = prs.prcalendarid
				)											           "CALENDAR NAME",
				obs_unit_full_path(obsa.unit_id) "OBS PATH"
FROM 			    srm_resources res
INNER JOIN		prj_resources prs
		    ON 		res.id = prs.prid
LEFT JOIN 		prcalendar prc
		    ON		prc.prresourceid = res.id
INNER JOIN  	prj_obs_associations obsa 
		    ON 		res.ID = obsa.record_id 
		    AND 	(obsa.table_name = 'SRM_RESOURCES')
INNER JOIN  	prj_obs_units obsu 
		    ON 		obsu.id = obsa.unit_id 
		    --AND 	obsu.type_id = 0000000    Use that line to fetch a specific OBS type
WHERE			(
				    prs.prcalendarid <> 9 		    --Standard Calendar ID
				    OR prc.prbasecalendarid <> 9  --Standard Calendar ID
				  ) 
		AND		res.person_type <> 0
		AND		is_active = 1
ORDER BY		res.full_name
