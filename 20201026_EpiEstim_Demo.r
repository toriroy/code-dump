#####################################################
# Estimating the Time-varying reproduction number 
# EpiEstim package Demo
# Using the incidence of COVID-19 confirmed cases from Arkansas 
# As an example
# 2020-10-26
# 
# Using code originally written for other projects
# by Isaac Chun-Hai Fung, PhD
# and Kamalich Muniz-Rodriguez, MPH
#
# Using data extracted from New York Times GitHub
# Extracted by Xinyi (Angela) Hua, MPH
#
# EpiEstim package: original demo can be found here:
# https://cran.r-project.org/web/packages/EpiEstim/vignettes/demo.html

#
# Set your working directory first: Type the path to your folder within setwd()
setwd()

# Load the packages that you need 
require(tidyverse)
require(EpiEstim)
require(incidence)
require(scales)
require(knitr)
require(ggplot2)
require(lubridate)
require(readr)
# Set the seed for the random number generator
# so that computer simulations can be repeated 
# and replicated
set.seed(1234) 




# Use the tidyverse function 'read_csv' to import data
# from a CSV file and specify the nature of the data
# in each column
# The name 'dat1' is the name of your dataset. 
# Give whatever name you want to call it.
dat1<-read_csv("Arkansas_daily_incidence 20201023.csv", #File name of your CSV file
                col_names = TRUE, #Specify that there is header in the dataset
                col_types=list(
                  col_integer(), #Number
                  col_date(format="%Y-%m-%d"),    #Reported_Date
                  col_character(),  #Name of the location (e.g., Arkansas)
                  col_character(),  #fips
                  col_integer(),    #cases
                  col_integer(),    #deaths
                  col_integer()     #daily_incidence
                ))

nrow(dat1) #Number of rows of data in dataset 'dat1'

# Extract dates and incidence only and save them as a new data frame
dat2 <- dat1[,c(2,7)]
colnames(dat2)<-c("dates", "I")
dat2[which(dat2$I<0),]
# # A tibble: 1 x 2
#   dates          I
#   <date>     <int>
# 1 2020-08-15  -400
dat2[c(157,158),] 
# # A tibble: 2 x 2
#   dates          I
#   <date>     <int>
# 1 2020-08-14   626
# 2 2020-08-15  -400
dat2[c(157,158),2]
# # A tibble: 2 x 1
#       I
#   <int>
# 1   626
# 2  -400
dat2[c(157,158),2] <- c(226, 0)
dat2[c(157,158),2]
# # A tibble: 2 x 1
#       I
#   <int>
# 1   226
# 2     0
plot(as.incidence(dat2$I, dates=dat2$dates))

# Shift the incidence by 1 week early
# To account for the delay in symptom onset, testing,
# and reporting.
dat3 <- dat2 #Create a duplicate data frame
dat3$dates <- dat3$dates-7

dat2[1,] #2020-03-11
dat3[1,] #2020-03-04
##############################################################
# 1-week window (default)
# T <- nrow(dat3)
# t_start <- seq(2, T-6) # starting at 2 as conditional on the past observations
# t_end <- t_start + 6 # adding 6 to get 7-day windows as bounds included in window

#####
# We are not using the 2-week window here.
# This is for your reference only.

# #### Time window = 2 week
# T<-nrow(dat3)   
#### Alternatively, write 
#### (length.out = length(dat2$I))
# 
# t_start <- seq(2, T-13) # starting at 2 as conditional on the past observations
# t_end <- t_start + 13 

 
# res_parametric_si <- estimate_R(dat3,
#                                 method="parametric_si",
#                                 config=make_config(list(
#                                   t_start=t_start,
#                                   t_end=t_end,
#                                   mean_si=4.60,
#                                   std_si=5.55)))

##############################################################


# Here we are using the default
res_parametric_si <- estimate_R(dat3,
                                method="parametric_si",
                                config=make_config(list(
                                  mean_si=4.60,
                                  std_si=5.55)))
# Plot it in RStudio
(p_I<-plot(res_parametric_si, "incid", 
     options_I=list(xlab="Episode date"),
     legend = F))
