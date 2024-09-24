# 2023-03-20
# Simple SIR model

# Load the functions
source('simulate_directtransmission.R')

# Note: force of infection for different scenarios: 
# 1 = density-dependent 
# 2 = frequency-dependent

# Use the simulate_directtransmission function to perform simulations ####
a<-simulate_directtransmission(S0 = 1e3, I0 = 1, tmax = 120,
                               scenario = 1, 
                               bd = 0.001, bf = 0, A = 1, 
                               m = 0, n = 0, 
                               g = 0.2, w = 0)
a<-as.data.frame(a)
View(a)

# Use base R plot function to plot ####
plot(a[,1], a[,2], type="l", xlab="Time (days)", ylab="Number", 
     col="black", lwd=3, 
     xlim=c(0,120), ylim=c(0,1000))
lines(a[,1], a[,3], type="l", col="red", lwd=3, lty=2)
lines(a[,1], a[,4], type="l", col="green", lwd=3, lty=3)
legend(80, 800, c("S", "I", "R"), col=c("black", "red", "green"), 
       lty=c(1,2,3), lwd=3)

# Use ggplot2 package to plot ####
# wide format: Just use the original dataframe
pacman::p_load(ggplot2)
ggplot(data=a) + 
  geom_line(mapping=aes(x=ts.Time, y=ts.S), color="black") +
  geom_line(mapping=aes(x=ts.Time, y=ts.I), color="red") +
  geom_line(mapping=aes(x=ts.Time, y=ts.R), color="green") + 
  labs(x = "Time (days)", y="Number") +
  theme_classic()

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
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

ggplot(data=a_long) +
  geom_line(mapping=aes(x=ts.Time, y=value, color=name)) +
  labs(x = "Time (days)", y="Number") +
  theme_classic() + 
  labs(color = "Compartment")+
  scale_color_manual(values=cbPalette, labels = c('S', 'I', 'R'))

# The palette with black:
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

ggplot(data=a_long) +
  geom_line(mapping=aes(x=ts.Time, y=value, color=name)) +
  labs(x = "Time (days)", y="Number") +
  theme_classic() + 
  labs(color = "Compartment")+
  scale_color_manual(values=cbbPalette, labels = c('S', 'I', 'R'))



#### Task for 2023-03-20 ####
# Please extend the model from S-I-R to S-E-I-R