## `duration_by_project`

### Query:
```sql
SELECT project.name AS project_name,
SUM(psa.duration)/360 AS duration 
FROM SRO.public.project
INNER JOIN SRO.public.specificprojectprocess AS spp
ON project.id = spp.generalprojectprocess_id
INNER JOIN SRO.public.specificprojectprocess_activity AS sppa
ON spp.id = sppa.specificproject_id
INNER JOIN SRO.public.activity
ON activity.id = sppa.activity_id
INNER JOIN SRO.public.project_stakeholder_activity AS psa
ON activity.id = psa.activity_id
INNER JOIN SRO.public.projectstakeholder AS psh
ON psh.id = psa.projectstakeholder_id
INNER JOIN SRO.public.person as p
ON p.id = psh.person_id
WHERE p.name NOT LIKE '%ConectaFAPES%' AND psa.event = 'ASSIGNED'
GROUP BY project_name
```

## `duration_by_task`

### Query:
```sql
SELECT project.name AS project_name,
activity.name AS activity_name,
p.name AS person_name,
psa.duration/60 AS duration
FROM SRO.public.project
INNER JOIN SRO.public.specificprojectprocess AS spp
ON project.id = spp.generalprojectprocess_id
INNER JOIN SRO.public.specificprojectprocess_activity AS sppa
ON spp.id = sppa.specificproject_id
INNER JOIN SRO.public.activity
ON activity.id = sppa.activity_id
INNER JOIN SRO.public.project_stakeholder_activity AS psa
ON activity.id = psa.activity_id
INNER JOIN SRO.public.projectstakeholder AS psh
ON psh.id = psa.projectstakeholder_id
INNER JOIN SRO.public.person as p
ON p.id = psh.person_id
WHERE p.name NOT LIKE '%ConectaFAPES%'
GROUP BY project_name, activity_name, person_name, duration
```

## `quantity_atomic_user_story_by_project`

### Query:
```sql
select count(*) as quantity_atomic_user_story,
 scrum_project.name  as project_name
from 
sro.public.artifact sprint_backlog 
inner join sro.public.artifact_artifact sprint_backlog_user_story on sprint_backlog.id = sprint_backlog_user_story.artifact_from_id 
inner join sro.public.artifact user_story on user_story.id = sprint_backlog_user_story.artifact_to_id  
inner join sro.public.specificprojectprocess_artifact sa on sa.artifact_id = sprint_backlog.id 
inner join sro.public.specificprojectprocess backlog_definition on backlog_definition.id = sa.specificprojectprocess_id 
inner join sro.public.generalprojectprocess scrum_process on scrum_process.productbacklogdefinition_id = backlog_definition.id 
inner join sro.public.project scrum_project on scrum_project.id = scrum_process.softwareproject_id  
where 
sprint_backlog.dtype = 'ProductBacklog' and 
user_story.dtype = 'UserStory' and 
backlog_definition.dtype = 'ProductBacklogDefinition' and
user_story.userstorytype = 'ATOMICUSERSTORY'
group by scrum_project.name
order by scrum_project.name
```

## `quantity_epic_by_project`

### Query:
```sql
select count(*) as quantity_epic,
 scrum_project.name  as project_name
from 
sro.public.artifact sprint_backlog 
inner join sro.public.artifact_artifact sprint_backlog_user_story on sprint_backlog.id = sprint_backlog_user_story.artifact_from_id 
inner join sro.public.artifact user_story on user_story.id = sprint_backlog_user_story.artifact_to_id  
inner join sro.public.specificprojectprocess_artifact sa on sa.artifact_id = sprint_backlog.id 
inner join sro.public.specificprojectprocess backlog_definition on backlog_definition.id = sa.specificprojectprocess_id 
inner join sro.public.generalprojectprocess scrum_process on scrum_process.productbacklogdefinition_id = backlog_definition.id 
inner join sro.public.project scrum_project on scrum_project.id = scrum_process.softwareproject_id  
where 
sprint_backlog.dtype = 'ProductBacklog' and 
user_story.dtype = 'UserStory' and 
backlog_definition.dtype = 'ProductBacklogDefinition' and
user_story.userstorytype = 'EPIC'
group by scrum_project.name
order by scrum_project.name
```

## `quantity_tasks_by_project`

