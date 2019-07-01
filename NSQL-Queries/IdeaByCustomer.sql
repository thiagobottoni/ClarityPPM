--Query to be used in chart portlets on Clarity PPM. It counts ideas grouped by customer (Custom object) and implements some useful filters.

SELECT	@SELECT:DIM:USER_DEF:IMPLIED:IDEA:demandas.cliente:cliente@,
	@SELECT:METRIC:USER_DEF:IMPLIED:COUNT(demandas.idea_id):idea_count:AGG@

FROM	(
                --Cliente is a custom object
		SELECT 	    cli.name customer
			    , inv.code idea_id
		FROM        inv_ideas idea
		INNER JOIN  inv_investments inv
			ON  idea.id = inv.id
		INNER JOIN  odf_ca_inv odfi
			ON  inv.id = odfi.id
		INNER JOIN  ODF_CA_TBG_CLIENTES cli
			ON  odfi.tbg_cliente = cli.code
				--Filter by Status (Custom attribute)
		WHERE		(	odfi.tbg_status = 	@WHERE:PARAM:USER_DEF:STRING:status@
					OR     			@WHERE:PARAM:USER_DEF:STRING:status@ is null
				)
				AND
				--Filter by Category (Custom attribute)
				(	odfi.tbg_categoria = 	@WHERE:PARAM:USER_DEF:STRING:categoria@
					OR    			@WHERE:PARAM:USER_DEF:STRING:categoria@ is null
				)
				AND
				--Filter by Type (Custom attribute)
				(	odfi.tbg_tipo = 	@WHERE:PARAM:USER_DEF:STRING:tipo@
					OR			@WHERE:PARAM:USER_DEF:STRING:tipo@ is null
				)
				AND
				--Filter by Customer (Custom attribute)
				(	odfi.tbg_cliente = 	@WHERE:PARAM:USER_DEF:STRING:cliente@
					OR    			@WHERE:PARAM:USER_DEF:STRING:cliente@ is null
				)
	) demandas
		
WHERE		@FILTER@
GROUP BY	demandas.cliente
HAVING		@HAVING_FILTER@
