##############################################
#
# kanban pillar
#
# django_project
#
# angular_project
#
##############################################

project_name: kanban
django_project_name: kanban_back

python_bin: /usr/bin/python3
pip_bin: /usr/bin/pip3

split_ends: true

git_revision: develop
git_upstream: git@dev.izeni.net:izeni/kanban-backend.git
django_settings_module: kanban_back.settings.staging
wsgi_module: kanban_back.wsgi

# Frontend settings. Required with split_ends
frontend_git_revision: develop
frontend_git_upstream: git@dev.izeni.net:izeni/kanban-prototype.git
frontend_env: staging

uwsgi_ini: server/uwsgi-staging.ini

fqdn: kanban.izeni.net

db_user: CHANGE_ME
db_pass: CHANGE_ME
db_name: CHANGE_ME
db_host: localhost


letsencrypt:
  config: |
    server = https://acme-v01.api.letsencrypt.org/directory
    email = kcole@izeni.com
    authenticator = webroot
    webroot-path = /opt/webroot/
    agree-tos = True
    renew-by-default = True
  domainsets:
    www:
      - kanban.izeni.net
      - kanban-staging.izeni.net
