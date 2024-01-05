#!/bin/bash

#SBATCH -A oze.oze
#SBATCH --job-name=io0036UA
#SBATCH -p matlab
#SBATCH -n 1
#SBATCH -c 6
#SBATCH --mem=20GB
#SBATCH -w fat-003
#SBATCH -t 12:00:00
#SBATCH --qos=12h
##SBATCH -o /work/ollie/orichter/Misomip2/io0036/uaRun/slurm-%j.out


#module unload matlab
#module load matlab/R2020b
module load matlab

##srun matlab.x -nodisplay -r "Ua; exit;" > ice.log 2>ice.err
matlab -nodisplay -r "Ua; exit;"
#srun matlab.x -nodisplay -r "run('/home/ollie/cwekerle/matlab/write_mesh_netcdf.m')"

