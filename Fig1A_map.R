library("ggmap")
library(scales)

bbox <- c(left=102, right=112, bottom=51, top=56.2)
BaikalMap <- get_stamenmap(bbox, zoom=9, maptype = "toner-background")

sampling_points <- data.frame(lat = c(53.374878, 51.870608, 51.870684), 
                              lon = c(108.975189, 104.828101, 104.811648), 
                              col = c("#D81B60", "#F0E442", "#4477AA"),
                              label = c("E", "W", "S"))

ggmap(BaikalMap) + xlab("Longitude") + ylab("Latitude") +
#  geom_point(data = sampling_points, aes(x = lon, y = lat), col = sampling_points$col, alpha = 0.5, size = 0.5) +
  geom_rect(xmin = 103.75, xmax = 105.75, ymin = 51.5, ymax = 52, col = "grey50", fill = 'NA') + 
  theme_classic(base_size = 22) + theme(panel.border = element_rect(colour = "black", fill=NA, size=1))

ggsave("map_tb_cl_r.png", width = 5.72*2, height = 4.29*2)


smallbbox <- c(left=103.75, right=105.75, bottom=51.5, top=52)
AngaraMap <- get_stamenmap(smallbbox, zoom=10, maptype = "toner-background")


ggmap(AngaraMap) + xlab("Longitude") + ylab("Latitude") +
  scale_y_continuous(breaks = pretty_breaks(n = 2)) + 
  xlab("") + ylab("") + 
#  geom_point(data = sampling_points, aes(x = lon, y = lat), col = sampling_points$col, alpha = 0.5, size = 5) + 
  theme_classic(base_size = 24) + theme(panel.border = element_rect(colour = "grey50", fill=NA, size=1)) 


ggsave("map_inlet.png", width = 5.72, height = 4.29)
