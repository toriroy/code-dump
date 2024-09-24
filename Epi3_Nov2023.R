##########################################
###						   ###
###   1. Example data for class 	   ###
###						   ###
##########################################
bmt1<-read.table("S:\\wolfb\\Classes\\Epi3_Survival2023\\BoneMarrowText.txt", header=TRUE, sep=" ")
head(bmt1)

### 1e. Exploring and manipulating data in R
table(bmt1$PatientSex)
mean(bmt1$PatientSex)
sum(bmt1$PatientSex)

mean(bmt1$PatientAge)
sqrt(var(bmt1$PatientAge))
range(bmt1$PatientAge)

table(bmt1$DFS)
mean(bmt1$TTE)				### NOTE: This includes ALL subjects, even those who hadn't died
sqrt(var(bmt1$TTE))
mean(bmt1$TTE[which(bmt1$DFS==1)])	### NOTE: this drops all people who had not died by the end of the study
sqrt(var(bmt1$TTE[which(bmt1$DFS==1)]))
par(mfrow=c(2,1))
hist(bmt1$TTE, xlab="Time to Death or Relapse (days)", main="All Patients", col=5)
hist(bmt1$TTE[which(bmt1$DFS==1)], xlab="Time to Death or Relapse (days)", main="Patients who died/relapsed", col=5)



##########################################
###						   ###
### 2. BASIC KAPLAN-MEIER TYPE CURVES  ###
###						   ###
##########################################
library(survival)
### 2a. Fitting/Plotting survival and cumulative hazard curves
t<-c(10,20,35,40,50,55,70,71,80,90)
d<-c(1,0,1,0,0,1,0,0,1,0)
st1<-Surv(t,d)
fit.km<-survfit(st1~1)					
fit.km
summary(fit.km)

st2<-Surv(bmt1$TTE, bmt1$DFS)
fit.km2<-survfit(st2~1)
summary(fit.km2)

### Plotting KM curve
par(mfrow=c(2,1))
plot(fit.km2, conf.int=F, xlab="Time to Event", ylab="Survival Function", lwd=2, mark.time=TRUE)

### Plotting cumulative hazard curve
plot(fit.km2, conf.int=F, fun="cumhaz", lwd=2, xlab="Time to Event", ylab="Cumulative Hazard", mark.time=TRUE)


### 2b. ESTIMATING SURVIVAL PROBABILITIES AND TIMES
	### Median and other quantiles in Bone Marrow Transplant Data
quantile(fit.km, c(0.25, 0.5))

	### 6 months, 1 year, and 2 year survival in Bone Marrow Transplant Data
survprob.timet<-function(fit, time)
{
 loc<-max(which(fit$time<=time))
 if (is.null(fit$conf.type)==T)
	print(paste("S(t) = ", fit$surv[loc], sep=""))
 if (is.null(fit$conf.type)==F)
	print(paste("S(t) = ", round(fit$surv[loc], 3), ", ", 100*fit$conf.int, "% CI = (", 
		round(fit$lower[loc], 3), ", ", round(fit$upper[loc], 3), ")", sep=""))
}

survprob.timet(fit.km, 182.5)
survprob.timet(fit.km, 730)


############################################
###						     ###
### 3. HYPOTHESIS TESTING WITH LOG-RANK  ###
###						     ###
############################################
### 3a. Log-rank type test
survdiff(st2~MTX, data=bmt1)
survdiff(st2~group, data=bmt1)

par(mfrow=c(1,2))
plot(survfit(st~MTX, data=bmt1), xlab="Time to Death (days)", ylab="", main="Methotrxate", col=1:2, lwd=2)
legend(1800, 1, c("No MTX","MTX"), col=c(1,2), lwd=2, bty="n")
text(2150, 0.8, "p = 0.092 ")

plot(survfit(st~group, data=bmt1), xlab="", ylab="", main="Disease Group", col=1:3, lwd=2)
legend(1500, 1, c("ALL","AML Low Risk", "AML High Risk"), col=1:3, lwd=2, bty="n")
text(1950, 0.75, "p = 0.001 ")



#############################################
###						      ###
### 4. OVERVIEW OF COX REGRESSION MODELS  ###
###						      ###
#############################################
### 4a. Global and Local Hypothesis Testing Cox models
	### Example global test and some local tests
dxmod<-coxph(st2~as.factor(group), data=bmt1)
summary(dxmod)
	### Linear contrast to compare AML low vs. AML high risk
delt<-t(c(1,-1))%*%dxmod$coef
delt
dse<-sqrt(t(c(1,-1))%*%dxmod$var%*%c(1,-1))
dse
pval<-pchisq((delt/dse)^2, df=1, lower=F)
pval

	### Categorical Covariate: Methotrexate Use
