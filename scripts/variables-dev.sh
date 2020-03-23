# Variables used by configuration shell scripts. Note this is designed for a multiuser ICP setup where the Linux user is
# the same as the ICP user and  the form user07 and the default ICP namespace for that user is devnamespace07.
# If your setup is different hardcode the namespace and chart names to appropriate values

#######################
#  GENERAL VARIABLES  #
#######################

# Kubernetes namespace where the stocktrader application is or will be installed.
# Hardcode to match your ICP installation
STOCKTRADER_NAMESPACE="default"

###############################
#  MARIADB-RELATED VARIABLES  #
###############################

# MARIADB Helm chart name
MARIADB_CHART="mariadb"

# MARIADB Helm release name.  Set this if the MARIADB chart is installed multiple times to indicate which one to use.  Otherwise leave it blank.
MARIADB_RELEASE_NAME="stocktrader-db"

# MARIADB Service name
MARIADB_SERVICE_NAME="$MARIADB_RELEASE_NAME-$MARIADB_CHART"

# MARIADB user
MARIADB_USER="traderuser"

# MARIADB password.  The setup script attempts to find this value so set this only if the script is unable to do so.
MARIADB_PASSWORD="n0tthem0stSecure"

# MARIADB port number
MARIADB_PORT=3306

# Database name that you created for the stocktrader application
STOCKTRADER_DB="trader"

###############################
#  POSTGRESQL -RELATED VARIABLES  #
###############################

# MARIADB Helm chart name
POSTGRESQL_CHART="postgresql"


# POSTGRESQL Helm release name.  Set this if the POSTGRESQL chart is installed multiple times to indicate which one to use.  Otherwise leave it blank.
POSTGRESQL_RELEASE_NAME="stocktrader-hist"

# MARIADB Service name
POSTGRESQL_SERVICE_NAME="$POSTGRESQL_RELEASE_NAME-$POSTGRESQL_CHART"

# POSTGRESQL user
POSTGRESQL_USER="traderuser"

# POSTGRESQL password.  The setup script attempts to find this value so set this only if the script is unable to do so.
POSTGRESQL_PASSWORD="n0tthem0stSecure"

# POSTGRESQL port number
POSTGRESQL_PORT=5432

# Database name that you created for the stocktrader application
POSTGRESQL_DATABASE="trader"


#############################
#  KAFKA-RELATED VARIABLES  #
#############################

# Kafka proxy  Helm chart name
KAFKA_CHART="kafka-dns-proxy"

# Kafka proxy  Helm chart release name
KAFKA_RELEASE_NAME="stocktrader-pubsub"

# Kafka DNS proxy service name
KAFKA_SERVICE_NAME="$KAFKA_RELEASE_NAME-$KAFKA_CHART"

# External Kafka api key
KAFKA_API_KEY="939bO-FlLyvpbrXSFfn4Fl9SAznT3ltpIdx7cPsxUc3A"

# Extrenal Kafka topic name for this instance of stocktrader
KAFKA_TOPIC_NAME="stocktrader-user001"

# DNS name of first external Kafka broker
KAFKA_BROKER1_DNS="broker-0-0mqz41lc21pr467x.kafka.svc01.us-south.eventstreams.cloud.ibm.com"

# Port of first extrenal broker
KAFKA_BROKER1_PORT="9093"

###################################
#  WATSON TONE ANALYZER VARIABLES #
###################################

# API URL
TONE_ANALYZER_ENDPOINT="https://gateway-wdc.watsonplatform.net/tone-analyzer/api"

# IAM API KEY
TONE_ANALYZER_APIKEY="yv_fqNk3mKpVB-Ut0rBIA-TCEBnhy1reOaRe3yREtNQ8"

##################################
#  API CONNECT  VARIABLES        #
##################################
# Proxy to Stock Quote Service
API_CONNECT_PROXY_URL="https://api.us-east.apiconnect.appdomain.cloud/amexturbo2-dev/sb"

# API Key for Stock Quote Service
API_CONNECT_PROXY_CLIENTID="5bb83715-834a-4d62-88e4-e88daca0c5ce"

# Stock Service (internal)
STOCK_QUOTE_URL="http://stock-quote-service:9080"

# Trade History Service (internal)
TRADE_HISTORY_URL="http://trade-history-service:5000"
