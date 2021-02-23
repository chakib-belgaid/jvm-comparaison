#! /bin/bash

IFS=$'\n'
mkdir benchmarks/results/ 2>/dev/NULL
reportfile=$(cat /etc/mailname)
reportfile=/home/mbelgaid/jvm-comparaison/benchmarks/results/report-zgc$1-${reportfile%%.*}.logs

jvms=$(grep -v "#" jvms.sh)

measure() {
    echo "--------------------------------------------" >>$reportfile
    echo $1 >>$reportfile
    shift
    perf stat -a -r 1 -e power/energy-pkg/ -e power/energy-cores/ -e power/energy-ram/ -e power:cpu_idle -o $reportfile --append $@
}

for iteration in {1..15}; do

    for benchmark in $(grep -v "#" benchmarks/benchmarks.sh); do

        # for jvm in ${jvms[@]} ;
        # do

        IFS=' '
        benchname=$(echo $benchmark | cut -d " " -f2)
        name=$benchname"_"$iteration
        echo $name

        
        ############### open jdk ###########

        measure OPENGC_Default_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1-open -Xmx2G -Xms2G -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure OPENGC_zgc_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1-open -Xmx2G -Xms2G -XX:+UnlockExperimentalVMOptions -XX:+UseZGC -jar -jar /jars/${benchmark[@]}
        sleep 3

        IFS=$'\n'

        # done
    done
done
