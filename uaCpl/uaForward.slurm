#!/bin/bash

#SBATCH --job-name=io0018
#SBATCH -p matlab
#SBATCH -n 1
#SBATCH -c 6
#SBATCH --mem=40GB
#SBATCH -w fat-0004
##SBATCH -w prod-0304
#SBATCH -t 12:00:00
#SBATCH -o /work/ollie/orichter/Misomip2/io0018/uarun/slurm-%j.out

start_time=$SECONDS

#module unload matlab
#module load matlab

JOBFILE=/work/ollie/orichter/Misomip2/io0018/uarun/ua"$(date +"%Y_%m_%d_%H_%M")".log
LOGFILE=/work/ollie/orichter/Misomip2/io0018/uarun/uaForwardResubmission.log
##srun matlab.x -nodisplay -r "Ua; exit;" > ice.log 2>ice.err
srun matlab.x -nodisplay -r "Ua; exit;" >> $JOBFILE

elapsed=$(( SECONDS - start_time))
eval "echo Elapsed time for ua: $(date -ud "@$elapsed" +'$((%s/3600/24)) days %H hr %M min %S sec') >> $JOBFILE"
sleep 2


if grep "Exiting run-step loop because total number of steps reached." $JOBFILE
then
  date >> $LOGFILE
  eval "echo Elapsed time for ua: $(date -ud "@$elapsed" +'$((%s/3600/24)) days %H hr %M min %S sec') >> $LOGFILE"
  echo "setting UserVar.CouplingStart to 0"
  sed -i "s/UserVar.CouplingStart=.*/UserVar.CouplingStart=0;/" DefineInitialInputs.m
  echo "Resubmitting next job, as total number of steps has been reached, but not time limit." >> $LOGFILE
  sbatch uaForward.slurm
else
  date >> $LOGFILE
  echo "Resubmitting jobs finished." >> $LOGFILE
fi

