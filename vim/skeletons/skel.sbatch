#!/usr/bin/env bash
#SBATCH --job-name=@BASENAME@
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --time=01:00:00
#SBATCH --ntasks=1

@CURSOR@
