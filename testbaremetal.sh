#! /bin/bash

IFS=$'\n'
# mkdir benchmarks/results/ 2>/dev/NULL
reportfile=$(cat /etc/mailname)
reportfile=/home/mbelgaid/jvm-comparaison/benchmarks/results/reportbare$1-${reportfile%%.*}.logs
source "$HOME/.sdkman/bin/sdkman-init.sh"

jvms=$(grep -v "#" jvms.sh)

measure() {
    echo "--------------------------------------------" >>$reportfile
    echo $1 >>$reportfile
    shift
    perf stat -a -r 1 -e power/energy-pkg/ -e power/energy-cores/ -e power/energy-ram/ -e power:cpu_idle -o $reportfile --append $@
}

for iteration in {1..30}; do
    for benchmark in $(grep -v "#" benchmarks/benchmarks.sh); do
        for jvm in ${jvms[@]}; do

            IFS=' '
            benchname=$(echo $benchmark | cut -d " " -f2)
            name=$jvm"_"$benchname"_"$iteration
            echo $name
            sdk use java $jvm
            measure $name java -jar /home/mbelgaid/jvm-comparaison/benchmarks/jars/${benchmark[@]}
            IFS=$'\n'

        done
    done
done
