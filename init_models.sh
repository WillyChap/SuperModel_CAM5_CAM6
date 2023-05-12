#!/usr/bin/env bash


#####settings####
#####settings####
#####settings####
#####settings####
CAM5DIR="/glade/u/home/wchapman/CAM5_CAM6_SuperModel/CAM5_32levs"
CAM6DIR="/glade/u/home/wchapman/CAM5_CAM6_SuperModel/CAM6_f09_g16"
PROJ="P54048000"


### this sucks but cant find another option### 
mkdir '/glade/work/wchapman/pseudoobs_V2'
cp ./Psuedo_Obs_Files/*.sh /glade/work/wchapman/pseudoobs_V2
cp ./Psuedo_Obs_Files/*.py /glade/work/wchapman/pseudoobs_V2
#####settings####
#####settings####
#####settings####
#####settings####


#### CAM 5 Initialization.... ####################
#### CAM 5 Initialization.... ####################
#### CAM 5 Initialization.... ####################
#### CAM 5 Initialization.... ####################
#### CAM 5 Initialization.... ####################

/glade/work/francines/my_cesm_sandbox/cime/scripts/create_newcase  --case $CAM5DIR --run-unsupported --compset HIST_CAM50_CLM50%SP_CICE%PRES_DOCN%DOM_MOSART_SGLC_SWAV  --res f09_g16 --mach cheyenne --project $PROJ

cd $CAM5DIR
./case.setup

#change to CAM5 physics and to 32 levels.

### sed -i -e '<entry id="CAM_CONFIG_OPTS" value="-phys cam5">' -e '<entry id="CAM_CONFIG_OPTS" value="-phys cam5 -nlev 32">' env_build.xml

#xml change all of our shit
./xmlchange CAM_CONFIG_OPTS="-phys cam5 -nlev 32"
./xmlchange --force ROF_NCPL=\$ATM_NCPL
./xmlchange --force GLC_NCPL=\$ATM_NCPL
./xmlchange JOB_QUEUE=premium 
./xmlchange PROJECT=$PROJ
./xmlchange JOB_WALLCLOCK_TIME=0:10:00
./xmlchange STOP_N=6
./xmlchange STOP_OPTION=nhours
./xmlchange DOUT_S=FALSE

#change namelist settings:
sed -i -e '$a\' user_nl_cam
sed -i -e '$a nhtfrq = 0, -6, 1' user_nl_cam
sed -i -e '$a mfilt = 1, 1' user_nl_cam
sed -i -e '$a ndens = 2, 2' user_nl_cam
sed -i -e '$a fincl2 = \x27U:A\x27,\x27V:A\x27, \x27Q:A\x27, \x27T:A\x27, \x27PS:A\x27, \x27Nudge_U\x27, \x27Nudge_V\x27, \x27Nudge_T\x27, \x27Target_U\x27, \x27Target_V\x27, \x27Target_T\x27' user_nl_cam
sed -i -e '$a &nudging_nl' user_nl_cam
sed -i -e '$a \ Nudge_Model        =.true.' user_nl_cam
sed -i -e '$a \ Nudge_Path         =\x27/glade/work/wchapman/pseudoobs_V2/\x27' user_nl_cam
sed -i -e '$a \ Nudge_File_Template=\x27/test_pseudoobs_UVT.h1.%y-%m-%d-%s.nc\x27' user_nl_cam
sed -i -e '$a \ Nudge_Beg_Year =1979' user_nl_cam
sed -i -e '$a \ Nudge_Beg_Month=1' user_nl_cam
sed -i -e '$a \ Nudge_Beg_Day=1' user_nl_cam
sed -i -e '$a \ Nudge_End_Year =2019' user_nl_cam
sed -i -e '$a \ Nudge_End_Month=8' user_nl_cam
sed -i -e '$a \ Nudge_End_Day  =31' user_nl_cam
sed -i -e '$a \ Nudge_Uprof =2' user_nl_cam
sed -i -e '$a \ Nudge_Vprof =2' user_nl_cam
sed -i -e '$a \ Nudge_Tprof =2' user_nl_cam
sed -i -e '$a \ Nudge_Qprof =0' user_nl_cam
sed -i -e '$a \ Nudge_PSprof =0' user_nl_cam
sed -i -e '$a \ Nudge_Ucoef =1.0' user_nl_cam
sed -i -e '$a \ Nudge_Vcoef =1.0' user_nl_cam
sed -i -e '$a \ Nudge_Tcoef =1.0' user_nl_cam
sed -i -e '$a \ Nudge_Qcoef =0.0' user_nl_cam
sed -i -e '$a \ Nudge_Force_Opt = 1' user_nl_cam
sed -i -e '$a \ Nudge_Times_Per_Day = 4' user_nl_cam
sed -i -e '$a \ Model_Times_Per_Day = 48' user_nl_cam
sed -i -e '$a \ Nudge_TimeScale_Opt = 0' user_nl_cam
sed -i -e '$a \ Nudge_Vwin_Lindex = 6.' user_nl_cam
sed -i -e '$a \ Nudge_Vwin_Ldelta = 0.001' user_nl_cam
sed -i -e '$a \ Nudge_Vwin_Hindex = 33.' user_nl_cam
sed -i -e '$a \ Nudge_Vwin_Hdelta = 0.001' user_nl_cam
sed -i -e '$a \ Nudge_Vwin_Invert = .false.' user_nl_cam
sed -i -e '$a \ Nudge_Hwin_lat0     = 0.' user_nl_cam
sed -i -e '$a \ Nudge_Hwin_latWidth = 999.' user_nl_cam
sed -i -e '$a \ Nudge_Hwin_latDelta = 1.0' user_nl_cam
sed -i -e '$a \ Nudge_Hwin_lon0     = 180.' user_nl_cam
sed -i -e '$a \ Nudge_Hwin_lonWidth = 999.' user_nl_cam
sed -i -e '$a \ Nudge_Hwin_lonDelta = 1.0' user_nl_cam
sed -i -e '$a \ Nudge_Hwin_Invert   = .false.' user_nl_cam


#add Source Mods. 
cp ../Source_Mods_Files/*.F90 $CAM5DIR/SourceMods/src.cam/

## build 
./case.build

#### CAM 6 Initialization.... ####################
#### CAM 6 Initialization.... ####################
#### CAM 6 Initialization.... ####################
#### CAM 6 Initialization.... ####################
#### CAM 6 Initialization.... ####################
#### CAM 6 Initialization.... ####################

/glade/work/francines/my_cesm_sandbox/cime/scripts/create_newcase  --case $CAM6DIR --run-unsupported --compset FHIST  --res f09_g16 --mach cheyenne --project $PROJ

cd $CAM6DIR
./case.setup

#xml change all of our shit
./xmlchange --force ROF_NCPL=\$ATM_NCPL
./xmlchange --force GLC_NCPL=\$ATM_NCPL
./xmlchange JOB_QUEUE=premium 
./xmlchange PROJECT=$PROJ
./xmlchange JOB_WALLCLOCK_TIME=0:10:00
./xmlchange STOP_N=6
./xmlchange STOP_OPTION=nhours
./xmlchange DOUT_S=FALSE

#change namelist settings:
sed -i -e '$a\' user_nl_cam
sed -i -e '$a nhtfrq = 0, -6, 1' user_nl_cam
sed -i -e '$a mfilt = 1, 1' user_nl_cam
sed -i -e '$a ndens = 2, 2' user_nl_cam
sed -i -e '$a fincl2 = \x27U:A\x27,\x27V:A\x27, \x27Q:A\x27, \x27T:A\x27, \x27PS:A\x27, \x27Nudge_U\x27, \x27Nudge_V\x27, \x27Nudge_T\x27, \x27Target_U\x27, \x27Target_V\x27, \x27Target_T\x27' user_nl_cam
sed -i -e '$a &nudging_nl' user_nl_cam
sed -i -e '$a \ Nudge_Model        =.true.' user_nl_cam
sed -i -e '$a \ Nudge_Path         =\x27/glade/work/wchapman/pseudoobs_V2/\x27' user_nl_cam
sed -i -e '$a \ Nudge_File_Template=\x27/test_pseudoobs_UVT.h1.%y-%m-%d-%s.nc\x27' user_nl_cam
sed -i -e '$a \ Nudge_Beg_Year =1979' user_nl_cam
sed -i -e '$a \ Nudge_Beg_Month=1' user_nl_cam
sed -i -e '$a \ Nudge_Beg_Day=1' user_nl_cam
sed -i -e '$a \ Nudge_End_Year =2019' user_nl_cam
sed -i -e '$a \ Nudge_End_Month=8' user_nl_cam
sed -i -e '$a \ Nudge_End_Day  =31' user_nl_cam
sed -i -e '$a \ Nudge_Uprof =2' user_nl_cam
sed -i -e '$a \ Nudge_Vprof =2' user_nl_cam
sed -i -e '$a \ Nudge_Tprof =2' user_nl_cam
sed -i -e '$a \ Nudge_Qprof =0' user_nl_cam
sed -i -e '$a \ Nudge_PSprof =0' user_nl_cam
sed -i -e '$a \ Nudge_Ucoef =1.0' user_nl_cam
sed -i -e '$a \ Nudge_Vcoef =1.0' user_nl_cam
sed -i -e '$a \ Nudge_Tcoef =1.0' user_nl_cam
sed -i -e '$a \ Nudge_Qcoef =0.0' user_nl_cam
sed -i -e '$a \ Nudge_Force_Opt = 1' user_nl_cam
sed -i -e '$a \ Nudge_Times_Per_Day = 4' user_nl_cam
sed -i -e '$a \ Model_Times_Per_Day = 48' user_nl_cam
sed -i -e '$a \ Nudge_TimeScale_Opt = 0' user_nl_cam
sed -i -e '$a \ Nudge_Vwin_Lindex = 6.' user_nl_cam
sed -i -e '$a \ Nudge_Vwin_Ldelta = 0.001' user_nl_cam
sed -i -e '$a \ Nudge_Vwin_Hindex = 33.' user_nl_cam
sed -i -e '$a \ Nudge_Vwin_Hdelta = 0.001' user_nl_cam
sed -i -e '$a \ Nudge_Vwin_Invert = .false.' user_nl_cam
sed -i -e '$a \ Nudge_Hwin_lat0     = 0.' user_nl_cam
sed -i -e '$a \ Nudge_Hwin_latWidth = 999.' user_nl_cam
sed -i -e '$a \ Nudge_Hwin_latDelta = 1.0' user_nl_cam
sed -i -e '$a \ Nudge_Hwin_lon0     = 180.' user_nl_cam
sed -i -e '$a \ Nudge_Hwin_lonWidth = 999.' user_nl_cam
sed -i -e '$a \ Nudge_Hwin_lonDelta = 1.0' user_nl_cam
sed -i -e '$a \ Nudge_Hwin_Invert   = .false.' user_nl_cam


#add Source Mods. 
cp ../Source_Mods_Files/*.F90 $CAM5DIR/SourceMods/src.cam/

## build 
./case.build
