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

        ############ graalvm ########

        measure GraalGC_Default_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:20.2.0.r11-grl -Xmx2G -Xms2G -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure GraalGC_G1_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:20.2.0.r11-grl -Xmx2G -Xms2G -XX:+UseG1GC -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure GraalGC_5Parallel_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:20.2.0.r11-grl -Xmx2G -Xms2G -XX:ParallelGCThreads=5 -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure GraalGC_5Concurent_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:20.2.0.r11-grl -Xmx2G -Xms2G -XX:ConcGCThreads=5 -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure GraalGC_1Parallel_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:20.2.0.r11-grl -Xmx2G -Xms2G -XX:ParallelGCThreads=1 -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure GraalGC_1Concurent_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:20.2.0.r11-grl -Xmx2G -Xms2G -XX:ConcGCThreads=1 -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure GraalGC_DisableExplicitGC_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:20.2.0.r11-grl -XX:+DisableExplicitGC -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure GraalGC_ParallelCG_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:20.2.0.r11-grl -Xmx2G -Xms2G -XX:+UseParallelGC -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure GraalGC_ParallelOldGC_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:20.2.0.r11-grl -Xmx2G -Xms2G -XX:+UseParallelOldGC -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure GraalGC_Pause_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:20.2.0.r11-grl -Xmx2G -Xms2G -XX:MaxGCPauseMillis=5000 -XX:GCTimeRatio=2 -jar -jar /jars/${benchmark[@]}
        sleep 3

        ############ j9 adopt #######

        measure J9GC_Default_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1.j9-adpt -Xmx2G -Xms2G -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure J9GC_ConcurrentScavenge_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1.j9-adpt -Xmx2G -Xms2G -Xgc:concurrentScavenge -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure J9GC_ScvNoAdaptiveTenure_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1.j9-adpt -Xmx2G -Xms2G -Xgc:scvNoAdaptiveTenure -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure J9GC_Balanced_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1.j9-adpt -Xmx2G -Xms2G -Xgcpolicy:balanced -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure J9GC_Gencon_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1.j9-adpt -Xmx2G -Xms2G -Xgcpolicy:gencon -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure J9GC_Metronome_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1.j9-adpt -Xmx2G -Xms2G -Xgcpolicy:metronome -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure J9GC_Nogc_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1.j9-adpt -Xgcpolicy:nogc -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure J9GC_Optavgpause_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1.j9-adpt -Xmx2G -Xms2G -Xgcpolicy:optavgpause -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure J9GC_Optthruput_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1.j9-adpt -Xmx2G -Xms2G -Xgcpolicy:optthruput -jar -jar /jars/${benchmark[@]}
        sleep 3

        ############### open jdk ###########

        measure OPENGC_Default_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1-open -Xmx2G -Xms2G -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure OPENGC_G1_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1-open -Xmx2G -Xms2G -XX:+UseG1GC -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure OPENGC_5Parallel_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1-open -Xmx2G -Xms2G -XX:ParallelGCThreads=5 -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure OPENGC_5Concurent_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1-open -Xmx2G -Xms2G -XX:ConcGCThreads=5 -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure OPENGC_1Parallel_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1-open -Xmx2G -Xms2G -XX:ParallelGCThreads=1 -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure OPENGC_1Concurent_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1-open -Xmx2G -Xms2G -XX:ConcGCThreads=1 -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure OPENGC_DisableExplicitGC_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1-open -XX:+DisableExplicitGC -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure OPENGC_ParallelCG_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1-open -Xmx2G -Xms2G -XX:+UseParallelGC -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure OPENGC_ParallelOldGC_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1-open -Xmx2G -Xms2G -XX:+UseParallelOldGC -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure OPENGC_SerialGC_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1-open -Xmx2G -Xms2G -XX:+UseSerialGC -jar -jar /jars/${benchmark[@]}
        sleep 3

        measure OPENGC_Epsilon_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1-open -Xmx2G -Xms2G -XX:+UnlockExperimentalVMOptions -XX:+UseEpsilonGC -XX:+AlwaysPreTouch -jar -jar /jars/${benchmark[@]}
        sleep 3

        IFS=$'\n'

        # done
    done
done
