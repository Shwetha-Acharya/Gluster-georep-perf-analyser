#!/bin/bash

sync_start_time=$1

sync_start_epochtime=`date "+%s" -d "$sync_start_time"`

completion_time=`grep "completion_time" /var/log/glusterfs/geo-replication/primary/*secondary.log | tail -1 | cut -f3 -d$'\t' | cut -f2 -d=`
completion_epochtime=`date "+%s" -d "$completion_time"`

duration=`expr $completion_epochtime - $sync_start_epochtime`

echo Time elapsed for sync = $duration seconds
