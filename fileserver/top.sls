base:
# Project highstates
  'kanban-staging':
    - projects.server_environment_high
    - projects.server_frontend_pkgs
    - projects.virtualenv
    - projects.backend_latest
    - projects.frontend_latest
    - projects.django.collectstatic
    - projects.postgres.pg94
    - projects.uwsgi
    - projects.nginx
    - projects.letsencrypt
