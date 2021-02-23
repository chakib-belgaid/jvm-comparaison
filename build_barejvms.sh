#! /bin/bash
IFS=$'\n'
jvms=$(grep -v "#" jvms.sh)

user=chakibmed
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

for jvm in ${jvms[@]}; do
    echo building jvm $jvm
    sdk install java $jvm
    # docker push $user/jvm:$jvm
done

mkdir benchmarks/jars && cd benchmarks/jars &&
    wget https://gitlab.inria.fr/mbelgaid/docker-jvm-builder/-/raw/master/dacapo.jar &&
    wget https://gitlab.inria.fr/mbelgaid/docker-jvm-builder/-/raw/master/renaissance-gpl-0.11.0.jar
