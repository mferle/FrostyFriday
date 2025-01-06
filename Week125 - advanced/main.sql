--!jinja2
{% from "utils.sql" import power_of_two %}

{% set numbers_list = [1, 2, 3, 4] %}

{{ power_of_two(numbers_list) }}
