#!/bin/bash
set -e
sdir=$(dirname $0)


# INPUTS:
partition=$1
path_to_sing=$2
mount_dirs=$(echo ${3} | sed "s/___/ /g")
use_gpus=$4
timeout=$5

if [[ ${use_gpus} == "True" ]]; then
    gpu_flag="--nv"
else
    gpu_flag=""
fi

# Do not use a '.' character here!
name=${partition}-$(basename ${path_to_sing})
name=${name:0:20}

# Make proxy configuration file:
echo PARTITION=${partition} > ~/.ssh/${name}.env
echo TIMEOUT=${timeout} >> ~/.ssh/${name}.env

# DEFINING KERNEL COMMAND:
remote_ipython3="singularity exec ${gpu_flag} ${mount_dirs} ${path_to_sing} ipython3"
kernel_cmd="${remote_ipython3} kernel -f {connection_file}"


echo Remote kernel command:
echo ${kernel_cmd}

kernel_out=/pw/jupyter-server/kernel-${name}.out

/gs/gsfs0/hpc01/rhel8/apps/conda3/bin/python -m remote_ikernel manage --add \
    --name=${name} \
    --interface=ssh \
    --host=${name}.partition \
    --kernel_cmd="${kernel_cmd}" > ${kernel_out} 2>&1

cat ${kernel_out}