#!/bin/csh
#$ -M yxu6@nd.edu
#$ -m abe
#$ -pe smp 1
#$ -q debug ##*@@emichaellab
#$ -N USA_test

module load R

R CMD BATCH spregPt2RW2.r
