#' This function processes the raw queried data 
#'
#'@param dat the csv file outputted by the query function
#'@return a data table with all dimensions represented as columns. Levels are numbered according to the tables below
#'
#'
#' Socioeconomic and agLU dimension numberings correspond to the respective SSP
#' If other SSP components are linked to the socioeconomic dimension, the level=1, if linked to agriculture, 2
#' Groundwater Availability: Low groundwater (5%) is coded as 1, medium (25%) as 2, and high  (40%) as 3
#' Reservoir Storage: Restricted reservoir storage is coded as 1, expanded as 2
#' Earth System Models: GFDL is 1, HadGEM2 is 2, IPSL is 3, MIROC is 4, NorESM is 5
#' Land Use Scenario: The FFICT tax is 1, the UCT is 2
#'
#'
#'

# make columns of all dimensions and use a numbering system to differentiate between them
process_query<-function(dat)
{
dat<-mutate(dat,esm=ifelse(grepl('gfdl',dat$scenario),1,ifelse(grepl('hadgem',dat$scenario),2,ifelse(grepl('ipsl',dat$scenario),3,ifelse(grepl('miroc',dat$scenario),4,5)))))
dat<-mutate(dat,ssp=ifelse(grepl('ssp_socio',dat$scenario),1,2))
dat<-mutate(dat,soc=ifelse(dat$ssp==2,substr(dat$scenario,12,12),substr(dat$scenario,10,10)))
dat<-mutate(dat,ag=ifelse(dat$ssp==2,substr(dat$scenario,7,7),substr(dat$scenario,14,14)))
dat<-mutate(dat,tax=ifelse(grepl('ffict',dat$scenario),1,2))
dat<-mutate(dat,gw=ifelse(grepl('lo',dat$scenario),1,ifelse(grepl('med',dat$scenario),2,3)))
dat<-mutate(dat,res=ifelse(grepl('rs',dat$scenario),1,2))


}