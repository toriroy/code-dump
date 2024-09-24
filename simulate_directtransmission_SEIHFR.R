# This function is used in the solver function and has no independent usages
SEIHFRdirecttransmissioneq <- function(t, y, parms)
{
  with(
    as.list(c(y,parms)), #lets us access variables and parameters stored in y and pars by name
    {
      
      
      #force of infection for different scenarios: 1 = density-dependent, 2 = frequency-dependent
      N=S+E+I+H+Fu+R
      if (scenario==1) { f=bd_1*I/A + bd_2*I/A + bd_3*I/A;}
      if (scenario==2) { f=bf_1*I/N + bf_2*I/N + bf_3*I/N;}

      #the ordinary differential equations - includes birth-death and waning immunity
      dS = - f*S ; #susceptibles 
      dE = f*S - sigma*E; #exposed
      dI = sigma*E - h*I - g*I - n*I; #infected/infectious
      dH = h*I - g*H - n*H;
      dFu = n*I + n*H - b*Fu
      dR = g*I + g*H + b*Fu  ; #removed

      list(c(dS, dE, dI, dH, dFu, dR))
    }
  ) #close with statement
} #end function specifying the ODEs

  

  
#' Simulation of a compartmental infectious disease transmission model illustrating different types of direct transmission
#'
#' @description  This model allows for the simulation of different direct transmission modes
#' 
#'
#' @param S0 initial number of susceptibles
#' @param I0 initial number of infected hosts
#' @param tmax maximum simulation time, units of months
#' @param bd rate of transmission for density-dependent transmission
#' @param bf rate of transmission for frequency-dependent transmission
#' @param scenario choice between density dependent (=1) and frequency dependent (=2) transmission scenarios
#' @param A the size of the area in which the hosts are assumed to reside/interact
#' @param m the rate of births 
#' @param n the rate of natural deaths
#' @param g the rate at which infected hosts recover
#' @param w the rate of waning immunity
#' @return This function returns the simulation result as obtained from a call
#'   to the deSolve ode solver
#' @details A compartmental ID model with several states/compartments
#'   is simulated as a set of ordinary differential
#'   equations. The function returns the output from the odesolver as a list,
#'   with the element ts, which is a dataframe whose columns represent time,
#'   the number of susceptibles, the number of infected, and the number of
#'   recovered.
#' @section Warning:
#'   This function does not perform any error checking. So if you try to do
#'   something nonsensical (e.g. any negative values or fractions > 1),
#'   the code will likely abort with an error message
#' @examples
#'   # To run the simulation with default parameters just call this function
#'   result <- simulate_directtransmission()
#'   # To choose parameter values other than the standard one, specify them e.g. like such
#'   result <- simulate_directtransmission(S0 = 100, tmax = 100, A=10)
#'   # You should then use the simulation result returned from the function, e.g. like this:
#'   plot(result$ts[,"Time"],result$ts[,"S"],xlab='Time',ylab='Number Susceptible',type='l')
#' @seealso The UI of the shiny app 'DirectTransmission', which is part of this package, contains more details on the model
#' @author Andreas Handel
#' @references See e.g. Keeling and Rohani 2008 for SIR models and the
#'   documentation for the deSolve package for details on ODE solvers
#' @export



SEIHFRsimulate_directtransmission <- function(S0 = 1e3, E0= 0, I0 = 1, tmax = 120, scenario = 1, 
                                            bd_1 = 0.01, bd_2 = 0.01, bd_3 = 0.01, bf_1 = 0.01, bf_2 = 0.01, bf_3 = 0.01, 
                                            A = 1, n = 0, g = 0.1, sigma=0.5, b = 0.5, h = 0.5)
{
  ############################################################
  Y0 = c(S = S0, E = E0, I = I0, H = 0, Fu=0, R = 0);  #combine initial conditions into a vector
  dt = min(0.1, tmax / 1000); #time step for which to get results back
  timevec = seq(0, tmax, dt); #vector of times for which solution is returned (not that internal timestep of the integrator is different)
  
  
  ############################################################
  #vector of parameters which is sent to the ODE function  
  pars=c(tmax = tmax, 
         bd_1 = bd_1, bd_2 = bd_2, bd_3 = bd_3, 
         bf_1 = bf_1, bf_2 = bf_2, bf_3 = bf_3, 
         A = A, n = n, g = g, sigma=sigma, 
         b = b, h = h,
         scenario = scenario); 

  #this line runs the simulation, i.e. integrates the differential equations describing the infection process
  #the result is saved in the odeoutput matrix, with the 1st column the time, the 2nd, 3rd, 4th column the variables S, I, R
  #This odeoutput matrix will be re-created every time you run the code, so any previous results will be overwritten
  odeoutput = deSolve::lsoda(Y0, timevec, func = SEIHFRdirecttransmissioneq, parms=pars, atol=1e-12, rtol=1e-12);
  
  colnames(odeoutput) = c('Time','S','E', 'I', 'H', 'Fu', 'R')
  
  result = list()
  result$ts <- as.data.frame(odeoutput)
  
  return(result)
  # return(odeoutput)
}
