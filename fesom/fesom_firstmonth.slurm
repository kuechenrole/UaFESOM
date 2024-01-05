#!/bin/sh
#SBATCH --nodes=16
#SBATCH --ntasks-per-node=36
#SBATCH --time=02:00:00
##SBATCH --time=00:30:00
##SBATCH --time=03:30:00
#SBATCH --job-name="oo0010"
#SBATCH -o /work/ollie/orichter/Misomip2/oo0010/run/slurm-%j.out 
#SBATCH -p mpp
#SBATCH --qos=express

start_time=$SECONDS

module load intel.compiler
module load intel.mpi
module load netcdf
module list

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/global/AWIsoft/metis/5.1.0_intel/lib

#set | grep SLURM_

ulimit -s unlimited 

rm goodfile

rm namelist.oce
sleep 10
cp namelist.oce.norm namelist.oce

sed -i "s~step_per_day=.*~step_per_day=360~" namelist.config
sed -i "s~run_length=.*~run_length=30~" namelist.config
sed -i "s~run_length_unit=.*~run_length_unit='d'~" namelist.config
sed -i "s~output_length_unit=.*~output_length_unit='m'~" namelist.config
sed -i "s~logfile_outfreq=.*~logfile_outfreq=360~" namelist.config

EXE=${PWD}/fesom.x
echo now run $EXE
srun --mpi=pmi2 -n 576 --tasks-per-node=36  ${EXE}

#if [ -f goonfile ]; then
if [ -f goodfile ]; then
 echo "goodfile exists, launch next job"
 sbatch fesom_firstyear.slurm
else 
 echo "goodfile does not exist, we do break the chain here"
fi 





elapsed=$(( SECONDS - start_time))
eval "echo Elapsed time for fesom.x: $(date -ud "@$elapsed" +'$((%s/3600/24)) days %H hr %M min %S sec')"
