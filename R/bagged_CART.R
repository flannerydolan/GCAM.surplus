#library(rpart)
#library(rpart.plot)
#library(dplyr)

##########################################################################
# modified from https://www.r-bloggers.com/2017/06/machine-learning-explained-bagging/

df %>% group_by(basin,ssp,soc,ag,gw,res,esm,tax) %>% summarize(netsurplus=sum(netsurplus)) -> summed
#aggregate over whatever dimensions should not be included in analysis. here we are summing over time.

summed %>% filter(basin=="Arabian Peninsula") -> ap

# factorize inputs so splits do not have to be sequential

ap$soc=as.factor(ap$soc)
ap$ag=as.factor(ap$ag)
ap$ssp=as.factor(ap$ssp)
ap$gw=as.factor(ap$gw)
ap$res=as.factor(ap$res)
ap$esm=as.factor(ap$esm)
ap$tax=as.factor(ap$tax)

##Training data

##Training of the bagged model
n_model=500
bagged_models=list()
for (i in 1:n_model)
{
  train_index=sample.int(nrow(ap),size=round(nrow(ap)*0.6),replace = T)

  bagged_models=c(bagged_models,list(rpart(netsurplus~.,ap[train_index,],control=rpart.control(minsplit=6))))
}
##Getting estimate from the bagged model
bagged_result=NULL
i=0
for (from_bag_model in bagged_models)
{
  if (is.null(bagged_result))
    bagged_result=predict(from_bag_model,ap)
  else
    bagged_result=(i*bagged_result+predict(from_bag_model,ap))/(i+1)
  i=i+1
}

ap %>% select(-netsurplus)->bagdat

bagged<-rpart(bagged_result~.,data=bagdat,method='anova',control=c(maxdepth=4),cp=.000001)

bagged$frame$var


rpart.plot(bagged)

# to remake Figure 12, use bagged$frame$var[1] for all basins
