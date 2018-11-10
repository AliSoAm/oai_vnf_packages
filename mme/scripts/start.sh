#!/bin/bash
PREFIX='/usr/local/etc/oai-vepc/mme1'
cd /home/ubuntu/openair-cn/scripts
nohup ./run_mme --config-file $PREFIX/mme.conf --set-virt-if &
