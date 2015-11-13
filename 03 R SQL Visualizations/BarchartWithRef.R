#df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from Infectious_Diseases where DISEASE = (\'Chlamydia\')"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_hys82', PASS='orcl_hys82', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

##########################################################################
df <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
"select YEAR, DISEASE, avg_COUNT, avg(avg_COUNT) 
OVER (PARTITION BY DISEASE ) as window_avg_COUNT
from 
(select YEAR, DISEASE, avg(COUNT) as avg_COUNT
from Infectious_Diseases
group by YEAR, DISEASE)
order by DISEASE;"
')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_hys82', PASS='orcl_hys82', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON', p1=KPI_Low_Max_value, p2=KPI_Medium_Max_value), verbose = TRUE))); View(df)

# df <- diamonds %>% group_by(YEAR, DISEASE) %>% summarize(AVG_COUNT = mean(COUNT)) %>% rename(YEAR=year, DISEASE=disease)
# df1 <- df %>% ungroup %>% group_by(DISEASE) %>% summarize(WINDOW_AVG_COUNT=mean(AVG_COUNT))
# df <- inner_join(df, df1, by="DISEASE")

spread(df, YEAR, AVG_COUNT) %>% View

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  facet_wrap(~DISEASE, ncol=1) +
  labs(title='INFECTIOUS DISEASES Barchart\nAVERAGE_PRICE, WINDOW_AVG_PRICE, ') +
  labs(x=paste("YEAR"), y=paste("AVG_COUNT")) +
  layer(data=df, 
        mapping=aes(x=YEAR, y=AVG_COUNT), 
        stat="identity", 
        stat_params=list(), 
        geom="bar",
        geom_params=list(colour="blue"), 
        position=position_identity()
  ) + coord_flip() +
  layer(data=df, 
        mapping=aes(x=YEAR, y=AVG_COUNT, label=round(AVG_COUNT)), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black", hjust=-0.5), 
        position=position_identity()
  ) +
  layer(data=df, 
        mapping=aes(x=YEAR, y=AVG_COUNT, label=round(WINDOW_AVG_COUNT)), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black", hjust=-2), 
        position=position_identity()
  ) +
  layer(data=df, 
        mapping=aes(x=YEAR, y=AVG_COUNT, label=round(AVG_COUNT - WINDOW_AVG_COUNT)), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black", hjust=-5), 
        position=position_identity()
  ) +
  layer(data=df, 
        mapping=aes(yintercept = WINDOW_AVG_COUNT), 
        geom="hline",
        geom_params=list(colour="red")
  ) 
