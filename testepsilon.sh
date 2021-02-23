#! /bin/bash

IFS=$'\n'
mkdir benchmarks/results/ 2>/dev/NULL
reportfile=$(cat /etc/mailname)
reportfile=/home/mbelgaid/jvm-comparaison/benchmarks/results/report-gc$1-${reportfile%%.*}.logs

jvms=$(grep -v "#" jvms.sh)

measure() {
    echo "--------------------------------------------" >>$reportfile
    echo $1 >>$reportfile
    shift
    perf stat -a -r 1 -B -e cache-references,cache-misses,cycles,instructions,branches,faults,migrations -e power/energy-pkg/ -e power/energy-cores/ -e power/energy-ram/ -e power:cpu_idle -o $reportfile --append $@
}

for iteration in {1..15}; do

    for benchmark in $(grep -v "#" benchmarks/benchmarks.sh); do

        # for jvm in ${jvms[@]} ;
        # do

        IFS=' '
        benchname=$(echo $benchmark | cut -d " " -f2)
        name=$benchname"_"$iteration
        echo $name

        measure OPENGC_Default_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1-open -Xmx10G -Xms10G -Xlog:gc -jar -jar /jars/${benchmark[@]}
        sleep 3

        # -Xmx240G -Xms240G
        # -Xmx240G -Xms240G
        #-XX:TLABSize
        measure OPENGC_Epsilon_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1-open -Xmx10G -Xms10G -Xlog:gc -XX:+UnlockExperimentalVMOptions -XX:+UseEpsilonGC -XX:+AlwaysPreTouch -jar -jar /jars/${benchmark[@]}
        sleep 3

        IFS=$'\n'

        # done
    done
done
