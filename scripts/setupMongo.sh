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

echo "Deploying Mongo Helm chart ..."
helm install --name $MONGODB_RELEASE_NAME --set mongodbPassword="$MONGODB_PASSWORD" -f ../mongodb/custom-values.yaml stable/mongodb

if [ $? -eq 0 ]; then
   echo "Creating Kubernetes secret for stocktrader to access Mongo ..."
   kubectl create secret generic mongodb-access --from-literal=id=$MONGODB_USER --from-literal=pwd=$MONGODB_PASSWORD --from-literal=host=$MONGODB_SERVICE_NAME --from-literal=port=$MONGODB_PORT --from-literal=db=$MONGODB_DATABASE -n ${STOCKTRADER_NAMESPACE}
   if [ $? -eq 0 ]; then
      echo "Mongo setup completed successfully"
   else
      echo "Error creating k8s secret for stocktrader to access Mongo"
   fi
else
  echo "Helm error - exiting script"
fi
