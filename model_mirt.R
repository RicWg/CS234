# CS234 RL MIRT model
# Input .csv file and build 2PL IRT model
# Output saved to .RData file with variables

mypackages = c("mirt")   # required packages
tmp = setdiff(mypackages, rownames(installed.packages()))  # packages need to be installed
if (length(tmp) > 0) install.packages(tmp)
lapply(mypackages, require, character.only = TRUE)

library(mirt)

# Read csv
setwd("~/cs234_RL_Stanford/")
testdata <- read.csv(file="./testdata.csv", header=TRUE, sep=",")

# Clean data and pre-processing
dt = within(testdata, rm('CALL'))
mod = mirt(dt, 2, itemtype='gpcm')

#
MDIFF(mod)
plot(mod)
itemplot(mod)

# fscores(mod, method='MAP', response.pattern = c(1,2,3))



dt = within(pron, rm('CALL'))
dt[dt>0] = 1
dt[dt<0] = 0
write.csv(dt,"pron2_dictomous.csv")

mod_pron = mirt(dt, 1)
item_diff = MDIFF(mod_pron)

fscores(mod2, method='MAP', response.pattern = score)

# example, call = 1385000
call1385000 = dt[1,]

# loop through column not NA
idx = is.na(call1385000)

sc = array(c(NA), dim = 172)
for (i in 1:length(idx)){
  if (!idx[i]) {
    sc = array(c(NA), dim = 172)
    sc[i] = call1385000[i]
    print(i)
    #print(sc[i])
    step = fscores(mod2, method='MAP', response.pattern = sc)
    #print(step)
    print(step[173])
    print(step[174])
  }
}


# 300 day pron pivot, grp 1001-1004, rl_pron_pivot.csv

pronpv <- read.csv(file="./rl_pron_pivot.csv", header=TRUE, sep=",")
dim(pronpv)
#[1] 49876   994

# remove rows with all NA
pronpv = pronpv[rowSums(is.na(pronpv)) != ncol(pronpv),]
dim(pronpv)
# 49876   994

write.csv(pronpv,"pronpv_clean.csv")

# dt = within(pronpv, rm('CALL'))
dt = pronpv[-c(1)]
dt[dt>0] = 1
dt[dt<0] = 0
write.csv(dt,"pronpv_dictomous.csv")

# c
dt = dt[rowSums(is.na(dt)) != ncol(dt),]
mod_pron = mirt(dt, 1)
item_diff = MDIFF(mod_pron)


# 201806 calls
setwd("/Richard/cs234_RL_Stanford/project/code")

pronpv <- read.csv(file="rl_c201806_pron_pivot.csv", header=TRUE, sep=",")
dim(pronpv)
#[1] 43522   725

# remove rows with all NA
pronpv = pronpv[rowSums(is.na(pronpv)) != ncol(pronpv),]
dim(pronpv)
# 49876   994

write.csv(pronpv,"pronpv_clean.csv")

# dt = within(pronpv, rm('CALL'))
dt = pronpv[-c(1)]
dt[dt>0] = 1
dt[dt<0] = 0

dt = subset( dt, select = -c(c_100114,c_100157,c_100172,c_100174,c_1002100,c_1002131,c_1002182,c_1002187,c_1002249,c_1002298,c_1002313,c_1002341,c_100250,c_10028,c_100298,c_1003104,c_100344,c_100349,c_100379,c_100398,c_100399,c_100489) )

write.csv(dt,"pronpv_dictomous.csv")
dim(dt)
# c
dt = dt[rowSums(is.na(dt)) != ncol(dt),]
mod_pron = mirt(dt, 1)
item_diff = MDIFF(mod_pron)

pron_call = subset( pronpv,select = -c(c_100114,c_100157,c_100172,c_100174,c_1002100,c_1002131,c_1002182,c_1002187,c_1002249,c_1002298,c_1002313,c_1002341,c_100250,c_10028,c_100298,c_1003104,c_100344,c_100349,c_100379,c_100398,c_100399,c_100489) )

head(pron_call)


# example, call = 1385000
library(dplyr)
#pronability = data.frame(call=rep(NA,20000),
#                         item=rep(NA,20000),
#                         item_score=rep(NA,20000),
#                         item_scorestd=rep(NA,20000))
pronability = data.frame()

for (j in 1:dim(dt)[1]) {
#for (j in 1:30) {
  callsc = dt[j,]

  # loop through column not NA
  idx = is.na(callsc)

  sc = array(c(NA), dim = dim(idx)[2])
  print(j)
  for (i in 1:length(idx)){
    if (!idx[i]) {
      #sc = array(c(NA), dim = dim(idx)[2])
      sc[i] = callsc[i]
      respsc = list()
      #print(i)
      #print(sc[i])
      step = fscores(mod_pron, method='MAP', response.pattern = sc)
      #print(step)
      
      respsc = data.frame(
        call = pron_call[j,]$call,
        item = colnames(callsc[i]),
        items_score = as.numeric(step[length(step)-1]),
        item_scorestd = as.numeric(step[length(step)]) )
      
      #print(paste("score=",step[length(step)-1], " , std=", 
      #       step[length(step)], sep = " "))
      
      #print(respsc)
      pronability = bind_rows(pronability,respsc)
      }
    }
}

print(pronability)

# single response score/stc, not done for all
write.csv(pronability_single, 'pron_score_singlestd.csv')
write.csv(pronability, 'pron_score_accumulated.csv')
write.csv(item_diff, 'item_diff.csv')

# join with item_diff
library(data.table)
item_diff_df = setDT(as.data.frame(item_diff), keep.rownames = "item")[]   

c1335_diff = merge(c1335, item_diff_df, by="item")

c1335_single = pronability_single[1:25,]
c1335_single_diff = merge(c1335_single, item_diff_df, by="item")

# try some policies, with different actions

plc1 = data.frame()

#for (j in 1:dim(dt)[1]) {
for (j in 1:1) {
  callsc = dt[j,]
  
  # loop through column not NA
  idx = is.na(callsc)
  
  sc = array(c(NA), dim = dim(idx)[2])
  print(j)
  for (i in length(idx):1){
    if (!idx[i]) {
      #sc = array(c(NA), dim = dim(idx)[2])
      sc[i] = callsc[i]
      respsc = list()
      #print(i)
      #print(sc[i])
      step = fscores(mod_pron, method='MAP', response.pattern = sc)
      #print(step)
      
      respsc = data.frame(
        call = pron_call[j,]$call,
        item = colnames(callsc[i]),
        items_score = as.numeric(step[length(step)-1]),
        item_scorestd = as.numeric(step[length(step)]) )
      
      #print(paste("score=",step[length(step)-1], " , std=", 
      #       step[length(step)], sep = " "))
      
      #print(respsc)
      plc1 = bind_rows(plc1,respsc)
    }
  }
}

print(plc1)

write.csv(c1335, 'c1335.csv')
