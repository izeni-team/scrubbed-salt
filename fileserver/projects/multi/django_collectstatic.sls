#!jinja|yaml

{% for project_name, project_data in pillar.backend_projects.iteritems() %}

{% set django_project_name = project_data.django_project_name|default(project_name) %}
{% set django_settings_module = project_data.django_settings_module|default(project_name + '.settings.production') %}
{% set python_path = project_data.python_path|default('') %}


{% for x in ["media", "static"] %}

.{{ x }}_{{ project_name }}:
  file.directory:
    - name: /var/media/{{ django_project_name }}/{{ x }}
    - user: www-data
    - group: www-data
    - mode: 2775
    - makedirs: True

{% endfor %}

project_collectstatic_{{ project_name }}:
  module.run:
    - name: django.collectstatic
    - settings_module: {{ django_settings_module }}
    - pythonpath: /opt/src/{{ project_name }}/{{ python_path }}
    - bin_env: /opt/virtualenvs/{{ project_name }}

{% endfor %}