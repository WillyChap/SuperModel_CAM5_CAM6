## import glob
import os
import pandas as pd
import datetime
import shutil

store_combined_path = '/glade/scratch/wchapman/store_super_cam5_cam6/'
dir_search = '/glade/work/wchapman/pseudoobs_V2/*.nc'


list_of_files = sorted(glob.glob(dir_search)) # get the latest file in the pseudo obs ...
latest_file = max(list_of_files, key=os.path.getctime)

#time stamp latest files
ts_latest= pd.to_datetime(latest_file[-19:-9]+' '+str(datetime.timedelta(seconds=float(latest_file[-8:-2]))))

mv_dict={}
for fn in sorted(glob.glob(dir_search)):
    try: 
        time_file = pd.to_datetime(fn[-19:-9]+' '+str(datetime.timedelta(seconds=float(fn[-8:-2]))))
        mv_dict[time_file]=fn
        print(fn)
        #move the file if they are four days older than the current time
        if time_file<(ts_latest - datetime.timedelta(days=3)):
            #save the combined states, discard the h1 files (they are repeated in the scract)
            if 'test_pseudoobs_UVT' in fn:
                if not os.path.exists(store_combined_path):
                    os.makedirs(store_combined_path)
                shutil.move(fn,store_combined_path+os.path.basename(fn))
            else:
                os.remove(fn)
                
    except ValueError:
        print('file name is: ',fn)
        print('NC file in the work directory cannot be moved')