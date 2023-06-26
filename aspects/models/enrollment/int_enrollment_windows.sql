-- join enrollment statuses to itself to get prior enrollment event time

with enrollment_windows as (
    select
        ies.org,
        ies.course_id,
        ies.actor_id,
        ies.enrollment_mode,
        ies.verb_id,
        ies.emission_time as window_start_at,
        -- oh come _on_, just return null!
        nullIf(next_event.emission_time, '1970-01-01 00:00:00') as window_end_at
    from
        {{ ref('int_enrollment_statuses') }} ies
        left asof join {{ ref('int_enrollment_statuses') }} next_event
            on (ies.org = next_event.org
                and ies.course_id = next_event.course_id
                and ies.actor_id = next_event.actor_id
                and ies.emission_time < next_event.emission_time)
)

select
    org,
    course_id,
    actor_id,
    enrollment_mode,
    verb_id,
    date_trunc('day', window_start_at) as window_start_date,
    date_trunc('day', coalesce(window_end_at, now())) as window_end_date
from
    enrollment_windows
