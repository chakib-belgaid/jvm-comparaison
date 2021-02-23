#! /bin/bash
IFS=$'\n'
jvms=$(grep -v "#" jvms.sh)

user=user

for jvm in ${jvms[@]}; do
    echo building jvm $jvm
    docker build --tag $user/jvm:$jvm --build-arg TAG="$jvm" -f jvms-builder/Dockerfile jvms-builder
    # docker push $user/jvm:$jvm
done

mkdir benchmarks/jars && cd benchmarks/jars
# mkdir benchmarks/jars && cd benchmarks/jars &&
# download dacapo.jar and renaissance.jar in benchmarks/jar
