#!/bin/sh

HOST=`grep APPSERVER_DOMAIN /opt/collabnet/teamforge/runtime/conf/runtime-options.conf | awk -F= '{print $2}' | sed 's/\./_/g'`
SCRIPT_LOC="/var/ops/monitor/"
SNIPS_LOC="${SCRIPT_LOC}/script-snips/"

for i in `ls ${SNIPS_LOC}`
do
#echo $i
pushd ${SNIPS_LOC} > /dev/null
${SNIPS_LOC}/$i $HOST
popd > /dev/null
done

