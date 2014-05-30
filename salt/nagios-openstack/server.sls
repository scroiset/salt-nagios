{% from "nagios-openstack/os-clients.jinja" import clients with context %}
{% from "nagios-openstack/roles.jinja" import roles with context %}

python-pip:
    pkg.installed

nagios-plugins-openstack:
    pkg.installed

nagios3:
    pkg.installed

nagios3-service:
    service:
        - name: nagios3
        - running
        - enable: True
        - reload: True
        - watch: 
             - file: /etc/nagios3/conf.d/*.cfg


#{% for cli in clients %}
#{{cli}}:
#    pip.installed:
#        - upgrade: True
#        - require:
#            - pkg: python-pip
#{%endfor%}

# add host

{% for host,v in salt['mine.get']('roles:\w+', 'grains.items', expr_form='grain_pcre').items() %}
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

# add users to group 'admins'

# add commands (for remote checks)
# note: nrpe remote check commands are generated on minions side

# add services to grouphost or hosts?
{% for host,v in salt['mine.get']('roles:\w+', 'grains.items', expr_form='grain_pcre').items() %}
{% if v.get('local_monitor') %}
/etc/nagios3/conf.d/service_{{host}}.cfg:
    file.managed:
        - source: salt://nagios-openstack/files/service.cfg
        - template: jinja
        - defaults:
            hostname: {{v['fqdn']}}
            checks: {{v.get('local_monitor')}}
{%else%}
/etc/nagios3/conf.d/service_{{host}}.cfg:
    file.absent
{%endif%}
{%endfor%}


#/tmp/test1:
#    file.managed:
#        - source: salt://nagios-openstack/files/test
#        - template: jinja
