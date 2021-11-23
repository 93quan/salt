include:
  - modules.database.mysql.install

mysql-slave-configfile:
  file.managed:
    - name: /etc/my.cnf.d/slave.cnf
    - source: salt://modules/database/mysql/files/slave.cnf
    - user: root
    - group: root
    - mode: 0644

slave-mysql-service:
  service.running:
    - name: mysqld.service
    - enable: true
    - require:
      - file: mysql-slave-configfile
    - reload: true
    - watch:
      - file: mysql-slave-configfile
