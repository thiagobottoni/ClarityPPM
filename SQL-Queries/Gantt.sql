SELECT  tsk.prprojectid project_id, 
        tsk.prid task_id, 
        tsk.prname task_name,
        parent_task.prid parent_task_id,
        parent_task.prname parent_task_name,
        tsk.prwbslevel,
        tsk.prwbssequence
FROM prtask tsk
LEFT JOIN (SELECT t1.prid, t1.prname, t1.prprojectid, t1.prwbssequence
           FROM   prtask t1
          ) parent_task ON  parent_task.prwbssequence = tsk.wbs_parseq 
                        AND parent_task.prprojectid = tsk.prprojectid
WHERE tsk.prprojectid = 5002012
ORDER BY tsk.prwbssequence
