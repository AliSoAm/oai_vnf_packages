#!/bin/bash
cd /home/ubuntu/openair-cn/scripts
INSTANCE=1
PREFIX='/usr/local/etc/oai-vepc/spgw1'
sudo mkdir -m 777 -p $PREFIX
cp ../etc/spgw.conf  $PREFIX
echo "Output: ${OUTPUT}"
echo "address: ${SGI_ADDRESS} dns1: ${DNS1}  dns2: ${DNS2}"
echo "IP-> S11: ${S11} - S1u: ${UT} - SGi: ${SGi}"
declare -A SPGW_CONF
SPGW_CONF[@PID_DIRECTORY@]='/var/run'
SPGW_CONF[@SGW_INTERFACE_NAME_FOR_S11@]="ens4"
SPGW_CONF[@SGW_IPV4_ADDRESS_FOR_S11@]="${S11}/24"
SPGW_CONF[@SGW_INTERFACE_NAME_FOR_S1U_S12_S4_UP@]="ens5"
SPGW_CONF[@SGW_IPV4_ADDRESS_FOR_S1U_S12_S4_UP@]="${UT}/24"
SPGW_CONF[@SGW_UDP_PORT_FOR_S1U_S12_S4_UP@]=2152
SPGW_CONF[@OUTPUT@]="${OUTPUT}"
SPGW_CONF[@INSTANCE@]=$INSTANCE
SPGW_CONF[@PID_DIRECTORY@]='/var/run'
SPGW_CONF[@PGW_INTERFACE_NAME_FOR_SGI@]="ens6"
SPGW_CONF[@PGW_IPV4_ADDRESS_FOR_SGI@]="${SGi}/24"
SPGW_CONF[@ARP_UE@]="oai"
SPGW_CONF[@DEFAULT_DNS_IPV4_ADDRESS@]="${DNS1}"
SPGW_CONF[@DEFAULT_DNS_SEC_IPV4_ADDRESS@]="${DNS2}"
SPGW_CONF[@GTPV1U_REALIZATION@]="GTP_KERNEL_MODULE"

for K in "${!SPGW_CONF[@]}"; do
  egrep -lRZ "$K" $PREFIX | xargs -0 -l sed -i -e "s|$K|${SPGW_CONF[$K]}|g"
done

sed -i "s|12.1.1.2 - 12.1.1.224|${SGI_ADDRESS}|g" ${PREFIX}/spgw.conf
