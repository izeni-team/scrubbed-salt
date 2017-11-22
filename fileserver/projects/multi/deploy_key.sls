#!jinja|yaml

# Need to make sure the .ssh directory exists. make_dirs apparently
# doesn't work on first run

ssh_dir:
  file.directory:
    - name: /home/izeni/.ssh/
    - user: izeni
    - group: izeni
    - mode: 700

private_deploy_key:
  file.managed:
    - name: /home/izeni/.ssh/deploy_key
    - source: salt://keys/deploy/project_deploy
    - make_dirs: true
    - user: izeni
    - group: izeni
    - mode: 600

public_deploy_key:
  file.managed:
    - name: /home/izeni/.ssh/deploy_key.pub
    - source: salt://keys/deploy/project_deploy.pub
    - make_dirs: true
    - user: izeni
    - group: izeni
    - mode: 600
