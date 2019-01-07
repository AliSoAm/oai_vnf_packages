#!/bin/bash
apt-get install bc
sudo ifconfig ens4 ${S6a}/24
sudo ifconfig ens5 ${ut}/24
sudo ifconfig ens6 ${S11}/24
sudo ifconfig ens7 ${S10}/24
