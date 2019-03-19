# CS234 RL 2019
# Generate graphs for all policies

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# MAB baseline random
plt.figure()
dt = pd.read_csv("~/cs234_RL_Stanford/exp_mab_random.csv", index_col=None)
dt = np.array(dt)[:,1:101]

# multiple line plot
for i in range(dt.shape[1]):
  p1 = plt.plot(1-dt[:,i], color='grey', linewidth=0.8, alpha=0.9)

# plot mean
dt_mean_random = np.mean(dt, axis=1)
p2 = plt.plot(1-dt_mean_random, color='red', linewidth=2, alpha=0.9)

plt.legend((p1[0], p2[0]), ('Episodes', 'Mean'))
plt.title("Regret vs items", loc='center', fontsize=12, fontweight=0, color='black')
plt.xlabel("Items")
plt.ylabel("Regret")
plt.grid()
plt.savefig('mab_random_reg.png')
#plt.show()


# MAB optimal policy
plt.figure()
dt = pd.read_csv("~/cs234_RL_Stanford/exp_mab_optimalbound.csv",
                 index_col=None)
dt = np.array(dt)[:,1:101]

# multiple line plot
for i in range(dt.shape[1]):
  p1 = plt.plot(1-dt[:,i], color='grey', linewidth=0.8, alpha=0.9)

# plot mean
dt_optimal_max = np.max(dt, axis=1)
p2 = plt.plot(1-dt_optimal_max, color='red', linewidth=2, alpha=0.9)

plt.legend((p1[0], p2[0]), ('Episodes', 'optimal'))
plt.title("Return vs items", loc='center', fontsize=12, fontweight=0, color='black')
plt.xlabel("Items")
plt.ylabel("Regret")
plt.grid()
plt.savefig('mab_optimal_bound_reg.png')
#plt.show()


# MAB probablity matching, 2 cases, -0.5 and 0.2
plt.figure()
dt = pd.read_csv("~/cs234_RL_Stanford/exp_mab_probmatching_-0.5.csv",
                 index_col=None)
# dt = pd.read_csv("~/cs234_RL_Stanford/exp_mab_probmatching_0.2.csv",
#                  index_col=None)
dt = np.array(dt)[:,1:101]

# multiple line plot
for i in range(dt.shape[1]):
  p1 = plt.plot(1-dt[:,i], color='grey', linewidth=0.8, alpha=0.9)

# plot mean
dt_ts_05 = np.mean(dt, axis=1)
p2 = plt.plot(1-dt_ts_05, color='red', linewidth=2, alpha=0.9)

dt = pd.read_csv("~/cs234_RL_Stanford/exp_mab_probmatching_0.2.csv",
                 index_col=None)
dt = np.array(dt)[:,1:101]
dt_ts_02 = np.mean(dt, axis=1)
p3 = plt.plot(1-dt_ts_02, color='green', linewidth=2, alpha=0.9)


plt.legend((p1[0], p2[0], p3[0]), ('Episodes', 'Mean TS0', 'Mean TS1'))
plt.title("Return vs items", loc='center', fontsize=12, fontweight=0, color='black')
plt.xlabel("Items")
plt.ylabel("Regret")
plt.grid()
plt.savefig('mab_TS_reg.png')
#plt.show()

# MAB Multistage
plt.figure()
dt = pd.read_csv("~/cs234_RL_Stanford/exp_mab_multistage.csv",
                 index_col=None)
dt = np.array(dt)[:,1:101]

# multiple line plot
for i in range(dt.shape[1]):
  p1 = plt.plot(1-dt[:,i], color='grey', linewidth=0.8, alpha=0.9)

dt_mean_multistg = np.mean(dt, axis=1)
p2 = plt.plot(1-dt_mean_multistg, color='red', linewidth=2, alpha=0.9)

plt.legend((p1[0], p2[0]), ('Episodes', 'Mean'))
plt.title("Return vs items", loc='center', fontsize=12, fontweight=0, color='black')
plt.xlabel("Items")
plt.ylabel("Regret")
plt.grid()
plt.savefig('../mab_multistage_reg.png')
#plt.show()

# MAB policy: monotonic
plt.figure()
dt = pd.read_csv("~/cs234_RL_Stanford/exp_mab_mono.csv",
                 index_col=None)
dt = np.array(dt)[:,1:101]

# multiple line plot
for i in range(dt.shape[1]):
  p1 = plt.plot(1-dt[:,i], color='grey', linewidth=0.8, alpha=0.9)

# plot mean
dt_mean_eh = np.mean(dt, axis=1)
p2 = plt.plot(1-dt_mean_eh, color='red', linewidth=2, alpha=0.9)

plt.legend((p1[0], p2[0]), ('Episodes', 'Mean'))
plt.title("Regret vs items", loc='center', fontsize=12, fontweight=0, color='black')
plt.xlabel("Items")
plt.ylabel("Regret")
plt.grid()
plt.savefig('mab_easytohard_reg.png')
#plt.show()

# baseline

'''
dt = pd.read_csv("//Richard/cs234_RL_Stanford/project/code/pron_score_accumulated.csv",
                 index_col=None)

dt_mean = np.array(dt['items_score'])[0:2500].reshape(25, 100, order='F')
dt_mean = np.mean(dt_mean, axis=1)
dt_std = np.array(dt['item_scorestd'])[0:2500].reshape(25, 100, order='F')
dt_std = np.mean(dt_std, axis=1)
plt.errorbar(range(1,26), dt_mean, dt_std, marker='o', color='b',capsize=2)

plt.title("Regret vs items", loc='center', fontsize=12, fontweight=0, color='black')
plt.xlabel("Items")
plt.ylabel("Ability")
plt.grid()
#plt.savefig('../ability_items.png')
#plt.show()

'''

# Comparison of all policies
plt.figure()
dts = np.array([1-dt_mean_random, 1-dt_mean_eh, 1-dt_mean_multistg, 1-dt_ts_02, 1-dt_ts_05, 1-dt_optimal_max]).T
plt.plot(dts, linewidth=3)
plt.grid()
plt.legend(('Baseline', 'Monotonic', 'Multistage', 'TS_02', 'TS_05', 'Oracle'))

plt.xlabel("Items");\
plt.ylabel("Regret");\
plt.savefig('policy_comparison_reg.png')
#plt.show()
