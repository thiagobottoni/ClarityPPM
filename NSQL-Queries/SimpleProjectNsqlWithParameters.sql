SELECT	@SELECT:DIM:USER_DEF:IMPLIED:PROJECT:projetos.id:id@,
		    @SELECT:DIM_PROP:USER_DEF:IMPLIED:PROJECT:projetos.prj:prj@,
        @SELECT:DIM_PROP:USER_DEF:IMPLIED:PROJECT:projetos.lookup:lookup@
FROM	(
		SELECT inv.id id, inv.name prj, lkp.name lookup
		FROM inv_investments inv
		INNER JOIN odf_ca_project prj
		ON prj.id = inv.id
		INNER JOIN cmn_lookups_v lkp
		ON prj.cvale_global_cap_att = lkp.lookup_code
		WHERE LANGUAGE_CODE = @where:param:language@
		AND lkp.lookup_type = 'GOMTH01_GLOBAL_LKP'
		AND lkp.lookup_code = @WHERE:PARAM:XML:STRING:/data/lookup/@value@
		) projetos
WHERE	@FILTER@
HAVING	@HAVING_FILTER@
