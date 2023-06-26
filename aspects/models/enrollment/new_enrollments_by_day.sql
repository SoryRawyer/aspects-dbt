select
    date(fromUnixTimestamp(enrollment_status_at)) as enrollment_status_date,
    org,
    course_id,
    actor_id,
    enrollment_mode,
    if(
        verb_id = 'http://adlnet.gov/expapi/verbs/registered',
        'registered',
        'unregistered'
    ) as enrollment_status
from
    {{ ref('stg_enrollments_by_day') }}
