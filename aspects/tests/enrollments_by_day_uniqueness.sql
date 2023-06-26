select
    enrollment_status_date,
    org,
    course_id,
    actor_id,
    count(*) as num_rows
from
    {{ ref('enrollments_by_day') }}
group by 1,2,3,4
having num_rows > 1
