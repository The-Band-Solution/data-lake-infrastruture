
# Growth_rate_product_backlog_project_accummulate_view
theband.sro."growth_rate_product_backlog_project_accummulate_view"

SELECT 
DISTINCT
project,
growth_rate_product_backlog_project_view.event_date,
sum(growth_rate_product_backlog_project_view.qtd) over (ORDER by growth_rate_product_backlog_project_view.event_date) as accumulated_sum
FROM theband.sro."growth_rate_product_backlog_project_view"
order by growth_rate_product_backlog_project_view.project, growth_rate_product_backlog_project_view.event_date


# growth_rate_product_backlog_project_view
theband.sro."growth_rate_product_backlog_project_view"
SELECT 
project,
userstorytype,
TO_DATE(event_date) as event_date, 
count(*) as qtd
FROM theband.sro."product_backlog_view"
group by project, event_date, userstorytype


# Growth rate view
# theband.sro."growth_rate_project_view"
SELECT 
  DISTINCT
  project,
  event_date,
  userstorytype,
  LAG(qtd) OVER (ORDER BY event_date) as previous_value,
  qtd as current_value,
  ((qtd - LAG(qtd) OVER (ORDER BY event_date)) / LAG(qtd) OVER (ORDER BY event_date)) * 100 as growth_rate
FROM
  theband.sro."growth_rate_product_backlog_project_view"
ORDER BY
  project, event_date, growth_rate

# Waiting Time view
select * from sro.public.waiting_time_view

# Product Backlog -> theband.sro."product_backlog_view"
select  
product_backlog."name" as project, 
userstory."name" as userstory,
userstory.userstorytype, 
relation.event_date,
relation.artifactrelation 
from 
sro.public.artifact_artifact relation 
inner join sro.public.artifact product_backlog on product_backlog.id = relation.artifact_from_id 
inner join sro.public.artifact userstory on userstory.id = relation.artifact_to_id 
where 
product_backlog.dtype = 'ProductBacklog'
order by project, userstory, event_date, event_date