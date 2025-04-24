# Extract`s Queries
Provide data about extraction application data. 

## Quantity of Artifact and Type saved in CIRO

Name: "extract".ciro."ciro_extract_artifact"

```sql
select 
count(*) as quantity,
dtype as artifact_type,
TO_CHAR(artifact.created_at,'YYYY-MM-DD') as extract_date 
from ciro.public.artifact
group by dtype,extract_date
order by extract_date, dtype,quantity
```

Name: "extract".ciro."ciro_extract_project"

## Quantity of Project saved in CIRO
```sql
SELECT 
count(*) as quantity, 
TO_cHAR (created_at,'YYYY-MM-DD') as extract_date
from ciro.public.project
group by extract_date
order by extract_date
```

## Quantity of User Story saved in SRO 

**Name**: sro_extract_user_story_project

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

## Person saved in SRO and CIRO
```sql
select 
sro_person.name, 
sro_person.email
from 
sro.public.person sro_person 
inner join ciro.public.person ciro_person on ciro_person.internal_id = sro_person.internal_id
order by sro_person.name
```