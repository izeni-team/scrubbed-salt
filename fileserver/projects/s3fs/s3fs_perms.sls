#!jinja|yaml

{% set s3fs = pillar.s3fs_conf|default({}) %}

file_perms:
  cmd.run:
    - name: find {{ s3fs.mount_path }} -type f -exec chmod 660 {} \;

owner:
  cmd.run:
    - name: chown -R {{ s3fs.user }}:{{ s3fs.group }} {{ s3fs.mount_path }}/*

dir_perms:
  cmd.run:
    - name: find {{ s3fs.mount_path }}/* -type d -exec chmod 770 {} \;
