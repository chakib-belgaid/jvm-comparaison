#! /bin/bash

IFS=$'\n'

reportfile=$(cat /etc/mailname)
reportfile=/home/mbelgaid/jvm-comparaison/benchmarks/results/report$1-${reportfile%%.*}.logs

measure() {

    echo "--------------------------------------------" >>$reportfile
    echo $1 >>$reportfile
    shift
    perf stat -a -r 1 -e power/energy-pkg/ -e power/energy-cores/ -e power/energy-ram/ -e power:cpu_idle -o $reportfile --append $@

    wait
}

for i in {1..2}; do
    for benchmark in $(grep -v "#" benchmarks/benchmarks.sh); do

        IFS=' '

        benchname=$(echo $benchmark | cut -d " " -f2)
        name=$i"_"$benchname
        echo $name

        measure openj9_$name docker run --rm -i -v $(pwd):/exp --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1.j9-adpt -jar /jars/${benchmark[@]}
        sleep 3

        # measure openj9-noclasssharing_$name docker run --rm -i -v $(pwd):/exp --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
        #     chakibmed/jvm:15.0.1.j9-adpt -Xshareclasses:none -jar /jars/${benchmark[@]}
        # sleep 3

        # measure openj9-notaot_$name docker run --rm -i -v $(pwd):/exp --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
        #     chakibmed/jvm:15.0.1.j9-adpt -Xnoaot -Xshareclasses:none -jar /jars/${benchmark[@]}
        # sleep 3

        # measure openj9-jitserver_$name docker run --rm -i -v $(pwd):/exp --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
        #     chakibmed/jvm:15.0.1.j9-adpt -XX:+UseJITServer -jar /jars/${benchmark[@]}
        # sleep 3

        # measure openj9-disablecontainers_$name docker run --rm -i -v $(pwd):/exp --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
        #     chakibmed/jvm:15.0.1.j9-adpt -XX:-UseContainerSupport -jar /jars/${benchmark[@]}
        # sleep 3

        # measure openj9-disableccpu_monitor_$name docker run --rm -i -v $(pwd):/exp --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
        #     chakibmed/jvm:15.0.1.j9-adpt -XX:-EnableCPUMonitor -XX:-ReduceCPUMonitorOverhead -jar /jars/${benchmark[@]}
        # sleep 3

        # measure openj9-disablePortableSharedCache_$name docker run --rm -i -v $(pwd):/exp --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
        #     chakibmed/jvm:15.0.1.j9-adpt -XX:-PortableSharedCache -jar /jars/${benchmark[@]}
        # sleep 3

        # measure openj9-disableJITInlineWatches_$name docker run --rm -i -v $(pwd):/exp --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
        #     chakibmed/jvm:15.0.1.j9-adpt -XX:-JITInlineWatches -jar /jars/${benchmark[@]}
        # sleep 3

        # measure openj9-LazySymbolResolution_$name docker run --rm -i -v $(pwd):/exp --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
        #     chakibmed/jvm:15.0.1.j9-adpt -XX:-LazySymbolResolution -jar /jars/${benchmark[@]}
        # sleep 3

        measure openj9-PortableSharedCache_$name docker run --rm -i -v $(pwd):/exp --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1.j9-adpt -XX:-UseContainerSupport -XX:-PortableSharedCache -Xshareclasses:none -jar /jars/${benchmark[@]}
        sleep 3

        measure hotspot_$name docker run --rm -i -v $(pwd):/exp --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:11.0.2-open -jar /jars/${benchmark[@]}
        sleep 3
        # exit

        # measure Graal_JIT_Default_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
        #     chakibmed/jvm:20.2.0.r11-grl -jar /jars/${benchmark[@]}
        # sleep 3

        # measure J9_JIT_Default_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
        #     chakibmed/jvm:15.0.1.j9-adpt -jar /jars/${benchmark[@]}
        # sleep 3
        IFS=$'\n'

    done
done
