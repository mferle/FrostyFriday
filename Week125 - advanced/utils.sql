{%- macro power_of_two(numbers_list) -%}
  {%- for n in numbers_list -%}
    {% if not loop.first %}
      {{ ' union all ' }}
    {%- endif -%}
    {{ 'select ' + n|string + ' as original_number, ' + (n*n)|string + ' as squared ' }}
  {% endfor %}
{%- endmacro -%}
