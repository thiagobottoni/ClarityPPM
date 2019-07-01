--Returns the financial plans created on an investment

SELECT
  INV.Name "Investment",
  FIN.NAME "Plan",
  FIN.DESCRIPTION  "Description",
  FIN.PLAN_TYPE_CODE "Type",
  FIN.PERIOD_TYPE_CODE "Period",
  DECODE(FIN.IS_PLAN_OF_RECORD, 1, 'Yes', 0, 'No') "Plan of Record",
  FIN.TOTAL_COST "Total Cost",
  FIN.TOTAL_BENEFIT "Total Benefit",
  FIN.STATUS_CODE "Status"
FROM
  FIN_PLANS FIN
    INNER JOIN INV_INVESTMENTS INV
      ON FIN.OBJECT_ID = INV.ID
WHERE
  INV.CODE = 'PR1002' --Type any project code
