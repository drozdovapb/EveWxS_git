library(ggplot2)
library(openxlsx)
library(ggpubr)

## read data
Evedat <- read.xlsx("data/TableS1_FCM.xlsx")
## rename for ease
Evedat$GS <- Evedat$`Est..genome.size,.pg`

## Mann-Whitney test
pairwise.wilcox.test(Evedat$GS, Evedat$Population)
## number of events
median(Evedat$All.Events)
## species medians for the text
median(Evedat[Evedat$Population == "W", "GS"])
median(Evedat[Evedat$Population == "S", "GS"])
median(Evedat[Evedat$Population == "E", "GS"])

## option for FCM in Figure 1. Plotting

Evedat$Population <- factor(Evedat$Population, levels = c("S", "W", "E"))

my_comparisons <- combn(x = unique(Evedat$Population), m = 2, simplify = F)
signif.df <- compare_means(data = Evedat, formula = GS ~ Population, method = "wilcox.test")
signif.df$p.signif <- signif.df$p.adj

ggplot(data = Evedat, 
       aes(x = Population, y = GS)) + expand_limits(y = c(0, 11.5)) +
  geom_jitter(aes(col = Population), show.legend = F) + 
  geom_boxplot(aes(col = Population), outlier.color = 'NA', show.legend = F) + 
  stat_pvalue_manual(signif.df, y.position = c(8.8, 9.4, 8.0)) +
  scale_color_manual(values = c("#4477AA", "#F0E442", "#D81B60")) +
  xlab("Lineage") + ylab("Genome size, pg") + 
  theme_bw(base_size = 16) + 
  theme(axis.text.x = element_text(face = "italic"))

ggsave("FC_long.svg", width = 4.5, height = 7)


###############
## optional for FMC in a separate figure
Evedat$Population <- factor(Evedat$Population, levels = c("W", "S", "E"))

my_comparisons <- combn(x = unique(Evedat$Population), m = 2, simplify = F)
signif.df <- compare_means(data = Evedat, formula = GS ~ Population, method = "wilcox.test")
signif.df$p.signif <- signif.df$p.adj

pairwise.wilcox.test(Evedat$GS, Evedat$Population)

ggplot(data = Evedat, 
       aes(x = Population, y = GS)) + expand_limits(y = c(0, 11)) +
  geom_jitter(aes(col = Population)) + geom_boxplot(aes(col = Population), outlier.color = 'NA') + 
  stat_pvalue_manual(signif.df, y.position = c(8.8, 9.4, 10.2)) +
  scale_color_manual(values = c("#F0E442", "#4477AA", "#D81B60")) +
  xlab("Lineage") + ylab("Genome size, pg") + 
  theme_bw(base_size = 16) + 
  theme(axis.text.x = element_text(face = "italic"))

ggsave("FC.svg", width = 8, height = 5)
ggsave("FC.png", width = 5, height = 4)
