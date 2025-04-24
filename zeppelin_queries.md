# Zeppelin`s Queries
Provide integrated data to answser some *Zeppelìn*`s assessment. 

## Agile Organization 

### [AO.01] Roles involved in the agile development process (e.g., Scrum Master, Product Owner, Developer, Tester) exist in the organization.

####  Team Member that Plays Back-End Developer Role

Name: zeppelin_develeper_backend

```sql 
Select 
DISTINCT
sro_project.name as project_name, 
--sourcerepository.name as sourcerepository_name,
person.name as developer
from sro.public.project sro_project 
inner join ciro.public.project ciro_project on sro_project.internal_id = ciro_project.internal_id
inner join ciro.public.generalprojectprocess on ciro_project.id = generalprojectprocess.softwareproject_id
inner join ciro.public.specificprojectprocess on generalprojectprocess.id = specificprojectprocess.generalprojectprocess_id
inner join ciro.public.specificprojectprocess_artifact on specificprojectprocess.id = specificprojectprocess_artifact.specificprojectprocess_id 
inner join ciro.public.artifact sourcerepository on specificprojectprocess_artifact.artifact_id = sourcerepository.id
inner join ciro.public.artifact_artifact aa on aa.artifact_from_id = sourcerepository.id 
inner join ciro.public.artifact artifact_copy on aa.artifact_to_id = artifact_copy.id 
inner join ciro.public.project_stakeholder_artifact psa on psa.artifact_id = artifact_copy.id
inner join ciro.public.projectstakeholder on projectstakeholder.id = psa.projectstakeholder_id
inner join ciro.public.person on person.id = projectstakeholder.person_id

WHERE
sourcerepository.dtype = 'SourceRepository' and 
artifact_copy.dtype = 'ArtifactCopy' and
SUBSTRING(artifact_copy.name, POSITION('.' IN artifact_copy.name) + 1) IN ('py','java', 'ts', 'js', 'sql','.feature')

order by project_name, person.name
```
#### Team Member that Plays Front-End Developer Role

Name: zeppelin_develeper_frontend

```sql
Select 
DISTINCT
sro_project.name as project_name, 
--sourcerepository.name as sourcerepository_name,
person.name as developer
from sro.public.project sro_project 
inner join ciro.public.project ciro_project on sro_project.internal_id = ciro_project.internal_id
inner join ciro.public.generalprojectprocess on ciro_project.id = generalprojectprocess.softwareproject_id
inner join ciro.public.specificprojectprocess on generalprojectprocess.id = specificprojectprocess.generalprojectprocess_id
inner join ciro.public.specificprojectprocess_artifact on specificprojectprocess.id = specificprojectprocess_artifact.specificprojectprocess_id 
inner join ciro.public.artifact sourcerepository on specificprojectprocess_artifact.artifact_id = sourcerepository.id
inner join ciro.public.artifact_artifact aa on aa.artifact_from_id = sourcerepository.id 
inner join ciro.public.artifact artifact_copy on aa.artifact_to_id = artifact_copy.id 
inner join ciro.public.project_stakeholder_artifact psa on psa.artifact_id = artifact_copy.id
inner join ciro.public.projectstakeholder on projectstakeholder.id = psa.projectstakeholder_id
inner join ciro.public.person on person.id = projectstakeholder.person_id

WHERE
sourcerepository.dtype = 'SourceRepository' and 
artifact_copy.dtype = 'ArtifactCopy' and
SUBSTRING(artifact_copy.name, POSITION('.' IN artifact_copy.name) + 1) IN ('ts', 'js','html','css')

order by project_name, person.name
```
#### Team members that Plays Scrum Master\Product Owner Role
Name: Zeppelin_developer_scrum_master
```sql
Select 
DISTINCT
sro_project.name as project_name,
person.name as stakeholder_name
from sro.public.project sro_project 
inner join ciro.public.project ciro_project on sro_project.internal_id = ciro_project.internal_id
inner join sro.public.projectstakeholder_softwareproject on projectstakeholder_softwareproject.softwareproject_id = sro_project.id
inner join sro.public.projectstakeholder on projectstakeholder.id = projectstakeholder_softwareproject.projectstakeholder_id
inner join sro.public.project_stakeholder_artifact on project_stakeholder_artifact.projectstakeholder_id = projectstakeholder.id
inner join sro.public.artifact userstory on userstory.id = project_stakeholder_artifact.artifact_id
inner join sro.public.person on person.id = projectstakeholder.person_id
where 
userstory.dtype = 'UserStory' and 
project_stakeholder_artifact.event='CREATED'
ORDER BY project_name, stakeholder_name
```
### [AO.03] The scope of the project is defined gradually, using the Product Backlog (or equivalent artifact).

```sql
Select 
DISTINCT
sro_project.name as project_name,
TO_CHAR(project_stakeholder_artifact.event_date, 'MM-DD-YYYY') created_date,
count(*) quantity,
userstory.userstorytype

