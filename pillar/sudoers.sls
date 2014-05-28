include:
    - openstack-services

sudoers:
  includedir: /etc/sudoers.d
  included_files:
{%for os in pillar.get('os-services', [])%}
    /etc/sudoers.d/os-nagios-{{os}}
      users:
        nagios: 'ALL=(ALL) NOPASSWD: {{os}}
      aliases:
        commands:
          {{os}}:
            - /usr/lib/nagios/plugins/ceilometer/check_{{os}}.sh
{%endfor%}

      #      - /usr/lib/nagios/plugins/ceilometer/check_ceilometer-agent-central.sh
      #      - /usr/lib/nagios/plugins/ceilometer/check_ceilometer-agent-compute.sh
      #      - /usr/lib/nagios/plugins/ceilometer/check_ceilometer-alarm-notify.sh
      #    NOVA:
      #      - /usr/lib/nagios/plugins/nova/check_nova-conductor.sh
      #      - /usr/lib/nagios/plugins/nova/check_nova-scheduler.sh
      #      - /usr/lib/nagios/plugins/nova/check_nova-compute.sh
      #    HEAT:
      #      - /usr/lib/nagios/plugins/heat/check_heat-engine.sh
