## 2023-04-05
## This R file is new for Spring 2023 session. 
## Typhoid: basic models

source('simulate_directtransmission_typhoid.R')  #Indirect
source('simulate_directtransmission_typhoid2.R')
pacman::p_load(ggplot2, tidyverse, forcats, janitor)

### Environmental transmission only ####
par(mfrow=c(1,1))
tmax_entry <- 2000
ylim_B <- 10000000
a<-Typhoid_simulate_transmission(S0 = 1e3, I0 = 1, 
                                 tmax = tmax_entry, 
                                 scenario = 1, 
                                 bd = 1, bf = 0, A = 1, 
                                 m = 0, n = 0, 
                                 n_typhoid = 0.001,
                                 sigma = 0.1,
                                 g = 0.1, w = 0,
                                 k = 10^5, 
                                 epsilon= 100, 
                                 delta= 1/41)
a<-as.data.frame(a)
plot(a[,1], a[,2], type="l", 
     xlab="Time (days)", ylab="Number", col="grey", 
     lwd=3, xlim=c(0,tmax_entry), ylim=c(0,1000))
lines(a[,1], a[,3], type="l", col="red", lwd=3, lty=2)
lines(a[,1], a[,4], type="l", col="blue", lwd=3, lty=3)
lines(a[,1], a[,5], type="l", col="purple", lwd=3, lty=4)
legend(1100, 800, c("S", "I", "Ca", "R"), 
       col=c("grey", "red", "blue", "purple"), 
       lty=c(1,2,3,4), lwd=3, ncol=1)

plot(a[,1], a[,6], type="l", 
     xlab="Time (days)", ylab="Concentration", col="black", 
     lwd=3, xlim=c(0,tmax_entry), ylim=c(0,ylim_B))
legend(1000, ylim_B, c("B"), col="black", lty=1, lwd=3)

# Pivot the data frame from wide to long format ####
a_long <- a %>%
  pivot_longer(
    cols = c('ts.S', 'ts.I', 'ts.Ca', 'ts.R', 'ts.B')
  )
View(a_long)

# Change the column 'name' from character to factor
a_long$name <- as.factor(a_long$name)

# Rearrange the order of the factor levels 
levels(a_long$name) #[1] "ts.B"  "ts.Ca" "ts.I"  "ts.R"  "ts.S"
a_long <- a_long %>%
  mutate(name = fct_relevel(name, c("ts.S", 
                                    "ts.I", 
                                    "ts.Ca",
                                    "ts.R",
                                    "ts.B")))
a_long <- a_long %>% 
  mutate(name = fct_recode(
    name,
    "S" = 'ts.S',
    "I" = 'ts.I',
    "Ca"= 'ts.Ca',
    "R" = 'ts.R',
    "B" = 'ts.B'
  )) 
# The palette with grey:
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", 
               "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

(p1<-a_long %>% filter(name!='B') %>%
  ggplot() +
    geom_line(mapping=aes(x=ts.Time, y=value, color=name)) +
    labs(x = "Time (days)", y="Number") +
    theme_classic() + 
    labs(color = "Compartment")+
    scale_color_manual(values=cbPalette, 
                       labels = c('S', 'I', 'Ca', 'R')))

(p2<-a_long %>% filter(name=='B') %>%
  ggplot() +
    geom_line(mapping=aes(x=ts.Time, y=value, color=name)) +
    labs(x = "Time (days)", y="Concentration") +
    theme_classic() + 
    labs(color = "Compartment")+
    scale_color_manual(values=cbPalette, labels = c('B')))


(p3<-a_long %>% 
  ggplot() +
  geom_line(mapping=aes(x=ts.Time, y=value, color=name)) +
  labs(x = "Time (days)", y="Number") +
  theme_minimal() + 
  labs(color = "Compartment") +
  facet_wrap(~name, scales="free") +
  theme(legend.position = "none"))

