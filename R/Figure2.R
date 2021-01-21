#library(zoo)
#library(dplyr)
#library(ggplot2)
#library(gridExtra)

########################
# Generate Figure 2

###################### load data
load('data/esm_uncert.rda')
#######################

#find the scenarios with the maximum and minimum mean uncertainty of impact over time 
esm_uncert %>% dplyr::group_by(basin,ssp,soc,ag,gw,res,tax)%>% dplyr::summarize(mean=mean(impact_max-impact_min,na.rm = T)) %>% 
  dplyr::group_by(basin) %>% dplyr::slice(which.max(mean)) -> maxmean


#min human uncertainty
esm_uncert %>% dplyr::filter(basin=="Arabian Peninsula",ssp==1,soc==4,ag==3,gw==2,res==2,tax==1)->apmin
esm_uncert %>% dplyr::filter(basin=="Indus",ssp==1,soc==1,ag==4,gw==2,res==1,tax==1)->indusmin
esm_uncert %>% dplyr::filter(basin=="Orinoco",ssp==1,soc==4,ag==3,gw==3,res==2,tax==1)->ormin
esm_uncert %>% dplyr::filter(basin=="Lower Colorado River",ssp==1,soc==4,ag==3,gw==3,res==2,tax==1)->locomin



# linearly interpolate from the first timestep to 2015 and smooth

max1<-rollmeanr(ifelse(apmin$impact_max>apmin$impact_min,apmin$impact_max,apmin$impact_min),3,na.pad=T)
min1<-rollmeanr(ifelse(apmin$impact_min<apmin$impact_max,apmin$impact_min,apmin$impact_max),3,na.pad=T)
max1[1]=0
min1[1]=0
na.approx(max1)->max1
na.approx(min1)->min1

max2<-rollmeanr(ifelse(indusmin$impact_max>indusmin$impact_min,indusmin$impact_max,indusmin$impact_min),3,na.pad=T)
min2<-rollmeanr(ifelse(indusmin$impact_min<indusmin$impact_max,indusmin$impact_min,indusmin$impact_max),3,na.pad=T)
max2[1]=0
min2[1]=0
na.approx(max2)->max2
na.approx(min2)->min2

max3<-rollmeanr(ifelse(ormin$impact_max>ormin$impact_min,ormin$impact_max,ormin$impact_min),3,na.pad=T)
min3<-rollmeanr(ifelse(ormin$impact_min<ormin$impact_max,ormin$impact_min,ormin$impact_max),3,na.pad=T)
max3[1]=0
min3[1]=0
na.approx(max3)->max3
na.approx(min3)->min3

max4<-rollmeanr(ifelse(locomin$impact_max>locomin$impact_min,locomin$impact_max,locomin$impact_min),3,na.pad=T)
min4<-rollmeanr(ifelse(locomin$impact_min<locomin$impact_max,locomin$impact_min,locomin$impact_max),3,na.pad=T)
max4[1]=0
min4[1]=0
na.approx(max4)->max4
na.approx(min4)->min4

# plot uncertainties

p1<-ggplot(apmin,aes(year,runoff_max))+geom_line(aes(y=runoff_min),color="red")+geom_line(aes(y=runoff_max),color="red")+theme_classic()+
  geom_ribbon(aes(ymin=runoff_min,ymax=runoff_max),fill="red",alpha="0.4")+
  geom_line(aes(y=min1),color="blue")+ggtitle('Arabian Peninsula')+
  geom_line(aes(y=max1),color="blue")+ theme(legend.title=element_blank())+
  geom_ribbon(aes(ymin=min1,ymax=max1),fill="blue",alpha="0.4")+ylab("Relative Uncertainty")+theme_classic()

p2<-ggplot(indusmin,aes(year,runoff_max))+geom_line(aes(y=runoff_min),color="red")+geom_line(aes(y=runoff_max),color="red")+theme_classic()+
  geom_ribbon(aes(ymin=runoff_min,ymax=runoff_max),fill="red",alpha="0.4")+
  geom_line(aes(y=min2),color="blue")+ggtitle('Indus')+
  geom_line(aes(y=max2),color="blue")+
  geom_ribbon(aes(ymin=min2,ymax=max2),fill="blue",alpha="0.4")+ylab("Relative Uncertainty")+theme_classic()

p3<-ggplot(ormin,aes(year,runoff_max))+geom_line(aes(y=runoff_min),color="red")+geom_line(aes(y=runoff_max),color="red")+theme_classic()+
  geom_ribbon(aes(ymin=runoff_min,ymax=runoff_max),fill="red",alpha="0.4")+
  geom_line(aes(y=min3),color="blue")+ggtitle('Orinoco')+
  geom_line(aes(y=max3),color="blue")+
  geom_ribbon(aes(ymin=min3,ymax=max3),fill="blue",alpha="0.4")+ylab("Relative Uncertainty")+theme_classic()

p4<-ggplot(locomin,aes(year,runoff_max))+geom_line(aes(y=runoff_min),color="red")+geom_line(aes(y=runoff_max),color="red")+theme_classic()+
  geom_ribbon(aes(ymin=runoff_min,ymax=runoff_max),fill="red",alpha="0.4")+
  geom_line(aes(y=min4),color="blue")+ggtitle('Lower Colorado River')+
  geom_line(aes(y=max4),color="blue")+
  geom_ribbon(aes(ymin=min4,ymax=max4),fill="blue",alpha="0.4")+ylab("Relative Uncertainty")+theme_classic()

