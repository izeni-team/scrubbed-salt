#!jinja|yaml

# We expect the project to install celery for its dependencies

{% set celery_conf = pillar.celery_conf|default() %}
{% set project_name = pillar.project_name|default('izeni') %}
{% set django_project_name = pillar.django_project_name|default(project_name) %}





celery_config:
  file.symlink:
    - target: /opt/src/{{ project_name }}-backend/{{ celery_conf }}
    - name: /etc/default/celeryd
    - user: root
    - group: root
    - mode: 600
    - force: true
    - makedirs: true

celery_initfile:
  file.managed:
    - name: /etc/init.d/celeryd
    - source: salt://projects/celery/celeryd
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: celery_config


celery_start:
  service.running:
    - name: celeryd
    - enable: True
    - reload: True
    - require:
      - file: celery_initfile

celery_restart:
  cmd.run:
    - name: service celeryd restart
    - user: root