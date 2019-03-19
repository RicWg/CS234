# CS234 RL 2019
# Convert test data into pivot form

import pandas as pd
import numpy as np

dt = pd.read_csv("~/cs234_RL_Stanford/rl_testdata.csv")
dt.columns = ["call", "response", "grp", "ansitem", "time", "mscore"]
dt['item'] = 'c_' + dt['grp'].astype(str) + dt['ansitem'].astype(str)

dtpv = pd.pivot_table(dt, index = ["call"], columns=["item"],values=[ "mscore"])

dtpv.columns = dtpv.columns.levels[1].values
dtpv.to_csv('rl_testdata_pivot.csv', header=True, index=True)

