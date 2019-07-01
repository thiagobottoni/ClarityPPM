--It returns information to build a project summary on Jaspersoft Studio

SELECT 	inv.investment_name			"Project Name",
        inv.investment_manager		"Project Manager",
        prj.objective				"Objective",
        inv.schedule_start			"Start Date", 
        inv.schedule_finish			"End Date", 
        inv.business_alignment		"Business Alignment", 
        inv.risk					"Risk Score", 
        smr.plan_cost				"Planned Cost", 
        smr.plan_actual_cost_var	"Planned Cost Variance",
        smr.plan_cost - smr.plan_actual_cost_var 	"Actual Cost",
        smr.plan_benefit			"Planned Benefit", 
        smr.plan_actual_benefit		"Actual Benefit"
FROM	dwh_inv_investment inv
	INNER JOIN dwh_inv_summary_facts smr
			ON inv.investment_key = smr.investment_key
	INNER JOIN dwh_inv_project prj
			ON inv.investment_key = prj.investment_key
WHERE 	inv.is_template = 0
		AND inv.is_active = 1
		AND inv.investment_type_key = 'project'
		AND UPPER(inv.investment_name) = UPPER('eCommerce Portal')