### Query:
```sql
SELECT project.name AS project_name,
COUNT(*) AS quantity_tasks
FROM SRO.public.project
INNER JOIN SRO.public.specificprojectprocess AS sprint
ON sprint.generalprojectprocess_id = project.id
INNER JOIN SRO.public.specificprojectprocess_activity AS sprint_activity
ON sprint_activity.specificproject_id = sprint.id
INNER JOIN SRO.public.activity
ON activity.id = sprint_activity.activity_id
GROUP BY project_name
```

## `quantities_atomic_epic_tasks_by_project`

### Query:
```sql
SELECT
    COALESCE(epic.project_name, atomicus.project_name, task.project_name) AS project_name,
    COALESCE(epic.quantity_epic, 0) AS quantity_epic,
    COALESCE(atomicus.quantity_atomic_user_story, 0) AS quantity_atomic_user_story,
    COALESCE(task.quantity_tasks, 0) AS quantity_tasks
FROM
    immigrant.queries.quantity_epic_by_project epic
FULL OUTER JOIN
    immigrant.queries.quantity_atomic_user_story_by_project atomicus
    ON epic.project_name = atomicus.project_name
FULL OUTER JOIN
    immigrant.queries.quantity_tasks_by_project task
    ON COALESCE(epic.project_name, atomicus.project_name) = task.project_name;
```

## `quantity_sprints_by_project`

### Query:
```sql
SELECT project.name AS project_name,
COUNT(*) AS quantity_sprints
FROM SRO.public.project
INNER JOIN SRO.public.specificprojectprocess AS sprint
ON project.id = sprint.generalprojectprocess_id
GROUP BY project_name
```

## `quantity_tasks_by_person`

### Query:
```sql
SELECT project.name AS project_name,
person.name AS person_name,
COUNT(*) AS quantity_tasks
FROM SRO.public.person
INNER JOIN SRO.public.projectstakeholder AS ps
ON ps.person_id = person.id
INNER JOIN SRO.public.project_stakeholder_activity_allocation AS allocation
ON allocation.projectstakeholder_id = ps.id
INNER JOIN SRO.public.activity
ON activity.id = allocation.activity_id
INNER JOIN SRO.public.specificprojectprocess_activity AS sprint_activity
ON sprint_activity.activity_id = activity.id
INNER JOIN SRO.public.specificprojectprocess AS sprint
ON sprint.id = sprint_activity.specificproject_id
INNER JOIN SRO.public.project
ON project.id = sprint.generalprojectprocess_id
WHERE person.name NOT LIKE '%ConectaF%'
GROUP BY project_name,person_name
```

## `quantity_tasks_by_person_by_sprint`

### Query:
```sql
SELECT project.name AS project_name,
sprint.name AS sprint_name,
person.name AS person_name,
COUNT(*) AS quantity_tasks_by_person_by_sprint
FROM SRO.public.person
INNER JOIN SRO.public.projectstakeholder AS ps
ON ps.person_id = person.id
INNER JOIN SRO.public.project_stakeholder_activity_allocation AS allocation
ON allocation.projectstakeholder_id = ps.id
INNER JOIN SRO.public.activity
ON activity.id = allocation.activity_id
INNER JOIN SRO.public.specificprojectprocess_activity AS sprint_activity
ON sprint_activity.activity_id = allocation.activity_id
INNER JOIN SRO.public.specificprojectprocess AS sprint
ON sprint.id = sprint_activity.specificproject_id
INNER JOIN SRO.public.project
ON project.id = sprint.generalprojectprocess_id
WHERE person.name NOT LIKE '%ConectaF%'
GROUP BY project_name, sprint_name, person_name
```

## `quantity_user_story_by_project`

### Query:
```sql
select count(*) as quantity,
 scrum_project.name  as project_name
from 
sro.public.artifact sprint_backlog 
inner join sro.public.artifact_artifact sprint_backlog_user_story on sprint_backlog.id = sprint_backlog_user_story.artifact_from_id 
inner join sro.public.artifact user_story on user_story.id = sprint_backlog_user_story.artifact_to_id  
inner join sro.public.specificprojectprocess_artifact sa on sa.artifact_id = sprint_backlog.id 
inner join sro.public.specificprojectprocess backlog_definition on backlog_definition.id = sa.specificprojectprocess_id 
inner join sro.public.generalprojectprocess scrum_process on scrum_process.productbacklogdefinition_id = backlog_definition.id 
inner join sro.public.project scrum_project on scrum_project.id = scrum_process.softwareproject_id  
where 
sprint_backlog.dtype = 'ProductBacklog' and 
user_story.dtype = 'UserStory' and 
backlog_definition.dtype = 'ProductBacklogDefinition'
group by scrum_project.name
order by scrum_project.name
```

