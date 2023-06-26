-- select
--     *
-- from
--     {{ ref('stg_enrollment_windows') }} s
--     left join {{ ref('int_enrollment_windows') }} i
--         using (org, course_id, actor_id, window_start_date, window_end_date)
-- where i.org is null

select
    e2.enrollment_status_date,
    e2.org,
    e2.course_id,
    e2.actor_id,
    count(*) as num_rows
from
    {{ ref('enrollments_by_day') }} e1
    left join {{ ref('new_enrollments_by_day') }} e2
        using (enrollment_status_date, org, course_id, actor_id)
group by 1,2,3,4
having num_rows > 1
