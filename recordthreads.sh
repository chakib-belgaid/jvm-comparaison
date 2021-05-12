#! /bin/sh

#to use this you have to launch the all-records.sh script
# this is ment to be used inside the docker continer
# If you want to use it alone you can call it directly and pass the reporting file name before the command
##  example : ./record.sh myreport.log [[CMD]]

reportfile=/exp/records/$1.top
shift
nohup $@ &
pid=$!
echo $pid
top -b -H -p $pid -d 0.5 >$reportfile &
# pidtop=$!
wait $pid
# kill -15 pidtop=$!
# wait
