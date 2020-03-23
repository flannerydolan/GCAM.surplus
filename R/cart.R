#library(rpart)
#library(rpart.plot)
###############################################################################
# This script shows how CART was used in this study using the rpart package

# after reading in data and naming it dat

# we don't want to take time into account, so filter for a specific timestep as well as the basin of interest
load('data/sur.rda')


sur %>% dplyr::filter(year==2100,basin=='Indus') -> indus

# convert columns to factors so that CART splits aren't sequential

indus$ssp <- as.factor(indus$ssp)
indus$soc<-as.factor(indus$soc)
indus$ag<-as.factor(indus$ag)
indus$gw <- as.factor(indus$gw)
indus$res<-as.factor(indus$res)
indus$esm<-as.factor(indus$esm)
indus$tax<-as.factor(indus$tax)

# the column to run CART on goes first followed by a tilda and a period
# the method can either be 'class' for classification or 'anova' for the regression method
# in control you can say how many levels you want, how big of a group needed before performing a split, etc.
# lower levels of cp will give you more splits, it's a sort of error tolerance

cart<-rpart(netsurplus~.,data=indus,method='class',control=c(minsplit=20,maxdepth=4),cp=.001)

# you can play with different types of plots (1-5 I think), fallen.leaves=T will have all the leaves go to the bottom in the same row


#rpart.plot(cart,type=5,fallen.leaves=F)
