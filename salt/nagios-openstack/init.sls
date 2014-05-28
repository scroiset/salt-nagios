#/etc/sudoers:
#  file.managed:
#    - user: root
#    - group: root
#    - mode: 440
#    - template: jinja
#    - source: salt://sudoers/files/sudoers
#    - context:
#        included: False
#    - require:
#      - pkg: sudo
