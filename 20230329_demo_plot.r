# 20230329 To modify this for the SEIHFR model:

#### 20230320: Starting with an SIR model ####

# Load the functions
source('simulate_directtransmission.R')

# Note: force of infection for different scenarios: 
# 1 = density-dependent 
# 2 = frequency-dependent

a<-simulate_directtransmission(S0 = 1e3, I0 = 1, 
                               tmax = 120, scenario = 1, 
                               bd = 0.001, bf = 0, A = 1, 
                               m = 0, n = 0, g = 0.2, w = 0)
a<-as.data.frame(a)
plot(a[,1], a[,2], type="l", xlab="Time (days)", ylab="Number", 
     col="black", lwd=3, xlim=c(0,120), ylim=c(0,1000))
lines(a[,1], a[,3], type="l", col="red", lwd=3, lty=2)
lines(a[,1], a[,4], type="l", col="green", lwd=3, lty=3)
legend(80, 800, c("S", "I", "R"), 
       col=c("black", "red", "green"), 
       lty=c(1,2,3), lwd=3)

# Pivot the data frame from wide to long format ####
pacman::p_load(tidyverse)
a_long <- a %>%
  pivot_longer(
    cols = c('ts.S', 'ts.I', 'ts.R')
  )
View(a_long)

# Change the column 'name' from character to factor
a_long$name <- as.factor(a_long$name)

# Rearrange the order of the factor levels 
levels(a_long$name) #[1] "ts.I" "ts.R" "ts.S"
pacman::p_load(forcats)
a_long <- a_long %>%
  mutate(name = fct_relevel(name, c("ts.S", "ts.I", "ts.R")))

# Use ggplot() to plot ####
ggplot(data=a_long) +
  geom_line(mapping=aes(x=ts.Time, y=value, color=name)) +
  labs(x = "Time (days)", y="Number") +
  theme_classic() + 
  labs(color = "Compartment")+
  scale_color_discrete(labels = c('S', 'I', 'R'))

# color-blind-friendly palette ####
# (Source: http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/)

# The palette with grey:
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", 
               "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

ggplot(data=a_long) +
  geom_line(mapping=aes(x=ts.Time, y=value, color=name)) +
  labs(x = "Time (days)", y="Number") +
  theme_classic() + 
  labs(color = "Compartment")+
  scale_color_manual(values=cbPalette, labels = c('S', 'I', 'R'))

# The palette with black:
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", 
                "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

ggplot(data=a_long) +
  geom_line(mapping=aes(x=ts.Time, y=value, color=name)) +
  labs(x = "Time (days)", y="Number") +
  theme_classic() + 
  labs(color = "Compartment")+
  scale_color_manual(values=cbbPalette, labels = c('S', 'I', 'R'))

#### 2023-03-27 SEIR model ####

# Load the functions
source('simulate_directtransmission_SEIR.R')

# Note: force of infection for different scenarios: 
# 1 = density-dependent 
# 2 = frequency-dependent

a2<-SEIRsimulate_directtransmission(S0 = 1e3, E0=0, I0 = 1, 
                                   tmax = 120, scenario = 1, 
                                   bd = 0.001, bf = 0, A = 1, 
                                   m = 0, n = 0, g = 0.2, w = 0, sigma=0.5)
a2<-as.data.frame(a2)
plot(a2[,1], a2[,2], type="l", xlab="Time (days)", ylab="Number", 
     col="black", lwd=3, xlim=c(0,120), ylim=c(0,1000))
lines(a2[,1], a2[,3], type="l", col="blue", lwd=3, lty=4)
lines(a2[,1], a2[,4], type="l", col="red", lwd=3, lty=2)
lines(a2[,1], a2[,5], type="l", col="green", lwd=3, lty=3)
legend(80, 800, c("S", "E", "I", "R"), 
       col=c("black", "blue", "red", "green"), 
       lty=c(1,4,2,3), lwd=3)

