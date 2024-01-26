#!/bin/bash
set -x
source env.sh

#echo ${HAPROXY_IP}

# If this is the first run, the persistent dirs should be created
if [ ! -d "${OC_PERSISTENCE}" ]; then
  echo "Creating volumes..."
  sudo mkdir ${CONTROLLER2_CACHES}
  sudo mkdir ${CONTROLLER1_CACHES}
  sudo mkdir ${CONTROLLER_PERSISTENCE}
  sudo mkdir ${OC_PERSISTENCE}
  sudo mkdir ${AGENT_PERSISTENCE}
  sudo chown -R 1000:1000 ${CONTROLLER2_CACHES}
  sudo chown -R 1000:1000 ${CONTROLLER1_CACHES}
  sudo chown -R 1000:1000 ${CONTROLLER_PERSISTENCE}
  sudo chown -R 1000:1000 ${OC_PERSISTENCE}
  sudo chown -R 1000:1000 ${AGENT_PERSISTENCE}
  sudo chmod 700 ${CONTROLLER2_CACHES}
  sudo chmod 700 ${CONTROLLER1_CACHES}
  sudo chmod 700 ${CONTROLLER_PERSISTENCE}
  sudo chmod 700 ${OC_PERSISTENCE}
  sudo chmod 700 ${AGENT_PERSISTENCE}
fi

echo Using Docker host IP: ${DOCKER_HOST_IP}
echo "###"

envsubst < docker-compose.yaml.template > docker-compose.yaml

docker compose up #-d

