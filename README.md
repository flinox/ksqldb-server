# flinox - ksqldb-server
Imagem para rodar o ksqldb server connectando no kafka do ambiente ccloud setado.

Build by: Flinox.


## 1) Crie uma pasta **_key** dentro do ccloud:
```
mkdir _key
```

## 2) Crie dois arquivos dentro da pasta **_key** com o seguinte conteúdo:
```
# API E SECRET DO SCHEMA REGISTRY ( AMBIENTE ??? )
export SR_API_KEY=<SUA_KEY_SR>
export SR_API_SECRET=<SUA_SECRET_SR>
export SR_URL=https://host.confluent.cloud

# API E SECRET DO KAFKA CLUSTER ( AMBIENTE ??? )
export KC_API_KEY=<SUA_KEY_KC>
export KC_API_SECRET=<SUA_SECRET_KC>
export KC_URL=https://host.confluent.cloud:9092

```
Um arquivo com os dados para ambiente de DEV o arquivo deve se chamar **key_dev.sh** o outro com os dados para o ambiente de HML o arquivo deve se chamar **key_hml.sh**
Obs.: Importante configurar o arquivo para quebra de linha do linux (LF) quando no windows


## Rodando o ksqldb server manualmente
```
# DEV 
. _key/key_dev.sh

docker run --rm -it --hostname flinox-ksqldb-server-DEV --name flinox-ksqldb-server-DEV \
--mount type=bind,source="$(pwd)"/_key,target=/key/ \
-p 8088:8088 \
-e KSQL_LISTENERS=http://0.0.0.0:8088 \
-e KSQL_BOOTSTRAP_SERVERS=$KC_URL \
-e KSQL_KSQL_INTERNAL_TOPIC_REPLICAS=3 \
-e KSQL_KSQL_SINK_REPLICAS=3 \
-e KSQL_KSQL_STREAMS_REPLICATION_FACTOR=3 \
-e KSQL_KSQL_LOGGING_PROCESSING_TOPIC_REPLICATION_FACTOR=3 \
-e KSQL_KSQL_LOGGING_PROCESSING_STREAM_AUTO_CREATE="false" \
-e KSQL_KSQL_LOGGING_PROCESSING_TOPIC_AUTO_CREATE="false" \
-e KSQL_SECURITY_PROTOCOL=SASL_SSL \
-e KSQL_SASL_MECHANISM=PLAIN \
-e KSQL_SASL_JAAS_CONFIG="org.apache.kafka.common.security.plain.PlainLoginModule required username=\""$KC_API_KEY"\" password=\""$KC_API_SECRET"\";" \
-e KSQL_KSQL_SCHEMA_REGISTRY_BASIC_AUTH_CREDENTIALS_SOURCE=USER_INFO \
-e KSQL_KSQL_SCHEMA_REGISTRY_BASIC_AUTH_USER_INFO=$SR_API_KEY:$SR_API_SECRET \
-e KSQL_KSQL_SCHEMA_REGISTRY_URL=$SR_URL \
-e KSQL_KSQL_SERVER_COMMAND_RESPONSE_TIMEOUT_MS=15000 \
--security-opt label=disable \
confluentinc/ksqldb-server:0.19.0
```
ou simplesmente rode o script:
```
./docker-run.sh
```

## Acessando o ksqldb server com o ksql cli
```
docker run --rm -it --hostname flinox-ksqldb-cli-DEV --name flinox-ksqldb-cli-DEV \
confluentinc/ksqldb-cli:0.19.0 \
ksql http://$(ip route show | awk '/default/ {print $3}'):8088
```

ou acesse diretamente o ksqldb-server
```
docker exec -it flinox-ksqldb-server-DEV ksql http://localhost:8088
```


## Acessando o ksqldb server para criar streams e outras paradas!
Acesse o container em execução:
```
docker exec -it ksqldb-server /bin/bash
```
Para acessar o ksql rode:
```
ksql http://localhost:8088
```
Para sair digite **exit**



SET 'auto.offset.reset' = 'latest';


## CONSULTAS

Antes de criar as streams, rode:
```sql
-- Para que ela contemple os eventos mais antigos
SET 'auto.offset.reset' = 'earliest';

-- Para contemplar somente os eventos a partir do momento
SET 'auto.offset.reset' = 'latest';
```



## Referencias
- https://github.com/confluentinc/ksql
- https://ksqldb.io/quickstart.html#quickstart-content
- https://docs.ksqldb.io/en/latest/developer-guide/joins/join-streams-and-tables/
- https://docs.confluent.io/platform/current/ksqldb/troubleshoot-ksql.html
- https://kafka-tutorials.confluent.io/working-with-nested-json/ksql.html
- https://docs.ksqldb.io/en/latest/how-to-guides/query-structured-data/

- https://stackoverflow.com/questions/63367592/how-to-construct-nested-json-message-on-output-topic-in-ksqldb
- https://docs.ksqldb.io/en/latest/operate-and-deploy/performance-guidelines/#aggregations