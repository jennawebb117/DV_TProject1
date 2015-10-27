require("jsonlite")
require("RCurl")
require("ggplot2")
require("dplyr")

KPI_Very_Low_value = 0
KPI_Low_value = 10
KPI_Medium_value = 100

df <- diseases %>% group_by(SEX, COUNTY) %>% summarize(avg_count = mean(COUNT)) %>% mutate(kpi = avg_count) %>% mutate(kpi = ifelse(kpi <= KPI_Very_Low_value, 'Very Low', ifelse(kpi <= KPI_Low_value, 'Low', ifelse(kpi <= KPI_Medium_value, 'Medium', 'High'))))

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_discrete() +
  labs(title='Number of Diseases per Sex per County') +
  labs(x=paste("SEX"), y=paste("County")) +
  layer(data=df, 
        mapping=aes(x=SEX, y=COUNTY, label=round(avg_count, 2)),
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black", size = 3), 
        position=position_identity()
  ) +
  layer(data=df, 
        mapping=aes(x=SEX, y=COUNTY, label=round(avg_count, 2)),
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black", vjust=4, hjust=-1, size = 3), 
        position=position_identity()
  ) +
  layer(data=df, 
        mapping=aes(x=SEX, y=COUNTY, fill=kpi), 
        stat="identity", 
        stat_params=list(), 
        geom="tile",
        geom_params=list(alpha=0.50), 
        position=position_identity()
  ) + theme(axis.text.y = element_text(face = "plain", size = 8))

