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

echo "Deploying MariaDB Helm chart ..."
#helm install --name $MARIADB_RELEASE_NAME --set db.password="$MARIADB_PASSWORD" -f ../mariadb/custom-values.yaml stable/mariadb
helm install --name $MARIADB_RELEASE_NAME --set db.password="$MARIADB_PASSWORD"   -f ../mariadb/custom-values.yaml  ../mariadb
if [ $? -eq 0 ]; then
   echo "Creating Kubernetes secret for stocktrader to access MariaDB ..."
   kubectl create secret generic mariadb-access --from-literal=id=$MARIADB_USER --from-literal=pwd=$MARIADB_PASSWORD --from-literal=host=$MARIADB_SERVICE_NAME --from-literal=port=$MARIADB_PORT --from-literal=db=$STOCKTRADER_DB -n ${STOCKTRADER_NAMESPACE}
   if [ $? -eq 0 ]; then
      echo "MariaDB setup completed successfully"
   else
      echo "Error creating k8s secret for stocktrader to access MariaDB"
   fi
else
  echo "Helm error - exiting script"
fi
