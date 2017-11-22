#!jinja|yaml

# Need to make sure the .ssh directory exists. make_dirs apparently
# doesn't work on first run

{% set project_deploy_key = pillar.project_deploy_key|default() %}

ssh_dir:
  file.directory:
    - name: /home/izeni/.ssh/
    - user: izeni
    - group: izeni
    - mode: 700

private_deploy_key:
  file.managed:
    - name: /home/izeni/.ssh/deploy_key
    {% if project_deploy_key %}
    - contents_pillar: project_deploy_key
    {% else %}     
    - source: salt://keys/deploy/project_deploy
    {% endif %}
    - make_dirs: true
    - user: izeni
    - group: izeni
    - mode: 600

{% if not project_deploy_key %}
public_deploy_key:
  file.managed:
    - name: /home/izeni/.ssh/deploy_key.pub
    - source: salt://keys/deploy/project_deploy.pub
    - make_dirs: true
    - user: izeni
    - group: izeni
    - mode: 600
{% endif %}
