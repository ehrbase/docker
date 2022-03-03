FROM eclipse-temurin:17-jre-alpine

RUN apk update && \
    apk add wget

ENV JMETER_HOME /apache-jmeter-5.4.3
ENV PATH $JMETER_HOME/bin:$PATH

RUN wget https://downloads.apache.org/jmeter/binaries/apache-jmeter-5.4.3.tgz && \
    tar -xzf /apache-jmeter-5.4.3.tgz && \
    rm apache-jmeter-5.4.3.tgz

COPY keystore/rmi_keystore.jks $JMETER_HOME/bin/rmi_keystore.jks

EXPOSE 1099

WORKDIR $JMETER_HOME/bin

ENTRYPOINT ["jmeter-server"]