p<-ggarrange(p1,p2,p3,p4,nrow=2,ncol=2,labels=c('A','B','C','D'))

ggsave('min_human_uncertainty.png',p,dpi=300)



#max human uncertainty
esm_uncert %>% filter(basin=="Arabian Peninsula",ssp==2,soc==5,ag==3,gw==1,res==1,tax==2)->apmax
esm_uncert %>% filter(basin=="Indus",ssp==2,soc==2,ag==4,gw==2,res==2,tax==2)->indusmax
esm_uncert %>% filter(basin=="Orinoco",ssp==2,soc==2,ag==4,gw==1,res==1,tax==1)->ormax
esm_uncert %>% filter(basin=="Lower Colorado River",ssp==2,soc==5,ag==4,gw==1,res==1,tax==2)->locomax



# linearly interpolate from the first timestep to 2015 and smooth

max5<-rollmeanr(ifelse(apmax$impact_max>apmax$impact_min,apmax$impact_max,apmax$impact_min),3,na.pad=T)
min5<-rollmeanr(ifelse(apmax$impact_min<apmax$impact_max,apmax$impact_min,apmax$impact_max),3,na.pad=T)
max5[1]=0
min5[1]=0
na.approx(max5)->max5
na.approx(min5)->min5

max6<-rollmeanr(ifelse(indusmax$impact_max>indusmax$impact_min,indusmax$impact_max,indusmax$impact_min),3,na.pad=T)
min6<-rollmeanr(ifelse(indusmax$impact_min<indusmax$impact_max,indusmax$impact_min,indusmax$impact_max),3,na.pad=T)
max6[1]=0
min6[1]=0
na.approx(max6)->max6
na.approx(min6)->min6

max7<-rollmeanr(ifelse(ormax$impact_max>ormax$impact_min,ormax$impact_max,ormax$impact_min),3,na.pad=T)
min7<-rollmeanr(ifelse(ormax$impact_min<ormax$impact_max,ormax$impact_min,ormax$impact_max),3,na.pad=T)
max7[1]=0
min7[1]=0
na.approx(max7)->max7
na.approx(min7)->min7

max8<-rollmeanr(ifelse(locomax$impact_max>locomax$impact_min,locomax$impact_max,locomax$impact_min),3,na.pad=T)
min8<-rollmeanr(ifelse(locomax$impact_min<locomax$impact_max,locomax$impact_min,locomax$impact_max),3,na.pad=T)
max8[1]=0
min8[1]=0
na.approx(max8)->max8
na.approx(min8)->min8

# plot uncertainties

p5<-ggplot(apmax,aes(year,runoff_max))+geom_line(aes(y=runoff_min),color="red")+geom_line(aes(y=runoff_max),color="red")+theme_classic()+
  geom_ribbon(aes(ymin=runoff_min,ymax=runoff_max),fill="red",alpha="0.4")+
  geom_line(aes(y=min5),color="blue")+ggtitle('Arabian Peninsula')+
  geom_line(aes(y=max5),color="blue")+ theme(legend.title=element_blank())+
  geom_ribbon(aes(ymin=min5,ymax=max5),fill="blue",alpha="0.4")+ylab("Relative Uncertainty")+theme_classic()

p6<-ggplot(indusmax,aes(year,runoff_max))+geom_line(aes(y=runoff_min),color="red")+geom_line(aes(y=runoff_max),color="red")+theme_classic()+
  geom_ribbon(aes(ymin=runoff_min,ymax=runoff_max),fill="red",alpha="0.4")+
  geom_line(aes(y=min6),color="blue")+ggtitle('Indus')+
  geom_line(aes(y=max6),color="blue")+
  geom_ribbon(aes(ymin=min6,ymax=max6),fill="blue",alpha="0.4")+ylab("Relative Uncertainty")+theme_classic()

p7<-ggplot(ormax,aes(year,runoff_max))+geom_line(aes(y=runoff_min),color="red")+geom_line(aes(y=runoff_max),color="red")+theme_classic()+
  geom_ribbon(aes(ymin=runoff_min,ymax=runoff_max),fill="red",alpha="0.4")+
  geom_line(aes(y=min7),color="blue")+ggtitle('Orinoco')+
  geom_line(aes(y=max7),color="blue")+
  geom_ribbon(aes(ymin=min7,ymax=max7),fill="blue",alpha="0.4")+ylab("Relative Uncertainty")+theme_classic()

p8<-ggplot(locomax,aes(year,runoff_max))+geom_line(aes(y=runoff_min),color="red")+geom_line(aes(y=runoff_max),color='red')+
  geom_ribbon(aes(ymin=runoff_min,ymax=runoff_max,fill="blue"),alpha="0.4")+
  geom_line(aes(y=min8),color="blue")+ggtitle('Lower Colorado River')+
  geom_line(aes(y=max8),color="blue")+
  geom_ribbon(aes(ymin=min8,ymax=max8,fill="red"),alpha="0.4")+ylab("Relative Uncertainty")+
  theme_classic()+scale_fill_manual(values=c('red','blue'),name='Uncertainty',labels=c('Runoff','Economic Impact'))+
  theme(legend.position = c(.3,.4))



pp<-ggarrange(p5,p6,p7,p8,nrow=2,ncol=2,labels=c('E','F','G','H'))

P<-ggarrange(p,pp,nrow=2)

ggsave('Figure2.pdf',P,dpi=300, height=10, width=7.5, units="in")
