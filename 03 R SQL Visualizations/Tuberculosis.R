df <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
"select YEAR, DISEASE, sum_COUNT, sum(sum_COUNT) 
                                                OVER (PARTITION BY DISEASE) as window_avg_COUNT
                                                from 
                                                (select YEAR, DISEASE, sum(COUNT) as sum_COUNT
                                                from Infectious_Diseases
                                                where DISEASE = (\'Tuberculosis\') and (SEX=(\'Male\') OR SEX=(\'Female\') )
                                                group by YEAR, DISEASE)
                                                order by DISEASE;"
                                                ')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_hys82', PASS='orcl_hys82', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE))); 

dfMALE <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
                                                    "select YEAR, DISEASE, sum_COUNT, sum(sum_COUNT) 
                                                    OVER (PARTITION BY DISEASE) as window_avg_COUNT
                                                    from 
                                                    (select YEAR, DISEASE, sum(COUNT) as sum_COUNT
                                                    from Infectious_Diseases
                                                    where DISEASE = (\'Tuberculosis\') and SEX=(\'Male\')
                                                    group by YEAR, DISEASE)
                                                    order by DISEASE;"
                                                    ')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_hys82', PASS='orcl_hys82', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)));

ggplot() + 
  coord_cartesian() + 
  scale_x_continuous() +
  scale_y_continuous() +
  labs(title='TUBERCULOSIS AVERAGE_COUNT, WINDOW_AVG_COUNT') +
  labs(x=paste("YEAR"), y=paste("COUNT OVER ALL COUNTIES PER YEAR")) +
  layer(data=df, 
        mapping=aes(x=YEAR, y=SUM_COUNT), 
        stat="identity", 
        stat_params=list(), 
        geom="bar",
        geom_params=list(fill="RED"), 
        position=position_identity()
  ) + coord_flip() +
  layer(data=dfMALE, 
        mapping=aes(x=YEAR, y=SUM_COUNT), 
        stat="identity", 
        stat_params=list(), 
        geom="bar",
        geom_params=list(fill="BLUE"), 
        position=position_identity()
  ) + coord_flip() +
  layer(data=df, 
        mapping=aes(yintercept = WINDOW_AVG_COUNT/14), 
        geom="hline",
        geom_params=list(colour="BLACK")
  ) +
  layer(data=df, 
        mapping=aes(x=2000, y=round(WINDOW_AVG_COUNT/14), label=round(WINDOW_AVG_COUNT/14)), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black", hjust=-.1), 
        position=position_identity()
  )
