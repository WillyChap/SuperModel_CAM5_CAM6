# SuperModel_CAM5_CAM6

### note: This really only works on Cheyenne / NCAR machines at the moment. ... 
This is a repo to run a CAM5/CAM6 super model with [CYLC](https://cylc.github.io/). Leveraging a custom made Relaxation tool box. 

### TO USE...First Change all the path names in: 
 - ./init_models.sh
 - ./cylc/super_cam5cam6/*
 - ./Peudo_obs_files/*

-- you should be able to just search and replace "wchapman"


## To run the super model
First run:

- bash init_model.sh

then run the cylc process: 

- 'HOW_TO_RUN_CYLC.txt' should give you some steps to do so... the syntax is weird. 
