#!/bin/bash
docker run -d \
  --net=host \
  --name=metricbeat \
  --user=root \
  --volume="/var/run/docker.sock:/var/run/docker.sock:ro" \
  --volume="/sys/fs/cgroup:/hostfs/sys/fs/cgroup:ro" \
  --volume="/proc:/hostfs/proc:ro" \
  --volume="/:/hostfs:ro" \
  docker.elastic.co/beats/metricbeat:6.5.4 metricbeat -e \
  -E output.elasticsearch.hosts=["${ELASTICSEARCH_HOST}"] \
  -E core_id=$CORE_ID -E vnf_type="mme"