(p_Ri<-plot(res_parametric_si, "R",
     options_R=list(col=palette(), transp=0.2, xlab="Date"),
     legend = FALSE))

# Plot 2 plots in 1
# Create a function first
plot_Ri <- function(estimate_R_obj) {
  p_I <- plot(estimate_R_obj, "incid",      
              options_I=list(xlab="Episode Date"),
              legend = F)  # plots the incidence
  #p_SI <- plot(estimate_R_obj, "SI")  # plots the serial interval distribution
  p_Ri <- plot(estimate_R_obj, "R", 
               options_R=list(xlab="Date"),
               legend = FALSE) 
  return(gridExtra::grid.arrange(p_I, p_Ri, ncol = 1))
}
# Use your function
plot_Ri(res_parametric_si)

# Try modifying the layout of the figure
# Incidence
p_I+theme_classic()+theme(legend.position=c(0.15,0.7),legend.box="vertical")+
  scale_x_date(breaks=date_breaks("months"), labels=date_format("%b"),
               limits=c(as.Date("2020-03-01"), as.Date("2020-10-26")))+
  #scale_y_continuous(breaks=c(0,200,400,600), limits=c(0,700))+
  labs(title="Incidence")+
  scale_fill_manual(name="", labels="Confirmed", values = "grey50")

# R_t
p_Ri+theme_classic()+theme(legend.position='none')+
  scale_x_date(breaks=date_breaks("months"), labels=date_format("%b"),
               limits=c(as.Date("2020-03-01"), as.Date("2020-10-26")))+
  #scale_y_continuous(breaks=c(0.5,1,1.5), limits=c(0,2))+
  geom_hline(yintercept=1, linetype="dotted")+
  labs(title="",
       y=expression(R[t]))

# Create a function for the modified figures and plot 2 in 1; 
# Change the title of the figure, by entering the Location
plot_Ri2 <- function(estimate_R_obj, Location) {
  p_I <- plot(estimate_R_obj, "incid",      
              options_I=list(xlab="Episode Date"),
              legend = F)  # plots the incidence
  
  g_I<-p_I+theme_classic()+theme(legend.position=c(0.15,0.7),legend.box="vertical")+
    scale_x_date(breaks=date_breaks("months"), labels=date_format("%b"),
                 limits=c(as.Date("2020-03-01"), as.Date("2020-10-26")))+
    #scale_y_continuous(breaks=c(0,200,400,600), limits=c(0,700))+
    labs(title=Location)+
    scale_fill_manual(name="", labels="Confirmed", values = "grey50")
  p_Ri <- plot(estimate_R_obj, "R", 
               options_R=list(xlab="Date"),
               legend = FALSE) 
  g_Ri<-p_Ri+theme_classic()+
        theme(legend.position='none', plot.margin=unit(c(0,0,0,0.6),"cm"))+  #top, right, bottom, left
        scale_x_date(breaks=date_breaks("months"), labels=date_format("%b"),
                 limits=c(as.Date("2020-03-01"), as.Date("2020-10-26")))+
        #scale_y_continuous(breaks=c(0.5,1,1.5), limits=c(0,2))+
        geom_hline(yintercept=1, linetype="dotted")+
        labs(title="",
         y=expression(R[t]))
  return(gridExtra::grid.arrange(g_I, g_Ri, ncol = 1))
}

# Enter the location here:
Location <- "Arkansas"
# Plot the whole figure
plot_Ri2(res_parametric_si, Location)

#save the figure as pdf
pdf(file="AR_Rt.pdf") 
plot_Ri2(res_parametric_si, Location)
dev.off()

#save the figure as tiff
tiff(file="AR_Rt.tif", width=6, height=6, units='in', res=300) 
plot_Ri2(res_parametric_si, Location)
dev.off()

#Save CSV file with Rt estimates
Rt<-as.data.frame(res_parametric_si[["R"]])
write.csv(Rt, file = "Rt_AR.csv")

#save as the whole output as an RDS file
saveRDS(res_parametric_si, file="res_parametric_si_AR.rds")
