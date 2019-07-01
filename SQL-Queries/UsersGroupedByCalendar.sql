--It returns the number of users grouped by calendar

SELECT		COUNT(res.full_name) 			"Users",
			calendar_group.calendar_name 	"Calendar Name"
FROM 		srm_resources res
INNER JOIN	prj_resources prs
		ON 	res.id = prs.prid
LEFT JOIN 	prcalendar prc
		ON	prc.prresourceid = res.id
inner join (SELECT CASE WHEN	prc2.prname IS NOT NULL 
						THEN	prc2.prname 
						ELSE 	'Custom Calendar' 
						END AS calendar_name, prc2.prid 
			FROM prcalendar prc2) calendar_group
		ON 	calendar_group.prid = prs.prcalendarid
		INNER JOIN  	prj_obs_associations obsa 
		ON 		res.ID = obsa.record_id 
		AND 	(obsa.table_name = 'SRM_RESOURCES')
INNER JOIN  	prj_obs_units obsu 
		ON 		obsu.id = obsa.unit_id 
		--AND 	obsu.type_id = 0000000 					--Use that line to fetch a specific OBS path
		WHERE	(prs.prcalendarid <> 9			--Standard Calendar ID
				 OR prc.prbasecalendarid <> 9)	--Standard Calendar ID
        AND res.person_type <> 0
        AND res.is_active = 1
GROUP BY	calendar_group.calendar_name
