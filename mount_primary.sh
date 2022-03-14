#!/bin/bash

mkdir -p /primary_mnt1
mount -t glusterfs $1:/primary /primary_mnt1
