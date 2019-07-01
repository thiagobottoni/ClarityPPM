--Returns the project team

SELECT DISTINCT INV.NAME "Investment Name",
		SRM.FULL_NAME "Resource",
          	(
          		SELECT	PROLE.LAST_NAME
          		FROM	SRM_RESOURCES PROLE
          		WHERE	PROLE.ID = TEAM.PRROLEID
          	) "Project Role",
		DECODE	(TEAM.PRBOOKING, 15, 'Hard', 10, 'Mixed', 5, 'Soft') "Booking Status",
		DECODE	(TEAM.PRISOPEN, 1, 'True', 0, 'False') "Open for Time"
FROM		INV_INVESTMENTS INV
	INNER JOIN	PRTEAM TEAM
		ON	TEAM.PRPROJECTID = INV.ID
	INNER JOIN	SRM_RESOURCES SRM
		ON	SRM.ID = TEAM.PRRESOURCEID
WHERE	INV.CODE = 'PR1002' --Type any project code
