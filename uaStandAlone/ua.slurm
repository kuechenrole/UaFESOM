#!/bin/bash

#SBATCH --job-name=io0006UA
#SBATCH -p matlab
#SBATCH -n 1
#SBATCH -c 8
#SBATCH --mem=30GB
#SBATCH -w fat-0004
##SBATCH -w prod-0304
#SBATCH -t 12:00:00
#SBATCH -o /work/ollie/orichter/Misomip2/io0006/uarun/slurm-%j.out


#module unload matlab
#module load matlab

##srun matlab.x -nodisplay -r "Ua; exit;" > ice.log 2>ice.err
srun matlab.x -nodisplay -r "Ua; exit;"
#srun matlab.x -nodisplay -r "run('/home/ollie/cwekerle/matlab/write_mesh_netcdf.m')"

