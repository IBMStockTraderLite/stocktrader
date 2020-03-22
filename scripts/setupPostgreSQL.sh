#!/bin/bash
# Copyright [2018] IBM Corp. All Rights Reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

source variables.sh

echo "Deploying PostgreSQL Helm chart ..."
helm install $POSTGRESQL_RELEASE_NAME --set service.port="$POSTGRESQL_PORT" \
                    --set postgresqlDatabase="$POSTGRESQL_DATABASE"   \
                    --set postgresqlUsername="$POSTGRESQL_USER" \
                    --set postgresqlPassword="$POSTGRESQL_PASSWORD" \
                    -f ../postgresql/custom-values.yaml bitnami/postgresql

if [ $? -eq 0 ]; then
   echo "Creating Kubernetes secret for stocktrader to access PostgreSQL ..."
   kubectl create secret generic postgresql-access --from-literal=id=$POSTGRESQL_USER --from-literal=pwd=$POSTGRESQL_PASSWORD --from-literal=host=$POSTGRESQL_SERVICE_NAME --from-literal=port=$POSTGRESQL_PORT --from-literal=db=$POSTGRESQL_DATABASE -n ${STOCKTRADER_NAMESPACE}
   if [ $? -eq 0 ]; then
      echo "PostgreSQL setup completed successfully"
   else
      echo "Error creating k8s secret for stocktrader to access PostgreSQL"
   fi
else
  echo "Helm error - exiting script"
fi
