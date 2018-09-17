#!/bin/sh
mkdir -p build/demo-0.0.1-SNAPSHOT
cd build/demo-0.0.1-SNAPSHOT && jar xf ../libs/demo-0.0.1-SNAPSHOT.jar
cd ../../
native-image -H:ReflectionConfigurationFiles=graalvm.json \
             -H:+ReportUnsupportedElementsAtRuntime \
             -H:Name=springdemo \
             -Dio.netty.noUnsafe=true \
             -Dfile.encoding=UTF-8 \
             -Dcom.oracle.graalvm.isaot=true \
             --static \
             --verbose \
             -cp ".:$(echo build/demo-0.0.1-SNAPSHOT/BOOT-INF/lib/*.jar | tr ' ' ':')":build/demo-0.0.1-SNAPSHOT/BOOT-INF/classes rimerosolutions.graalvm.springboot.demo.DemoApplication
