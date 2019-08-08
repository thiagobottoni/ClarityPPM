SELECT	@SELECT:DIM:USER_DEF:IMPLIED:PROJECT:projects.id:id@,
		@SELECT:DIM_PROP:USER_DEF:IMPLIED:PROJECT:projects.name:name@,
        @SELECT:DIM_PROP:USER_DEF:IMPLIED:PROJECT:projects.code:code@,
		@SELECT:DIM_PROP:USER_DEF:IMPLIED:PROJECT:projects.percent_complete:percent_complete@
FROM	(

SELECT DISTINCT 
			inv.id,
			inv.name,
			inv.code,
            prj.percent_complete
FROM        inv_projects prj
	JOIN    inv_investments inv     ON prj.prid = inv.id
	JOIN    prtask tsk              ON prj.prid = tsk.prprojectid
WHERE       prj.is_template = 0 
	AND     inv.odf_object_code = 'project' 
	AND     inv.is_active = 1
	AND     prj.percent_calc_mode = 0
	AND     tsk.pristask = 1
	
	) projects
WHERE	@FILTER@
HAVING	@HAVING_FILTER@
