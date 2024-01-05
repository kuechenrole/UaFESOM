#!/bin/sh
#SBATCH --nodes=16 
#SBATCH --ntasks-per-node=36
##SBATCH --time=08:00:00
#SBATCH --qos=short
#SBATCH --time=00:30:00
#SBATCH --job-name="io0022FESOM"
#SBATCH -o /work/ollie/orichter/Misomip2/io0022/fesomRun/slurm-%j.out 
#SBATCH -p mpp

start_time=$SECONDS

module load intel.compiler
module load intel.mpi
module load netcdf
module list

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/global/AWIsoft/metis/5.1.0_intel/lib

ulimit -s unlimited 

#rm goonfile
#EXE=${PWD}/fesom_part.x
#echo now run $EXE
#srun --mpi=pmi2 -n 576 --tasks-per-node=36 ${EXE}

int_time=$SECONDS                                                                                  
elapsed1=$(( int_time - start_time ))

EXE=${PWD}/fesom.x
echo now run $EXE
srun --mpi=pmi2 -n 576 --tasks-per-node=36  ${EXE}

elapsed2=$(( SECONDS - int_time))
eval "echo Elapsed time for fesom_part.x: $(date -ud "@$elapsed1" +'$((%s/3600/24)) days %H hr %M min %S sec')"
eval "echo Elapsed time for fesom.x: $(date -ud "@$elapsed2" +'$((%s/3600/24)) days %H hr %M min %S sec')"
