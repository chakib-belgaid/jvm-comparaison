#! /bin/bash

IFS=$'\n'
# mkdir benchmarks/results/ 2>/dev/NULL
reportfile=$(cat /etc/mailname)
reportfile=/home/mbelgaid/jvm-comparaison/benchmarks/results/report$1-${reportfile%%.*}.logs
jvms=$(grep -v "#" jvms.sh)

exp_name=tt$1
duration=1200

mkdir $(pwd)/powers/$exp_name

# docker run --net=host --rm --privileged --name powerapi-$exp_name -d -v /sys:/sys -v /var/lib/docker/containers:/var/lib/docker/containers:ro -v $(pwd)/powers/$exp_name:/reporting/ powerapi/hwpc-sensor:latest -f 5000 -n machine -s rapl -e RAPL_ENERGY_PKG -e RAPL_ENERGY_DRAM -r csv -U /reporting/

measure() {
    echo "--------------------------------------------" >>$reportfile
    echo $1 >>$reportfile
    echo $(date +%s) >>$reportfile
    shift
    perf stat -a -r 1 -e power/energy-pkg/ -e power/energy-cores/ -e power/energy-ram/ -e power:cpu_idle -o $reportfile --append $@
    echo $(date +%s) >>$reportfile
}

for iteration in {1..30}; do
    for benchmark in $(grep -v "#" benchmarks/benchmarks.sh); do
        for jvm in ${jvms[@]}; do

            IFS=' '
            benchname=$(echo $benchmark | cut -d " " -f2)
            name=$jvm"_"$benchname"_"$iteration
            echo $name

            measure $name docker run --rm -i --entrypoint=/root/.sdkman/candidates/java/current/bin/java -v$(pwd)/benchmarks/jars:/jars \
                chakibmed/jvm:$jvm -jar /jars/$(echo $benchmark | cut -d " " -f1) $benchname -t $duration
            IFS=$'\n'
            sleep 5

        done
    done
done

docker stop powerapi-$exp_name
