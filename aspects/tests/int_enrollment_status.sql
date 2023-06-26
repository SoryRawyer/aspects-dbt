-- confirm there is only one enrollment status per:
-- day, org, course_id, actor_id

select
    date(emission_time) as enrollment_date,
    org,
    course_id,
    actor_id,
    count(*) as num_rows
from
    {{ ref('int_enrollment_statuses') }}
group by
    enrollment_date,
    org,
    course_id,
    actor_id
having num_rows > 1
