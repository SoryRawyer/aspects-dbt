-- present one record per learner per problem
-- includes the total number of attempts made and the results of the final
-- problem submission
-- this could include "number of attempts until first success"

-- dimensions: org, course_id, problem_id, actor_id
-- metrics: success, attempts

-- TODO: this should be first success, not last attempt
-- maybe we could filter out people who never had a successful
-- submission and summarize their attempts separately, then union
-- everything back together later

-- get the ids of the last attempt and select
-- only records that match the last attemp
with last_attempts as (
    select
        org,
        course_id,
        problem_id,
        actor_id,
        max(attempts) as attempts
    from
        {{ ref('problem_responses') }}
    group by
        org,
        course_id,
        problem_id,
        actor_id
)

select
    emission_time,
    org,
    course_id,
    problem_id,
    actor_id,
    responses,
    success,
    attempts
from
    {{ ref('problem_responses') }} pr
    join last_attempts la
        using (attempts, actor_id, problem_id, course_id, org)
