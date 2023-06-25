-- problem_results should only have one record for the following
-- combination of values:
-- actor_id, problem_id, course_id, org

select
    org,
    course_id,
    problem_id,
    actor_id,
    count(*) as num_rows
from
    {{ ref('problem_results') }}
group by
    org,
    course_id,
    problem_id,
    actor_id
having num_rows > 1
