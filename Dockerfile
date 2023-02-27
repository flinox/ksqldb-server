FROM openjdk:11.0.9.1-jre

ENV TZ=America/Sao_Paulo

RUN apt update
RUN apt install -y apt-utils telnet netcat git jq nano wget
RUN apt install -y software-properties-common curl gnupg

RUN curl -sq http://ksqldb-packages.s3.amazonaws.com/deb/0.19/archive.key | apt-key add -

# Add the ksqlDB apt repository
RUN add-apt-repository "deb http://ksqldb-packages.s3.amazonaws.com/deb/0.19 stable main"
RUN apt update

# Install KSQLDB
RUN apt install confluent-ksqldb

COPY /etc/ksqldb/ksql-server.properties /etc/ksqldb/ksql-server.properties
COPY /etc/security/limits.conf /etc/security/limits.conf

EXPOSE 8088

# Executar shell para definir as variaveis de ambiente
#WORKDIR /app/consumer

#RUN mkdir -p /usr/logs/

CMD ["sh", "-c", "/usr/bin/ksql-server-start /etc/ksqldb/ksql-server.properties"]