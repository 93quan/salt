master-grant:
  cmd.run:
    - name: {{ pillar['install_mysqldir'] }}/bin/mysql -e "grant replication slave,super on *.* to 'repl'@'192.168.100.120' identified by 'repl123'; flush privileges;"