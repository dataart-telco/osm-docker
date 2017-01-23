#!/bin/bash

source ~/nova.rc

set -x

if [ -z "$OS_AUTH_URL" ]; then
  echo "ERROR: No openstack info"
  exit 1
fi

echo -e "\nConfiguring osm env"

get_container_ip(){
  container=$1
  echo `docker inspect $container | python -c "import sys, json; print json.load(sys.stdin)[0]['NetworkSettings']['Networks']['osmdocker_default']['IPAddress']"`
}

JUJU_PASSWD=`docker exec osm-vca juju show-controller osm --show-password | grep password | awk '{print $2}'`
if [ -z "$JUJU_PASSWD" ]; then
  echo "ERROR: Can't find juju password"
  exit 1
fi

JUJU_CONTROLLER_IP=`docker exec osm-vca juju show-controller osm | grep api-endpoint | awk '{print $2}'`
#cut ip address from: ['10.44.127.68:17070']
JUJU_CONTROLLER_IP=`echo ${JUJU_CONTROLLER_IP:2:-2} | cut -d : -f1`

SO_CONTAINER_IP=`get_container_ip osm-so-ui`
RO_CONTAINER_IP=`get_container_ip osm-ro`

echo "+++++++++++++++++++++++++++++++++++"
echo "IP SET:"
echo "SO_CONTAINER_IP=$SO_CONTAINER_IP"
echo "RO_CONTAINER_IP=$RO_CONTAINER_IP"
echo "JUJU_CONTROLLER_IP=$JUJU_CONTROLLER_IP"
echo "JUJU_PASSWD=$JUJU_PASSWD"
echo "+++++++++++++++++++++++++++++++++++"

#remove data from RO
echo -e "Clean openmano"
docker exec --env OPENMANO_TENANT=osm osm-ro openmano datacenter-detach openstack
docker exec --env OPENMANO_TENANT=osm osm-ro openmano datacenter-delete -f openstack
docker exec osm-ro openmano tenant-delete -f osm

#add tenant
RO_TENANT_ID=`docker exec osm-ro openmano tenant-create osm |awk '{print $1}'`
echo "Tenant ID: $RO_TENANT_ID"

#add openstack as datacenter
echo -e "Add openstack to openmano"
docker exec --env OPENMANO_TENANT=osm osm-ro openmano datacenter-create --type openstack --description "OpenStack Datacenter" --config='{use_floating_ip: true}' openstack $OS_AUTH_URL 
docker exec --env OPENMANO_TENANT=osm osm-ro openmano datacenter-attach openstack --user=$OS_USERNAME --password=$OS_PASSWORD --vim-tenant-name=$OS_TENANT_NAME
docker exec --env OPENMANO_TENANT=osm osm-ro openmano datacenter-list
docker exec --env OPENMANO_TENANT=osm --env OPENMANO_DATACENTER=openstack osm-ro openmano datacenter-netmap-import --force

#configure SO: add openmano and juju
echo -e "\nDelete config account"

curl -k --request DELETE \
  --url https://$SO_CONTAINER_IP:8008/api/config/config-agent/account \
  --header 'accept: application/vnd.yang.data+json' \
  --header 'authorization: Basic YWRtaW46YWRtaW4=' \
  --header 'cache-control: no-cache' \
  --header 'content-type: application/vnd.yang.data+json'

echo -e "\nAdd config account"

curl -k --request POST \
  --url https://$SO_CONTAINER_IP:8008/api/config/config-agent \
  --header 'accept: application/vnd.yang.data+json' \
  --header 'authorization: Basic YWRtaW46YWRtaW4=' \
  --header 'cache-control: no-cache' \
  --header 'content-type: application/vnd.yang.data+json' \
  --data '{"account": [ { "name": "osmjuju", "account-type": "juju", "juju": { "ip-address": "'$JUJU_CONTROLLER_IP'", "port": "17070", "user": "admin", "secret": "'$JUJU_PASSWD'" }  }  ]}'

echo -e "\nUpdate RO config"

curl -k --request PUT \
  --url https://$SO_CONTAINER_IP:8008/api/config/resource-orchestrator \
  --header 'accept: application/vnd.yang.data+json' \
  --header 'authorization: Basic YWRtaW46YWRtaW4=' \
  --header 'cache-control: no-cache' \
  --header 'content-type: application/vnd.yang.data+json' \
  --data '{ "openmano": { "host": "'$RO_CONTAINER_IP'", "port": "9090", "tenant-id": "'$RO_TENANT_ID'" }, "name": "osmopenmano", "account-type": "openmano" }'