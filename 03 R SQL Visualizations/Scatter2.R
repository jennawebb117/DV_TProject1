require("jsonlite")
require("RCurl")
require("ggplot2")
require("dplyr")
require(extrafont)

Male_df <- df %>% select(SEX, mean(COUNT), YEAR) %>% filter(SEX == "Male")

Male_df %>% select(SEX, mean(COUNT), YEAR) %>% ggplot(aes(y = mean(COUNT), x = YEAR, color = "Male")) + ggtitle("Average Count of Infectious Diseases by Sex (MALE)") + geom_point() + scale_y_continuous() + scale_x_continuous() + coord_cartesian() 
