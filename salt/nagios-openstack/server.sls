{% from "nagios-openstack/os-clients.jinja" import clients with context %}
{% from "nagios-openstack/roles.jinja" import roles with context %}

python-pip:
    pkg.installed

nagios-plugins-openstack:
    pkg.installed

#{% for cli in clients %}
#{{cli}}:
#    pip.installed:
#        - upgrade: True
#        - require:
#            - pkg: python-pip
#{%endfor%}

# add host
{% for host,v in salt['mine.get']('roles:os-controler', 'grains.items', expr_form='grain').items() %}
/etc/nagios3/conf.d/host_{{host}}.cfg:
    file.managed:
        - source: salt://nagios-openstack/files/n_host.cfg
        - template: jinja
        - defaults:
            ip: {{v['ipv4'][0]}}
            hostname: {{v['fqdn']}}
{%endfor%}
# add grouphost and theirs members
{% for r in roles %}
{%- set grain_match = 'roles:' + r %}
{%- set hosts = salt['mine.get'](grain_match, 'grains.items', expr_form='grain').keys() %}

/etc/nagios3/conf.d/hostgroup_{{r}}.cfg:
{% if hosts|count > 0 %}
    file.managed:
        - source: salt://nagios-openstack/files/n_hostgroup.cfg
        - template: jinja
        - defaults:
            hosts: {{",".join(hosts)}}
            name: {{r}}
{%else%}
    file.absent
{%endif%}
{%endfor%}

# add commands (for remote checks)
# note: nrpe remote check commands are generated on minions side

# add services to grouphost or hosts?

#/tmp/test1:
#    file.managed:
#        - source: salt://nagios-openstack/files/test
#        - template: jinja
