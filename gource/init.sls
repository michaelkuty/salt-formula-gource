{%- if pillar.gource is defined %}
include:
{%- if pillar.gource.client is defined %}
- gource.client
{%- endif %}
{%- endif %}
