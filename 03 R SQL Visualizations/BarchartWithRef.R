df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from Infectious_Diseases where COUNTY NOT IN (\'California\')"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_hys82', PASS='orcl_hys82', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

##########################################################################
#df <- D %>% group_by(YEAR, DISEASE) %>% summarize(AVG_COUNT = mean(COUNT))

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  #facet_wrap(~YEAR, ncol=14) +
  labs(title='DISEASE COUNT BY YEAR') +
  labs(x=paste("DISEASE"), y=paste("COUNT")) +
  layer(data=df, 
        mapping=aes(x=DISEASE, y=COUNT), 
        stat="identity", 
        stat_params=list(), 
        geom="bar",
        geom_params=list(colour="blue"), 
        position=position_identity()
  ) + coord_flip() +
  layer(data=df, 
        mapping=aes(x=DISEASE, y=COUNT, label=round(COUNT)), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black", hjust=-0.5), 
        position=position_identity()
  ) +
  layer(data=df, 
        mapping=aes(yintercept = COUNT), 
        geom="hline",
        geom_params=list(colour="red")
  ) 
################################################################################

