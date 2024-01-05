#!/bin/sh
#SBATCH -N 20
#SBATCH --ntasks-per-node=96
#SBATCH -t 02:00:00
#SBATCH --job-name="VH52000N"
#SBATCH -p standard96
#SBATCH -A bbk00016

export SLURM_CPU_BIND=none

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(HOME)/lib/metis/5.1.0_intel/lib

#set | grep SLURM_

ulimit -s unlimited 

rm -f goonfile
rm -f goodfile

#rm -f namelist.oce
#sleep 5
#cp namelist.oce.norm namelist.oce

#rm -f namelist.config
#sleep 5
#cp namelist.config.1m namelist.config


EXE=${PWD}/fesom_part.x
echo first do partitioning with $EXE
mpirun ${EXE}

EXE=${PWD}/fesom.x
echo now run the model with $EXE
mpirun ${EXE}

if [ -f goonfile ]; then
 echo "goonfile exists, launch next job"
 sbatch fesom_nextmonth.slurm
else 
 echo "goonfile does not exist, we do break the chain here"
fi 

