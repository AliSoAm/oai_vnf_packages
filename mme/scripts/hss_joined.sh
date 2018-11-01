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
MME_CONF[@REALM@]='ng4T.com'

MME_CONF[@HSS_HOSTNAME@]='hss'
MME_CONF[@HSS_FQDN@]="${MME_CONF[@HSS_HOSTNAME@]}.${MME_CONF[@REALM@]}"
MME_CONF[@HSS_IP_ADDR@]='${hss_S6a}'
for K in "${!MME_CONF[@]}"; do
  egrep -lRZ "$K" $PREFIX | xargs -0 -l sed -i -e "s|$K|${MME_CONF[$K]}|g"
  ret=$?;[[ ret -ne 0 ]] && echo "Tried to replace $K with ${MME_CONF[$K]}"
done
