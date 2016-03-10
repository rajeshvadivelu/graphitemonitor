#!/bin/sh

HOST="$1"

####################
# JVM metrics
###################

java_bin=`ps auwwxx |grep -v grep | grep standalone-full.xml |grep sourceforge.home | awk '{print $11}' | sed 's/.\{4\}$//'`
app_user=`grep ^APP_USER= /opt/collabnet/teamforge/runtime/conf/runtime-options.conf | awk -F= '{print $2}'`

if [ ! -z "$java_bin" ]; then
  ctf_pid=`ps auwwxx |grep -v grep | grep standalone-full.xml |grep sourceforge.home | awk '{print $2}' | head -1`
  ctf_heap_metrics=`su $app_user -c "$java_bin/jstat -gc $ctf_pid" | tail -1 | awk '{tot = $5 + $7 ; used = $6 + $8 } END {printf ("%d,%d\n",tot*1024,used*1024)}'`
  echo $ctf_heap_metrics | awk  -F\, -v host_name="$HOST" '{print "cust." host_name ".ctf.jvm.max " $1\
                                                       "\ncust." host_name ".ctf.jvm.min " $2
                                                         }'

  phoenix_heap_metrics=`$java_bin/jps | grep phoenix-loader.jar | awk '{print $1}' | head -1 | xargs $java_bin/jstat -gc | tail -1 | awk '{tot = $5 + $7 ; used = $6 + $8 } END {printf ("%d,%d\n",tot*1024,used*1024)}'`
  echo $phoenix_heap_metrics | awk  -F\, -v host_name="$HOST" '{print "cust." host_name ".phoenix.jvm.max " $1\
                                                       "\ncust." host_name ".phoenix.jvm.min " $2
                                                         }'
fi
