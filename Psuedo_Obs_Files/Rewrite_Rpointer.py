## import glob
import os
import pandas as pd
import datetime
import shutil


cam5_path = '/glade/scratch/wchapman/CAM5_32levs/run/'
cam6_path = '/glade/scratch/wchapman/CAM6_f09_g16/run/'

for dat_path in sorted(glob.glob(cam5_path+'/rpointer*')):
    with open(dat_path, 'r') as file:
        data = file.read().replace('\n', '')
    rpoint_dat_cam5 = data.split('.')[-2]
    
cam5_rpoint = pd.to_datetime(rpoint_dat_cam5[-19:-9]+' '+str(datetime.timedelta(seconds=float(rpoint_dat_cam5[-5:]))))

for dat_path in sorted(glob.glob(cam6_path+'/rpointer*')):
    with open(dat_path, 'r') as file:
        data = file.read().replace('\n', '')
    rpoint_dat_cam6 = data.split('.')[-2]
    
cam6_rpoint = pd.to_datetime(rpoint_dat_cam6[-19:-9]+' '+str(datetime.timedelta(seconds=float(rpoint_dat_cam6[-5:]))))
print('cam5 rpoiner: ',cam5_rpoint)
print('cam6 rpoiner: ',cam6_rpoint)


#logical to see what is smaller. 
if cam5_rpoint <= cam6_rpoint:
    cam_replace = cam5_rpoint
else:
    cam_replace = cam6_rpoint
    
# Extract the time component from the incremented timestamp
ts = str(cam_replace)[-8:]
# Convert the time component from HH:MM:SS to seconds
secs = sum(int(x) * 60 ** i for i, x in enumerate(reversed(ts.split(':')))) #change seconds to HH:MM:SS 

cam_replace_str = str(cam_replace)[:10]+'-'+f'{secs:05}'

for dat_path in sorted(glob.glob(cam5_path+'/rpointer*')):
    with open(dat_path, 'r') as file:
        data = file.read()
        data = data.replace(rpoint_dat_cam5, cam_replace_str)
    
    with open(dat_path, 'w') as file:
        # Writing the replaced data in our
        # text file
        file.write(data)
# Printing Text replaced
print("Text replaced cam5")

for dat_path in sorted(glob.glob(cam6_path+'/rpointer*')):
    with open(dat_path, 'r') as file:
        data = file.read()
        data = data.replace(rpoint_dat_cam6, cam_replace_str)
    
    with open(dat_path, 'w') as file:
        # Writing the replaced data in our
        # text file
        file.write(data)
# Printing Text replaced
print("Text replaced cam6")