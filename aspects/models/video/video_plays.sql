-- model to support number of watches per video
-- ref: https://edx.readthedocs.io/projects/edx-insights/en/latest/Reference.html#engagement-computations

select
    emission_time,
    org,
    course_key,
    splitByString('/xblock/', object_id)[2] as video_id,
    actor_id
from
    {{ source('xapi', 'video_playback_events') }}
where
    verb_id = 'https://w3id.org/xapi/video/verbs/played'
