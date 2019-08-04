SELECT  TSK.PRPROJECTID,
        TSK.PRID,
        TSK.PRNAME,
        PARENT_TASK.PRID PARENT_ID,
        PARENT_TASK.PRNAME PARENT_TASK,
        LEVEL WBS_LEVEL,
        SYS_CONNECT_BY_PATH(TSK.PRNAME, '\') PATH
FROM        PRTASK TSK
LEFT JOIN   ( SELECT PRID, PRNAME, PRPROJECTID, PRWBSSEQUENCE, PRISTASK 
              FROM PRTASK ) PARENT_TASK    ON   PARENT_TASK.PRWBSSEQUENCE = TSK.WBS_PARSEQ
                                           AND  PARENT_TASK.PRPROJECTID = TSK.PRPROJECTID
                                           AND  PARENT_TASK.PRISTASK = 0
WHERE TSK.PRPROJECTID = 5002012 --Replace with your project ID
START WITH PARENT_TASK.PRID IS NULL
CONNECT BY PRIOR TSK.PRID = PARENT_TASK.PRID
ORDER BY TSK.PRWBSSEQUENCE
