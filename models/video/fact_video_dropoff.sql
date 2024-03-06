with
    blocks as (
        select org, course_key, display_name_with_location, hierarchy_location
        from {{ ref("dim_course_blocks") }}
        where block_id like '%@chapter+block@%' or block_id like '%@sequential+block@%'
    ),
    views_by_section as (
        -- section: x:0:0
        -- take just the first number from the hierarchy location
        select
            date(emission_time) as emission_date,
            org,
            course_key,
            {{ section_from_display("video_name_with_location") }} as section_number,
            actor_id,
            count(*) as total_views
        from {{ ref("fact_video_plays") }}
        group by emission_date, org, course_key, section_number, actor_id
    ),
    views_by_subsection as (
        -- subsection: x:y:0
        -- take the first two numbers from the hierarchy location
        select
            date(emission_time) as emission_date,
            org,
            course_key,
            {{ subsection_from_display("video_name_with_location") }}
            as subsection_number,
            actor_id,
            count(*) as total_views
        from {{ ref("fact_video_plays") }}
        group by emission_date, org, course_key, subsection_number, actor_id
    ),
    video_views as (
        select
            emission_date,
            org,
            course_key,
            'section' as rollup_name,
            section_number as hierarchy_location,
            actor_id,
            sum(total_views) as total_views
        from views_by_section
        group by
            emission_date, org, course_key, rollup_name, hierarchy_location, actor_id
        union all
        select
            emission_date,
            org,
            course_key,
            'subsection' as rollup_name,
            subsection_number as hierarchy_location,
            actor_id,
            sum(total_views) as total_views
        from views_by_subsection
        group by
            emission_date, org, course_key, rollup_name, hierarchy_location, actor_id
    )

select
    video_views.emission_date as emission_date,
    video_views.org as org,
    video_views.course_key as course_key,
    video_views.rollup_name as rollup_name,
    blocks.display_name_with_location as block_name,
    video_views.actor_id as actor_id,
    video_views.total_views as total_views
from video_views
join
    blocks
    on (
        video_views.org = blocks.org
        and video_views.course_key = blocks.course_key
        and video_views.hierarchy_location = blocks.hierarchy_location
    )
