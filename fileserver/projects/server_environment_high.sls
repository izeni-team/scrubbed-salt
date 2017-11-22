#!jinja|yaml

include:
  - projects.server_pkgs
  - projects.server_user
  {% if pillar.multi|default() %}
  - projects.multi.server_directories
  {% else %}
  - projects.server_directories
  {% endif %}
  - projects.server_env
  - projects.server_rc
