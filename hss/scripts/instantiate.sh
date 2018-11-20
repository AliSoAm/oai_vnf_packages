#!/bin/bash
while ! cqlsh -e 'describe cluster'; do
  sleep 1
done
Cassandra_Server_IP='127.0.0.1'
cd /home/ubuntu/openair-cn/scripts
cqlsh --file ../src/hss_rel14/db/oai_db.cql $Cassandra_Server_IP
./data_provisioning_users --apn default --apn2 internet --key fec86ba6eb707ed08905757b1bb44b8f --imsi-first 001011234561000 --msisdn-first 001011234561000 --mme-identity mme.ng4T.com --no-of-users 20 --realm ng4T.com --truncate True  --verbose True --cassandra-cluster $Cassandra_Server_IP
./data_provisioning_mme --id 3 --mme-identity mme.ng4T.com --realm ng4T.com --ue-reachability 1 --truncate True  --verbose True
