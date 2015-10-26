require("jsonlite")
require("RCurl")
require("ggplot2")

KPI_Very_Low_value = 0
KPI_Low_value = 10
KPI_Medium_value = 100

df <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", '129.152.144.84:5001/rest/native/?query=
"select SEX, County, kpi, 
case
when kpi <= "p1" then \\\'Very Low\\\'
when kpi <= "p2" then \\\'Low\\\'
when kpi <= "p3" then \\\'Medium\\\'
else \\\'High\\\'
end kpi
from (select SEX, County, COUNT, 
avg(Count) kpi
from INFECTIOUS_DISEASES
group by SEX, County, COUNT)
order by County;"
')),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_jnw653', PASS='orcl_jnw653', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON', p1=KPI_Very_Low_value, p2=KPI_Low_value, p3=KPI_Medium_value), verbose = TRUE)))



ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_discrete() +
  labs(title='Number of Diseases per Sex per County') +
  labs(x=paste("SEX"), y=paste("County")) +
  layer(data=df, 
        mapping=aes(x=SEX, y=COUNTY, label=COUNTY), #label is wrong here
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black"), 
        position=position_identity()
  ) +
  layer(data=df, 
        mapping=aes(x=SEX, y=COUNTY, label=COUNTY), #label is wrong here
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black", vjust=4), 
        position=position_identity()
  ) 

