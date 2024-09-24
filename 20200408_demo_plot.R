a<-SEIHFRsimulate_directtransmission(S0 = 1e3, E0=0, I0 = 1, tmax = 120, scenario = 1, 
                                   bd_1 = 0.001, bd_2 = 0.001, bd_3 = 0.001,
                                   bf_1 = 0, bf_2 = 0, bf_3 = 0,
                                   A = 1, n = 0, g = 0.2, sigma=0.2, b = 0.5, h = 0.5)
a<-as.data.frame(a)
plot(a[,1], a[,2], type="l", xlab="Time (days)", ylab="Number", col="grey", lwd=3, xlim=c(0,120), ylim=c(0,1000))
lines(a[,1], a[,3], type="l", col="blue", lwd=3, lty=2)
lines(a[,1], a[,4], type="l", col="red", lwd=3, lty=3)
lines(a[,1], a[,5], type="l", col="green", lwd=3, lty=4)
lines(a[,1], a[,6], type="l", col="orange", lwd=3, lty=5)
lines(a[,1], a[,7], type="l", col="black", lwd=3, lty=6)
legend(80, 800, c("S", "E", "I", "H", "F", "R"), col=c("grey", "blue", "red", "green", "orange", "black"), lty=c(1,2,3,4,5,6), lwd=3)
