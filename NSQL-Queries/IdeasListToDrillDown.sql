--Query to be used in grid portlets as a drill down. It lists ideas which type is equals the parameter received through the page URL.

SELECT	@SELECT:DIM:USER_DEF:IMPLIED:IDEA:demandas.idea_id:idea_id@,
	@SELECT:DIM_PROP:USER_DEF:IMPLIED:IDEA:demandas.nome:nome@,
	@SELECT:DIM_PROP:USER_DEF:IMPLIED:IDEA:demandas.tipo:tipo@

FROM	(
		SELECT	inv.code idea_id
			, inv.name nome
			, lkp.name tipo
		FROM        inv_ideas idea
		INNER JOIN  inv_investments inv
			ON  idea.id = inv.id
		INNER JOIN  odf_ca_inv odfi
			ON  inv.id = odfi.id
		INNER JOIN  cmn_lookups_v lkp
			--This field 'tipo' is a custom attribute
			ON  odfi.tbg_tipo = lkp.lookup_code
			AND lkp.language_code = @where:param:language@
		WHERE	    lkp.name = @WHERE:PARAM:XML:STRING:/data/tbg_tipo_p/@value@

	) demandas
		
WHERE		@FILTER@
HAVING		@HAVING_FILTER@
