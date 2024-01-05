#!/bin/sh
#SBATCH --nodes=16 
#SBATCH --ntasks-per-node=36
#SBATCH --time=03:00:00
##SBATCH --time=00:30:00
#SBATCH --job-name="oo0003"
#SBATCH -o /work/ollie/orichter/Misomip2/oo0003/run/slurm-%j.out 
#SBATCH -p mpp

start_time=$SECONDS

module load intel.compiler
module load intel.mpi
module load netcdf
module list

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/global/AWIsoft/metis/5.1.0_intel/lib

ulimit -s unlimited

rm goodfile
#EXE=${PWD}/fesom_part.x
#echo now run $EXE
#srun --mpi=pmi2 -n 576 --tasks-per-node=36  ${EXE}

#int_time=$SECONDS
#elapsed1=$(( int_time - start_time ))

EXE=${PWD}/fesom.x
echo now run $EXE
srun --mpi=pmi2 -n 576 --tasks-per-node=36  ${EXE}

#if [ -f goonfile ]; then      # use this for ice sheetr/ocean coupled runs
if [ -f goodfile ]; then      # use this for standalone FESOM runs
 echo "goodfile exists, launch next job"
 sbatch fesom.slurm
else 
 echo "goodfile does not exist, we do break the chain here"
fi 

elapsed2=$(( SECONDS - start_time))
#eval "echo Elapsed time for fesom_part.x: $(date -ud "@$elapsed1" +'$((%s/3600/24)) days %H hr %M min %S sec')"
eval "echo Elapsed time for fesom.x: $(date -ud "@$elapsed2" +'$((%s/3600/24)) days %H hr %M min %S sec')"