## `tasks_status_by_project`

### Query:
```sql
WITH TaskEvents AS (
    SELECT
    project.name AS project_name,
    sprint.name AS sprint_name,
    activity.id AS activity_id,
    MAX(CASE WHEN activity_event.successtype = 'SUCCESSS' THEN 1 ELSE 0 END) AS is_success,
    SUM(CASE WHEN activity_event.successtype = 'UNDEFINED' THEN 1 ELSE 0 END) AS intended_undefined_count,
    SUM(CASE WHEN activity_event.successtype = 'SUCCESSS' THEN 1 ELSE 0 END) AS performed_success_count
    FROM SRO.public.activity_event
    INNER JOIN SRO.public.activity
    ON activity.id = activity_event.activity
    INNER JOIN SRO.public.specificprojectprocess_activity AS sprint_activity
    ON sprint_activity.activity_id = activity.id
    INNER JOIN SRO.public.specificprojectprocess AS sprint
    ON sprint.id = sprint_activity.specificproject_id
    INNER JOIN SRO.public.generalprojectprocess AS project
    ON project.id = sprint.generalprojectprocess_id
    GROUP BY project.name, sprint.name, activity.id
)
SELECT
    project_name,
    sprint_name,
    SUM(CASE WHEN is_success = 0 THEN intended_undefined_count ELSE 0 END) AS unfinished_tasks,
    SUM(performed_success_count) AS finished_tasks
FROM TaskEvents
GROUP BY project_name, sprint_name
ORDER BY project_name, sprint_name
```

## `duration_x_planned_by_project`

### Query:
```sql
SELECT 
    project.name AS project_name,
    sprint.name AS sprint_name,
    SUM(psa.duration)/60 AS total_duration,
    (1200 * COUNT(teammembership.id)) AS total_planned
FROM 
    SRO.public.project_stakeholder_activity AS psa
INNER JOIN 
    SRO.public.specificprojectprocess_activity AS sprint_activity
    ON psa.activity_id = sprint_activity.activity_id
INNER JOIN 
    SRO.public.specificprojectprocess AS sprint
    ON sprint.id = sprint_activity.specificproject_id
INNER JOIN 
    SRO.public.generalprojectprocess AS project
    ON project.id = sprint.generalprojectprocess_id
INNER JOIN 
    SRO.public.team
    ON project.id = team.project_id
INNER JOIN 
    SRO.public.teammembership
    ON teammembership.team_id = team.id
GROUP BY 
    project.name, sprint.name
ORDER BY 
    project_name;
```

## `user_stories_without_task`

### Query:
```sql
SELECT
project.name AS project_name,
sprint.name AS sprint_name,
artifact.name AS user_story,
person.name AS person_name

FROM SRO.public.artifact

INNER JOIN SRO.public.artifact_artifact AS aa
ON aa.artifact_to_id = artifact.id

LEFT JOIN SRO.public.activity_artifact
ON activity_artifact.artifact_id = artifact.id

INNER JOIN SRO.public.artifact AS sprint_a
ON sprint_a.id = aa.artifact_from_id

INNER JOIN SRO.public.specificprojectprocess_artifact AS sppa
ON sppa.artifact_id = sprint_a.id

INNER JOIN SRO.public.specificprojectprocess AS sprint
ON sprint.id = sppa.specificprojectprocess_id

INNER JOIN SRO.public.generalprojectprocess AS project
ON project.id = sprint.generalprojectprocess_id

INNER JOIN SRO.public.project_stakeholder_artifact
ON project_stakeholder_artifact.artifact_id = artifact.id

INNER JOIN SRO.public.projectstakeholder AS ps
ON ps.id = project_stakeholder_artifact.projectstakeholder_id

INNER JOIN SRO.public.person 
ON person.id = ps.person_id

WHERE artifact.userstorytype = 'ATOMICUSERSTORY'
AND sprint_a.dtype = 'SprintBacklog'
AND activity_artifact.activity_id IS NULL

GROUP BY project_name,sprint_name, user_story, person_name
```

## `tasks_without_date`

