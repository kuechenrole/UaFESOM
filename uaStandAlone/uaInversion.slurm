#!/bin/bash

#SBATCH --job-name=ii0020
#SBATCH -p matlab
#SBATCH -n 1
#SBATCH -c 6
#SBATCH --mem=40GB
#SBATCH -w fat-0004
##SBATCH -w prod-0304
#SBATCH -t 12:00:00
#SBATCH -o /work/ollie/orichter/Misomip2/ii0020/uaRun/slurm-%j.out


#module unload matlab
#module load matlab/R2020b

JOBFILE=/work/ollie/orichter/Misomip2/ii0020/uaRun/ua"$(date +"%Y_%m_%d_%I_%M_%p")".log
LOGFILE=/work/ollie/orichter/Misomip2/ii0020/uaRun/uaResubmission.log
##srun matlab.x -nodisplay -r "Ua; exit;" > ice.log 2>ice.err
srun matlab.x -r "Ua; saveAllPlots; exit;" >> $JOBFILE
#srun matlab.x -nodisplay -r "run('/home/ollie/cwekerle/matlab/write_mesh_netcdf.m')"
sleep 2

if grep "stopped because it exceeded the iteration limit" $JOBFILE
then
  date >> $LOGFILE
  echo "Resubmitting next job, as time limnit has been reached, but not convergence." >> $LOGFILE
  sbatch uaInversion.slurm
else
  date >> $LOGFILE
  echo "Resubmitting jobs finished." >> $LOGFILE
fi

