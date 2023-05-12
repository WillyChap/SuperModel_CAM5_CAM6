#!/bin/bash 
#

module load nco 

case1=CAM6_f09_g16
case2=CAM5_32levs

path1=/glade/scratch/wchapman/${case1}/run
path2=/glade/scratch/wchapman/${case2}/run
outpath=/glade/work/wchapman/pseudoobs_V2

cd ${path2}
declare cam5_time
cam5_time=$(head -n 1 "find_time_cam5.txt")

cd ${path1}
declare cam6_time
cam6_time=$(head -n 1 "find_time_cam6.txt")

time=`echo "${cam6_time}" | grep -o -P '(?<=r.).*(?=.nc)'`
echo "$time"

cd ${outpath}
file1=CAM6_f09_g16.cam.h1.${time}.nc
file2=CAM5_32levs.cam.h1.${time}.nc
outfile=test_pseudoobs_UVT.h1.${time}.nc


ncea -O -v U,V,T,Q,PS $file1 $file2 $outfile

