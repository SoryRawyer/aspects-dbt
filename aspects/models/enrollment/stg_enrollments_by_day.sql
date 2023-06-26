select
    arrayJoin(
        range(
            toUnixTimestamp(window_start_date),
            toUnixTimestamp(window_end_date),
            86400
        )
    ) as enrollment_status_at,
    org,
    course_id,
    actor_id,
    enrollment_mode,
    verb_id
from
    {{ ref('int_enrollment_windows') }}
