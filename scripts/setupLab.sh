#!/bin/bash
if test "$0" = "./setupLab.sh"
then
   echo "Script being run from correct folder"
else
   echo "Error: Must be run from folder where this script resides"
   exit 1
fi

usage () {
  echo "Usage:
  echo "setupLab.sh URL_TO_SETUP_FILES  (if env var USERNAME is set)"
  echo "or"
  echo "setupLab.sh URL_TO_SETUP_FILES [CLUSTER_NAME] (if env var USERNAME  is set)"
  echo "or"
  echo "setupLab.sh URL_TO_SETUP_FILES [CLUSTER_NAME] [KAFKA_TOPIC_NAME]"
}

if [ -z "$1" ]
then
    usage
    exit 1
fi


if [ -z "$2" ]
then
    if [ -z "$USERNAME" ]
    then
       echo "Error: USERNAME env var not set and CLUSTER_NAME not supplied"
       usage
       exit 1
    else
       CLUSTER_NAME=$USERNAME-cluster
    fi
else
    CLUSTER_NAME=$2
fi

if [ -z "$3" ]
then
  if [ -z "$USERNAME" ]
  then
     echo "Error: USERNAME env var not set and KAFKA_TOPIC_NAME not supplied"
     usage
     exit 1
  else
     KAFKA_TOPIC=stocktrader-$USERNAME
  fi
else
    KAFKA_TOPIC=$3
fi

echo "Using $CLUSTER_NAME as IKS cluster name ..."
regex='(https?)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
if [[ ! $1 =~ $regex ]]; then
   echo "Error: Argument is not a valid URL"
   exit 1
fi

http_code=`curl -o variables.sh -s -L -w "%{http_code}" $1 `
if [ $? -ne 0 ]
then
    echo "Error: Retrieving setup files. Check the URL and try again"
    exit 1
fi

if test  "$http_code" != "200"
then
  echo "Error: Retrieving setup files. HTTP code $http_code returned"
  exit 1
else
  chmod +x variables.sh
fi

echo "Getting Ingress subdomain for cluster $CLUSTER_NAME  ..."
#ibmcloud ks cluster-get --cluster $CLUSTER_NAME > tmp.out

ingress_subdomain=`ibmcloud ks cluster-get --cluster $CLUSTER_NAME | grep "Ingress Subdomain:" | awk '{print $3}'`

if [ $? -ne 0 ]
then
    echo "Error: Retrieving ingress subdomain.  Redo cluster access setup and try again"
    #rm tmp.out
    exit 1
fi

#ingress_subdomain=`cat tmp.out | grep "Ingress Subdomain:" | awk '{print $3}' `
#rm tmp.out

echo "Updating Helm chart with ingress subdomain: $ingress_subdomain"
sed -i"_x" "s/changeme/$ingress_subdomain/g" ../stocktrader/values.yaml && rm ../stocktrader/values.yaml_x

echo "Updating variables.sh with Kafka topic : $KAFKA_TOPIC"
sed -i"_x" "s/changeme/$KAFKA_TOPIC/g" variables.sh && rm variables.sh_x

echo "Setup completed successfully"
exit 0
