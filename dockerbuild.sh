#!/bin/sh

## Clean local machine builds requires a java installation

# pushd demo
# gradle -b demo/build.gradle clean
# rm -rf demo/.gradle
# popd

# Build the image
docker build -t springdemo .
