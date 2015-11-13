require("jsonlite")
require("RCurl")
require("ggplot2")
require("dplyr")
require(extrafont)

df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from Infectious_Diseases where COUNTY NOT IN (\'California\')"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_cmm5627', PASS='orcl_cmm5627', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))


df %>% select(SEX, mean(COUNT), YEAR) %>% ggplot(aes(y = mean(COUNT), x = YEAR, color = SEX)) + ggtitle("Average Count of Infectious Diseases by Sex") + geom_point() + scale_y_continuous() + scale_x_continuous() + coord_cartesian() 

Male_df <- df %>% select(SEX, mean(COUNT), YEAR) %>% filter(SEX == "Male")
Female_df <- df %>% select(SEX, mean(COUNT), YEAR) %>% filter(SEX == "Female")

Male_df %>% select(SEX, mean(COUNT), YEAR) %>% ggplot(aes(y = mean(COUNT), x = YEAR, color = "Male")) + ggtitle("Average Count of Infectious Diseases by Sex") + geom_point() + scale_y_continuous() + scale_x_continuous() + coord_cartesian() 

Female_df %>% select(SEX, mean(COUNT), YEAR) %>% ggplot(aes(y = mean(COUNT), x = YEAR, color = Female)) + ggtitle("Average Count of Infectious Diseases by Sex") + geom_point() + scale_y_continuous() + scale_x_continuous() + coord_cartesian() 