from sro.public.project sro_project 
inner join ciro.public.project ciro_project on sro_project.internal_id = ciro_project.internal_id
inner join sro.public.projectstakeholder_softwareproject on projectstakeholder_softwareproject.softwareproject_id = sro_project.id
inner join sro.public.projectstakeholder on projectstakeholder.id = projectstakeholder_softwareproject.projectstakeholder_id
inner join sro.public.project_stakeholder_artifact on project_stakeholder_artifact.projectstakeholder_id = projectstakeholder.id
inner join sro.public.artifact userstory on userstory.id = project_stakeholder_artifact.artifact_id
inner join sro.public.person on person.id = projectstakeholder.person_id
where 
userstory.dtype = 'UserStory' and 
project_stakeholder_artifact.event='CREATED'
group by project_name, created_date, userstory.userstorytype
ORDER BY project_name, created_date, userstory.userstorytype
```


### [AO.04] Effort estimation is performed by (or together with) the development team considering short activities to implement a set of selected requirements (and not the project as a whole)

```sql
select 
count(*) as quantity, 
scrum_project.name as project_name
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
user_story.effort is null 
group by scrum_project.name
```


### [AO.07] The development process is performed iteratively, in short cycles (e.g., 2 weeks), in which selected project requirements recorded in a Sprint Backlog (or equivalent artifact) are developed

#### Quantity of Sprints by Projects

```sql
select 
project.name,
count(*) as quantity
from 
sro.public.project 
inner join sro.public.generalprojectprocess g on project.id = g.softwareproject_id
inner join sro.public.specificprojectprocess sprint on sprint.generalprojectprocess_id = g.id
where 
sprint.dtype = 'Sprint'
group by project.name
order by project.name   
```

#### Last Sprint by Project

```sql
select 
project.name,
MAX(sprint.end_date) as max_end_date,
MAX(sprint.start_date) as max_start_date
from 
sro.public.project 
inner join sro.public.generalprojectprocess g on project.id = g.softwareproject_id
inner join sro.public.specificprojectprocess sprint on sprint.generalprojectprocess_id = g.id
where 
sprint.dtype = 'Sprint'
group by project.name
order by project.name
```

### [AO.14] Teams are small (usually between 4 to 6 developers), self-organized and multidisciplinary

```sql
select 
project.name as project_name,
count(*) quantity
from 
sro.public.project  
inner join sro.public.projectstakeholder_softwareproject ps on ps.softwareproject_id = project.id
inner join sro.public.projectstakeholder p on p.id = ps.projectstakeholder_id 
inner join sro.public.person pe on pe.id  = p.person_id 
group by project.name 
order by project.name
```

## Continuous Integration

### [CI.12] Check-in good practices are applied in the development trunk (e.g., use of tools such as GitFlow and Toogle Feature)

#### Projects x Source Repository x Branch

```sql
Select 
sro_project.name as project_name, 
sourcerepository.name as sourcerepository_name,
count (*) as quantity
from sro.public.project sro_project 
inner join ciro.public.project ciro_project on sro_project.internal_id = ciro_project.internal_id
inner join ciro.public.generalprojectprocess on ciro_project.id = generalprojectprocess.softwareproject_id
inner join ciro.public.specificprojectprocess on generalprojectprocess.id = specificprojectprocess.generalprojectprocess_id
inner join ciro.public.specificprojectprocess_artifact on specificprojectprocess.id = specificprojectprocess_artifact.specificprojectprocess_id 
inner join ciro.public.artifact sourcerepository on specificprojectprocess_artifact.artifact_id = sourcerepository.id
inner join ciro.public.artifact_artifact aa on aa.artifact_from_id = sourcerepository.id 
inner join ciro.public.artifact artifac_branch on aa.artifact_to_id = artifac_branch.id 
WHERE
sourcerepository.dtype = 'SourceRepository' and 
artifac_branch.dtype = 'Branch'
group by project_name,sourcerepository_name
order by project_name

```
##### Projects x Source Repository x Branch x Merged
```sql
Select 
sro_project.name as project_name, 
sourcerepository.name as sourcerepository_name,
artifac_branch.merged, 
count (*) as quantity
from sro.public.project sro_project 
inner join ciro.public.project ciro_project on sro_project.internal_id = ciro_project.internal_id
inner join ciro.public.generalprojectprocess on ciro_project.id = generalprojectprocess.softwareproject_id
inner join ciro.public.specificprojectprocess on generalprojectprocess.id = specificprojectprocess.generalprojectprocess_id
inner join ciro.public.specificprojectprocess_artifact on specificprojectprocess.id = specificprojectprocess_artifact.specificprojectprocess_id 
inner join ciro.public.artifact sourcerepository on specificprojectprocess_artifact.artifact_id = sourcerepository.id
inner join ciro.public.artifact_artifact aa on aa.artifact_from_id = sourcerepository.id 
inner join ciro.public.artifact artifac_branch on aa.artifact_to_id = artifac_branch.id 
WHERE
sourcerepository.dtype = 'SourceRepository' and 
artifac_branch.dtype = 'Branch'
group by project_name,sourcerepository_name, artifac_branch.merged
order by project_name, artifac_branch.merged

```