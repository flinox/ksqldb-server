#!/bin/bash

# DEV 
. _key/key_dev.sh

docker build -t flinox/flinox-ksqldb-server:latest .

docker run --rm -it --hostname flinox-ksqldb-server-DEV --name flinox-ksqldb-server-DEV \
--mount type=bind,source="$(pwd)"/properties,target=/properties/ \
-p 8088:8088 \
--ulimit nofile=16384:16384 \
--security-opt label=disable \
flinox/flinox-ksqldb-server:latest


# docker run --rm -it --hostname flinox-ksqldb-server-DEV --name flinox-ksqldb-server-DEV \
# --mount type=bind,source="$(pwd)"/_key,target=/key/ \
# --mount type=bind,source="$(pwd)"/_key/limits.conf,target=/etc/security/limits.conf \
# -p 8088:8088 \
# -e TZ=America/Sao_Paulo \
# -e KSQL_LISTENERS=http://0.0.0.0:8088 \
# -e KSQL_BOOTSTRAP_SERVERS=$KC_URL \
# -e KSQL_KSQL_INTERNAL_TOPIC_REPLICAS=3 \
# -e KSQL_KSQL_SINK_REPLICAS=3 \
# -e KSQL_KSQL_STREAMS_REPLICATION_FACTOR=3 \
# -e KSQL_KSQL_LOGGING_PROCESSING_TOPIC_REPLICATION_FACTOR=3 \
# -e KSQL_LOG4J_PROCESSING_LOG_BROKERLIST=$KC_URL \
# -e KSQL_LOG4J_PROCESSING_LOG_TOPIC=ksql-processing-log-topic \
# -e KSQL_KSQL_LOGGING_PROCESSING_TOPIC_NAME=ksql-processing-log-topic \
# -e KSQL_KSQL_LOGGING_PROCESSING_TOPIC_AUTO_CREATE="true" \
# -e KSQL_KSQL_LOGGING_PROCESSING_STREAM_AUTO_CREATE="true" \
# -e KSQL_LOG4J_ROOT_LOGLEVEL=TRACE \
# -e KSQL_TOOLS_LOG4J_LOGLEVEL=TRACE \
# -e KSQL_SECURITY_PROTOCOL=SASL_SSL \
# -e KSQL_SASL_MECHANISM=PLAIN \
# -e KSQL_SASL_JAAS_CONFIG="org.apache.kafka.common.security.plain.PlainLoginModule required username=\""$KC_API_KEY"\" password=\""$KC_API_SECRET"\";" \
# -e KSQL_KSQL_SCHEMA_REGISTRY_BASIC_AUTH_CREDENTIALS_SOURCE=USER_INFO \
# -e KSQL_KSQL_SCHEMA_REGISTRY_BASIC_AUTH_USER_INFO=$SR_API_KEY:$SR_API_SECRET \
# -e KSQL_KSQL_SCHEMA_REGISTRY_URL=$SR_URL \
# -e KSQL_KSQL_SERVER_COMMAND_RESPONSE_TIMEOUT_MS=15000 \
# -e MAX_OPEN_FILES=102400 \
# --security-opt label=disable \
# confluentinc/ksqldb-server:latest