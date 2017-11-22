#!jinja|yaml


pgbouncer_installed:
  pkg.installed:
    - name: pgbouncer

config_file:
  file.managed:
    - name: /etc/pgbouncer/pgbouncer.ini
    - source: salt://projects/pgbouncer/pgbouncer.ini
    - user: postgres
    - group: postgres

user_file:
  file.managed:
    - name: /etc/pgbouncer/userlist.txt
    - source: salt://projects/pgbouncer/userlist.txt
    - user: postgres
    - group: postgres

service_restart:
  service.running:
    - name: pgbouncer
    - enable: True
    - reload: True