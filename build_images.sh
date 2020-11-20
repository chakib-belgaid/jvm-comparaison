#! /bin/bash
IFS=$'\n'
jvms=`grep -v  "#" jvms.sh `

user=chakibmed

for jvm in ${jvms[@]};
 do
    echo building jvm $jvm
    docker build --tag $user/jvm:$jvm --build-arg TAG="$jvm"  -f jvms-builder/Dockerfile jvms-builder
    # docker push $user/jvm:$jvm
done




mkdir  benchmarks/jars &&   cd benchmarks/jars && \
    wget   https://gitlab.inria.fr/mbelgaid/docker-jvm-builder/-/raw/master/dacapo.jar  &&\
    wget https://gitlab.inria.fr/mbelgaid/docker-jvm-builder/-/raw/master/renaissance-gpl-0.11.0.jar
