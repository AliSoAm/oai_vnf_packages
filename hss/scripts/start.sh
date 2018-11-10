#!/bin/bash
PREFIX='/usr/local/etc/oai-vepc/hss14'
cd /home/ubuntu/openair-cn/scripts
nohup oai_hss -j $PREFIX/hss_rel14.json &
