#! /bin/bash

name="testt"

IFS=$'\n'

measure() {
    # {   echo "--------------------------------------------" >> $reportfile
    echo $1
    shift
    #  perf stat -a -r 1 -e power/energy-pkg/ -e power/energy-cores/ -e power/energy-ram/ -e power:cpu_idle -o $reportfile --append
    $@

    wait
}

for benchmark in $(grep -v "#" benchmarks/benchmarks.sh); do

    IFS=' '

    benchname=$(echo $benchmark | cut -d " " -f2)
    name=$benchname
    echo $name

    measure OPEN_JIT_Default_$name docker run --rm -i -v $(pwd):/exp --entrypoint=/exp/record.sh -v$(pwd)/benchmarks/jars:/jars \
        chakibmed/jvm:15.0.1-open lolol.txt /root/.sdkman/candidates/java/current/bin/java -jar /jars/${benchmark[@]}
    sleep 3
    exit

    measure Graal_JIT_Default_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
        chakibmed/jvm:20.2.0.r11-grl -jar /jars/${benchmark[@]}
    sleep 3

    measure J9_JIT_Default_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
        chakibmed/jvm:15.0.1.j9-adpt -jar /jars/${benchmark[@]}
    sleep 3
    IFS=$'\n'

done
