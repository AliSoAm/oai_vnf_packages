#!/bin/bash
cd /home/ubuntu/openair-cn/scripts
PREFIX='/usr/local/etc/oai-vepc/hss14'
nohup oai_hss -j $PREFIX/hss_rel14.json > hss.out 2> hss.err &
