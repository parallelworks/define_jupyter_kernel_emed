#!/bin/bash
set -e
sdir=$(dirname $0)

# INPUTS:
partition=$1
conda_env=$2
timeout=$3
# Do not use a '.' character here!
name=${partition}-${conda_env}
name=${name:0:20}

# Make proxy configuration file:
echo PARTITION=${partition} > ~/.ssh/${name}.env
echo TIMEOUT=${timeout} >> ~/.ssh/${name}.env

# DEFINING KERNEL COMMAND:
remote_ipython3=/gs/gsfs0/hpc01/rhel8/apps/conda3/envs/${conda_env}/bin/ipython3 #/contrib/Alvaro.Vidal/miniconda3/bin/ipython3
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