#! /bin/bash

name="testt"

IFS=$'\n'

mkdir records 2>/dev/NULL

measure() {
    # {   echo "--------------------------------------------" >> $reportfile
    name=$1
    jvm=$2
    shift 2

    #  perf stat -a -r 1 -e power/energy-pkg/ -e power/energy-cores/ -e power/energy-ram/ -e power:cpu_idle -o $reportfile --append
    docker run --rm -i -v $(pwd):/exp --entrypoint=/exp/record.sh -v$(pwd)/benchmarks/jars:/jars \
        chakibmed/jvm:$jvm $name /root/.sdkman/candidates/java/current/bin/java -jar /jars/$@
    sleep 3

    wait
}

for benchmark in $(grep -v "#" benchmarks/benchmarks.sh); do
    for jvm in $(grep -v "#" jvms.sh); do

        IFS=' '

        benchname=$(echo $benchmark | cut -d " " -f2)

        name=$benchname"_"$jvm
        echo $name

        measure $name $jvm $benchmark
        IFS=$'\n'
    done
done
