#!/bin/bash

############################################################################
#How to run:
# geo-rep_cleanup.sh <secondary_ip1> <secondary_ip2> <secondary_ip3> <primary_ip2>
# <primary_ip3> <primary_client_ip> <secondary_client_ip>
#
# primary_ip1 is not taken this script is to executed on the machine with primary_ip1
############################################################################
<
echo cleaning up geo-rep setup
yes | gluster volume geo-replication primary $secondary_ip1::secondary stop
yes | gluster volume geo-replication primary $secondary_ip1::secondary delete reset-sync-time


echo cleaning up mount points
ssh $primary_client_ip umount -l /primary_mnt1
ssh $primary_client_ip rm -rf /primary_mnt1
ssh $secondary_client_ip umount -l /secondary_mnt
ssh $secondary_client_ip rm -rf /secondary_mnt

echo cleanup primary volume and bricks
yes | gluster volume stop primary
yes | gluster volume delete primary
rm -rf /brick1
ssh $primary_ip2 rm -rf /brick2
ssh $primary_ip3 -rf /brick3

echo cleaning up secondary volume and bricks
yes | ssh $secondary_ip1 gluster volume stop secondary
yes | ssh $secodary_ip2 gluster volume delete secondary
yes | ssh $secondary_ip1 rm -rf /brick*
yes | ssh $secondary_ip2 rm -rf /brick*
yes | ssh $secondary_ip3 rm -rf /brick*
