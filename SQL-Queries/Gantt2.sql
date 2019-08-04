SELECT  tsk.prprojectid,
        tsk.prid,
        tsk.prname,
        parent_task.prid parent_id,
        parent_task.prname parent_task,
        LEVEL wbs_level,
        SYS_CONNECT_BY_PATH(tsk.prname, '\') PATH
FROM        prtask tsk
LEFT JOIN   ( SELECT prid, prname, prprojectid, prwbssequence, pristask
              FROM prtask ) parent_task    ON   parent_task.prwbssequence = tsk.wbs_parseq
                                           AND  parent_task.prprojectid = tsk.prprojectid
                                           AND  parent_task.pristask = 0
WHERE tsk.prprojectid = 5002012
START WITH parent_task.prid IS NULL
CONNECT BY PRIOR tsk.prid = parent_task.prid
ORDER BY tsk. prwbssequence
