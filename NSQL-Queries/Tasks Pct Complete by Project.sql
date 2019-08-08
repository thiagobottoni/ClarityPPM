SELECT	@SELECT:DIM:USER_DEF:IMPLIED:PROJECT:tasks.prid:prid@,
        @SELECT:DIM_PROP:USER_DEF:IMPLIED:PROJECT:tasks.prprojectid:prprojectid@, 
		@SELECT:DIM_PROP:USER_DEF:IMPLIED:PROJECT:tasks.prname:prname@,
        @SELECT:DIM_PROP:USER_DEF:IMPLIED:PROJECT:tasks.task_type:task_type@,
		@SELECT:DIM_PROP:USER_DEF:IMPLIED:PROJECT:tasks.cpc_duration:cpc_duration@,
		@SELECT:DIM_PROP:USER_DEF:IMPLIED:PROJECT:tasks.prpctcomplete:prpctcomplete@,
		@SELECT:DIM_PROP:USER_DEF:IMPLIED:PROJECT:tasks.cpc_days_complete:cpc_days_complete@,
		@SELECT:DIM_PROP:USER_DEF:IMPLIED:PROJECT:tasks.calculation:calculation@,
        @SELECT:DIM_PROP:USER_DEF:IMPLIED:PROJECT:tasks.description:description@,
        @SELECT:DIM_PROP:USER_DEF:IMPLIED:PROJECT:tasks.cpc_update:cpc_update@,
        @SELECT:DIM_PROP:USER_DEF:IMPLIED:PROJECT:tasks.cpc_exclude:cpc_exclude@,
        @SELECT:DIM_PROP:USER_DEF:IMPLIED:PROJECT:tasks.wbs:wbs@,
        @SELECT:DIM_PROP:USER_DEF:IMPLIED:PROJECT:tasks.task_level:task_level@
FROM	(
			SELECT  tsk.prid,
					tsk.prprojectid,
					tsk.prname,
					CASE CONNECT_BY_ISLEAF WHEN 0 THEN 'SUMMARY' WHEN 1 THEN 'TASK' ELSE 'N/A' END task_type,
					odf_tsk.cpc_duration,
					tsk.prpctcomplete,
					odf_tsk.cpc_days_complete,
					CASE CONNECT_BY_ISLEAF WHEN 1 THEN 'Days Complete = Duration * Percent Complete' WHEN 0 THEN '% Complete = Total Childs Days Complete / Total Childs Duration' END calculation,
					CASE CONNECT_BY_ISLEAF WHEN 1 THEN 'You update the detail task duration and/or % Complete. Clarity calculates the days complete' WHEN 0 THEN 'Clarity calculates total duration, days complete and % complete for summary tasks automatically' END description,
					CASE CONNECT_BY_ISLEAF WHEN 1 THEN odf_tsk.cpc_update ELSE 0 END cpc_update,
					odf_tsk.cpc_exclude,
					SYS_CONNECT_BY_PATH(tsk.prname, '\\') wbs,
					LEVEL task_level
			FROM        prtask tsk
			LEFT JOIN   ( SELECT prid, prname, prprojectid, prwbssequence, pristask
						  FROM prtask ) parent_task    ON   parent_task.prwbssequence = tsk.wbs_parseq
													   AND  parent_task.prprojectid = tsk.prprojectid
													   AND  parent_task.pristask = 0
			JOIN    odf_ca_task odf_tsk                ON tsk.prid = odf_tsk.id
			WHERE tsk.prprojectid = @WHERE:PARAM:USER_DEF:INTEGER:prjid@
			CONNECT BY PRIOR tsk.prid = parent_task.prid
			START WITH parent_task.prid IS NULL
			ORDER BY tsk.prwbssequence	
		) tasks
WHERE	@FILTER@
HAVING	@HAVING_FILTER@