### Query:
```sql
SELECT 
project.name AS project_name,
sprint.name AS sprint_name,
task.name AS task_name,
person.name AS person_name

FROM SRO.public.activity AS task

INNER JOIN SRO.public.specificprojectprocess_activity AS sppa
ON sppa.activity_id = task.id

INNER JOIN SRO.public.specificprojectprocess AS sprint
ON sprint.id = sppa.specificproject_id

INNER JOIN SRO.public.generalprojectprocess AS project
ON project.id = sprint.generalprojectprocess_id

INNER JOIN SRO.public.project_stakeholder_activity AS psa
ON psa.activity_id = task.id

INNER JOIN SRO.public.projectstakeholder AS ps
ON ps.id = psa.projectstakeholder_id

INNER JOIN SRO.public.person
ON person.id = ps.person_id

WHERE (task.start_date IS NULL OR task.end_date IS NULL) AND person.name NOT LIKE '%ConectaFAPES%'
```

## `user_stories_without_task_by_person`

### Query:
```sql
SELECT
    project.name AS project_name,
    person.name AS person_name,
    COUNT(DISTINCT artifact.name) AS user_stories_sem_tasks
FROM SRO.public.artifact

INNER JOIN SRO.public.artifact_artifact AS aa
ON aa.artifact_to_id = artifact.id

LEFT JOIN SRO.public.activity_artifact
ON activity_artifact.artifact_id = artifact.id

INNER JOIN SRO.public.artifact AS sprint_a
ON sprint_a.id = aa.artifact_from_id

INNER JOIN SRO.public.specificprojectprocess_artifact AS sppa
ON sppa.artifact_id = sprint_a.id

INNER JOIN SRO.public.specificprojectprocess AS sprint
ON sprint.id = sppa.specificprojectprocess_id

INNER JOIN SRO.public.generalprojectprocess AS project
ON project.id = sprint.generalprojectprocess_id

INNER JOIN SRO.public.project_stakeholder_artifact
ON project_stakeholder_artifact.artifact_id = artifact.id

INNER JOIN SRO.public.projectstakeholder AS ps
ON ps.id = project_stakeholder_artifact.projectstakeholder_id

INNER JOIN SRO.public.person 
ON person.id = ps.person_id

WHERE artifact.userstorytype = 'ATOMICUSERSTORY'
AND sprint_a.dtype = 'SprintBacklog'
AND activity_artifact.activity_id IS NULL
AND person.name NOT LIKE '%ConectaFAPES%'

GROUP BY project_name,person.name
```

## `tasks_without_date_by_person`

### Query:
```sql
SELECT
    project.name AS project_name,
    person.name AS person_name,
    COUNT(DISTINCT task.id) AS tasks_without_date
FROM SRO.public.activity AS task

INNER JOIN SRO.public.specificprojectprocess_activity AS sppa
ON sppa.activity_id = task.id

INNER JOIN SRO.public.specificprojectprocess AS sprint
ON sprint.id = sppa.specificproject_id

INNER JOIN SRO.public.generalprojectprocess AS project
ON project.id = sprint.generalprojectprocess_id

INNER JOIN SRO.public.project_stakeholder_activity AS psa
ON psa.activity_id = task.id

INNER JOIN SRO.public.projectstakeholder AS ps
ON ps.id = psa.projectstakeholder_id

INNER JOIN SRO.public.person
ON person.id = ps.person_id

WHERE (task.start_date IS NULL OR task.end_date IS NULL)
AND person.name NOT LIKE '%ConectaFAPES%'

GROUP BY project_name,person.name
```

## `user_stories_without_task_by_date`

### Query:
```sql
SELECT
    project.name AS project_name,
    sprint.name AS sprint_name,
    TO_DATE(artifact.created_date) AS created_date,
    COUNT(DISTINCT artifact.id) AS user_story_count
FROM SRO.public.artifact

INNER JOIN SRO.public.artifact_artifact AS aa
ON aa.artifact_to_id = artifact.id

LEFT JOIN SRO.public.activity_artifact
ON activity_artifact.artifact_id = artifact.id

INNER JOIN SRO.public.artifact AS sprint_a
ON sprint_a.id = aa.artifact_from_id

INNER JOIN SRO.public.specificprojectprocess_artifact AS sppa
ON sppa.artifact_id = sprint_a.id

INNER JOIN SRO.public.specificprojectprocess AS sprint
ON sprint.id = sppa.specificprojectprocess_id

INNER JOIN SRO.public.generalprojectprocess AS project
ON project.id = sprint.generalprojectprocess_id

INNER JOIN SRO.public.project_stakeholder_artifact
ON project_stakeholder_artifact.artifact_id = artifact.id

INNER JOIN SRO.public.projectstakeholder AS ps
ON ps.id = project_stakeholder_artifact.projectstakeholder_id

INNER JOIN SRO.public.person 
ON person.id = ps.person_id

WHERE artifact.userstorytype = 'ATOMICUSERSTORY'
AND sprint_a.dtype = 'SprintBacklog'
AND activity_artifact.activity_id IS NULL

GROUP BY project_name, sprint_name, created_date
ORDER BY created_date;
```