mtx.mod<-coxph(st2~MTX, data=bmt1)
summary(mtx.mod)

	### Categorical Covaraite with more than 2 levels: Disease type
dx.mod<-coxph(st2~as.factor(group), data=bmt1)
summary(dx.mod)
	

	### Continuous covariate: patient age
ptage.mod<-coxph(st2~PatientAge, data=bmt1)
summary(ptage.mod)
exp(ptage.mod$coef*10)

	### More than 1 covariat: MTX and Patient Sex
mtx_ptsex.mod<-coxph(st2~MTX+PatientSex, data=bmt1)
summary(mtx_ptsex.mod)
	
### 4b. Modeling Interactions 
dpsex.mod<-coxph(st2~PatientSex+DonorSex+PatientSex*DonorSex, data=bmt1)
summary(dpsex.mod)

dpage.mod<-coxph(st2~PatientAge+DonorAge+PatientAge*DonorAge, data=bmt1)
summary(dpage.mod)

###4c. Time Varying Covariates
expand.data<-function(event, eventtime, tvc, timetvc, data)
{
 n<-nrow(data)
 timeloc<-which(colnames(data)%in%c(eventtime, timetvc))
 outc<-which(colnames(data)%in%event)
 eloc<-which(colnames(data)%in%c(event, tvc))
 fixdat<-data[,-c(timeloc, eloc)]
 longdata<-matrix(, nrow=0, ncol=ncol(fixdat))
 tvdat<-matrix(, nrow=0, ncol=length(eloc)+2)
 colnames(tvdat)<-c("Start","Stop",event,tvc)
 for (i in 1:n)
	{
	times<-as.numeric(data[i,timeloc])
	utimes<-unique(times[which(times<=times[1])])
	ntimes<-length(utimes)
	utimes<-sort(utimes)
	ind<-data[i,eloc]
	if (ntimes>1) 
		{
		strt<-c(0, utimes)[-(ntimes+1)]
		stp<-utimes
		evnts<-matrix(0, nrow=ntimes, ncol=length(tvc))
		for (j in 1:(length(tvc)))
			{
			evnts[,j]<-ifelse(times[j+1]<stp, 1, 0)
			}
		if(data[i,outc]==1) evt<-c(rep(0, ntimes-1), 1)
		if(data[i,outc]==0) evt<-rep(0, ntimes)
		tvdat<-rbind(tvdat, cbind(strt, stp, evt, evnts))
		}
	if(ntimes==1)
		{
		strt<-0; stp<-max(times)
		evt<-ifelse(data[i,outc]==1, 1, 0)
		evnts<-as.numeric(data[i,eloc[-1]])
		tvdat<-rbind(tvdat, c(strt, stp, evt, evnts))
		}

	longdata<-rbind(longdata, fixdat[rep(i, ntimes),])
	}
 newdata<-cbind(tvdat, longdata)
 return(newdata)
}

bmt.long<-expand.data(event="DFS", eventtime="TTE", tvc=c("AGvHD","CGvHD","PlateletRecovery"), 
		timetvc=c("TAGvHD","TCGvHD","TimePlateletRecovery"), data=bmt1)	
st3<-Surv(bmt.long$Start, bmt.long$Stop, bmt.long$DFS)
pr.mod<-coxph(st3~PlateletRecovery, data=bmt.long)	
summary(pr.mod)


###########################################
###						    ###
###  4. DIAGNOSTICS FOR COX REGRESSION  ###
###						    ###
###########################################

### 4A. Model diagnostics, use of time varying covariates too address issues with proportional hazards	
	### Proportional hazards using Grambsch-Therneau test (based on Schoenfeld residuals)
mod<-coxph(st3~MTX, data=bmt.long)
cox.zph(mod)

fullmod<-coxph(st3~as.factor(group)+MTX+PlateletRecovery+PatientAge+DonorAge+
	PatientAge*DonorAge, data=bmt.long)
summary(fullmod)
cox.zph(fullmod)


### 4B. Introducing Time varying covariates to address proportional hazards issue...
### CHANGE-POINT MODEL for MTX
bmt.long$cp1MTX<-ifelse(bmt.long$Stop>466, bmt.long$MTX, 0)
bmt.long$cp2MTX<-ifelse(bmt.long$Stop<=466, bmt.long$MTX, 0)
fullmod2<-coxph(st3~as.factor(group)+PlateletRecovery+cp1MTX+cp2MTX+PatientAge+DonorAge+
	PatientAge*DonorAge, data=bmt.long)
summary(fullmod2)
cox.zph(fullmod2)


