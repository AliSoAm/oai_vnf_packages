#!/bin/bash
PREFIX='/usr/local/etc/oai-vepc/spgw1'
cd /home/ubuntu/openair-cn/scripts
nohup ./run_spgw --config-file $PREFIX/spgw.conf --sgi-mac-nh 52:54:00:66:21:e2 --set-virt-if &
