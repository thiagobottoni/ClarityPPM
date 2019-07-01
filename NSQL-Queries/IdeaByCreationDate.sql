--Query to be used in a graph portlet on Clarity PPM. It counts ideas grouped by creation date and implements some filters.

SELECT	@SELECT:DIM:USER_DEF:IMPLIED:IDEA:demandas.created_date:created_date@,
	@SELECT:METRIC:USER_DEF:IMPLIED:COUNT(demandas.idea_id):idea_count:AGG@

FROM	(
		--Returns the creation date (Removing the hours part) and the idea ID
		SELECT      TRUNC(idea.created_date) created_date
			    , inv.code idea_id
		FROM        inv_ideas idea
		INNER JOIN  inv_investments inv
			ON  idea.id = inv.id
		INNER JOIN  odf_ca_inv odfi
			ON  inv.id = odfi.id
				--Filter by Status (Custom attribute)
		WHERE		(	odfi.tbg_status =	@WHERE:PARAM:USER_DEF:STRING:status@
				OR      			@WHERE:PARAM:USER_DEF:STRING:status@ is null
				)
			AND
				--Filter by Category (Custom attribute)
				(	odfi.tbg_categoria = 	@WHERE:PARAM:USER_DEF:STRING:categoria@
				OR				@WHERE:PARAM:USER_DEF:STRING:categoria@ is null
				)
			AND
				--Filter by Type (Custom attribute)
				(	odfi.tbg_tipo = 	@WHERE:PARAM:USER_DEF:STRING:tipo@
				OR      			@WHERE:PARAM:USER_DEF:STRING:tipo@ is null
				)
			AND
				--Filter by Customer (Custom attribute)
				(	odfi.tbg_cliente = 	@WHERE:PARAM:USER_DEF:STRING:cliente@
				OR      			@WHERE:PARAM:USER_DEF:STRING:cliente@ is null
				)
	) demandas
		
WHERE		@FILTER@
GROUP BY	demandas.created_date
HAVING		@HAVING_FILTER@
