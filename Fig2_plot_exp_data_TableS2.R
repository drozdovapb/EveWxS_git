Sys.setlocale("LC_TIME", "C")
library(ggplot2)
library(openxlsx)
library(scales) ## for different linetypes
library(ggpubr) ## for ggarrange

## tune ggplot theme

## scale_color_manual(values=c(
## "#000000", "#E69F00", "#56B4E9", "#009E73",
## "#F0E442", "#0072B2", "#D55E00", "#CC79A7"))
## black    orange  sky_blue    green 
## yellow   blue    vermilion   reddish_purple

mytheme <- theme_bw() + theme(line = element_line(size = 2))

## read the data
expdat <- read.xlsx("data/TableS2_experiment.xlsx")
expdat$Date <- convertToDate(expdat$Date)

pampl <- 
ggplot(expdat, aes(x = Date, col = Cross)) + 
  geom_line(aes(y = `Precopulas.(amplexuses)`, linetype = Cross), size = 1) + 
  expand_limits(y=c(0, 10)) + 
  scale_color_manual(values = c("#4477AA", "#66CCEE", "#228833", "#F0E442")) +
  theme_bw(base_size = 14) + 
  scale_y_continuous(breaks = pretty_breaks()) +
  scale_x_date(date_breaks = "1 month", date_labels = "%b") + 
#  scale_linetype_manual(values = c("solid", "212151", "57", "solid")) + 
#  scale_linetype_manual(values = c("1234", "21", "31", "11")) + 
  scale_linetype_manual(values = c("1234", "21", "2111", "31")) + 
#  guides(linetype = "none") + 
  theme(legend.position = 'bottom', legend.key.width = unit(2, "cm"))

#ggsave("ampl.svg", width = 5, heigh = 3)

pjuv <- 
ggplot(expdat, aes(x = Date, col = Cross)) + 
  geom_line(aes(y = Juveniles, linetype = Cross), size = 1) +
#  geom_point(aes(y=Juveniles, shape = Cross, fill = Cross), alpha=0.5) + 
  expand_limits(y=c(0, 10)) + 
#  scale_color_manual(values = c("#F0E442", "#007656", "#56B4E9", "#0072B2")) +
#  scale_color_manual(values = c("#CCBB44", "#228833", "#66CCEE", "#4477AA")) +
#  scale_color_manual(values = c("#F0E442", "#009E73", "#56B4E9", "#0072B2")) +
  scale_color_manual(values = c("#4477AA", "#66CCEE", "#228833", "#F0E442")) +
#   scale_shape_manual(values = c(21, 24, 25, 22)) + 
  theme_bw(base_size = 14) + 
  scale_y_continuous(breaks = pretty_breaks()) +
#  scale_linetype_manual(values = c("solid", "solid", "55", "solid")) + 
#  scale_linetype_manual(values = c("solid", "212151", "57", "solid")) + 
#  scale_linetype_manual(values = c("1234", "21", "31", "11")) + 
  scale_linetype_manual(values = c("1234", "21", "2111", "31")) + 
  scale_x_date(date_breaks = "1 month", date_labels = "%b") + 
  guides(linetype = "none") + 
  theme(legend.position = 'bottom')
#ggsave("juv.svg", pjuv, width = 5, heigh = 3)


ggarrange(pampl, pjuv)
ggsave("ampl_and_juv.svg", width = 8, heigh = 4)

