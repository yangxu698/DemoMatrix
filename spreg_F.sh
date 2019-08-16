#!/bin/csh
#$ -M yxu6@nd.edu
#$ -m abe
#$ -pe smp 24
#$ -q debug ##*@@emichaellab
#$ -N F_network

module load R

R CMD BATCH spregPt2RW2_F.r
