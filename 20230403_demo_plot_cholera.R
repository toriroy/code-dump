## 2023-04-03
## This R file has been modified for Spring 2023 session. 
## The functions are the same as in previous sessions.

source('simulate_directtransmission_cholera.R')  #Direct
source('simulate_directtransmission_cholera2.R') #Indirect + Direct
pacman::p_load(ggplot2, tidyverse, forcats, janitor)

### Indirect transmission only ####
par(mfrow=c(1,2))
tmax_entry <- 1000
ylim_B <- 2000000
a<-Cholera_simulate_directtransmission(S0 = 1e3, I0 = 1, 
                                       tmax = tmax_entry, 
                                       scenario = 1, 
                                       bd = 1, bf = 0, A = 1, 
                                       m = 0, n = 0, n_c = 0.001, 
                                       g = 0.1, w = 0,
                                       k = 10^5, epsilon= 100, 
                                       delta= 1/41)
a<-as.data.frame(a)
plot(a[,1], a[,2], type="l", 
     xlab="Time (days)", ylab="Number", col="grey", 
     lwd=3, xlim=c(0,tmax_entry), ylim=c(0,1000))
lines(a[,1], a[,3], type="l", col="red", lwd=3, lty=2)
lines(a[,1], a[,4], type="l", col="blue", lwd=3, lty=3)

legend(0, 800, c("S", "I", "R"), col=c("grey", "blue", "red"), 
       lty=c(1,2,3), lwd=3, ncol=1)

plot(a[,1], a[,5], type="l", 
     xlab="Time (days)", ylab="Concentration", col="black", 
     lwd=3, xlim=c(0,tmax_entry), ylim=c(0,ylim_B))
legend(400, ylim_B, c("B"), col="black", lty=1, lwd=3)

# Pivot the data frame from wide to long format ####
a_long <- a %>%
  pivot_longer(
    cols = c('ts.S', 'ts.I', 'ts.R', 'ts.B')
  )
View(a_long)

# Change the column 'name' from character to factor
a_long$name <- as.factor(a_long$name)

# Rearrange the order of the factor levels 
levels(a_long$name) #[1]"ts.B" "ts.I" "ts.R" "ts.S"
a_long <- a_long %>%
  mutate(name = fct_relevel(name, c("ts.S", "ts.I", "ts.R",
                                    "ts.B")))
a_long <- a_long %>% 
  mutate(name = fct_recode(
    name,
    "S" = 'ts.S',
    "I" = 'ts.I',
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
    scale_color_manual(values=cbPalette, labels = c('S', 'I', 'R')))

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

### Indirect + direct transmission ####
par(mfrow=c(1,2))
tmax_entry <- 1000
ylim_B <- 2000000
a2<-Cholera_simulate_directtransmission2(S0 = 1e3, I0 = 1, 
                                       tmax = tmax_entry, 
                                       scenario = 1, b=1,
                                       bd = 1e-4, bf = 0, A = 1, 
                                       m = 0, n = 0, n_c = 0.001, 
                                       g = 0.1, w = 0,
                                       k = 10^5, epsilon= 100, 
                                       delta= 1/41)
a2<-as.data.frame(a2)
plot(a2[,1], a2[,2], type="l", 
     xlab="Time (days)", ylab="Number", col="grey", 
     lwd=3, xlim=c(0,tmax_entry), ylim=c(0,1000))
lines(a2[,1], a2[,3], type="l", col="red", lwd=3, lty=2)
lines(a2[,1], a2[,4], type="l", col="blue", lwd=3, lty=3)

legend(400, 800, c("S", "I", "R"), col=c("grey", "red", "blue"), 
       lty=c(1,2,3), lwd=3, ncol=1)

plot(a2[,1], a2[,5], type="l", 
     xlab="Time (days)", ylab="Concentration", col="black", 
     lwd=3, xlim=c(0,tmax_entry), ylim=c(0,ylim_B))
legend(400, ylim_B, c("B"), col="black", lty=1, lwd=3)

# Pivot the data frame from wide to long format ####
a2_long <- a2 %>%
  pivot_longer(
    cols = c('ts.S', 'ts.I', 'ts.R', 'ts.B')
  )
View(a2_long)

# Change the column 'name' from character to factor
a2_long$name <- as.factor(a2_long$name)

# Rearrange the order of the factor levels 
levels(a2_long$name) #[1]"ts.B" "ts.I" "ts.R" "ts.S"
a2_long <- a2_long %>%
  mutate(name = fct_relevel(name, c("ts.S", "ts.I", "ts.R",
                                    "ts.B")))

a2_long <- a2_long %>% 
  mutate(name = fct_recode(
    name,
    "S" = 'ts.S',
    "I" = 'ts.I',
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
  scale_color_manual(values=cbPalette, labels = c('S', 'I', 'R')))

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

#### 2023-04-03 Homework: Typhoid ####
