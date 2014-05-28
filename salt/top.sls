base:
    'local_monitor:\w+':
        - match: grain_pcre
        - nagios.agent
        - nagios-openstack.node
    'roles:nagios':
        - match: grain
        - nagios-openstack.server
