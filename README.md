# Define Jupyter Kernel Emed
Run this workflow to define a Jupyter kernel that connects to your PW Jupyter server from a partition in the EinstenMed cluster. To view available partitions use the `sinfo` command in a PW terminal.

### Remove a kernel:
First, list existing kernels with the command below:

```
/gs/gsfs0/hpc01/rhel8/apps/conda3/bin/jupyter kernelspec list
```

Then, remove the desired kernel with the command below:

```
/gs/gsfs0/hpc01/rhel8/apps/conda3/bin/remote_ikernel  manage --delete kernel_id
```

Where the kernel_id was listed with the firt command (`rik_ssh_*`). Finally, restart the Jupyter server the command:

```
bash /pw/jupyter/restart-jupyter-server.sh
```