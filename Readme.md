# JVM comparaison 
Compare the energy consumption of multiple versions of Java virtual machine 


# Usage 

1. select the Jvms that you want to use in the file `jvms.sh`, and then uncomment them 
2. build the docker images using the script `build_images.sh`
3. Select the benchmark that you want to test and put them in `benchmarks/benchmarks.sh` (or just uncomment them if they already exist)
4. launch the tests using `testbed.sh` 

# Results 
they will be found in the subfolder benchmakrs/results
