require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)

df <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
"""select Disease || \\\' \\\' || \\\'Count\\\' as measure_names, sum(Count) as measure_values from California_Diseases
where Disease != \\\'Influenza Death (<65 years of age)\\\'
group by Disease
union all
select Immunization || \\\' \\\' || \\\'Immunization_Count\\\' as measure_names, sum(Immunization_Count) as measure_values from Immunizations
where Immunization != \\\'Rotavirus\\\' and Immunization != \\\'Polio\\\' and Immunization != \\\'Pneumococcal\\\' and Immunization != \\\'Varicella\\\' and Immunization != \\\'Meningococcal\\\' and Immunization != \\\'Human Papilloma Virus\\\' and Immunization != \\\'Hib\\\' and Immunization != \\\'Hepatitis A\\\' and Immunization != \\\'Hepatitis B\\\' and Immunization != \\\'Influenza\\\' 
group by Immunization
order by 1;"""
')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_cmm5627', PASS='orcl_cmm5627', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)));

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  labs(title='Disease vs. Immunization Count') +
  labs(x=paste("Disease"), y=paste("Sum of Immunization Count")) +
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
        geom_params=list(colour="blue", vjust=0, hjust=-0.1), 
        position=position_identity()
        
  ) + theme(axis.text.y=element_text(angle=40, size = 10))

