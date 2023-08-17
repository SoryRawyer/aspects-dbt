with navigation as (
    select
        emission_time,
        org,
        course_key,
        actor_id,
        splitByString('/xblock/', object_id)[-1] as block_location,
        object_type,
        starting_position,
        ending_point
    from
        {{ source('xapi', 'navigation_events') }}
)

select
    navigation.emission_time as emission_time,
    navigation.org as org,
    navigation.course_key as course_key,
    courses.course_name as course_name,
    courses.course_run as course_run,
    navigation.actor_id as actor_id,
    navigation.block_location as block_location,
    blocks.block_name as block_name,
    navigation.object_type as object_type,
    navigation.starting_position as starting_position,
    navigation.ending_point as ending_point
from
    navigation
    join {{ source('event_sink', 'course_names') }} courses
        on navigation.course_key = courses.course_key
    join {{ source('event_sink', 'course_block_names') }} blocks
        on navigation.block_location = blocks.location
