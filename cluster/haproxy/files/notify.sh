#!/bin/bash
case "$1" in
  master)
        haproxy_status=$(ps -ef|grep -Ev "grep|$0"|grep '\bhaproxy\b'|wc -l)
        if [ $haproxy_status -lt 1 ];then
            systemctl start haproxy
        fi
  ;;
  backup)
        haproxy_status=$(ps -ef|grep -Ev "grep|$0"|grep '\bhaproxy\b'|wc -l)
        if [ $haproxy_status -gt 0 ];then
            systemctl stop haproxy
        fi
  ;;
  *)
        echo "Usage:$0 master|backup "
   ;;
esac
