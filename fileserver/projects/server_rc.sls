#!jinja|yaml

{% for file_name in [
  'bashrc',
  'bash_prompt',
  'bash_prompt_colors',
  'vimrc',
  'nanorc'
] %}


{{ file_name }}:
  file.managed:
    - name: /home/izeni/.{{ file_name }}
    - source: salt://projects/rc_files/{{ file_name }}
    - user: izeni
    - group: izeni

{% endfor %}
