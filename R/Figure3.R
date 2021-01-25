#library(ggplot2)
#library(cowplot)
#library(ggpubr)
#library(gridExtra)
##################################################################

# Generate Figure 3

#################### load data
# please note that this data may not load from cloning the github repo. If it doesn't, download the data manually from Github

load('data/crops.rda')
load('data/indus_price.rda')
load('data/ap_with.rda')

source('R/process_query.R')

crops %>% process_query()->crops

crops %>% filter(landleaf=="Crop") -> crops

indus_price %>% mutate(value=value*4.82) -> indus_price # transform 1975 $ to 2020 $
#########################
p1<-ggplot(crops,aes(value/1000,fill=as.factor(tax)))+geom_density(alpha=0.4)+
  scale_fill_manual(name="Tax",values=c("orange","cyan"),labels=c("FFICT","UCT"))+xlab(bquote("Area (million km"^"2"~")"))+
  theme_classic()+scale_x_continuous(expand=c(0,0))+scale_y_continuous(expand=c(0,0))+
  theme(plot.title = element_text(hjust = 0, size = 18))+theme(legend.position = "none",axis.text=element_text(size=14),text=element_text(size=14))


p2<-ggplot(indus_price,aes(value,fill=as.factor(tax)))+geom_density(alpha=.4)+
  scale_fill_manual(name="Tax",values=c("orange","cyan"),labels=c("FFICT","UCT"))+
  theme_classic()+scale_x_continuous(expand=c(0,0))+scale_y_continuous(expand=c(0,0))+
  xlab(bquote("$/m"^"3"))+theme(legend.position=c(.75,.75),axis.text=element_text(size=14),text=element_text(size=14))

p3<-ggplot(ap_with,aes(value,fill=as.factor(tax)),alpha=.04)+geom_density(alpha=.4)+
  scale_fill_manual(name="Tax",values=c("orange","cyan"),labels=c("FFICT","UCT"))+
  theme_classic()+theme(legend.position = "none",axis.text=element_text(size=14),text=element_text(size=14))+scale_x_continuous(expand=c(0,0))+scale_y_continuous(expand=c(0,0))+
  xlab(bquote("km"^"3"))




gt <- arrangeGrob(p1,                               # bar plot spanning two columns
                  p3, p2,                               # box plot and scatter plot
                  ncol = 1, nrow = 3,
                  layout_matrix = rbind(c(1,2,3)))


p<-as_ggplot(gt) +                                # transform to a ggplot
  draw_plot_label(label = c("A", "B", "C"), size = 15,x = c(0, 0.33, 0.66), y = c(1, 1, 1)) # Add labels



ggsave('Figure3.pdf',height=3,width=10,dpi=300)

