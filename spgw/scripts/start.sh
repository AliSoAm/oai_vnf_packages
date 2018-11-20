#!/bin/bash
cd /home/ubuntu/openair-cn/scripts
INSTANCE=1
PREFIX='/usr/local/etc/oai-vepc/spgw1'
sudo mkdir -m 777 -p $PREFIX
cp ../etc/spgw.conf  $PREFIX
echo "IP S11: ${S11} - S11: ${S1U} - SGi: ${SGi}"
declare -A SPGW_CONF
SPGW_CONF[@PID_DIRECTORY@]='/var/run'
SPGW_CONF[@SGW_INTERFACE_NAME_FOR_S11@]="ens4"
SPGW_CONF[@SGW_IPV4_ADDRESS_FOR_S11@]="${S11}/24"
SPGW_CONF[@SGW_INTERFACE_NAME_FOR_S1U_S12_S4_UP@]="ens5"
SPGW_CONF[@SGW_IPV4_ADDRESS_FOR_S1U_S12_S4_UP@]="${S1U}/24"
SPGW_CONF[@SGW_UDP_PORT_FOR_S1U_S12_S4_UP@]=2152
SPGW_CONF[@OUTPUT@]="CONSOLE"
SPGW_CONF[@INSTANCE@]=$INSTANCE
SPGW_CONF[@PID_DIRECTORY@]='/var/run'
SPGW_CONF[@PGW_INTERFACE_NAME_FOR_SGI@]="ens6"
SPGW_CONF[@PGW_IPV4_ADDRESS_FOR_SGI@]="${SGi}/24"
SPGW_CONF[@ARP_UE@]="oai"
SPGW_CONF[@DEFAULT_DNS_IPV4_ADDRESS@]="192.168.122.1"
SPGW_CONF[@DEFAULT_DNS_SEC_IPV4_ADDRESS@]="192.168.122.1"
SPGW_CONF[@GTPV1U_REALIZATION@]="GTP_KERNEL_MODULE"

for K in "${!SPGW_CONF[@]}"; do
  egrep -lRZ "$K" $PREFIX | xargs -0 -l sed -i -e "s|$K|${SPGW_CONF[$K]}|g"
done

nohup ./run_spgw --config-file $PREFIX/spgw.conf --sgi-mac-nh 52:54:00:66:21:e2 --set-virt-if > spgw.out 2> spgw.err &
