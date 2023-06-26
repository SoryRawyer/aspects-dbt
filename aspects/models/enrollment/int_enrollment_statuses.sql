-- get a maximum of one enrollment status per day per learner

with last_of_day as (
    select
        date(emission_time) as event_date,
        org,
        course_id,
        actor_id,
        max(emission_time) as last_event_at
    from
        {{ source('xapi', 'enrollment_events') }}
    group by
        event_date,
        org,
        course_id,
        actor_id
)

select
    e.emission_time,
    e.org,
    e.course_id,
    e.actor_id,
    e.enrollment_mode,
    e.verb_id
from
    {{ source('xapi', 'enrollment_events') }} e
    join last_of_day lod
        on (e.org = lod.org
            and e.course_id = lod.course_id
            and e.actor_id = lod.actor_id
            and e.emission_time = lod.last_event_at)
