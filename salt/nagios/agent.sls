nagios-nrpe-server:
    pkg.installed

nagios-plugins:
    pkg.installed

nagios-nrpe-server-service:
    service:
        - name: nagios-nrpe-server
        - running
        - enable: True
        - watch: 
             - file: /etc/nagios/nrpe.cfg

/etc/nagios/nrpe.cfg:
    file.replace:
        - pattern: allowed_hosts=127.0.0.1.*
        - repl: allowed_hosts=127.0.0.1,{{ salt['pillar.get']('monitoring_ip','') }}
        - require:
            - pkg : nagios-nrpe-server

