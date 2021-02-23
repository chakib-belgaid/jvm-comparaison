#! /bin/bash

for jvm in $(grep -v "#" jvms.sh); do

    name=$jvm

    echo $name
    docker run --rm -i --entrypoint=/root/.sdkman/candidates/java/current/bin/java \
        chakibmed/jvm:$jvm -version 2>&1
    echo ---------------- file

done
