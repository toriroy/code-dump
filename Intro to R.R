# Hashtag can be used to put comments in the code

# There are some data types in R
# Numeric
# Character use quotation marks to define them
# Factor used for working with categorical variables
# Logical which is a Boolean or "True/False" classification

# CTRL + enter can be used to run a line
class
class(3)
?mean

class("3")  # Quotes makes it a character, not numeric


a = 3       # Single equals sign is an assignment
b<-5        #<- can be used for assignment too

b<-7

c<-'some character'
print(c)
class(a)

class(c)


1/3

sum=1+2

sum==3

sum!=3

1+2==3      # Double equals signs is not an assignment, but a TEST returning a logical


1+2==4
1+2!=4

class(1+2==3)

class(1+2==4)

new_object<-(1+3==4)
print(new_object)
print(new_object)

class(new_object)


class(sum==4)


# Other data structure can be built out of these basic classes. 

# A vector is a set of values of the same class.  Use c() for "c"ombine.

numVec = c(1, 3, 5, 7)
class(numVec)
print(numVec)

#can combine numbers to a numeric vector
numVec5=c(1,3,5,7,2000)

numVec3=c(numVec, 20001)

class(numVec)

numvec9=c(numVec, 'cccc')

class(numvec9)

#for strings it works a little bit different
some_string<-'Colour'


substr(some_string, 3, 6)
substr(some_string, 2, nchar(some_string))  #Indexing in R starts from 1

some_string_1=c(some_string, 'aaaaa')  #this returns a vector with 2 characters

class(some_string_1)
class(some_string_1[2])
some_string_1[1]
some_string_1[2]

numVec[3]

some_string_2=paste(some_string, 'aaaaa') #this will concatinate the strings

some_string_3=paste(some_string, 'aaaaa', sep = '>>')
class(some_string_2)


numVec[10]        # Use brackets for indexing

numVec^2         # By default, vector calculations are componentwise
numVec*2
#careful when doing operation with vectors, same length
vec1=c(1,2)
numVec+vec1

vec2=c(1,1,1,1,1)
numVec3+vec2

numVec*2

charVec = c("Blue", "Green", "Green", "Blue")  #this is a character vector
charVec[3]                                     #indexing is the same

charVec == "Blue"            # Returns a vector of logicals, checks which are true

as.numeric(charVec=="Blue")  # Converts logicals into 0's and 1's

as.logical(c(1,0,0))         # Converts a numeric vector to a logical vector

which(charVec=='Blue')       #this will return indeces where there is blue
charVec[c(1,4)]
charVec[4]

charVec[which(charVec=='Blue')]

3+"3"                        # This will throw an error

3+as.numeric("3")            # but this works

sum(charVec=="Blue")         # Count occurrence of a value


numVec>4

sum(numVec>4)

# A factor is similar to a character, but contains information about
# the number of possible levels
exampleFactor = factor(charVec)      # Here's one way to create a factor
exampleFactor
as.factor(charVec)              # This gives equivalent output
class(exampleFactor)

# Matrices are two-dimensional collections of values
numMatrix = matrix(numVec, nrow=2, byrow=T)
numMatrix

?matrix

charMatrix = matrix(charVec, nrow=2, byrow=F)
charMatrix




# The "data frame" is an adaptable data structure

name_df = data.frame(numVec,charVec)
?data.frame
# You can find and double click on dataframe name in environment on the righ
?summary

summary(name_df)             # Statistics for each variable


name_df[3,1]                 # Data frame entries can be accessed like a matrix


class(name_df$charVec )             # Columns can be extracted entirely with a $ and variable name

name_df$charVec[3]

name_df[2,]                  # Leave an index blank to get an entire row/column

name_df[,1]

write.csv(name_df, 'created_df.csv')
?write.csv

#or you can put the folder that you want it saved to
write.csv(name_df, 'U:\\Rcreated_df_new1.csv')


vec1=seq(1,5, 0.5)
?seq

