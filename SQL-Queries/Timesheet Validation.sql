--It lists resources who have reported hours not between the assigned task start date and finish date.
--If these entries were approved, the task start or finish date would change, since it has actuals reported.

SELECT  tpd.prstart                     AS  "Period Start", 
        tpd.prfinish                    AS  "Period Finish",
        tsh.prid                        AS  "Timesheet ID", 
        CASE tsh.prstatus 
            WHEN 0 THEN 'Unsubmitted' 
            WHEN 1 THEN 'Submitted' 
            WHEN 3 THEN 'Approved' 
            WHEN 4 THEN 'Posted' 
            WHEN 5 THEN 'Adjusted' 
            ELSE        'Rejected' 
        END                             AS  "Status Timesheet",
        srm.full_name                   AS  "Resource",
        slc.slice_date                  AS  "Reported Date", 
        slc.slice                       AS  "Reported Hours",
        inv.name                        AS  "Investment Name",
        UPPER(inv.odf_object_code)      AS  "Investment Type",
        tsk.prname                      AS  "Task Name",
        tsk.prstart                     AS  "Task Start",
        tsk.prfinish                    AS  "Task Finish"
FROM        srm_resources srm
INNER JOIN  prtimesheet tsh
        ON  tsh.prresourceid = srm.id
INNER JOIN  prtimeentry tey
        ON  tey.prtimesheetid = tsh.prid
INNER JOIN  prtimeperiod tpd
        ON  tpd.prid = tsh.prtimeperiodid
INNER JOIN  prassignment asg
        ON  asg.prid = tey.prassignmentid AND asg.prresourceid = srm.id
INNER JOIN  prtask tsk
        ON  tsk.prid = asg.prtaskid
INNER JOIN  inv_investments inv
        ON  inv.id = tsk.prprojectid
INNER JOIN  prj_resources prs
        ON  prs.prid = srm.id
INNER JOIN  prtypecode prt
        ON  prt.prid = prs.prtypecodeid
INNER JOIN  prj_blb_slices slc
        ON  slc.prj_object_id = tey.prid
WHERE       slc.slice_request_id = 55555
        AND tpd.prisopen = 1
        AND TO_CHAR(slc.slice_date, 'YYYY-MM-DD') NOT BETWEEN TO_CHAR(tsk.prstart, 'YYYY-MM-DD') AND TO_CHAR(tsk.prfinish, 'YYYY-MM-DD')
        AND tsh.prstatus IN (0, 1, 2, 3, 4, 5)
        AND inv.is_active = 1
      --AND srm.full_name IN ('Morris, Tom', 'Berry, Jason') --Use this line to filter by Resource Name
ORDER BY    srm.full_name, tsh.prid, tpd.prstart, tsk.prstart, tsh.prstatus
