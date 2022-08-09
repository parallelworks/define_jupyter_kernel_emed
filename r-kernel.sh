#!/bin/bash
set -e
sdir=$(dirname $0)

# INPUTS:
partition=$1
r_module=$2
timeout=$3
# Do not use a '.' character here!
r_version=$(basename ${r_module})
name=${partition}-r-${r_version}
name=${name:0:20}
name=$(echo ${name} | sed "s/\.//g")

# Make proxy configuration file:
echo PARTITION=${partition} > ~/.ssh/${name}.env
echo TIMEOUT=${timeout} >> ~/.ssh/${name}.env

# REMOTE KERNEL COMMAND
pre_cmd="module load conda3/4.10.3; conda activate base; module load ${r_module}"
kernel_cmd="${pre_cmd}; R --slave -e IRkernel::main() --args {connection_file}"
echo Remote kernel command:
echo ${kernel_cmd}

kernel_out=/pw/jupyter-server/kernel-${name}.out

/gs/gsfs0/hpc01/rhel8/apps/conda3/bin/python -m remote_ikernel manage --add \
    --name=${name} \
    --interface=ssh \
    --host=${name}.partition \
    --kernel_cmd="${kernel_cmd}" > ${kernel_out} 2>&1

cat ${kernel_out}