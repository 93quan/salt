#!/bin/bash

master_ip=192.168.100.120
mysql=/usr/local/mysql/bin/mysql
repl_user=repl
repl_pass=repl123
log_file=$($mysql -u$repl_user -p$repl_pass -h$master_ip -r 'show master status;'| grep mysql_bin|awk '{print $1}')
log_pos=$($mysql -u$repl_user -p$repl_pass -h$master_ip -r 'show master status;'| grep mysql_bin|awk '{print $2}')

$mysql -e "change master to MASTER_HOST='$master_ip', MASTER_USER='$repl_user', MASTER_PASSWORD='$repl_pass',MASTER_LOG_FILE='$log_file',MASTER_LOG_POS=log_pos;start slave; "
