#!/bin/bash

#########################################################################################
# Pass the three ip addressed as arguments to primary.sh where first ip is of the system
# where this script (primary.sh) is executed. Fourth argument is the client ip where
# you want to mount the primary volume.
# By default geo-rep perf test uses replica 3 arbiter 1 setup.
#########################################################################################

ip1=$1
ip2=$2
ip3=$3
client_ip=$4 


gluster peer probe $ip2
gluster peer probe $ip3

gluster volume create primary  replica 3 arbiter 1 $ip1:/brick1 $ip2:/brick2 $ip3:/brick3 force

gluster volume start primary

gluster volume status primary

#mount primary
ssh $client_ip mount_primary.sh $ip1
