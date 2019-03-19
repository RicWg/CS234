# CS234 RL MIRT model 2019
# Input .csv file and build 2PL IRT model
# Output saved to .RData file with variables
# Probablity used to plot and generate prior prob for Probablity Matching

mypackages = c("mirt", "rlist")   # required packages
tmp = setdiff(mypackages, rownames(installed.packages()))  # packages need to be installed
if (length(tmp) > 0) install.packages(tmp)
lapply(mypackages, require, character.only = TRUE)

library(mirt)
library(dplyr)
library(rlist)
library(data.table)

# Read csv
setwd("~/cs234_RL_Stanford/")
testdata <- read.csv(file="./rl_testdata.csv", header=TRUE, sep=",")

# Clean data and pre-processing
dt = within(testdata, rm('CALL'))
dt = dt[rowSums(is.na(dt)) != ncol(dt),]
dt[dt>0] = 1
dt[dt<0] = 0

# Reselect valid items (after IRT model screening)
dt = subset( dt, select = -c(c_100114,c_100157,c_100172,c_100174,c_1002100,c_1002131,c_1002182,c_1002187,c_1002249,c_1002298,c_1002313,c_1002341,c_100250,c_10028,c_100298,c_1003104,c_100344,c_100349,c_100379,c_100398,c_100399,c_100489) )
write.csv(dt,"testdata_dictomous.csv")

# Build 2PL model with gpcm
mod_rl = mirt(dt, 2, itemtype='gpcm')
item_diff = MDIFF(mod_pron)

# Convert training data into IRT scores
pronability = data.frame()

for (j in 1:dim(dt)[1]) {
  callsc = dt[j,]

  # loop through column not NA
  idx = is.na(callsc)

  sc = array(c(NA), dim = dim(idx)[2])
  print(j)
  for (i in 1:length(idx)){
    if (!idx[i]) {
      sc[i] = callsc[i]
      respsc = list()
      step = fscores(mod_pron, method='MAP', response.pattern = sc)
      
      respsc = data.frame(
        call = pron_call[j,]$call,
        item = colnames(callsc[i]),
        items_score = as.numeric(step[length(step)-1]),
        item_scorestd = as.numeric(step[length(step)]) )
      pronability = bind_rows(pronability,respsc)
      }
    }
}

# Join with item_diff
df_item_diff = setDT(as.data.frame(item_diff), keep.rownames = "item")[]   
pronability_diff = merge(pronability, df_item_diff, by="item")

write.csv(pronability, 'irt_score_accumulated.csv')
write.csv(item_diff, 'item_diff.csv')

# Save enviroment, variable mod_irt
save(file = "./rl_irt.RData")
