mine_functions:
    test.ping: []
    grains.items: []

monitoring_ip: 10.197.223.69
nagios_plugins_git_repo: http://github.com/scroiset/openstack-monitoring.git
nagios_plugins_git_branch: master
nagios_plugins_dir: /usr/lib/nagios/plugins
nagios_plugins_params:
    disk:
        warning: 20%
        critical: 10%
        extra: -l -X udev -X devpts -X tmpfs -X none -X  cgroup
    rabbitMQ:
        extra: 
    mongo:
        extra: 
    all_diskstat:
        extra: 200,6000000,1000000 300,10000000,2500000
    swap:
        warning: 90%
        critical: 80%

nagios_server_conf_dir: /etc/nagios3/conf.d/
nagios_server_conf_name: xlcloud_havana.cfg

nagios_server_contacts:
    swann:
        email: swann.croiset@bull.net
        name: Swann Croiset
        group: admins
    jp:
        email: jean-pierre.dion@bull.net
        name: Jean-Pierre Dion
        group: admins