## `throughput_by_sprint`

### Query:
```sql
SELECT
    project.name AS project_name,
    sprint.name AS sprint_name,
    CAST(REGEXP_EXTRACT(sprint.name, '([0-9]+)') AS INT) AS sprint_number,
    COUNT(DISTINCT task.id) AS throughput
FROM SRO.public.activity AS task

INNER JOIN SRO.public.specificprojectprocess_activity AS sprint_task
ON task.id = sprint_task.activity_id

INNER JOIN SRO.public.specificprojectprocess AS sprint
ON sprint.id = sprint_task.specificproject_id

INNER JOIN SRO.public.activity_event AS event
ON task.id = event.activity

INNER JOIN SRO.public.generalprojectprocess AS project
ON sprint.generalprojectprocess_id = project.id

WHERE event.successtype = 'SUCCESSS'
GROUP BY project_name, sprint_name
ORDER BY project_name,sprint_number
```

## `wip_by_sprint`

### Query:
```sql
WITH TaskEvents AS (
    SELECT
    project.name AS project_name,
    sprint.name AS sprint_name,
    CAST(REGEXP_EXTRACT(sprint.name, '([0-9]+)') AS INT) AS sprint_number,
    activity.id AS activity_id,
    MAX(CASE WHEN activity_event.successtype = 'SUCCESSS' THEN 1 ELSE 0 END) AS is_success,
    SUM(CASE WHEN activity_event.successtype = 'UNDEFINED' THEN 1 ELSE 0 END) AS intended_undefined_count,
    SUM(CASE WHEN activity_event.successtype = 'SUCCESSS' THEN 1 ELSE 0 END) AS performed_success_count
    FROM SRO.public.activity_event
    INNER JOIN SRO.public.activity
    ON activity.id = activity_event.activity
    INNER JOIN SRO.public.specificprojectprocess_activity AS sprint_activity
    ON sprint_activity.activity_id = activity.id
    INNER JOIN SRO.public.specificprojectprocess AS sprint
    ON sprint.id = sprint_activity.specificproject_id
    INNER JOIN SRO.public.generalprojectprocess AS project
    ON project.id = sprint.generalprojectprocess_id
    GROUP BY project.name, sprint.name, activity.id
)
SELECT
    project_name,
    sprint_name,
    sprint_number,
    SUM(CASE WHEN is_success = 0 THEN intended_undefined_count ELSE 0 END) AS wip
FROM TaskEvents
GROUP BY project_name, sprint_name, sprint_number
ORDER BY project_name, sprint_number
```

## `throughput_by_person_by_sprint`

### Query:
```sql
SELECT
    project.name AS project_name,
    sprint.name AS sprint_name,
    CAST(REGEXP_EXTRACT(sprint.name, '([0-9]+)') AS INT) AS sprint_number,
    person.name AS person_name,
    COUNT(DISTINCT task.id) AS throughput
FROM SRO.public.activity AS task

INNER JOIN SRO.public.specificprojectprocess_activity AS sprint_task
ON task.id = sprint_task.activity_id

INNER JOIN SRO.public.specificprojectprocess AS sprint
ON sprint.id = sprint_task.specificproject_id

INNER JOIN SRO.public.activity_event AS event
ON task.id = event.activity

INNER JOIN SRO.public.generalprojectprocess AS project
ON sprint.generalprojectprocess_id = project.id

INNER JOIN SRO.public.project_stakeholder_activity AS psa
ON psa.activity_id = task.id

INNER JOIN SRO.public.projectstakeholder AS ps
ON ps.id = psa.projectstakeholder_id

INNER JOIN SRO.public.person AS person
ON person.id = ps.person_id

WHERE event.successtype = 'SUCCESSS'
GROUP BY project_name, sprint_name, person_name
ORDER BY project_name, sprint_number, person_name;
```

## `wip_by_person_by_sprint`

