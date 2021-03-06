#!/bin/bash
PREFIX='/usr/local/etc/oai-vepc/hss14'
cd /home/ubuntu/openair-cn/scripts

while ! cqlsh -e 'describe cluster'; do
  sleep 1
done
Cassandra_Server_IP='127.0.0.1'
cqlsh --file ../src/hss_rel14/db/oai_db.cql $Cassandra_Server_IP

./data_provisioning_users --apn default --apn2 internet --key fec86ba6eb707ed08905757b1bb44b8f --imsi-first 262791234561000 --msisdn-first 2627912345000 --mme-identity mme.ng4T.com --no-of-users 50 --realm ng4T.com --truncate True  --verbose True --cassandra-cluster $Cassandra_Server_IP

./data_provisioning_mme --id 3 --mme-identity mme.ng4T.com --realm ng4T.com --ue-reachability 1 --truncate True  --verbose True

./data_provisioning_users --apn default --apn2 internet --key fec86ba6eb707ed08905757b1bb44b8f --imsi-first 262801234561000 --msisdn-first 2628012345000 --mme-identity mme2.ng4T.com --no-of-users 50 --realm ng4T.com --truncate False  --verbose True --cassandra-cluster $Cassandra_Server_IP

./data_provisioning_mme --id 4 --mme-identity mme2.ng4T.com --realm ng4T.com --ue-reachability 1 --truncate False  --verbose True

sudo mkdir -m 777 -p $PREFIX
sudo mkdir -m 777    $PREFIX/freeDiameter

# freeDiameter configuration files
cp ../etc/acl.conf ../etc/hss_rel14_fd.conf $PREFIX/freeDiameter
cp ../etc/hss_rel14.conf ../etc/hss_rel14.json $PREFIX

declare -A HSS_CONF
HSS_CONF[@PREFIX@]=$PREFIX
HSS_CONF[@REALM@]='ng4T.com'
HSS_CONF[@HSS_FQDN@]="hss.${HSS_CONF[@REALM@]}"
HSS_CONF[@cassandra_Server_IP@]=$Cassandra_Server_IP
HSS_CONF[@OP_KEY@]='1006020f0a478bf6b699f15c062e42b3'
HSS_CONF[@ROAMING_ALLOWED@]='true'

for K in "${!HSS_CONF[@]}"; do
  egrep -lRZ "$K" $PREFIX | xargs -0 -l sed -i -e "s|$K|${HSS_CONF[$K]}|g"
done

### freeDiameter certificate
../src/hss_rel14/bin/make_certs.sh hss ${HSS_CONF[@REALM@]} $PREFIX

# Finally customize the listen address of FD server
# set in $PREFIX/freeDiameter/hss_rel14_fd.conf and uncomment the following line
#ListenOn = "172.66.1.113";
echo "IP S6a: ${S6a}"
sed -i "s|\#ListenOn = \"127.0.0.1\";|ListenOn = \"${S6a}\";|g" ${PREFIX}/freeDiameter/hss_rel14_fd.conf

oai_hss -j $PREFIX/hss_rel14.json --onlyloadkey
