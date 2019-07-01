--It returns tasks and milestones from a project

SELECT	tsk.task_name		"Task Name", 
	tsk.start_date		"Start Date", 
	tsk.finish_date		"End Date", 
	tsk.days_late		"Days Late", 
	tsk.wbs_type_key	"Type", 
	tsk.cost_type_key	"Cost Type", 
	tsk.task_owner		"Owner"
FROM		dwh_inv_task tsk
INNER JOIN	dwh_inv_investment inv
	ON 	tsk.investment_key = inv.investment_key
WHERE 		tsk.wbs_type_key IN ('TASK', 'MILESTONE')
	--AND	UPPER(inv.investment_name) = UPPER('eCommerce Portal') --Use that line to fetch tasks of a specific project only
