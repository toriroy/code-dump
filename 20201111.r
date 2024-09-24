################################
# EPID 7135                    #
# Sample Code for Nov 11, 2020 #
################################
plot_Ri4 <- function(estimate_R_obj, df, Location, start_date, end_date) {
  p_Ioriginal<-plot(as.incidence(df$I, dates=df$dates),
                    xlab="Date of Positive Specimens", ylab="Incidence")
  g_Ioriginal<-p_Ioriginal+theme_classic()+theme(legend.position='none',legend.box="vertical")+
    scale_x_date(breaks=date_breaks("months"), labels=date_format("%b"),
                 limits=c(as.Date(start_date), as.Date(end_date)))+
    #scale_y_continuous(breaks=c(0,200,400,600), limits=c(0,700))+
    labs(title=Location)+
    scale_fill_manual(name="", labels="Confirmed", values = "grey50")
  p_I <- plot(estimate_R_obj, "incid",      
              options_I=list(xlab="Episode Date"),
              legend = F)  # plots the incidence
  
  g_I<-p_I+theme_classic()+theme(legend.position='none',legend.box="vertical")+
    scale_x_date(breaks=date_breaks("months"), labels=date_format("%b"),
                 limits=c(as.Date(start_date), as.Date(end_date)))+
    #scale_y_continuous(breaks=c(0,200,400,600), limits=c(0,700))+
    labs(title="By Assumed Episode Date")+
    scale_fill_manual(name="", labels="Confirmed", values = "grey50")
  p_Ri <- plot(estimate_R_obj, "R", 
               options_R=list(xlab="Date"),
               legend = FALSE) 
  g_Ri<-p_Ri+theme_classic()+
    theme(legend.position='none', plot.margin=unit(c(0,0,0,0),"cm"))+  #top, right, bottom, left
    scale_x_date(breaks=date_breaks("months"), labels=date_format("%b"),
                 limits=c(as.Date(start_date), as.Date(end_date)))+
    scale_y_continuous(breaks=c(1,2,3,4), limits=c(0,5))+
    geom_hline(yintercept=1, linetype="dotted")+
    labs(title="",
         y=expression(R[t]))
  return(gridExtra::grid.arrange(g_Ioriginal, g_I, g_Ri, ncol = 1))
}

# Enter the location here:
Location <- "County_Name"
start_date <- "2020-03-01"
end_date <- "2020-11-07"
# Plot the whole figure
plot_Ri4(res_parametric_si, df, Location, start_date, end_date)

#save the figure as pdf
pdf(file="N_Rt4.pdf")
plot_Ri4(res_parametric_si, df, Location, start_date, end_date)
dev.off()

#save the figure as tiff
tiff(file="N_Rt4.tif", width=6, height=6, units='in', res=300)
plot_Ri4(res_parametric_si, df, Location, start_date, end_date)
dev.off()

#Save CSV file with Rt estimates
Rt<-as.data.frame(res_parametric_si[["R"]])
write.csv(Rt, file = "df_Rt.csv")

#save as the whole output as an RDS file
saveRDS(res_parametric_si, file="df_res_parametric_si.rds")
