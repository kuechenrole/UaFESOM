#!/bin/sh
#SBATCH -N 20
#SBATCH --ntasks-per-node=96
#SBATCH -t 10:00:00
#SBATCH --job-name="oo0020"
#SBATCH -p standard96
#SBATCH -A hbk00097

module load intel
module load impi/2018.5
module load netcdf

export SLURM_CPU_BIND=none
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(HOME)/lib/metis/5.1.0_intel/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/sw/dataformats/netcdf/intel.18/4.7.3/skl/lib

ulimit -s unlimited 
#EXE=${PWD}/fesom_part.x
#echo now run $EXE
#mpirun ${EXE}

rm goodfile
rm namelist.oce
sleep 10
cp namelist.oce.highfric namelist.oce

sed -i "s~step_per_day=.*~step_per_day=2880~" namelist.config
sed -i "s~run_length=.*~run_length=1~" namelist.config
sed -i "s~run_length_unit=.*~run_length_unit='d'~" namelist.config
sed -i "s~output_length_unit=.*~output_length_unit='d'~" namelist.config
sed -i "s~logfile_outfreq=.*~logfile_outfreq=2880~" namelist.config

EXE=${PWD}/fesom.x
echo now run $EXE
mpirun ${EXE}

#if [ -f goonfile ]; then
if [ -f goodfile ]; then
 echo "goodfile exists, launch next job"
 sbatch fesom_firstmonth.slurm
else 
 echo "goodfile does not exist, we do break the chain here"
fi 





elapsed=$(( SECONDS - start_time))
eval "echo Elapsed time for fesom.x: $(date -ud "@$elapsed" +'$((%s/3600/24)) days %H hr %M min %S sec')"
