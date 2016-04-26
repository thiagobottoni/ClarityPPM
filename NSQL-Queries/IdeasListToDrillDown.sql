--Consulta para ser usada em portlets de lista (grid) como drill down. Consiste na listagem de demandas cujo tipo obedeça o parâmetro recebido pela URL da página do Clarity PPM.

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
			--Esse 'tipo' que estou usando não é atributo nativo
			ON  odfi.tbg_tipo = lkp.lookup_code
			AND lkp.language_code = @where:param:language@
		WHERE	    lkp.name = @WHERE:PARAM:XML:STRING:/data/tbg_tipo_p/@value@

	) demandas
		
WHERE		@FILTER@
HAVING		@HAVING_FILTER@
