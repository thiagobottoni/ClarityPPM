--Returns the ETC and EAC in HOURS stored on the Clarity Data Warehouse

SELECT      inv.investment_key         "ID", 
            inv.investment_name        "PROJECT NAME", 
            isf.etc_labor_hours        "ETC", 
            isf.eac_labor_hours        "EAC"
FROM        dwh_inv_summary_facts isf 
INNER JOIN  dwh_inv_investment inv 
        ON  inv.investment_key = isf.investment_key 
WHERE       inv.investment_type_key = 'project'
        AND inv.is_active = 1
        AND inv.is_template = 0
--      AND inv.investment_name = 'Project Name' --Use that line to filter by Project Name
--      AND inv.investment_key = 5002003         --Use that line to filter by Project ID
