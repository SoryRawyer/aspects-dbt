select '3:1:4 - Electronic Sound Experiment' as display_name_with_location
from system.one
where
    {{ subsection_from_display(display_name_with_location) }} != '3:1:0'
    and {{ section_from_display(display_name_with_location) }} != '3:0:0'
