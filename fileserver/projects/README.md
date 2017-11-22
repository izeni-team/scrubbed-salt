# Standards for our Salt Project Deployments

## Variables
***variable_name:default_value***

project_name: izeni

python_bin: /usr/bin/python

split_ends: false

git_revision: master
git_upstream: git@dev.izeni.net:izeni/izeni-django-template.git


## Directory Structure

* /home/izeni/
  *TODO*


* /opt/
  * src/
    * {{project_name}}-backend/
    * ({{project_name}}-frontend/)
  * virtualenvs/
  * backend -> Symlink
  * (frontend -> Symlink)


* /var/log/{{project_name}}/


## Users/Permissions

User: izeni - groups: wheel/sudo, www-data

## Packages

### System
htop,iotop,iftop,vim-nox,git,git-flow,tig,ack-grep,tmux,screen,byobu,graphviz,
libfreetype6-dev,libjpeg8-dev,libxml2-dev,libxslt1-dev,lib32z1-dev,
postgresql-server-dev-all,python-dev,python-pip

### Python