#!jinja|yaml

{% set project_name = pillar.project_name|default('izeni') %}
{% set pip_bin = pillar.pip_bin|default('/usr/local/bin/pip') %}

uwsgi_installed:
  pip.installed:
    - name: uwsgi
    - bin_env: {{ pip_bin }}

uwsgitop_installed:
  pip.installed:
    - name: uwsgitop

service_script:
  file.managed:
    {% if grains['os'] == 'Ubuntu' and grains['osrelease'] == '14.04' %}
    - name: /etc/init/uwsgi-{{ project_name }}.conf
    - source: salt://projects/uwsgi/upstart.conf
    {% else %}
    - name: /etc/systemd/system/uwsgi-{{ project_name }}.service
    - source: salt://projects/uwsgi/systemd.service
    {% endif %}
    - template: jinja
    - makedirs: true

uwsgi_running:
  service.running:
    - name: uwsgi-{{ project_name }}
    - enable: true
    - reload: true

# A restart because reload on service doesn't work very well
uwsgi_restart:
  cmd.run:
    - name: sudo service uwsgi-{{ project_name }} restart
