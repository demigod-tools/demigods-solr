#!/bin/bash

STATUS=`curl -sf http://localhost:8983/solr/${PROJECT_NAME}/admin/ping?wt=json | jq -r .status`

# try to create a collection if it doesn't already exist
if [[ "${STATUS}" != "OK" ]]; then
  solr create_collection -c ${PROJECT_NAME} -d /opt/search_api_solr/jump-start/solr8/cloud-config-set
  STATUS=`curl -sf http://localhost:8983/solr/${PROJECT_NAME}/admin/ping?wt=json | jq -r .status`
fi

if [[ "${STATUS}" != "OK" ]]; then
  exit 1
fi

exit 0