### Query:
```sql
WITH TaskEvents AS (
    SELECT
        project.name AS project_name,
        sprint.name AS sprint_name,
        CAST(REGEXP_EXTRACT(sprint.name, '([0-9]+)') AS INT) AS sprint_number,
        activity.id AS activity_id,
        person.name AS person_name,
        MAX(CASE WHEN activity_event.successtype = 'SUCCESSS' THEN 1 ELSE 0 END) AS is_success,
        SUM(CASE WHEN activity_event.successtype = 'UNDEFINED' THEN 1 ELSE 0 END) AS intended_undefined_count,
        SUM(CASE WHEN activity_event.successtype = 'SUCCESSS' THEN 1 ELSE 0 END) AS performed_success_count
    FROM SRO.public.activity_event
    INNER JOIN SRO.public.activity
    ON activity.id = activity_event.activity
    INNER JOIN SRO.public.specificprojectprocess_activity AS sprint_activity
    ON sprint_activity.activity_id = activity.id
    INNER JOIN SRO.public.specificprojectprocess AS sprint
    ON sprint.id = sprint_activity.specificproject_id
    INNER JOIN SRO.public.generalprojectprocess AS project
    ON project.id = sprint.generalprojectprocess_id
    INNER JOIN SRO.public.project_stakeholder_activity AS psa
    ON psa.activity_id = activity.id
    INNER JOIN SRO.public.projectstakeholder AS ps
    ON ps.id = psa.projectstakeholder_id
    INNER JOIN SRO.public.person
    ON person.id = ps.person_id
    GROUP BY project.name, sprint.name, activity.id, person.name
)

SELECT
    project_name,
    sprint_name,
    sprint_number,
    person_name,
    SUM(CASE WHEN is_success = 0 THEN intended_undefined_count ELSE 0 END) AS wip
FROM TaskEvents
WHERE person_name NOT LIKE '%ConectaFAPES%'
GROUP BY project_name, sprint_name, sprint_number, person_name
ORDER BY project_name, sprint_number, person_name;

```

## `job_tasks_without_date`

### Query:
```sql
SELECT
    project.name AS project_name,
    person.name AS person_name,
    task.name AS task_name,
    task.created_date
FROM SRO.public.activity AS task

INNER JOIN SRO.public.specificprojectprocess_activity AS sppa
ON sppa.activity_id = task.id

INNER JOIN SRO.public.specificprojectprocess AS sprint
ON sprint.id = sppa.specificproject_id

INNER JOIN SRO.public.generalprojectprocess AS project
ON project.id = sprint.generalprojectprocess_id

INNER JOIN SRO.public.project_stakeholder_activity AS psa
ON psa.activity_id = task.id

INNER JOIN SRO.public.projectstakeholder AS ps
ON ps.id = psa.projectstakeholder_id

INNER JOIN SRO.public.person
ON person.id = ps.person_id

WHERE (task.start_date IS NULL OR task.end_date IS NULL)
AND psa.event = 'ASSIGNED'

GROUP BY project_name, person.name, task.name, task.created_date
```

## `job_us_without_tasks`

### Query:
```sql
SELECT
    project.name AS project_name,
    person.name AS person_name,
    artifact.name AS user_story_name,
    artifact.created_date
FROM SRO.public.artifact

INNER JOIN SRO.public.artifact_artifact AS aa
ON aa.artifact_to_id = artifact.id

LEFT JOIN SRO.public.activity_artifact
ON activity_artifact.artifact_id = artifact.id

INNER JOIN SRO.public.artifact AS sprint_a
ON sprint_a.id = aa.artifact_from_id

INNER JOIN SRO.public.specificprojectprocess_artifact AS sppa
ON sppa.artifact_id = sprint_a.id

INNER JOIN SRO.public.specificprojectprocess AS sprint
ON sprint.id = sppa.specificprojectprocess_id

INNER JOIN SRO.public.generalprojectprocess AS project
ON project.id = sprint.generalprojectprocess_id

INNER JOIN SRO.public.project_stakeholder_artifact
ON project_stakeholder_artifact.artifact_id = artifact.id

INNER JOIN SRO.public.projectstakeholder AS ps
ON ps.id = project_stakeholder_artifact.projectstakeholder_id

INNER JOIN SRO.public.person 
ON person.id = ps.person_id

WHERE artifact.userstorytype = 'ATOMICUSERSTORY'
AND sprint_a.dtype = 'SprintBacklog'
AND activity_artifact.activity_id IS NULL
AND project_stakeholder_artifact.event = 'ASSIGNED'

GROUP BY project_name,person_name,user_story_name,artifact.created_date
```