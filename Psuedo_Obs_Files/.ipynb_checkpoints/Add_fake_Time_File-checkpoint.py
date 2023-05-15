import glob
import os
import pandas as pd
import datetime
import shutil

list_of_files = glob.glob('/glade/work/wchapman/pseudoobs_V2/*.nc') # get the latest file in the pseudo obs ...
latest_file = max(list_of_files, key=os.path.getctime)

# Extract the relevant timestamp information from the latest file name
# and calculate a new timestamp with an increment of 6 hours

increment_time_6h = str(pd.to_datetime(latest_file[-19:-9]+' '+str(datetime.timedelta(seconds=float(latest_file[-8:-2]))))+datetime.timedelta(hours=6))

# Extract the time component from the incremented timestamp
ts = str(increment_time_6h)[-8:]

# Convert the time component from HH:MM:SS to seconds
secs = sum(int(x) * 60 ** i for i, x in enumerate(reversed(ts.split(':')))) #change seconds to HH:MM:SS 

print(latest_file)
# Copy the latest file with a modified filename based on the incremented timestamp
shutil.copy(latest_file,latest_file.split('.h1.')[0]+'.h1.'+str(increment_time_6h)[:10]+'-'+f'{secs:05}'+'.nc') #copy files 
