#!/bin/csh
#$ -M yxu6@nd.edu
#$ -m abe
#$ -pe smp 12 
#$ -q long ##*@@emichaellab
#$ -N USA_test

module load R

R CMD BATCH spregPt2RW2.r
