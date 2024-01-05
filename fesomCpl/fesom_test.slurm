#!/bin/sh
#SBATCH -N 16
#SBATCH --ntasks-per-node=96
#SBATCH -t 01:00:00
#SBATCH --job-name="io0035TestFESOM"
#SBATCH -p standard96:test
##SBATCH -A bbk00016
#SBATCH -A hbk00097

module load intel
module load impi/2018.5
module load netcdf

export SLURM_CPU_BIND=none
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(HOME)/lib/metis/5.1.0_intel/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/sw/dataformats/netcdf/intel.18/4.7.3/skl/lib

ulimit -s unlimited 

rm -f goonfile
rm -f goodfile

start_time=$SECONDS  

EXE=${PWD}/fesom_part.x
echo first do partitioning with $EXE
mpirun ${EXE}

int_time=$SECONDS
                                                              
EXE=${PWD}/fesom.x
echo now run the model with $EXE
mpirun ${EXE}

elapsed2=$(( SECONDS - int_time))
eval "echo Elapsed time for fesom_part.x: $(date -ud "@$elapsed1" +'$((%s/3600/24)) days %H hr %M min %S sec')"
eval "echo Elapsed time for fesom.x: $(date -ud "@$elapsed2" +'$((%s/3600/24)) days %H hr %M min %S sec')"
