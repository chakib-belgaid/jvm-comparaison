#! /bin/bash 

IFS=$'\n'
reportfile="report3.logs"

jvms=(
    15.0.1.j9-adpt
    15.0.1.hs-adpt
    14.0.2.j9-adpt
    14.0.2.hs-adpt
    13.0.2.j9-adpt
    13.0.2.hs-adpt
    12.0.2.j9-adpt
    12.0.2.hs-adpt
    #11.0.9.open-adpt
    11.0.9.j9-adpt
    11.0.9.hs-adpt
    #8.0.275.open-adpt
    8.0.275.j9-adpt
    8.0.275.hs-adpt
    #8.0.272.hs-adpt
    11.0.8-albba
    8u272-albba
    15.0.1-amzn
    11.0.9-amzn
    8.0.275-amzn
    15.0.1-zulu
    #15.0.1.fx-zulu
    14.0.2-zulu
    #14.0.2.fx-zulu
    13.0.5-zulu
    #13.0.5.fx-zulu
    12.0.2-zulu
    11.0.9-zulu
    #11.0.9.fx-zulu
    10.0.2-zulu
    9.0.7-zulu
    8.0.272-zulu
    #8.0.272.fx-zulu
    #7.0.282-zulu
    #6.0.119-zulu
    #15.0.1.fx-librca
    15.0.1-librca
    #14.0.2.fx-librca
    14.0.2-librca
    #13.0.2.fx-librca
    13.0.2-librca
    12.0.2-librca
    #11.0.9.fx-librca
    11.0.9-librca
    #8.0.275.fx-librca
    8.0.275-librca
    #8.0.265.fx-librca
    20.2.0.r11-grl
    20.2.0.r8-grl
    #20.1.0.r11-grl
    #20.1.0.r8-grl
    #20.0.0.r11-grl
    #20.0.0.r8-grl
    19.3.4.r11-grl
    19.3.4.r8-grl
    #19.3.1.r11-grl
    #19.3.1.r8-grl
    16.ea.24-open
    #16.ea.7.lm-open
    #16.ea.2.pma-open
    15.0.1-open
    14.0.2-open
    13.0.2-open
    12.0.2-open
    11.0.2-open
    10.0.2-open
    9.0.4-open
    8.0.265-open
    20.2.0.0-mandrel
    15.0.1-sapmchn
    14.0.2-sapmchn
    13.0.2-sapmchn
    12.0.2-sapmchn
    11.0.9-sapmchn
    11.0.9-trava
    8.0.232-trava
)




measure()
{   echo "--------------------------------------------" >> $reportfile
    echo  $1 >> $reportfile 
    shift 
    perf stat -a -r 1  -e power/energy-pkg/ -e power/energy-cores/ -e power/energy-ram/ -e power:cpu_idle -o $reportfile --append   $@
}

for benchmark in `cat benchmarks.txt`; 
do
    for iteration in {1..15} ; 
    do      
        for jvm in ${jvms[@]} ; 
        do     
            sleep 4
            IFS=' '
            benchname=`echo $benchmark|cut -d " " -f2`
            name=$jvm"_"$benchname"_"$iteration
            echo $name
            
            measure $name docker run --rm -it --entrypoint=/root/.sdkman/candidates/java/current/bin/java  -v`pwd`/jars:/jars \
            chakibmed/jvm:$jvm  -jar /jars/${benchmark[@]}
            IFS=$'\n'
        done
    done
done 