# Pivot the data frame from wide to long format ####
pacman::p_load(tidyverse)
a2_long <- a2 %>%
  pivot_longer(
    cols = c('ts.S', 'ts.E', 'ts.I', 'ts.R')
  )
View(a2_long)

# Change the column 'name' from character to factor
a2_long$name <- as.factor(a2_long$name)

# Rearrange the order of the factor levels 
levels(a2_long$name) #[1] "ts.E" "ts.I" "ts.R" "ts.S"
pacman::p_load(forcats)
a2_long <- a2_long %>%
  mutate(name = fct_relevel(name, c("ts.S", "ts.E", "ts.I", "ts.R")))

# The palette with grey:
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", 
               "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

ggplot(data=a2_long) +
  geom_line(mapping=aes(x=ts.Time, y=value, color=name)) +
  labs(x = "Time (days)", y="Number") +
  theme_classic() + 
  labs(color = "Compartment")+
  scale_color_manual(values=cbPalette, labels = c('S', 'E', 'I', 'R')) +
  theme(legend.position=c(0.8, 0.5))

#### 2023-03-29 Ebola ####
# An Ebola model: S-E-I-H-F-R model

# Load the functions
source('simulate_directtransmission_SEIHFR2.R')

# Note: force of infection for different scenarios: 
# 1 = density-dependent 
# 2 = frequency-dependent

a3<-SEIHFRsimulate_directtransmission(S0 = 1e3, E0= 0, I0 = 1, 
                                      tmax = 120, scenario = 1, 
                                      bd_1 = 0.0005, bd_2 = 0.0005, bd_3 = 0.0005, 
                                      bf_1 = 0.001, bf_2 = 0.001, bf_3 = 0.001, 
                                      A = 1, n = 0.1, g = 0.1, 
                                      sigma=0.5, b = 0.5, h = 0.5)
a3<-as.data.frame(a3)
plot(a3[,1], a3[,2], type="l", col="black", lwd=3, lty=1,
     xlab="Time (days)", ylab="Number", 
     xlim=c(0,120), ylim=c(0,1000))
lines(a3[,1], a3[,3], type="l", col="blue", lwd=3, lty=4)
lines(a3[,1], a3[,4], type="l", col="red", lwd=3, lty=2)
lines(a3[,1], a3[,5], type="l", col="magenta", lwd=3, lty=3)
lines(a3[,1], a3[,6], type="l", col="purple", lwd=3, lty=1)
lines(a3[,1], a3[,7], type="l", col="green", lwd=3, lty=1)
legend(80, 700, c("S", "E", "I", "H", "F", "R"), 
       col=c("black", "blue", "red", "magenta", "purple", "green"), 
       lty=c(1,4,2,3,1,1), lwd=3)
# Pivot the data frame from wide to long format ####
pacman::p_load(tidyverse)
a3_long <- a3 %>%
  pivot_longer(
    cols = c('ts.S', 'ts.E', 'ts.I', 'ts.H', 'ts.Fu', 'ts.R')
  )
View(a3_long)
# Change the column 'name' from character to factor
a3_long$name <- as.factor(a3_long$name)

# Rearrange the order of the factor levels 
levels(a3_long$name) #[1] "ts.E"  "ts.Fu" "ts.H"  "ts.I"  "ts.R"  "ts.S" 
pacman::p_load(forcats)
a3_long <- a3_long %>%
  mutate(name = fct_relevel(name, c("ts.S", "ts.E", "ts.I", 
                                    "ts.H", "ts.Fu","ts.R")))
# The palette with grey:
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", 
               "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

ggplot(data=a3_long) +
  geom_line(mapping=aes(x=ts.Time, y=value, color=name)) +
  labs(x = "Time (days)", y="Number") +
  theme_classic() + 
  labs(color = "Compartment")+
  scale_color_manual(values=cbPalette, 
                     labels = c('S', 'E', 'I', 'H', 'F', 'R')) +
  theme(legend.position=c(0.8, 0.5))


#### 2023-03-29 Homework: To program a cholera model in R ####