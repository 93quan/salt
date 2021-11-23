mysql-master-configfile:
  file.managed:
    - name: /etc/my.cnf.d/master.cnf
    - source: salt://modeles/database/mysql/files/master.cnf
    - user: root
    - group: root
    - mode: 0644

master-service:
  service.running:
    - name: mysqld.service
    - enable: true
    - require: 
      - file: mysql-master-configfile
    - reload: true
    - watch:
      - file: mysql-master-configfile