x = seq(1,10,.05)  # Make a vector of evenly spaced values
y = x^2            # Componentwise squaring
plot(x,y)          
?plot
plot(x,y,type='l', col='red', main='title goes here', xlab = 'x label',
     ylab='y ;abe;')

#for loops
for (i in c(1,2,3,4,5,6,7,8,9,10)){
  print(i+2)
}

for (i in seq(1:10)){
  print(i)
}

#functions

func_prime<-function(argument){
  for (i in seq(2, argument-1)){ #start from 2 till number - 1
    if (argument%%i==0)  {   #should put condition inside () in if statement
      thing_to_print='Not prime'
      break  #once you find a number that divides evenly, break the loop and declare
      #as not prime
    }
    else{
      thing_to_print='Prime'
    }#only after making sure that no number exists that
  }
print(thing_to_print)
}

func_prime(12)

# Sometimes you need functionality not included in base R
install.packages('DescTools')       #... or use this commmand
# install.packages() needs to be run once on each machine

library(DescTools)
Primes(50)      #careful about upper/lower letters
?survivalROC

#read data by specifying full path
carsDF = read.csv("W:/Categorical/cars93.csv")


#use setwd to set the working directory for R
#this is where R will read files from and save them if you do not specify the full path

setwd("W:/Categorical")

#C:\\Users\\Mario\\Google Drive\\Categorical



#Now let's read data
carsDF = read.csv("U:\\cars93.csv")
write.csv(carsDF, 'carsDF_created_newly.csv')

carsDF               # Hard to read with a big data set
head(carsDF)         # See a small portion of the data

colnames(carsDF)     # See variable names
ncol(carsDF)         # There are 27 variables
nrow(carsDF)         # There are 93 observations
summary(carsDF)
write.csv(carsDF, 'cars93_saved.csv')


#Show how to save environment and load it again

carsDF$Manufacturer        # The dollar sign can select a variable by name

table(carsDF$Manufacturer) # A frequency table for categorical variables

carsDF$Horsepower          

mean(carsDF$Horsepower)    # Average

sd(carsDF$Horsepower)      # Standard deviation

range(carsDF$Horsepower)   # Minimum and maximum

sum(carsDF$Horsepower>200) # How many cars with more than 200 hp

# Let's see how to produce basic plots
hist(carsDF$Horsepower)  # The most basic way to produce a histogram
?hist                    # View the documentation   

# Customize
hist(carsDF$Horsepower, breaks=10, xlab = 'Horsepower', main='Histogram of Horsepower')  

peg('plot_generated.png')
plot(x,y)
dev.off()

plot(carsDF$Horsepower, carsDF$Price, xlab='x axis',
     main = 'Put a title here')    # Basic scatterplot


cor(carsDF$Horsepower, carsDF$Price, method = 'spearman')     # Linear correlation?


boxplot(carsDF$Horsepower, xlab='x axis')               # Basic boxplot

boxplot(carsDF$Horsepower ~ carsDF$Type) # Break down by factor



####### A small list of useful commands and tricks for reference ##########
a = c(5,15,5,20)
length(a)
?length                 # Use this to see documentation for function
sum(a)
mean(a)
sd(a)                   # Standard deviation
min(a)
max(a)
median(a)
sort(a)
a[a>10]                 # You can use logicals for indexing
which(a>10)             # Useful for finding indices satisfying condition
which.min(a)
which.max(a)


7 %/% 3                 # integer quotient
7 %%  3                 # remainder; modulo


!(5<3)                  # logical NOT
(5<3) | (9>7)           # logical OR
(5<3) & (9>7)           # logical AND

log(2)                  # logarithm base e
exp(2)                  # exponentiation base e, that is, e^x
sqrt(2)
factorial(3) 
choose(4,2)             # binomial coefficients
floor(2.3)              # round down to nearest integer
ceiling(2.3)            # round up to nearest integer
round(2.7)

1:5                     # make integer sequence
seq(1,5,.2)             # make sequences with arbitrary intervals
rep(1,5)                # repeat an entry

rep('color', 10)
