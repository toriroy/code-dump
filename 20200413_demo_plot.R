par(mfrow=c(2,2))
tmax_entry <- 1000
ylim_B <- 2000000
a<-Cholera_simulate_directtransmission(S0 = 1e3, I0 = 1, tmax = tmax_entry, scenario = 1, 
                                       bd = 1, bf = 0, A = 1, m = 0, n = 0, n_c = 0.001, g = 0.1, w = 0,
                                       k = 10^5, epsilon= 100, delta= 1/41)
a<-as.data.frame(a)
plot(a[,1], a[,2], type="l", xlab="Time (days)", ylab="Number", col="grey", lwd=3, xlim=c(0,tmax_entry), ylim=c(0,1000))
lines(a[,1], a[,3], type="l", col="blue", lwd=3, lty=2)
lines(a[,1], a[,4], type="l", col="red", lwd=3, lty=3)

legend(400, 800, c("S", "I", "R"), col=c("grey", "blue", "red"), lty=c(1,2,3), lwd=3, ncol=3)

plot(a[,1], a[,5], type="l", xlab="Time (days)", ylab="Concentration", col="black", lwd=3, xlim=c(0,tmax_entry), ylim=c(0,ylim_B))
legend(400, ylim_B, c("B"), col="black", lty=1, lwd=3)
