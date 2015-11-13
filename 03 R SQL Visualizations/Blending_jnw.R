require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)

df <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query="""select Immunization || \\\' \\\' || \\\'Immunization_Count\\\' as measure_names, sum(Immunization_Count) as measure_values from Immunizations 
where Immunization = \\\'Diphtheria\\\' || \\\'Measles\\\' || \\\'Mumps\\\' || \\\'Pertussis\\\' || \\\'Rubella\\\' || \\\'Tetanus\\\' 
group by Immunization 
union all 
select Disease || \\\' \\\' || \\\'Count\\\' as measure_names, sum(Count) as measure_values from California_Diseases 
group by Disease 
order by 1;"""')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_jnw653', PASS='orcl_jnw653', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)));

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  #facet_wrap(~CLARITY, ncol=1) +
  labs(title='Disease vs. Immunization Count') +
  labs(x=paste("Disease"), y=paste("Immunization Count")) +
  layer(data=df, 
        mapping=aes(x=MEASURE_NAMES, y=MEASURE_VALUES), 
        stat="identity", 
        stat_params=list(), 
        geom="bar",
        geom_params=list(colour="black"), 
        position=position_identity()
  ) + coord_flip() +
  layer(data=df, 
        mapping=aes(x=MEASURE_NAMES, y=MEASURE_VALUES, label=round(MEASURE_VALUES)), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="blue", vjust=-0.5, hjust=-0.1), 
        position=position_identity()
  ) +
  layer(data=df, 
        mapping=aes(x=MEASURE_NAMES, y=MEASURE_VALUES, label="*"), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="blue", vjust=1.5, hjust=-0.1), 
        position=position_identity()
  )
