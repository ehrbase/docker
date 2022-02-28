FROM eclipse-temurin:17-jre-alpine

RUN apk update && \
    apk add wget

ENV JMETER_HOME /opt/apache-jmeter-5.4.3/
ENV PATH $JMETER_HOME/bin:$PATH

RUN wget https://downloads.apache.org/jmeter/binaries/apache-jmeter-5.4.3.tgz && \
    tar -xzf /apache-jmeter-5.4.3.tgz -C /opt && \
    rm apache-jmeter-5.4.3.tgz

COPY keystore/rmi_keystore.jks /opt/apache-jmeter-5.4.3/bin/rmi_keystore.jks

EXPOSE 1099

ENTRYPOINT jmeter-server -Dserver.rmi.ssl.keystore.file=/opt/apache-jmeter-5.4.3/bin/rmi_keystore.jks