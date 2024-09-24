################################
# EPID 7135                    #
# Sample Code for Nov 11, 2020 #
# Data import +                #
# Shift the date by 9 days     #
# Generate Rt                  #
################################

#Set your working directory
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

#dat<-read.csv("County1.csv")

dat<-read_csv("County1.csv", #File name of your CSV file
                  col_names = TRUE, #Specify that there is header in the dataset
                  col_types=list(
                    col_integer(),                  #Number
                    col_date(format="%Y-%m-%d"),    #Reported_Date
                    col_integer()                  #Incidence
                    ))


# Extract dates and incidence only and save them as a new data frame
datN <- dat[,c(2,3)] #I extract the date column and the incidence column
colnames(datN)<-c("dates", "I") #I rename the columns
plot(as.incidence(datN$I, dates=datN$dates)) #Plot it on the screen to make sure that it works

# Shift the incidence by 9 days early
# To account for the incubation period (from infection to symptom onset) (mean = 6d) 
# the delay in testing (median = 3d)
# and the delay in reporting (we assume that they were reported on the same day as the day of positive specimen)
# Thus, 6 + 3 = 9 days
datN1       <- datN #Create a duplicate data frame (Just give it a name 'datN1')
datN1$dates <- datN1$dates-9 #Shift the dates by 9 days backward

# Test if you have done it right, by comparing the first row of 
# your original dataset
# and your new shifted dataset
datN[1,] 
datN1[1,] 

# Here we are using the default sliding window of 7 days
# i.e., taking the average of 7 consecutive daily Rt estimates
# The daily Rt estimate is stored in an object named 'res_parameteric_si'
# You can give it a different name, if you want
res_parametric_si <- estimate_R(datN1,  #name of the new shifted dataset 
                                method="parametric_si",  #we use the parametric method
                                config=make_config(list( #we set the configuration of the serial interval
                                  mean_si=4.60,          #mean of serial interval = 4.60
                                  std_si=5.55)))         #standard deviation of serial interval = 5.55  

########################################################################
# and then, you can now use the plot_Ri4 function in the other R file  #
# to create your figure                                                #
########################################################################