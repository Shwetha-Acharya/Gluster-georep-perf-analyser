#!/bin/bash

###############################################################################
#How to run:
##bash performance_trigger.sh <workload type> <secondary_ip> <primary_client_ip>
#
#- workload can be either large, small or rename
#- secondary_ip is the secondary ip used during geo-rep setup
#- primary_client ip is the ip where pimary is mounted
###############################################################################

if [ $# -eq 0 ]; then
    echo "Provide an argument to specify the workload. Argument value can be 'small' for small file workload,'large' for large file workload or 'rename' for rename workload."
    exit 1
fi

gluster volume geo-replication primary $secondary_ip::secondary status

workload=$1
secondary_ip=$2
primary_client_ip=$3

test_performance () {
  
        sync_start_time=$1
	echo "**setting checkpoint as the workload entry is complete**"
	gluster volume geo-replication primary $secondary_ip::secondary config checkpoint now

	echo "**waiting for checkpoint to be met**"
	tail -f /var/log/glusterfs/geo-replication/primary/*secondary.log | while read LINE
	do
   	[[ "${LINE}" == *"completion_time"* ]] && pkill -P $$ tail
	done

	echo "**measuring the performance in seconds**"
	bash geo-performance.sh $sync_start_time

	echo "**unsetting the checkpoint**"
	gluster volume geo-replication primary $secodary_ip::secondary config \!checkpoint
}

echo "**triggering the workload script**"

if [[ $workload == "small" ]]
then 
	echo "SMALL FILE WORKLOAD"
	sync_start_time=`ssh $primary_client_ip bash small_workload.sh`
	test_performance $sync_start_time

elif [[ $workload == "large" ]]
then
	echo "LARGE FILE WORKLOAD"
	sync_start_time=`ssh $primary_client_ip bash large_workload.sh`
	test_performance $sync_start_time
elif [[ $workload == "rename" ]]
then
	echo "RENAME WORKLOAD"
	sync_start_time=`ssh $primary_client_ip bash rename_workload.sh`
	test_performance $sync_start_time
else
	echo "wrong workload type"
        exit 1
fi
