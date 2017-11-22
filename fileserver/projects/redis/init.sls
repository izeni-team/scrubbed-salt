#!jinja|yaml

redis_ppa:
  pkgrepo.managed:
    - ppa: chris-lea/redis-server


redis_server_installed:
  pkg.installed:
    - name: redis-server
    - refresh: true
