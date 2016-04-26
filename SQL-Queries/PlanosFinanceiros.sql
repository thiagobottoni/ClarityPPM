--Retorna os planos financeiros criados no investimento

SELECT
  FIN.NAME "Plano",
  FIN.DESCRIPTION  "Descrição",
  FIN.PLAN_TYPE_CODE "Tipo",
  FIN.PERIOD_TYPE_CODE "Período",
  DECODE(FIN.IS_PLAN_OF_RECORD, 1, 'Sim', 0, 'Não') "Plano de Registro",
  FIN.TOTAL_COST "Custo Total",
  FIN.TOTAL_BENEFIT "Benefício Total",
  FIN.STATUS_CODE "Status"
FROM
  FIN_PLANS FIN
    INNER JOIN INV_INVESTMENTS INV
      ON FIN.OBJECT_ID = INV.ID
WHERE
  INV.CODE = 'PR1002' --Altere pelo código do seu investimento
