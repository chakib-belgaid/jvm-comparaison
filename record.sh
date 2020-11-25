#! /bin/sh

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
