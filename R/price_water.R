#Code adapted from Sean Turner PNNL

library(rgcam)
library(dplyr)
queryName<-'price_water'


dbs_unfiltered<-list.dirs("/path/to/GCAM/output/databases/")
dbs<-dbs_unfiltered[grepl("NDC",dbs_unfiltered)] %>% substr(.,71,nchar(.))

make_query<-function(scenario){
  dbLoc<-paste0('/path/to/GCAM/output/databases/db_',scenario)
  queryFile<-paste0('/path/to/GCAM/queries/',queryName,'.xml')
  queryData=paste0('/path/to/temp_data_files/',queryName,'.dat')
  queryResult<-rgcam::addScenario(dbLoc,queryData,queryFile=queryFile)
  file.remove(queryData)
  queryResult[[1]][[1]]
}

bind_rows(lapply(dbs,make_query)) %>%
  readr::write_csv(paste0('/path/to/GCAM/query_results/',queryName,"_FINAL.csv"))