### Environmental & Human-to-human transmission ####
par(mfrow=c(1,1))
tmax_entry <- 2000
ylim_B <- 10000000
a2<-Typhoid_simulate_transmission2(S0 = 1e3, I0 = 1, 
                                   tmax = tmax_entry, 
                                   scenario = 1, b=1,
                                   bd = 1e-4, bf = 0, A = 1, 
                                   m = 0, n = 0, 
                                   n_typhoid = 0.001,
                                   sigma = 0.1,
                                   g = 0.1, w = 0,
                                   k = 10^5, 
                                   epsilon= 100, 
                                   delta= 1/41)
a2<-as.data.frame(a2)
plot(a2[,1], a2[,2], type="l", 
     xlab="Time (days)", ylab="Number", col="grey", 
     lwd=3, xlim=c(0,tmax_entry), ylim=c(0,1000))
lines(a2[,1], a2[,3], type="l", col="red", lwd=3, lty=2)
lines(a2[,1], a2[,4], type="l", col="blue", lwd=3, lty=3)
lines(a2[,1], a2[,5], type="l", col="purple", lwd=3, lty=4)
legend(1100, 800, c("S", "I", "Ca", "R"), 
       col=c("grey", "red", "blue", "purple"), 
       lty=c(1,2,3,4), lwd=3, ncol=1)

plot(a2[,1], a2[,6], type="l", 
     xlab="Time (days)", ylab="Concentration", col="black", 
     lwd=3, xlim=c(0,tmax_entry), ylim=c(0,ylim_B))
legend(1000, ylim_B, c("B"), col="black", lty=1, lwd=3)

# Pivot the data frame from wide to long format ####
a2_long <- a2 %>%
  pivot_longer(
    cols = c('ts.S', 'ts.I', 'ts.Ca', 'ts.R', 'ts.B')
  )
View(a2_long)

# Change the column 'name' from character to factor
a2_long$name <- as.factor(a2_long$name)

# Rearrange the order of the factor levels 
levels(a2_long$name) #[1]"ts.B" "ts.Ca" "ts.I" "ts.R" "ts.S"
a2_long <- a2_long %>%
  mutate(name = fct_relevel(name, c("ts.S", 
                                    "ts.I", 
                                    "ts.Ca",
                                    "ts.R",
                                    "ts.B")))

a2_long <- a2_long %>% 
  mutate(name = fct_recode(
    name,
    "S" = 'ts.S',
    "I" = 'ts.I',
    "Ca"= 'ts.Ca',
    "R" = 'ts.R',
    "B" = 'ts.B'
  )) 

# The palette with grey:
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", 
               "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
(p4<-a2_long %>% filter(name!='B') %>%
  ggplot() +
  geom_line(mapping=aes(x=ts.Time, y=value, color=name)) +
  labs(x = "Time (days)", y="Number") +
  theme_classic() + 
  labs(color = "Compartment")+
  scale_color_manual(values=cbPalette, labels = c('S', 'I', 'Ca',
                                                  'R')))

(p5<-a2_long %>% filter(name=='B') %>%
  ggplot() +
  geom_line(mapping=aes(x=ts.Time, y=value, color=name)) +
  labs(x = "Time (days)", y="Concentration") +
  theme_classic() + 
  labs(color = "Compartment")+
  scale_color_manual(values=cbPalette, labels = c('B')))

(p6<-a2_long %>% 
  ggplot() +
  geom_line(mapping=aes(x=ts.Time, y=value, color=name)) +
  labs(x = "Time (days)", y="Number") +
  theme_minimal() + 
  labs(color = "Compartment") +
  facet_wrap(~name, scales="free") +
  theme(legend.position = "none"))

#save.image("D:/GSU/Teaching/2023_EPID_9131/Model/20230405_demo_plot_typhoid.RData")
#savehistory("D:/GSU/Teaching/2023_EPID_9131/Model/20230405_demo_plot_typhoid.Rhistory")
