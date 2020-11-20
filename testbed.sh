#! /bin/bash 

IFS=$'\n'
mkdir benchmarks/results/ 2>/dev/NULL
reportfile=`cat /etc/mailname`
reportfile=benchmarks/results/report$1-${reportfile%%.*}.logs


jvms=`grep -v  "#" jvms.sh `



measure()
{   echo "--------------------------------------------" >> $reportfile
    echo  $1 >> $reportfile 
    shift 
    perf stat -a -r 1  -e power/energy-pkg/ -e power/energy-cores/ -e power/energy-ram/ -e power:cpu_idle -o $reportfile --append   $@
}

for iteration in {1..15} ; 
do 
for benchmark in `grep -v  "#" benchmarks/benchmarks.sh`; 
do
     
        for jvm in ${jvms[@]} ; 
        do     
            sleep 4
            IFS=' '
            benchname=`echo $benchmark|cut -d " " -f2`
            name=$jvm"_"$benchname"_"$iteration
            echo $name
            
            measure $name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java  -v`pwd`/benchmarks/jars:/jars \
            chakibmed/jvm:$jvm  -jar /jars/${benchmark[@]}
            IFS=$'\n'

        done
    done
done 
