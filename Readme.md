# JVM comparaison 
Compare the energy consumption of multiple versions of Java virtual machine based on [SDKman JVM database ](https://sdkman.io/jdks)




# Tools 

## Building images 

The script [build_images.sh](./build_images.sh) is used to generate docker images, each one represent a *jvm* version 
- The file   [jvms.sh](./jvms.sh) is used to configure the images 
- The script will take only the uncommented lines into consediration 
- The name of the generated docker images is following this syntax *user*/jvm:*jvm-version* 
## Measuring the energy 

We do it by launching the script [testbed.sh](./testbed.sh) 

This script will execute each line in the [benchmarks file](./benchmarks/benchmarks.sh) using all the jvms presentend in the [jvm file](./jvms.sh) and report the results in a `report_file.logs` [resutls directory](./benchmarks/results). 

Later use the  notebook  [all-jvms.ipynb](./notebooks/all-jvms.sh) to parse the report files  

## Measuring the evolution of power consumption 

Same as `testbed.sh` the scrip [recordpower.sh](./recordpower.sh) will execute all the benchmarks using the avialable jvms and record the powers into the `powers/rapl` 

Use the notebook [parse_powers.ipynb](./notebooks/parse_powers.ipynb) to parse the report files  

## Measuring the evolution of threads  

Same as `testbed.sh` the scrip [recordthreads.sh](./recordthreads.sh) will execute all the benchmarks using the avialable jvms and record the evolution of threads  into the `records/benchmarkname` 

Use the notebook [parse_records.ipynb](./notebooks/parse_records.ipynb) to parse the report files  

# How to use  

1. Select the Jvms that you want to use in the file `jvms.sh`, and then uncomment them 
2. Build the docker images using the script `build_images.sh`
3. Select the benchmark that you want to test and put them in `benchmarks/benchmarks.sh` (or just uncomment them if they already exist)
4. Launch the tests using `testbed.sh` 


# Results 
They will be found in the subfolder `benchmakrs/results

