#!/bin/sh

HOST="$1"

count=`ps auwwxx |grep dstat | grep -v grep | grep -c "output /opt/collabnet/teamforge/log/runtime/dstat.out"`
if [ $count -eq 0 ]; then
   echo "dstat process not running .. starting one .."
  /usr/bin/dstat -tcdglmnprsy --tcp --noupdate --float --noheader --nocolor --output /opt/collabnet/teamforge/log/runtime/dstat.out 30 2>&1 1>/dev/null &
fi

if [[ ! -f /opt/collabnet/teamforge/log/runtime/dstat.out ]] ; then
    exit
fi

line=`tail -1 /opt/collabnet/teamforge/log/runtime/dstat.out`
echo $line | awk -F\, -v host_name="$HOST" '{print "cust." host_name ".system.cpu.usr " $2\
                            "\ncust." host_name ".system.cpu.sys " $3\
                            "\ncust." host_name ".system.cpu.idl " $4\
                            "\ncust." host_name ".system.cpu.wait " $5\
                            "\ncust." host_name ".system.dsk.read " $8\
                            "\ncust." host_name ".system.dsk.write " $9\
                            "\ncust." host_name ".system.page.in " $10\
                            "\ncust." host_name ".system.page.out " $11\
                            "\ncust." host_name ".system.lavg.1m " $12\
                            "\ncust." host_name ".system.lavg.5m " $13\
                            "\ncust." host_name ".system.lavg.15m " $14\
                            "\ncust." host_name ".system.mem.used " $15\
                            "\ncust." host_name ".system.net.recv " $19\
                            "\ncust." host_name ".system.net.send " $20\
                            "\ncust." host_name ".system.proc.run " $21\
                            "\ncust." host_name ".system.proc.block " $22\
                            "\ncust." host_name ".system.proc.new " $23\
                            "\ncust." host_name ".system.io.read " $24\
                            "\ncust." host_name ".system.io.write " $25\
                            "\ncust." host_name ".system.swap.used " $26\
                            "\ncust." host_name ".system.swap.free " $27\
                            "\ncust." host_name ".system.sys.int " $28\
                            "\ncust." host_name ".system.sys.csw " $29\
                            "\ncust." host_name ".system.tcp.listen " $30\
                            "\ncust." host_name ".system.tcp.active " $31\
                            "\ncust." host_name ".system.tcp.closed " $34\
                        }'

