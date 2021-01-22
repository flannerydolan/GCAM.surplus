#library(dplyr)
#library(gcammaptools)
#library(ggplot2)
#library(schoolmath)
#library(cowplot)
#library(gridExtra)
#library(ggpubr)
##############################################################################################################
## A

# make map of physical scarcity, mean over scenario, max over time

################load data
load('data/with.rda')
load('data/supply.rda')
load('data/sur.rda')

source('R/process_query.R')
#####################


supply %>% dplyr::select(-subresource)-> supply
supply$basin=substr(supply$basin,1,nchar(supply$basin)-18)
supply %>% dplyr::group_by(scenario,basin,year) %>% dplyr::summarize(value=sum(value)) -> supply
supply %>% dplyr::left_join(with,by=c("ssp","soc","ag","gw","res","esm","tax","basin","year")) -> scarcity

# calculate Water Scarcity Index as withdrawals over runoff

scarcity %>% dplyr::mutate(scarcity=value.y/value.x)-> scarcity

# use the maximum value of scarcity over time

scarcity %>% dplyr::group_by(basin,ssp,soc,ag,gw,res,esm,tax) %>% dplyr::summarise(scarcity=max(scarcity)) -> mst

# use the maximum value of impact over time
sur  %>% mutate(netsurplus=netsurplus*4.82)->sur #convert to 2020$
sur %>% dplyr::group_by(basin,ssp,soc,ag,gw,res,esm,tax) %>% dplyr::slice(netsurplus=which.max(abs(netsurplus))) -> msurt


# make character columns numeric

mst %>% ungroup() -> mst


mst$soc=as.numeric(mst$soc)
mst$ag=as.numeric(mst$ag)

msurt$soc=as.numeric(msurt$soc)
msurt$ag=as.numeric(msurt$ag)

# use the median across all scenarios

mst %>% group_by(basin) %>% summarize(scarcity=median(scarcity)) -> medscarce


# prepare data for plotting
medscarce=as.data.frame(medscarce)
medscarce$region=medscarce$basin
medscarce<-add_region_ID(medscarce,lookupfile = 'data/lookup_basin.txt')

# create discrete levels

medscarce %>% mutate(level=ifelse(scarcity<.2,"1",ifelse(scarcity<.4,"2",ifelse(scarcity<1,"3","4")))) -> medscarce

#plot scarcity
p1<-plot_GCAM(map.basin235,col='level',gcam_df = medscarce,legend=T,proj=robin,gcam_key = 'id') + ggplot2::scale_fill_manual(breaks=c("Low","Medium","High","Extreme"),values=c("olivedrab3","gold1","darkorange","darkred"),na.value=gray(.5))


#################################################################################################################################

## B

# make map of surplus, max absolute value over time, mean over sceanario


msurt %>% group_by(basin) %>% summarize(netsurplus=median(netsurplus)) -> medsur

# calculate log modulus
medsur %>% mutate(Log_Modulus=sign(netsurplus)*log10(abs(netsurplus)+1))->medsur


# prepare data for plotting
medsur=as.data.frame(medsur)
medsur$region=medsur$basin
medsur<-add_region_ID(medsur,lookupfile = 'data/lookup_basin.txt')
medsur=na.omit(medsur)

# make discrete levels

medsur %>% mutate(level=ifelse(Log_Modulus > 0,"1",ifelse(Log_Modulus>-.5,"2",ifelse(Log_Modulus>-1,"3","4")))) -> medsur


# plot

p2<-plot_GCAM(map.basin235,col='level',gcam_df = medsur,legend=T,proj=robin,gcam_key = 'id') +
  ggplot2::scale_fill_manual(breaks=c("Low","Medium","High","Extreme"),values=c("olivedrab3","gold1","darkorange","darkred"),na.value=gray(.5))


##################################################################

# C

# join physical metric and impact
mst %>% dplyr::left_join(msurt,by=c("basin",'ssp','soc','ag','gw','res','esm','tax')) -> j

# convert impact to log modulus of impact
j %>% dplyr::mutate(Log_Modulus=sign(netsurplus)*log10(abs(netsurplus)+1))->j

# use highlighted basins
j %>% dplyr::filter(basin=="Arabian Peninsula"| basin=="Indus" |basin=="Lower Colorado River" |basin=="Orinoco") -> jf


#plot
p3<-ggplot(jf,aes(Log_Modulus,scarcity,color=basin))+geom_point(size=1)+theme_classic()+
  ylab('Physical Water Scarcity')+xlab('Log-Modulus of Impact')+
  theme(legend.box.background = element_rect(colour = "black"),legend.background = element_blank(),text=element_text(size=14),axis.text=element_text(size=14), legend.position = c(.75,.85))




gt <- arrangeGrob(p3,                               
                  p1, p2,
                  ncol = 2, nrow = 2,
                  layout_matrix = rbind(c(1,2), c(1,3)))


p<-as_ggplot(gt) +                                
  draw_plot_label(label = c("A", "B", "C"), size = 15,x = c(0, 0.5, 0.5), y = c(1, 1, 0.5)) # Add labels


p
ggsave('Figure1.pdf',p,dpi=300, height=6, width = 10.5)

