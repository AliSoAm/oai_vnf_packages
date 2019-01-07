#!/bin/bash
cd /home/ubuntu/openair-cn/scripts
PREFIX='/usr/local/etc/oai-vepc/spgw1'
nohup ./run_spgw --config-file $PREFIX/spgw.conf --sgi-mac-nh e8:39:35:b8:95:80 --set-virt-if > spgw.out 2> spgw.err &
