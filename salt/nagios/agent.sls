nagios-nrpe-server:
    pkg.installed

nagios-plugins:
    pkg.installed

nagios-nrpe-server-service:
    service:
        - name: nagios-nrpe-server
        - running
        - enable: True
        - reload: True
        - full_restart: True
        - watch: 
             - file: /etc/nagios/nrpe.cfg
             - file: /etc/nagios/nrpe.d/openstack_*cfg
             - file: /etc/sudoers.d/*

/etc/nagios/nrpe.cfg:
    file.replace:
        - pattern: allowed_hosts=127.0.0.1.*
        - repl: allowed_hosts=127.0.0.1,{{ salt['pillar.get']('monitoring_ip','') }}
        - require:
            - pkg : nagios-nrpe-server

