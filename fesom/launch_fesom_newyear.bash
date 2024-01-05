#!/bin/bash 
cd $1
sbatch $1/fesom_newyear.slurm | cut -d ' ' -f4 | tee jobid.dat
