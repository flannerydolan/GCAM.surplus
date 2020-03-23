#library(ggplot2)
#library(cowplot)
#library(ggpubr)
#library(gridExtra)
##################################################################

# Generate Figure 3

#################### load data
load('data/crops_j.rda')
load('data/indus_price.rda')
load('data/ap_with.rda')
#########################

p1<-ggplot(crops_j,aes(value,color=as.factor(tax)))+stat_ecdf(aes(linetype=`Scenario Type`),geom="step")+
  scale_color_manual(name="Tax",values=c("orange","cyan"),labels=c("FFICT","UCT"))+xlab(bquote("Area (thousand km"^"2"~")"))+
  ylab('Probability')+xlim(240000,320000)+theme_classic()+
  theme(plot.title = element_text(hjust = 0, size = 18))+theme(legend.position = "none") 

p2<-ggplot(indus_price,aes(value,fill=as.factor(tax)))+geom_density(alpha=.4)+
  scale_fill_manual(name="Tax",values=c("orange","cyan"),labels=c("FFICT","UCT"))+
  theme_classic()+scale_x_continuous(expand=c(0,0))+scale_y_continuous(expand=c(0,0))+
  xlab(bquote("$/m"^"3"))+theme(legend.position=c(.75,.75))

p3<-ggplot(ap_with,aes(value,fill=as.factor(tax)),alpha=.04)+geom_density(alpha=.4)+
  scale_fill_manual(name="Tax",values=c("orange","cyan"),labels=c("FFICT","UCT"))+
  theme_classic()+theme(legend.position = "none")+scale_x_continuous(expand=c(0,0))+scale_y_continuous(expand=c(0,0))+
  xlab(bquote("km"^"3"))




gt <- arrangeGrob(p1,                               # bar plot spaning two columns
                  p3, p2,                               # box plot and scatter plot
                  ncol = 2, nrow = 2, 
                  layout_matrix = rbind(c(1,2), c(1,3)))


p<-as_ggplot(gt) +                                # transform to a ggplot
  draw_plot_label(label = c("A", "B", "C"), size = 15,x = c(0, 0.5, 0.5), y = c(1, 1, 0.5)) # Add labels


p
