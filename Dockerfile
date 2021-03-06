FROM fedora:27 as build-env

RUN dnf install -y glibc-static zlib-static gcc make automake gcc gcc-c++ kernel-devel zlib-devel glibc-nss-devel wget

ARG GRAALVM_BUILD=1.0.0-rc5
ARG GRAALVM_VERSION=graalvm-ce-${GRAALVM_BUILD}

RUN mkdir -p /opt/java
RUN cd /opt/java && wget https://github.com/oracle/graal/releases/download/vm-${GRAALVM_BUILD}/${GRAALVM_VERSION}-linux-amd64.tar.gz
RUN cd /opt/java && tar zxf ${GRAALVM_VERSION}-linux-amd64.tar.gz && rm ${GRAALVM_VERSION}-linux-amd64.tar.gz

ENV GRAALVM_HOME=/opt/java/${GRAALVM_VERSION}
ENV JAVA_HOME=${GRAALVM_HOME}
ENV PATH=${PATH}:${JAVA_HOME}/bin

ADD demo /demo

RUN cd /demo && ./gradlew clean assemble \
    && cd /demo && mkdir -p build/demo-0.0.1-SNAPSHOT  \
    && ./build.sh && cp springdemo /usr/bin/springdemo  \
    && rm -rf /opt/java ~/.m2 ~/.gradle /demo

FROM busybox:1.29.2-glibc
WORKDIR /usr/bin
COPY --from=build-env /usr/bin/springdemo /usr/bin/springdemo
RUN addgroup graalvm
RUN adduser graalvmuser -H -D -G graalvm graalvm -s /bin/false
USER graalvmuser
ENTRYPOINT [ "/usr/bin/springdemo" ]
