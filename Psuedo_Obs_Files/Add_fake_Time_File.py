import glob
import os
import pandas as pd
import datetime
import shutil

list_of_files = glob.glob('/glade/work/francines/pseudoobs/*.nc') # get the latest file in the pseudo obs ...
latest_file = max(list_of_files, key=os.path.getctime)

#latest_file='/glade/scratch/wchapman/inputdata/nudging/ERAI_fv09/L32/ERAI_fv09.cam2.i.1979-01-05-21600.nc'

increment_time_6h = str(pd.to_datetime(latest_file[-19:-9]+' '+str(datetime.timedelta(seconds=float(latest_file[-8:-2]))))+datetime.timedelta(hours=6))
ts = str(increment_time_6h)[-8:]
secs = sum(int(x) * 60 ** i for i, x in enumerate(reversed(ts.split(':'))))
print(latest_file)
shutil.copy(latest_file,latest_file.split('.h1.')[0]+'.h1.'+str(increment_time_6h)[:10]+'-'+str(secs)+'.nc')
