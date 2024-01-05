#!/bin/sh
#SBATCH -N 20
#SBATCH --ntasks-per-node=96
#SBATCH -t 00:30:00
#SBATCH --job-name="io0025FESOM"
#SBATCH -p standard96
#SBATCH -A hbk00097

#export SLURM_CPU_BIND=none

#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(HOME)/lib/metis/5.1.0_intel/lib

#set | grep SLURM_

ulimit -s unlimited 

rm goodfile

start_time=$SECONDS

EXE=${PWD}/fesom_part.x
echo now run $EXE
srun --mpi=pmi2 -n 576 --tasks-per-node=36 ${EXE}

int_time=$SECONDS                                                                                  
elapsed1=$(( int_time - start_time ))

EXE=${PWD}/fesom.x
echo now run $EXE
srun --mpi=pmi2 -n 576 --tasks-per-node=36  ${EXE}

elapsed2=$(( SECONDS - int_time))
eval "echo Elapsed time for fesom_part.x: $(date -ud "@$elapsed1" +'$((%s/3600/24)) days %H hr %M min %S sec')"
eval "echo Elapsed time for fesom.x: $(date -ud "@$elapsed2" +'$((%s/3600/24)) days %H hr %M min %S sec')"
