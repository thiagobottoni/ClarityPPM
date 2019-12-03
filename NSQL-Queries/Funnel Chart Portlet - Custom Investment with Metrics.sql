SELECT	@SELECT:DIM:USER_DEF:IMPLIED:PROJECT:planej.oists:oists@,
		    @SELECT:DIM_PROP:USER_DEF:IMPLIED:PROJECT:planej.fase:fase@,
		    @SELECT:METRIC:USER_DEF:IMPLIED:planej.qtde:qtde@
FROM	(
        SELECT COUNT(inv.id) qtde, lkp.name fase, odf.status_ciclo_vida oists
        FROM odf_ca_objeto obj
          JOIN odf_ca_inv odf
            ON obj.id = odf.id
          JOIN inv_investments inv
            ON inv.id = odf.id
          JOIN cmn_lookups_v lkp
            ON odf.status_ciclo_vida = lkp.lookup_code
            AND lkp.language_code = 'en'
        WHERE lkp.lookup_code in ('STATUS_01', 'STATUS_02', 'STATUS_03')
          AND inv.stage_code = 'ETP_01'
        GROUP BY lkp.name, odf.status_ciclo_vida
        ORDER BY qtde desc
	) planej
WHERE	@FILTER@
HAVING	@HAVING_FILTER@
