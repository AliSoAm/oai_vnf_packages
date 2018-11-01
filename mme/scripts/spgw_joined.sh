# prompt has been removed for easier Ctrl+C Ctrl+V
# cd $OPENAIRCN_DIR/scripts
# S6a
cd /home/ubuntu/openair-cn/scripts
#sudo ifconfig ens9:11 172.66.1.111 up
INSTANCE=1
PREFIX='/usr/local/etc/oai-vepc/mme1'
sudo mkdir -m 777 -p $PREFIX
sudo mkdir -m 777    $PREFIX/freeDiameter

# freeDiameter configuration file
cp ../etc/mme_fd.sprint.conf  $PREFIX/freeDiameter/mme_fd.conf

cp ../etc/mme.conf  $PREFIX

declare -A MME_CONF

MME_CONF[@SGW_IPV4_ADDRESS_FOR_S11_TEST_0@]='${spgw_S11}/24'
MME_CONF[@SGW_IPV4_ADDRESS_FOR_S11_0@]='${spgw_S11}/24'

for K in "${!MME_CONF[@]}"; do
  egrep -lRZ "$K" $PREFIX | xargs -0 -l sed -i -e "s|$K|${MME_CONF[$K]}|g"
  ret=$?;[[ ret -ne 0 ]] && echo "Tried to replace $K with ${MME_CONF[$K]}"
done

# freeDiameter certificate
sudo ./check_mme_s6a_certificate $PREFIX/freeDiameter mme.${MME_CONF[@REALM@]}
