#!/bin/bash
set -e
all_rik=$(/gs/gsfs0/hpc01/rhel8/apps/conda3/bin/jupyter kernelspec list | grep rik_ | awk '{print $1}')
/gs/gsfs0/hpc01/rhel8/apps/conda3/bin/remote_ikernel  manage --delete ${all_rik}
bash /pw/jupyter-server/restart-jupyter-server.sh