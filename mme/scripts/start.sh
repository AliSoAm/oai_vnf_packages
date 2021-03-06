#!/bin/bash
source /opt/openbaton/scripts/ob_parameters.sh
cd /home/ubuntu/openair-cn/scripts
INSTANCE=1
PREFIX='/usr/local/etc/oai-vepc/mme1'
sudo mkdir -m 777 -p $PREFIX
sudo mkdir -m 777    $PREFIX/freeDiameter

# freeDiameter configuration file
cp ../etc/mme_fd.sprint.conf  $PREFIX/freeDiameter/mme_fd.conf

cp ../etc/mme.conf  $PREFIX

declare -A MME_CONF
MME_CONF[@MME_S6A_IP_ADDR@]="${S6a}"
MME_CONF[@INSTANCE@]=$INSTANCE
MME_CONF[@PREFIX@]=$PREFIX
MME_CONF[@REALM@]="${REALM}"
MME_CONF[@PID_DIRECTORY@]='/var/run'
MME_CONF[@MME_FQDN@]="${MME_HOSTNAME}.${MME_CONF[@REALM@]}"
MME_CONF[@HSS_HOSTNAME@]="${HSS_HOSTNAME}"
MME_CONF[@HSS_FQDN@]="${MME_CONF[@HSS_HOSTNAME@]}.${MME_CONF[@REALM@]}"
MME_CONF[@HSS_IP_ADDR@]="${OB_oai_hss_VNFC_S6a}"
MME_CONF[@MCC@]="${MCC}"
MME_CONF[@MNC@]="${MNC}"
MME_CONF[@MME_GID@]="${MME_GID}"
MME_CONF[@MME_CODE@]="${MME_CODE}"
MME_CONF[@TAC_0@]='600'
MME_CONF[@TAC_1@]='601'
MME_CONF[@TAC_2@]='602'
MME_CONF[@MME_INTERFACE_NAME_FOR_S1_MME@]='ens5'
MME_CONF[@MME_IPV4_ADDRESS_FOR_S1_MME@]="${UT}/24"
MME_CONF[@MME_INTERFACE_NAME_FOR_S11@]='ens6'
MME_CONF[@MME_IPV4_ADDRESS_FOR_S11@]="${S11}/24"
MME_CONF[@MME_INTERFACE_NAME_FOR_S10@]='ens7'
MME_CONF[@MME_IPV4_ADDRESS_FOR_S10@]="${S10}/24"
MME_CONF[@OUTPUT@]="${OUTPUT}"
MME_CONF[@SGW_IPV4_ADDRESS_FOR_S11_TEST_0@]="${OB_oai_spgw_VNFC_S11}/24"
MME_CONF[@SGW_IPV4_ADDRESS_FOR_S11_0@]="${OB_oai_spgw_VNFC_S11}/24"
MME_CONF[@PEER_MME_IPV4_ADDRESS_FOR_S10_0@]='0.0.0.0/24'
MME_CONF[@PEER_MME_IPV4_ADDRESS_FOR_S10_1@]='0.0.0.0/24'

#implicit MCC MNC 001 01
TAC_SGW_TEST='7'
tmph=`echo "$TAC_SGW_TEST / 256" | bc`
tmpl=`echo "$TAC_SGW_TEST % 256" | bc`
MME_CONF[@TAC-LB_SGW_TEST_0@]=`printf "%02x\n" $tmpl`
MME_CONF[@TAC-HB_SGW_TEST_0@]=`printf "%02x\n" $tmph`

MME_CONF[@MCC_SGW_0@]=${MME_CONF[@MCC@]}
MME_CONF[@MNC3_SGW_0@]=`printf "%03d\n" $(echo ${MME_CONF[@MNC@]} | sed 's/^0*//')`
TAC_SGW_0='600'
tmph=`echo "$TAC_SGW_0 / 256" | bc`
tmpl=`echo "$TAC_SGW_0 % 256" | bc`
MME_CONF[@TAC-LB_SGW_0@]=`printf "%02x\n" $tmpl`
MME_CONF[@TAC-HB_SGW_0@]=`printf "%02x\n" $tmph`

MME_CONF[@MCC_MME_0@]=${MME_CONF[@MCC@]}
MME_CONF[@MNC3_MME_0@]=`printf "%03d\n" $(echo ${MME_CONF[@MNC@]} | sed 's/^0*//')`
TAC_MME_0='601'
tmph=`echo "$TAC_MME_0 / 256" | bc`
tmpl=`echo "$TAC_MME_0 % 256" | bc`
MME_CONF[@TAC-LB_MME_0@]=`printf "%02x\n" $tmpl`
MME_CONF[@TAC-HB_MME_0@]=`printf "%02x\n" $tmph`

MME_CONF[@MCC_MME_1@]=${MME_CONF[@MCC@]}
MME_CONF[@MNC3_MME_1@]=`printf "%03d\n" $(echo ${MME_CONF[@MNC@]} | sed 's/^0*//')`
TAC_MME_1='602'
tmph=`echo "$TAC_MME_1 / 256" | bc`
tmpl=`echo "$TAC_MME_1 % 256" | bc`
MME_CONF[@TAC-LB_MME_1@]=`printf "%02x\n" $tmpl`
MME_CONF[@TAC-HB_MME_1@]=`printf "%02x\n" $tmph`


for K in "${!MME_CONF[@]}"; do
  egrep -lRZ "$K" $PREFIX | xargs -0 -l sed -i -e "s|$K|${MME_CONF[$K]}|g"
  ret=$?;[[ ret -ne 0 ]] && echo "Tried to replace $K with ${MME_CONF[$K]}"
done

# freeDiameter certificate
sudo ./check_mme_s6a_certificate $PREFIX/freeDiameter mme.${MME_CONF[@REALM@]}
nohup ./run_mme --config-file $PREFIX/mme.conf --set-virt-if > mme.out 2> mme.err &
