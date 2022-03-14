#!/bin/bash

mkdir /secondary_mnt
mount -t glusterfs $1:/secondary /secondary_mnt
