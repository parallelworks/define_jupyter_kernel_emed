#!/bin/bash
set -e
sdir=$(dirname $0)

# INPUTS:
partition=$1
julia_version=$2
timeout=$3
# Do not use a '.' character here!
name=${partition}-julia-${julia_version}
name=${name:0:20}

# INPUTS:
julia_bin=/public/apps/julia/julia-${julia_version}/bin/julia
julia_kernel=/public/apps/julia/julia-${julia_version}/packages/packages/IJulia/AQu2H/src/kernel.jl

# REMOTE KERNEL COMMAND
kernel_cmd="module load julia/${julia_version}; ${julia_bin} -i --color=yes --project=@. ${julia_kernel} {connection_file}"
echo Remote kernel command:
echo ${kernel_cmd}

kernel_out=/pw/jupyter-server/kernel-${name}.out

/gs/gsfs0/hpc01/rhel8/apps/conda3/bin/python -m remote_ikernel manage --add \
    --name=${name} \
    --interface=ssh \
    --host=${name}.partition \
    --kernel_cmd="${kernel_cmd}" > ${kernel_out} 2>&1

cat ${kernel_out}


${local_conda_dir}/envs/${local_conda_env}/bin/python -m remote_ikernel manage --add \
    --name=${name} \
    --interface=ssh \
    --host=${pool_name}.clusters.pw \
    --kernel_cmd="${kernel_cmd}" > ${sdir}/kernel-${name}.out 2>&1

cat ${sdir}/kernel-${name}.out