#! /bin/bash

case "$1" in
start)
  echo "Starting new process ..."
  count=`ps auwxx |grep pipe-to-graphite-30.sh | grep -v grep | wc -l`
  if [ $count -eq 0 ]; then
    /var/ops/monitor/bin/pipe-to-graphite-30.sh  report-to-graphite /var/ops/monitor/bin/scripts_wrapper.sh >/dev/null &
  else
    echo "Process already running"
  fi
 ;;
status)
  count=`ps auwxx |grep pipe-to-graphite-30.sh | grep -v grep | wc -l`
  if [ $count -eq 0 ]; then
    echo "pipe-to-graphite process not running"
  else
    echo "pipe-to-graphite process running ..."
  fi
 ;;
stop)
  count=`ps auwxx |grep pipe-to-graphite-30.sh | grep -v grep | wc -l`
  if [ $count -gt 0 ]; then
    echo "Exiting monitor process .. "
    ps auwxx |grep pipe-to-graphite-30.sh | grep -v grep | awk '{print $2}'| xargs kill -9
  fi
 ;;
restart)
  $0 stop
  $0 start
 ;;
*)
  echo "usage: $0 (start | stop | restart)"
esac
