#!/bin/bash
sdir=$(dirname $0)
# HELPER FUNCTIONS
# Read arguments in format "--pname pval" into export pname=pval
f_read_cmd_args(){
    index=1
    args=""
    for arg in $@; do
	    prefix=$(echo "${arg}" | cut -c1-2)
	    if [[ ${prefix} == '--' ]]; then
	        pname=$(echo $@ | cut -d ' ' -f${index} | sed 's/--//g')
	        pval=$(echo $@ | cut -d ' ' -f$((index + 1)))
	        echo "export ${pname}=${pval}" >> $(dirname $0)/env.sh
	        export "${pname}=${pval}"
	    fi
        index=$((index+1))
    done
}

echod() {
    echo $(date): $@
}

# READ INPUTS
f_read_cmd_args $@

# SELECT KERNEL SCRIPT
if [[ ${kernel_type} == "conda" ]]; then
    bash ${sdir}/conda-kernel.sh ${partition} ${conda_env} ${timeout}
elif [[ ${kernel_type} == "singularity" ]]; then
    bash ${sdir}/singularity-kernel.sh ${partition} ${path_to_sing} ${mount_dirs} ${use_gpus} ${timeout}
elif [[ ${kernel_type} == "julia" ]]; then
    bash ${sdir}/julia-kernel.sh ${partition} ${julia_version} ${timeout}
else
    echod "ERROR: Kernel type ${kernel_type} is not yet supported!"
fi

