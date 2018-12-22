#!/bin/bash
# 
# CompecTA (c) 2018
#
# Example job submission script
#
# TODO:
#   - Set name of the job below changing "Slurm" value.
#   - Set the requested number of tasks (cpu cores) with --ntasks parameter.
#   - Set the required time limit for the job with --time parameter.
#   - Put this script and all the input file under the same directory.
#   - Set the required parameters, input and output file names below.
#   - If you do not want mail please remove the line that has --mail-type
#   - Put this script and all the input file under the same directory.
#   - Submit this file using:
#      sbatch slurm_example.sh

# -= Resources =-
#
#SBATCH --job-name=hello
##SBATCH --ntasks-per-node=1
#SBATCH --ntasks=1
#SBATCH --gres=gpu:1
#SBATCH --partition=main
#SBATCH --output=test-%j.out
##SBATCH --mail-type=ALL
##SBATCH --mail-user=fuatgeleri@gmail.com

################################################################################
##################### !!! DO NOT EDIT BELOW THIS LINE !!! ######################
################################################################################
source /etc/profile.d/z_compecta.sh 
echo "source /etc/profile.d/z_compecta.sh" 
################################################################################ 

## Load Python 3.6.4
#echo "Activating Python 3.6.4..."
#module load python/3.6.4

## Load GCC-7.3.0
#echo "Activating GCC-7.3.0..."
#module load gcc/7.3.0

echo "Activatign CUDA/9.0..."
module load cuda/9.0

echo ""
echo "======================================================================================"
env
echo "======================================================================================"
echo ""

# Set stack size to unlimited
echo "Setting stack size to unlimited..."
ulimit -s unlimited
ulimit -l unlimited
ulimit -a
echo

echo "Running Example Job...!"
echo "==============================================================================="
# Command 1 for matrix
# echo "Running Python script..."
# Put Python script command below

# Command 2 for matrix
#echo "Running G++ compiler..."
# Put g++ compiler command below
mkdir -p build
cd build
cmake ..
make -j8
./hello

# Command 3 for matrix
echo "Running compiled binary..."
# Put compiled binary command below

echo `pwd`
