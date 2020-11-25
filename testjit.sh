#! /bin/bash

IFS=$'\n'
mkdir benchmarks/results/ 2>/dev/NULL
reportfile=$(cat /etc/mailname)
reportfile=/home/mbelgaid/jvm-comparaison/benchmarks/results/report-jit$1-${reportfile%%.*}.logs

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
        sleep 3
        IFS=' '
        benchname=$(echo $benchmark | cut -d " " -f2)
        name=$benchname"_"$iteration
        echo $name

        ############ graalvm ########
        measure Graal_JIT_Default_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:20.2.0.r11-grl -jar /jars/${benchmark[@]}
        sleep 3

        measure Graal_JIT_DisableJVMCI_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:20.2.0.r11-grl -XX:-UseJVMCICompiler -jar /jars/${benchmark[@]}
        sleep 3

        measure Graal_JIT_Community_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:20.2.0.r11-grl -Dgraal.CompilerConfiguration=community -jar /jars/${benchmark[@]}
        sleep 3

        measure Graal_JIT_Economy_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:20.2.0.r11-grl -Dgraal.CompilerConfiguration=economy -jar /jars/${benchmark[@]}
        sleep 3

        ############ j9 adopt #######

        measure J9_JIT_Default_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1.j9-adpt -jar /jars/${benchmark[@]}
        sleep 3

        # measure J9_JIT_Disabled_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java  -v`pwd`/benchmarks/jars:/jars \
        # chakibmed/jvm:15.0.1.j9-adpt   -Xint -jar /jars/${benchmark[@]}
        # sleep 3

        measure J9_JIT_1Thread_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1.j9-adpt -XcompilationThreads1 -jar /jars/${benchmark[@]}
        sleep 3

        measure J9_JIT_3Thread_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1.j9-adpt -XcompilationThreads3 -jar /jars/${benchmark[@]}
        sleep 3

        measure J9_JIT_7Thread_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1.j9-adpt -XcompilationThreads7 -jar /jars/${benchmark[@]}
        sleep 3

        measure J9_JIT_Count0_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1.j9-adpt -Xjit:count=0 -jar /jars/${benchmark[@]}
        sleep 3

        measure J9_JIT_Count1_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1.j9-adpt -Xjit:count=1 -jar /jars/${benchmark[@]}
        sleep 3

        measure J9_JIT_Count10_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1.j9-adpt -Xjit:count=10 -jar /jars/${benchmark[@]}
        sleep 3

        measure J9_JIT_Count100_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1.j9-adpt -Xjit:count=100 -jar /jars/${benchmark[@]}
        sleep 3

        measure J9_JIT_Cold_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1.j9-adpt -Xjit:optlevel=cold -jar /jars/${benchmark[@]}
        sleep 3

        measure J9_JIT_Warm_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1.j9-adpt -Xjit:optlevel=warm -jar /jars/${benchmark[@]}
        sleep 3

        measure J9_JIT_Hot_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1.j9-adpt -Xjit:optlevel=hot -jar /jars/${benchmark[@]}
        sleep 3

        measure J9_JIT_VeryHot_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1.j9-adpt -Xjit:optlevel=veryhot -jar /jars/${benchmark[@]}
        sleep 3

        measure J9_JIT_Schorching_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1.j9-adpt -Xjit:optlevel=scorching -jar /jars/${benchmark[@]}
        sleep 3

        ############### open jdk ###########
        measure OPEN_JIT_Default_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1-open -jar /jars/${benchmark[@]}
        sleep 3

        measure OPEN_JIT_NotTired_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1-open -XX:-TieredCompilation -jar /jars/${benchmark[@]}
        sleep 3

        measure OPEN_JIT_Lvl0_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1-open -XX:TieredStopAtLevel=0 -jar /jars/${benchmark[@]}
        sleep 3

        measure OPEN_JIT_Lvl1_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1-open -XX:TieredStopAtLevel=1 -jar /jars/${benchmark[@]}
        sleep 3

        measure OPEN_JIT_Lvl2_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1-open -XX:TieredStopAtLevel=2 -jar /jars/${benchmark[@]}
        sleep 3

        measure OPEN_JIT_Lvl3_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1-open -XX:TieredStopAtLevel=3 -jar /jars/${benchmark[@]}
        sleep 3

        measure OPEN_JIT_Lvl4_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1-open -XX:TieredStopAtLevel=4 -jar /jars/${benchmark[@]}
        sleep 3

        measure OPEN_JIT_Graal_$name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
            chakibmed/jvm:15.0.1-open -XX:+UnlockExperimentalVMOptions -XX:+EnableJVMCI -XX:-UseJVMCICompiler -jar /jars/${benchmark[@]}
        sleep 3

        IFS=$'\n'

        # done
    done
done
