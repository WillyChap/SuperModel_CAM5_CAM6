#!/usr/bin/env bash


#####settings####
#####settings####
#####settings####
#####settings####
CAM5DIR="/glade/u/home/wchapman/CAM5_CAM6_SuperModel/CAM5_32levs_individual"
CAM6DIR="/glade/u/home/wchapman/CAM5_CAM6_SuperModel/CAM6_f09_g16_individual"
PROJ="P54048000"

#####settings####
#####settings####
#####settings####
#####settings####


# ### CAM 5 Initialization.... ####################
# ### CAM 5 Initialization.... ####################
# ### CAM 5 Initialization.... ####################
# ### CAM 5 Initialization.... ####################
# ### CAM 5 Initialization.... ####################

/glade/work/francines/my_cesm_sandbox/cime/scripts/create_newcase  --case $CAM5DIR --run-unsupported --compset HIST_CAM50_CLM50%SP_CICE%PRES_DOCN%DOM_MOSART_SGLC_SWAV  --res f09_g16 --mach cheyenne --project $PROJ

cd $CAM5DIR
./case.setup

# change to CAM5 physics and to 32 levels.

# ## sed -i -e '<entry id="CAM_CONFIG_OPTS" value="-phys cam5">' -e '<entry id="CAM_CONFIG_OPTS" value="-phys cam5 -nlev 32">' env_build.xml

#xml change all of our shit
./xmlchange CAM_CONFIG_OPTS="-phys cam5 -nlev 32"
./xmlchange --force ROF_NCPL=\$ATM_NCPL
./xmlchange --force GLC_NCPL=\$ATM_NCPL
./xmlchange JOB_QUEUE=regular 
./xmlchange PROJECT=$PROJ
./xmlchange JOB_WALLCLOCK_TIME=03:00:00
./xmlchange STOP_N=1
./xmlchange STOP_OPTION=nyears
./xmlchange RESUBMIT=30


#change namelist settings:
sed -i -e '$a\' user_nl_cam
sed -i -e '$a nhtfrq = 0, -24' user_nl_cam
sed -i -e '$a mfilt = 1, 1' user_nl_cam
sed -i -e '$a ndens = 2, 2' user_nl_cam
sed -i -e '$a fincl2 = \x27U:A\x27,\x27V:A\x27, \x27Q:A\x27, \x27T:A\x27, \x27PS:A\x27, \x27Z500:A\x27, \x27PRECT:A\x27' user_nl_cam

#add Source Mods. 
cp ../Source_Mods_Files/*.F90 $CAM5DIR/SourceMods/src.cam/

## build 
./case.build

# ### CAM 6 Initialization.... ####################
# ### CAM 6 Initialization.... ####################
# ### CAM 6 Initialization.... ####################
# ### CAM 6 Initialization.... ####################
# ### CAM 6 Initialization.... ####################
# ### CAM 6 Initialization.... ####################

/glade/work/francines/my_cesm_sandbox/cime/scripts/create_newcase  --case $CAM6DIR --run-unsupported --compset FHIST  --res f09_g16 --mach cheyenne --project $PROJ

cd $CAM6DIR
./case.setup

# change to CAM6 physics and to 32 levels.

#xml change all of our shit
./xmlchange --force ROF_NCPL=\$ATM_NCPL
./xmlchange --force GLC_NCPL=\$ATM_NCPL
./xmlchange JOB_QUEUE=regular 
./xmlchange PROJECT=$PROJ
./xmlchange JOB_WALLCLOCK_TIME=03:00:00
./xmlchange STOP_N=1
./xmlchange STOP_OPTION=nyears
./xmlchange RESUBMIT=30

#change namelist settings:
sed -i -e '$a\' user_nl_cam
sed -i -e '$a nhtfrq = 0, -24' user_nl_cam
sed -i -e '$a mfilt = 1, 1' user_nl_cam
sed -i -e '$a ndens = 2, 2' user_nl_cam
sed -i -e '$a fincl2 = \x27U:A\x27,\x27V:A\x27, \x27Q:A\x27, \x27T:A\x27, \x27PS:A\x27, \x27Z500:A\x27, \x27PRECT:A\x27' user_nl_cam


#add Source Mods.
## build 
./case.build


cd $CAM6DIR
./case.submit 


cd $CAM5DIR
./case.submit 


