#!/bin/bash
cd /home/ubuntu/openair-cn/scripts
PREFIX='/usr/local/etc/oai-vepc/spgw1'
echo "SGI_NEXT_HOPE: ${SGI_NEXT_HOPE}"
nohup ./run_spgw --config-file $PREFIX/spgw.conf --sgi-nh ${SGI_NEXT_HOPE} --set-virt-if > spgw.out 2> spgw.err &
