{% from "nagios-openstack/package-map.jinja" import pkgs with context %}
{% from "nagios-openstack/checks.jinja" import checks with context %}

sudo:
  pkg.installed:
    - name: {{ pkgs.sudo }}

git:
  pkg.installed:
    - name: {{ pkgs.git}}

# sync plugins
{{salt['pillar.get']('nagios_plugins_git_repo', 'http://github.com/scroiset/openstack-monitoring.git')}}:
  git.latest:
    - rev: {{salt['pillar.get']('nagios_plugins_git_branch', 'master')}}
    - target: {{salt['pillar.get']('nagios_plugins_dir', '/usr/lib/nagios/plugins')}}/openstack
    - require:
      - pkg: git

# sudoers
{% for os,params in checks.items() %}
/etc/sudoers.d/{{os}}:
{% if os in salt['grains.get']('local_monitor', []) %}
  file.managed:
    - user: root
    - group : root
    - mode: 0440
    - template: jinja
    - source: salt://nagios-openstack/files/sudoers
    - defaults:
      os: {{os}}
      cmd_user: nagios
      nagios_plugins_dir: {{salt['pillar.get']('nagios_plugins_dir', '/usr/lib/nagios/plugins')}}
      path: {{params.get('path', '')}}
    - require:
        - pkg: {{ pkgs.sudo }}
{%else%}
  file.absent
{% endif %}
{% endfor %}

# nrpe command
{% for os, params in checks.items() %}
/etc/nagios/nrpe.d/openstack_{{os}}.cfg:
{% if os in salt['grains.get']('local_monitor', []) %}
  file.managed:
    - user: root
    - group : root
    - mode: 0440
    - template: jinja
    - source: salt://nagios-openstack/files/nrpe.cfg
    - defaults:
      os: {{os}}
      cmd_user: nagios
      nagios_plugins_dir: {{salt['pillar.get']('nagios_plugins_dir', '/usr/lib/nagios/plugins')}}
      path: {{params.get('path','')}}
    - require:
        - pkg: nagios-nrpe-server
{%else%}
  file.absent
{% endif %}

{%endfor%}
