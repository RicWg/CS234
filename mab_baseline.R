# CS234 RL 2019
# Multi-armed bandit(MAB) Baseline: random action

mypackages = c("mirt", "rlist", "gtools")   
tmp = setdiff(mypackages, rownames(installed.packages()))  
if (length(tmp) > 0) install.packages(tmp)
lapply(mypackages, require, character.only = TRUE)

require(ggplot2)
library(dplyr)

setwd("~/cs234_RL_Stanford/")
pronability = read.csv('rl_score_accumulated.csv', header=TRUE, sep=",")
item_diff = read.csv('item_diff.csv', header=TRUE, sep=",")

# Load IRT model from env
load('rl_irt.RData')  

p_ability = data.frame()
window_size = 8
num_episod = 1 #100
for (j in 1:dim(dt)[1]) {
#for (j in 1:300) {
  callsc = dt[j,]
  
  # loop through column withnot NA
  idx = is.na(callsc)
  pos = which(idx %in% c(FALSE))
  print(j)
  
  # generate sequences of pos
  for (k in 1:num_episod){
    sc = array(c(NA), dim = dim(dt)[2])
    # random action for every state
    seq_pos = sample(pos)
    for (i in 1:length(pos)) {
      #sc = array(c(NA), dim = dim(idx)[2])
      p = seq_pos[i]
      sc[p] = callsc[p]
      
      # reset sc[i - window_size] to NA, only use scores in window to calculate
      if (i > window_size) {
        sc[seq_pos[i-window_size]] = NA
      }
      
      respsc = list()
      step = fscores(mod_irt, method='MAP', response.pattern = sc)
      
      respsc = data.frame(
        call = pron_call[j,]$call,
        item = colnames(callsc[p]),
        items_score = as.numeric(step[length(step)-1]),
        item_scorestd = as.numeric(step[length(step)]) )

      p_ability = bind_rows(p_ability,respsc)
    }
  }
}
#print(p_ability)

dtm = matrix(p_ability[,'items_score'], nrow=25)
dtm_mean = melt(data.frame(rowSums(dtm))/n)

# check mean
p = ggplot() + 
  geom_line(data=melt(dtm), aes(x = Var1, y = value, group = Var2)) +
  xlab('Items') + ylab('Ability') +
  geom_line(aes(x = c(1:25), y = dtm_mean['value'], colour='red')) + geom_line(size=2)
print(p)

# check std
dtm_std = melt(matrix(p_ability[,'item_scorestd'], nrow=25))
p = ggplot() + 
  geom_line(data=dtm_std, aes(x = Var1, y = value, group = Var2)) +
  xlab('Items') + ylab('Score by window') 
print(p)

# check reward
dtm_reward = matrix(p_ability[,'item_scorestd'], nrow=25)
for (j in 2:25){
  dtm_reward[j,] = dtm_reward[1,] - dtm_reward[j,] 
}
dtm_reward[1,] = 0.0

dtrew_std = melt(data.frame(rowSums(dtm_reward))/dim(dtm_reward)[2])
p = ggplot() + 
  geom_line(data=melt(dtm_reward), aes(x = X1, y = value, group = X2)) +
  xlab('Items') + ylab('Return') +
  geom_line(aes(x = c(1:25), y = dtrew_std['value'], colour='red')) 
print(p)

# output to csv for pyplot
write.csv(dtm_reward, 'mab_random.csv')
