#!/bin/sh

HOST="$1"

[ ! -f /tmp/testfile.out ] && dd if=/dev/zero of=/tmp/testfile.out bs=1024 count=5000
[ ! -d /shared/testcreate ] && mkdir /shared/testcreate

_utime="$( TIMEFORMAT='%3R';time ( yes | cp -f /tmp/testfile.out /shared/testcreate/testfile.out ) 2>&1 1>/dev/null )"
echo "cust.$HOST.custom.netapp.copytest `echo "$_utime * 1000" | bc`"

