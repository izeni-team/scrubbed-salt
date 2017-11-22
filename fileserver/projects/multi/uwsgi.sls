#!jinja|yaml


{% set pip_bin = pillar.pip_bin|default('/usr/local/bin/pip') %}

uwsgi_installed:
  pip.installed:
    - name: uwsgi
    - bin_env: {{ pip_bin }}

uwsgitop_installed:
  pip.installed:
    - name: uwsgitop

{% for project_name, project_data in pillar.backend_projects.iteritems() %}


upstart_script_{{ project_name }}:
  file.managed:
    - name: /etc/init/uwsgi-{{ project_name }}.conf
    - source: salt://projects/multi/uwsgi_upstart.conf
    - template: jinja
    - makedirs: true
    - context:
        project_data: {{ project_data }}
        project_name: {{ project_name }}


uwsgi_running_{{ project_name }}:
  service.running:
    - name: uwsgi-{{ project_name }}
    - enable: true
    - reload: true

# A restart because reload on service doesn't work very well
uwsgi_restart_{{ project_name }}:
  cmd.run:
    - name: sudo service uwsgi-{{ project_name }} restart

{% endfor %}
