--Consulta para ser usada em portlets gráficos no CA Clarity PPM. Consiste na contagem de demandas agrupadas por data de criação e com alguns filtros que podem ser usados tanto em portlets de filtro por página quanto em filtros do próprio portlet gráfico.

SELECT	@SELECT:DIM:USER_DEF:IMPLIED:IDEA:demandas.created_date:created_date@,
	@SELECT:METRIC:USER_DEF:IMPLIED:COUNT(demandas.idea_id):idea_count:AGG@

FROM	(
		-- Seleciona a data de criação (removendo as horas) e o ID da demanda
		SELECT      TRUNC(idea.created_date) created_date
			    , inv.code idea_id
		FROM        inv_ideas idea
		INNER JOIN  inv_investments inv
			ON  idea.id = inv.id
		INNER JOIN  odf_ca_inv odfi
			ON  inv.id = odfi.id
				-- Filtro por status (atributo não nativo)
		WHERE		(	odfi.tbg_status =	@WHERE:PARAM:USER_DEF:STRING:status@
				OR      			@WHERE:PARAM:USER_DEF:STRING:status@ is null
				)
			AND
				-- Filtro por categoria (atributo não nativo)
				(	odfi.tbg_categoria = 	@WHERE:PARAM:USER_DEF:STRING:categoria@
				OR				@WHERE:PARAM:USER_DEF:STRING:categoria@ is null
				)
			AND
				-- Filtro por tipo (atributo não nativo)
				(	odfi.tbg_tipo = 	@WHERE:PARAM:USER_DEF:STRING:tipo@
				OR      			@WHERE:PARAM:USER_DEF:STRING:tipo@ is null
				)
			AND
				-- Filtro por cliente (atributo não nativo)
				(	odfi.tbg_cliente = 	@WHERE:PARAM:USER_DEF:STRING:cliente@
				OR      			@WHERE:PARAM:USER_DEF:STRING:cliente@ is null
				)
	) demandas
		
WHERE		@FILTER@
GROUP BY	demandas.created_date
HAVING		@HAVING_FILTER@
