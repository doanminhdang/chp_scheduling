# -*- coding: utf-8 -*-

"""
Created on Mar 21th 2019
Solver-SCIP
Problem-KWKK_MILP: All Components included. Constant powers and Constant Efficiencies. Mixed Tanks.
P8P Style of coding
"""
# %%
# Library and Package imports
import pylab as pl
from pyscipopt import quicksum, Model
from datetime import datetime
import time
from Libraries.auxiliary_functions import AuxFunc,ReadExcel,\
Forecasts,Plots,SPS,DB_Comm
pl.close("all")
# %%
# Booleans for Real/Simulation, Forecast/ NO Forecast
real = True# True/False = Experiment/Simulation
f_cast = True# True/False = darksky forecast/values on file
epex_read = False# True/False = epex forecast/values on file
# %%
# Formulate the MILP Problem as a Function
# N receives the number of time steps to solve per iteration
# dt is the amount of steps to discretizice the model eg. dt =  4 is every 15 min = 1hr /  4 for every hour dt = 1.
# Par* = the parameters that are solved every iteration as the Cost of electricity per time window.

def kwkk_opt(N, dt, past_values, Par_C_El_B, Par_C_El_S, Par_T_Amb_bin, \
             Par_Load_El, Par_Load_H, Par_Load_C, T_HP_max, T_HP_min, \
             T_AdCM_min, LS_CHP_S, LS_HP_S, LS_CCM_S, LS_AdCM_S):

    model = Model("kwkk_milp")  # Name of Model

# Declare the variables of the model as dictionaries 

    Pel_CHP, Pgrid_B, Pgrid_S, Pth_COIL, Pth_HP, Pth_CHP, Pth_AdCM_HT, \
    Pth_AdCM_LT, Pel_CCM, Pel_AdCM, Pel_AUX, Pth_CCM, Pel_OC, V_FUEL,\
    CHP_bin, COIL_bin, HP_bin, CCM_bin, AdCM_bin, T_HTES, T_CTES,\
    HP_S_bin, CHP_S_bin, CCM_S_bin, AdCM_S_bin, HTES_slack, HTES_slack_obj = {},{},{},{},{},{},{},{},{},\
    {},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}

# Define the variables of the model as lists of pre-defined size. These will be vectors to be fit in the optimisation framework
    for j in range((N)+past_values):  # 0 to N+past_values

        Pel_CHP[j] = model.addVar(vtype="C", name="Pel_CHP_{0}".format(j), lb=0.0, ub=Pmax_CHP_El)
        Pgrid_B[j] = model.addVar(vtype="C", name="Pgrid_B_{0}".format(j), lb=0.0)
        Pgrid_S[j] = model.addVar(vtype="C", name="Pgrid_S_{0}".format(j), lb=0.0)
        Pth_COIL[j] = model.addVar(vtype="C", name="Pth_COIL_{0}".format(j), lb=0.0, ub=Pmax_COIL_Th)
        Pth_HP[j] = model.addVar(vtype="C", name="Pth_HP_{0}".format(j), lb=0.0, ub=Pmax_HP_Th)
        Pth_CHP[j] = model.addVar(vtype="C", name="Pth_CHP_{0}".format(j), lb=0.0, ub=Pmax_CHP_Th)
        Pth_AdCM_HT[j] = model.addVar(vtype="C", name="Pth_AdCM_HT_{0}".format(j), lb=0.0, ub=Pmax_AdCM_HT_Th)
        Pth_AdCM_LT[j] = model.addVar(vtype="C", name="Pth_AdCM_LT_{0}".format(j), lb=0.0, ub=Pmax_AdCM_LT_Th)
        Pel_AdCM[j] = model.addVar(vtype="C", name="Pel_AdCM_{0}".format(j), lb=0.0, ub=Pmax_AdCM_El)
        Pel_CCM[j] = model.addVar(vtype="C", name="Pel_CCM_{0}".format(j), lb=0.0, ub=Pmax_CCM_El)
        Pel_AUX[j] = model.addVar(vtype="C", name="Pel_AUX_{0}".format(j), lb=0.0)
        Pth_CCM[j] = model.addVar(vtype="C", name="Pth_CCM_{0}".format(j), lb=0.0, ub=Pmax_CCM_Th)
        Pel_OC[j] = model.addVar(vtype="C", name="Pel_OC_{0}".format(j), lb=0.0)
        V_FUEL[j] = model.addVar(vtype="C", name="V_FUEL_{0}".format(j), lb=0.0, ub=fuel_IP)
        T_HTES[j] = model.addVar(vtype="C", name="T_HTES_{0}".format(j))  #no bounds due to slacks

        T_CTES[j] = model.addVar(vtype="C", name="T_CTES_{0}".format(j))
        CHP_bin[j] = model.addVar(vtype="B", name="CHP_bin_{0}".format(j))
        COIL_bin[j] = model.addVar(vtype="B", name="COIL_bin_{0}".format(j))
        HP_bin[j] = model.addVar(vtype="B", name="HP_bin_{0}".format(j))
        CCM_bin[j] = model.addVar(vtype="B", name="CCM_bin_{0}".format(j))
        AdCM_bin[j] = model.addVar(vtype="B", name="AdCM_bin_{0}".format(j))
        HP_S_bin[j] = model.addVar(vtype="B", name="HP_S_bin_{0}".format(j))
        CHP_S_bin[j] = model.addVar(vtype="B", name="CHP_S_bin_{0}".format(j))
        CCM_S_bin[j] = model.addVar(vtype="B", name="CCM_S_bin_{0}".format(j))
        AdCM_S_bin[j] = model.addVar(vtype="B", name="AdCM_S_bin_{0}".format(j))
        HTES_slack[j] = model.addVar(vtype="C", name="HTES_slack_{0}".format(j))
        HTES_slack_obj[j] = model.addVar(vtype="C", name="HTES_slack_obj_{0}".format(j))
        
    # Tank temperatures for the initial and final values in the vector
    T_HTES[(N)+past_values] = model.addVar(vtype="C", name="T_HTES_{0}".format((N)+past_values)) # N+1th variable 
  
    T_HTES[0+past_values] = model.addVar(vtype="C", name="T_HTES_{0}".format(0+past_values), lb=T_HTES_init_0, ub=T_HTES_init_0)  # initial value variable
    T_CTES[(N)+past_values] = model.addVar(vtype="C", name="T_CTES_{0}".format((N)+past_values), lb=CTES_Cold, ub=CTES_Warm)
    T_CTES[0+past_values] = model.addVar(vtype="C", name="T_CTES_{0}".format(0+past_values), lb=T_CTES_init_0, ub=T_CTES_init_0)

# ??? For the section till runtime?? to be explained better!!

    for j in range(0, past_values):

        HP_bin[j] = model.addVar(vtype="I", name="HP_bin_{0}".format(j), lb=int(LS_HP_S[j]), ub=int(LS_HP_S[j]))
        CHP_bin[j] = model.addVar(vtype="I", name="CHP_bin_{0}".format(j), lb=int(LS_CHP_S[j]), ub=int(LS_CHP_S[j]))
        CCM_bin[j] = model.addVar(vtype="I", name="CCM_bin_{0}".format(j), lb=int(LS_CCM_S[j]), ub=int(LS_CCM_S[j]))
        AdCM_bin[j] = model.addVar(vtype="I", name="AdCM_bin_{0}".format(j), lb=int(LS_AdCM_S[j]), ub=int(LS_AdCM_S[j]))

# Define the constraints.
# First the energy balances and the physical constraints
    for t in range(past_values, (N)+past_values):
        # Electricity Balance
        # Pel_CHP - Pel_All_Loads + Pel_Grid_Buy - Pel_Grid_Sell = 0
        # In the objective function buying is +ve and selling is -ve
        # Thus if Pel_CHP - Pel_All_Loads > 0 then optimiser will sell to meet energy balance and make buying = 0. Vice-Versa is also true
        # This is however true only if buying price > selling price. Otherwise both buying and selling may occur to reach better optimisation values\
        # since the ub on these variables is inf. And energy balance can still be met. So binaries must be introduced to constraint bidirectional power flow
        model.addCons(0 == (Pel_AUX[t]) + (Pel_OC[t]) + (Pel_CCM[t]) + (Pel_AdCM[t]) + (Pth_HP[t]*(1./COP_HP)) + \
                      (Pth_COIL[t] * (1./Pth_eff_COIL)) + (Par_Load_El[t-past_values] * (1./dt)) - (Pel_CHP[t]) - Pgrid_B[t] + Pgrid_S[t])
        # Thermal Balance, Heat and Cold
        model.addCons(0 == (((T_HTES[t+1] - T_HTES[t]) * (1./3600)) * (HTES_Cap*rho_w*cp_w)) - ((Pth_HP[t] + Pth_COIL[t] + Pth_CHP[t])\
                            - Pth_AdCM_HT[t] - Par_Load_H[t-past_values] * (1./dt)))
        model.addCons(0 == (((T_CTES[t+1]-T_CTES[t]) * (1./3600)) * (CTES_Cap*rho_w*cp_w)) + ((Pth_CCM[t] + Pth_AdCM_LT[t]) \
                            - Par_Load_C[t-past_values] * (1./dt)))
        # Physical characteristics including switches
        model.addCons(0 == (Pel_CHP[t]*dt) - (Pmax_CHP_El * CHP_bin[t]))
        model.addCons(0 == (Pel_AdCM[t]*dt) - (Pmax_AdCM_El * AdCM_bin[t]))
        model.addCons(0 == (Pel_CCM[t]*dt) - (Pmax_CCM_El * CCM_bin[t]))
        model.addCons(0 == (Pel_AUX[t]*dt) - ((0.7 * HP_bin[t]) + (0.1 * AdCM_bin[t]) + (0.3 * CCM_bin[t]) + (0.1)))  # Auxiliary consumption in \
        # different modes, assumed constant and values from experiments
        model.addCons(0 == (Pel_OC[t]*dt) - ((0.9 * HP_bin[t]) + (0.9 * AdCM_bin[t])+(0.9 * CCM_bin[t])))  # Consumption of OC in different modes,\
        # assumed constant and maximum value that OC consumes = 0.9kWel
        model.addCons(0 == (Pth_HP[t]*dt) - (Pmax_HP_Th * HP_bin[t]))
        model.addCons(0 == (Pth_COIL[t]*dt) - (Pmax_COIL_Th * COIL_bin[t]))
        model.addCons(0 == (Pth_CHP[t]*dt) - (Pmax_CHP_Th * CHP_bin[t]))
        model.addCons(0 == (Pth_AdCM_HT[t]*dt) - (Pmax_AdCM_HT_Th * AdCM_bin[t]))
        model.addCons(0 == (Pth_AdCM_LT[t]*dt) - (Pmax_AdCM_LT_Th * AdCM_bin[t]))
        model.addCons(0 == (Pth_CCM[t]*dt) - (Pmax_CCM_Th * CCM_bin[t]))
        model.addCons(0 == (V_FUEL[t]*dt) - (fuel_IP * CHP_bin[t]))
        # Physical restrictions of components programmed using binaries
        model.addCons(0 <= (CHP_bin[t] + HP_bin[t] <= 1))  # HP and CHP cannot work at the same time
        model.addCons(0 <= (CCM_bin[t] + HP_bin[t] + AdCM_bin[t] <= 1))  # HP, CCM and AdCM cannot run together
        model.addCons(0 <= (Par_T_Amb_bin[t-past_values] + HP_bin[t] <= 1))  # HP can work only if T_Amb > Limit\
        # ParT_amb_bin is obtained via  function "binarytransform".
        # System  constraints big M
        model.addCons((T_HTES[t] - 500*(1-HP_bin[t])) <= T_HP_max)  # if T_HTES > T_HP_max(in K) it it not possible to turn ON the Heat Pump.
        model.addCons((-T_HTES[t] - 500*(1-AdCM_bin[t])) <= -T_AdCM_min)
        model.addCons(HTES_Cold <= (T_HTES[t+1] + HTES_slack[t] <= HTES_Warm) )
        model.addCons(HTES_slack_obj[t] == HTES_slack[t]**2 )  # this formulation used since quadratic terms are not allowed in SCIP cost functions.


# System maximum switching constraints
    for k in range(1, (N)+past_values):  # Number of flanks calculation
        model.addCons((CHP_bin[k-1]-CHP_bin[k]-CHP_S_bin[k] <= 0))  # calculates flanks by calculating for CHP_S_bin after checking binary value at t-1 and t  
        model.addCons((-CHP_bin[k-1]+CHP_bin[k]-CHP_S_bin[k] <= 0))  # same as above                                                                 
        model.addCons((HP_bin[k-1]-HP_bin[k]-HP_S_bin[k] <= 0))  # 
        model.addCons((-HP_bin[k-1]+HP_bin[k]-HP_S_bin[k] <= 0))
        model.addCons((CCM_bin[k-1]-CCM_bin[k]-CCM_S_bin[k] <= 0))           
        model.addCons((-CCM_bin[k-1]+CCM_bin[k]-CCM_S_bin[k] <= 0))
        model.addCons((AdCM_bin[k-1]-AdCM_bin[k]-AdCM_S_bin[k] <= 0))           
        model.addCons((-AdCM_bin[k-1]+AdCM_bin[k]-AdCM_S_bin[k] <= 0))        
     
  
    for k in range((past_values-1), (N)+past_values):  # for ex. range (3, N+3). this is one value before . The optimisation horizon starts at 4 and goes till N+4
        
        model.addCons((quicksum(CHP_S_bin[k-j] for j in range(int(min_runtime_CHP*dt))) <= 1))  # loops this loop first before doing the outer loop \
        # Example Calculation: for min_runtime_CHP = 1 and dt = 1 -> CHP_bin[3] <= 1 and then CHP_bin[4] < 1 and so on.\
        # Example Calculation: for min_runtime_CHP = 1 and dt = 2 -> CHP_bin[3] + CHP_bin[2] <= 1 and then CHP_bin[4] + CHP_bin[3] <= 1 and so on.\
        # Example Calculation: for min_runtime_CHP = 1 and dt = 4 -> CHP_bin[3] + CHP_bin[2] + CHP_bin[1] + CHP_bin[0] <= 1 
        model.addCons((quicksum(AdCM_S_bin[k-j] for j in range(int(min_runtime_CHP*dt))) <= 1))
        
    for k in range((past_values-1), (N)+past_values):     
        model.addCons((quicksum(HP_S_bin[k-j] for j in range(int(min_runtime_HP*dt))) <= 1))
        # Example Calculation: for min_runtime_HP = 0.5 and dt = 2 -> HP_bin[3] <= 1 and then HP_bin[4] < 1 and so on.\
        # Example Calculation: for min_runtime_HP = 0.5 and dt = 4 -> HP_bin[3] + HP_bin[2] <= 1 and then HP_bin[4] + HP_bin[3] <= 1 and so on.\
        model.addCons((quicksum(CCM_S_bin[k-j] for j in range(int(min_runtime_HP*dt))) <= 1))  #
# Cost Function
    model.setObjective(quicksum((Par_C_El_B[t-past_values]*Pgrid_B[t]) + (fuel_price*V_FUEL[t]) + (1e4* HTES_slack_obj[t]) - (Par_C_El_S[t-past_values]*Pgrid_S[t]) \
                                for t in range(past_values, (N)+past_values)))
# Add the variables to the data set, for later retrieval ----
    model.data = Pel_CHP, Pgrid_B, Pgrid_S, Pth_COIL, Pth_HP, Pth_CHP, V_FUEL, CHP_bin, COIL_bin, \
        HP_bin, CCM_bin, AdCM_bin, T_HTES, CHP_S_bin, HP_S_bin, CCM_S_bin, AdCM_S_bin, Pel_CCM, \
        Pel_AdCM, Pel_AUX, Pel_OC, Pth_CCM, Pth_AdCM_HT, Pth_AdCM_LT, T_CTES, HTES_slack, HTES_slack_obj
    return model
# %%
# Variables to store data at each step of the optimization

Step_T_HTES, Step_T_CTES, Stepplus_T_HTES, Stepplus_T_CTES, T_Amb_f_15 , \
T_Amb_Forec_real_15 , Pth_Load_Heat , Pth_Load_Cool = \
[],[],[],[],[],[],[],[]
# %%
# User input for component parameters


# Powers
Pmin_CHP_Th = 0  # kW_th
Pmax_CHP_Th = 0 # 10.3 "-1.3" is for the thermal losses
Pmin_CHP_El = 0
Pmax_CHP_El = 0  # kW_el
Pmin_COIL_Th = 0
Pmax_COIL_Th = 5.7  # kW_th
Pmin_HP_Th = 0
Pmax_HP_Th = 0  # 16 kW_Th, 0 for Summer when HP is not considered
Pmin_AdCM_Th = 0
Pmax_AdCM_HT_Th = 0  # For the system we have 10 is OK. It is impractical to run COIL and heat up tank to convert to cooling
Pmax_AdCM_LT_Th = 0  # 7.5 with latest test, 6.5 considering Manufacturer's COP of 0.65
Pmin_AdCM_El = 0
Pmax_AdCM_El = 0
Pmin_CCM_Th = 0
Pmax_CCM_Th = 0
Pmin_CCM_El = 0
Pmax_CCM_El = 0

# Efficiencies
COP_HP = 4.45
Pth_eff_COIL = 0.95

# Storage Tank
HTES_Cap = 1.5  # m³, Assuming no loss in the tank
CTES_Cap = 1.5

# Thermodynamical properties
rho_w = 977.8  # kg/m³
cp_w = 4.180  # kJ/kg.K

# Volume flow of Fuel for CHP. Assuming Gas CHP and using HCV
fuel_IP = 1.48  # m³/h 

# Fuel Price
fuel_price = 0.72  # Eur/m³ for Gas

# Electricity Base Price
base_sell = 0.150  # Euro/kWh_el
base_buy = 0.209

# User input for temperature ranges in tanks
HTES_Warm = 80 + 273.15  # K, Highest allowed temp in HTES
HTES_Cold = 36 + 273.15  # K, Lowest allowed temp in HTES, 55 for summer considering AdCM
CTES_Warm = 50 + 273.15  # K, 18 could be considered thinkin of a 2 K in-built slack variable for T_Fl_Load of 16°C 
CTES_Cold = 10 + 273.15  # K, Optimiser must decide how much the tank should be cooled down

# User input for ambient temperature constraints
T_HP_min = 12  # Minimum ambient temp. to operate the HP

# User input for HTES temp. restrictions for HP and AdCM
T_HP_max = 40 + 273.15  # Max HTES temp. when HP is ON, Could be different in case of mixed tank
T_AdCM_min = 50 + 273.15  # Minimum temp. the HTES must have to operate the AdCM.


#Initial tank temperatures and energies
T_HTES_init_0 = 50 +273.15
T_CTES_init_0 = 13 +273.15  # Initial temperature in the Tank

Q_HTES_init = ((((T_HTES_init_0-HTES_Cold)/3600.)*(HTES_Cap*rho_w*cp_w)))  # 77.5 # kW Initial Power in Tank
Q_CTES_init = ((((T_CTES_init_0-CTES_Cold)/3600.)*(CTES_Cap*rho_w*cp_w)))

# Previous four values
LS_CHP_S = pl.array([0, 0, 0, 0]) # ??? check for possibility of multiplying with min_runtime
LS_CHP_S = pl.array([0, 0, 0, 0]) # ??? check for possibility of multiplying with min_runtime
LS_HP_S = pl.array([0, 0, 0, 0])
LS_CCM_S = pl.array([0, 0, 0, 0])
LS_AdCM_S = pl.array([0, 0, 0, 0])

""" User input to formulate the MILP Problem and discretisations The horizon part is a bit complicated to make the minimum run time constraint work. 
The entire horizon over which the calculation works is the sum of the past horizon and forecast horizon. Calculation horizon = [0:N+past_values] which could be imagined to be made up of \
(0,1,2,3, 'past_values', 5 ,6 .... N + 'past_values'). Thus for the optimisation itself the user-defined value of 'past_values' is the first""" 

dt = 4  # Hour splitting factor or Discretization step. dt = 60 mins / time step(in mins). For ex. if time step = 15 mins, dt = 4.\
# This is called control_actions_per_hour in MINLP problem
forecast_horizon = 24 * 1  # hours to solve each iteration * number of days . This is the forecast horizon
N = forecast_horizon * dt  # N Total number of discretisations over the forecast horizon. +1 for Euler intergrator.
sampling_time = 60 / dt # in min  --- Time to wait between iterations              
t_amb_horz = forecast_horizon + 1  # 168hours in total can be set. this means weather will be forecasted for the next t_amb_horz hours.\
# 25 is the min required as it is forecasting for the 24 h + 15 min 
past_values = 4  # must be >= to minimum run times. This represents the number of values that should be remembered for the calculation horizon
min_runtime_HP = 1  # minimum run time of HP and CCM in hours. Should be defined such that int(min_runtime_HP * dt) > 1.\
# For ex. for a dt = 1 (1 hour grid) it is not sensible to keep a min_runtime of 0.5 hours
min_runtime_CHP = 1  # minimum run time of CHP and AdCM in hours
path = "C:/Users/PXI-PC/Documents/"
file_name = "Winter_7.5kW_Mixed_2019.05.23_Python.xlsx"
sheet_name = "Loadprofil_EPEX_EWERK_2week"

# Start the load depending on the hour
st = datetime.now().time().hour*dt + int(datetime.now().time().minute/(60/dt))  # In this case st is also a value based on the actual time and multiple of dt
#st = 0 * dt  # Give here number of hours to move ahead in the load file. st = Starting hour * dt. 
# %%
# Define number of iterations to solve
# Start the solving iteration loop
# Variable declaration of the looping
i = 0
#steps = 1  # DE- ACTIVATE for Experiments 
while True:  # ACTIVATE for experiments
#while i != steps:  # DE- ACTIVATE for Experiments. To solve for the amount of time steps defined
    # Define the incoming variables        
    start_time = time.time()
    date = datetime.now()
    solv_error = None    
    print('CPU_Clock_Time',date.time())
    
    """------ Retrieve data from excel ----"""
    file_data = ReadExcel(path + file_name, sheet_name)    
    Pth_Load_Heat_File, Pth_Load_Cool_File, Time, Pel_Load, C_El_B, C_El_S, T_Amb \
    = file_data.excel_data(dt) 
   
    """------ Retrieve load data from sps + correction ----"""
    if real:
        real_load = SPS.read_sps("LOAD_HC_W_PT_M___")
    else:
        real_load = None

    Pth_Load_Heat, Pth_Load_Cool = AuxFunc.correction_load(i, st, Pth_Load_Heat_File, Pth_Load_Heat, \
                                                   Pth_Load_Cool_File, Pth_Load_Cool, real_load)

    if real:  # If running real mode, read from sps the initial value
        T_HTES_init_0 = SPS.read_sps("HTES_H_W_T_M_IT_"+str(1)+"_") + 273.15
        T_CTES_init_0 = (SPS.read_sps("CTES_C_W_T_M_IT_"+str(1)+"_") + SPS.read_sps("CTES_C_W_T_M_IT_"+str(2)+"_") \
        + SPS.read_sps("CTES_C_W_T_M_IT_"+str(3)+"_") + SPS.read_sps("CTES_C_W_T_M_IT_"+str(4)+"_"))/4 + 273.15  # Average of the 4 CTES temperatures \
                         # since delta T is not large

    """------ Electricity Forecast ----"""
    try:
        da_buy15, da_sell15 = Forecasts.epexdata(dt, N, date, base_sell, base_buy, epex_read)
        Par_C_El_B = da_buy15  
        Par_C_El_S = da_sell15
        print('EPEX READ')
    except:
        print('EPEX NOT READ')
        Par_C_El_B = C_El_B[0+i+st:(N)+i+st]  # updating the parameter acccording to where we want to start
        Par_C_El_S = C_El_S[0+i+st:(N)+i+st]


    """------ Temperature forecast ----"""
    # call the forecast up to "t_amb_horz" times, transform it to 15 min intevals and append each one to the last forecast ´+ 1 step. Also first hour is same as real Aux_Tamb value
    if real:
        sps_temp = SPS.read_sps("AUX_HC_A_T_M___")
    else:
        sps_temp = None
    T_Amb_f_15, T_Amb_Forec_real_15 = \
    Forecasts.t_amb_forecast(t_amb_horz, i, T_Amb_f_15, sps_temp,f_cast,T_Amb,T_Amb_Forec_real_15,dt)

    """------ Parameters ----"""
    # define the parameter values that will change through time
    Par_T_Amb_bin = AuxFunc.binarytransform(T_HP_min, T_Amb_f_15[0+i:(N)+i])
    Par_Load_El = Pel_Load[0+i+st:(N)+i+st]
    Par_Load_H = Pth_Load_Heat[0+i+st:(N)+i+st]
    Par_Load_H_File = Pth_Load_Heat_File[0+i+st:(N)+i+st]
    Par_Load_C_File = Pth_Load_Cool_File[0+i+st:(N)+i+st]
    Par_Load_C = Pth_Load_Cool[0+i+st:(N)+i+st]

    """------ Create the optimization model from function ----"""
    try:
        model = kwkk_opt(N, dt, past_values, Par_C_El_B, Par_C_El_S, Par_T_Amb_bin, \
                         Par_Load_El, Par_Load_H, Par_Load_C, T_HP_max, T_HP_min, \
                         T_AdCM_min, LS_CHP_S, LS_HP_S, LS_CCM_S, LS_AdCM_S)

        print("Initial Temp = ", T_HTES_init_0-273.15, T_CTES_init_0-273.15)
        print("Iteration No.= _{0}_".format(i))

        """---------------- Optimize the model ------------------"""
        
        model.setRealParam('limits/time', 30)  # for limiting the solving time (seconds)
        model.optimize()  # optimize the model
    except:
        solv_error = 'Solving_error'
# Extract the variables from the model
    Pel_CHP, Pgrid_B, Pgrid_S, Pth_COIL, Pth_HP, Pth_CHP, V_FUEL, CHP_bin, COIL_bin, \
        HP_bin, CCM_bin, AdCM_bin, T_HTES, CHP_S_bin, HP_S_bin, CCM_S_bin, AdCM_S_bin, \
        Pel_CCM, Pel_AdCM, Pel_AUX, Pel_OC, Pth_CCM, Pth_AdCM_HT, Pth_AdCM_LT, T_CTES, HTES_slack, HTES_slack_obj = model.data
# %%
# Optimal variables
# Retrieve the  values of each optimization and append them as the optimal values
    P_El_CHP_opt = pl.array([model.getVal(Pel_CHP[j]) for j in range(past_values, (N)+past_values)])*dt
    P_El_CCM_opt = pl.array([model.getVal(Pel_CCM[j]) for j in range(past_values, (N)+past_values)])*dt
    P_El_AdCM_opt = pl.array([model.getVal(Pel_AdCM[j]) for j in range(past_values, (N)+past_values)])*dt
    P_El_AUX_opt = pl.array([model.getVal(Pel_AUX[j]) for j in range(past_values, (N)+past_values)])*dt
    P_El_OC_opt = pl.array([model.getVal(Pel_OC[j]) for j in range(past_values, (N)+past_values)])*dt
    Pgrid_B_opt = pl.array([model.getVal(Pgrid_B[j]) for j in range(past_values, (N)+past_values)])*dt
    Pgrid_S_opt = pl.array([model.getVal(Pgrid_S[j]) for j in range(past_values, (N)+past_values)])*dt
    Pth_COIL_opt = pl.array([model.getVal(Pth_COIL[j]) for j in range(past_values, (N)+past_values)])*dt
    Pth_HP_opt = pl.array([model.getVal(Pth_HP[j]) for j in range(past_values, (N)+past_values)])*dt
    Pth_CHP_opt = pl.array([model.getVal(Pth_CHP[j]) for j in range(past_values, (N)+past_values)])*dt
    Pth_AdCM_HT_opt = pl.array([model.getVal(Pth_AdCM_HT[j]) for j in range(past_values, (N)+past_values)])*dt
    Pth_AdCM_LT_opt = pl.array([model.getVal(Pth_AdCM_LT[j]) for j in range(past_values, (N)+past_values)])*dt
    Pth_CCM_opt = pl.array([model.getVal(Pth_CCM[j]) for j in range(past_values, (N)+past_values)])*dt
    V_FUEL_opt = pl.array([model.getVal(V_FUEL[j]) for j in range(past_values, (N)+past_values)])
# Binary Decision Variables     
    CHP_bin_opt = pl.array([model.getVal(CHP_bin[j]) for j in range(past_values, (N)+past_values)])
    COIL_bin_opt = pl.array([model.getVal(COIL_bin[j]) for j in range(past_values, (N)+past_values)])
    HP_bin_opt = pl.array([model.getVal(HP_bin[j]) for j in range(past_values, (N)+past_values)])
    CCM_bin_opt = pl.array([model.getVal(CCM_bin[j]) for j in range(past_values, (N)+past_values)])
    AdCM_bin_opt = pl.array([model.getVal(AdCM_bin[j]) for j in range(past_values, (N)+past_values)])
# Tank Temperatures    
    T_HTES_opt = pl.array([model.getVal(T_HTES[j]) for j in range(past_values, (N+1)+past_values)])
    T_CTES_opt = pl.array([model.getVal(T_CTES[j]) for j in range(past_values, (N+1)+past_values)])
    HTES_slack_opt = pl.array([model.getVal(HTES_slack_obj[j]) for j in range(past_values, (N)+past_values)])

    E_El_HP_opt = Pth_HP_opt*(1./COP_HP)
    E_El_COIL_opt = Pth_COIL_opt*(1./Pth_eff_COIL)

# Save the first optimal actions from each optimal solution for printing the whole optimal actions in time
    Step_T_HTES.append(T_HTES_opt[0])
    Step_T_CTES.append(T_CTES_opt[0])

    if i == 0:  # Used for plotting the temperature expected versus real temperature in the tank
        Stepplus_T_HTES.append(T_HTES_opt[0])
        Stepplus_T_CTES.append(T_CTES_opt[0])

    Stepplus_T_HTES.append(T_HTES_opt[1]) # This is the temperature which the model would have achieved if the optimal solution would have been applied
    Stepplus_T_CTES.append(T_CTES_opt[1])

# Part to append optimal control values  to the past defined values and delete the first value of the past list. Acts like a shifing mechanism
    LS_CHP_S = pl.delete(pl.append(LS_CHP_S, pl.array([model.getVal(CHP_bin[0+past_values])])), 0)
    LS_HP_S = pl.delete(pl.append(LS_HP_S, pl.array([model.getVal(HP_bin[0+past_values])])), 0)
    LS_CCM_S = pl.delete(pl.append(LS_CCM_S, pl.array([model.getVal(CCM_bin[0+past_values])])), 0)
    LS_AdCM_S = pl.delete(pl.append(LS_AdCM_S, pl.array([model.getVal(AdCM_bin[0+past_values])])), 0)

# %% Calculating and writing the optimal mode

    operation_mode = SPS.oprtmode(HP_bin_opt[0], CHP_bin_opt[0], CCM_bin_opt[0], AdCM_bin_opt[0])
    print('SOLVING TIME FOR OPTIMISER =', round(model.getSolvingTime(),2),'s')
    print('TOTAL TIME FOR OPTIMISER =', round(model.getTotalTime(),2),'s')

    if real:
        SPS.write_sps(operation_mode, COIL_bin_opt[0])  # To write the optimal mode and coil switch on the sps 
# %%
# Plot Graphs
    Plots.plotall(Time[0+i+st:(N)+i+st], 1 , dt, Par_Load_H, Pth_CHP_opt, Pth_HP_opt, Pth_COIL_opt, \
                 Par_C_El_B, Par_C_El_S, E_El_HP_opt, E_El_COIL_opt, Par_Load_El, Pgrid_B_opt, \
                 Pgrid_S_opt, P_El_CHP_opt, T_HTES_opt, T_Amb_f_15[0+i:(N)+i], T_HP_min, \
                 COIL_bin_opt, CHP_bin_opt, HP_bin_opt, T_Amb_Forec_real_15[0+i:(N)+i], \
                 Par_Load_H_File, Par_Load_C_File, Par_Load_C, P_El_AUX_opt, P_El_CCM_opt, P_El_AdCM_opt, Pth_AdCM_HT_opt, \
                 Pth_AdCM_LT_opt, P_El_OC_opt, Pth_CCM_opt, CCM_bin_opt, AdCM_bin_opt, N, T_CTES_opt, \
                 Q_HTES_init, Q_CTES_init, HTES_Cap, rho_w, cp_w, CTES_Cap)
    Plots.plotTdev(Step_T_HTES, Stepplus_T_HTES,0,'*')  # plot deviation in HTES temperature. Check which one to ACTIVATE  
#    Plots.plotTdev(Step_T_CTES, Stepplus_T_CTES,0,'*')  # plot deviation in CTES temperature

# %%
# Write to the IMG_KWKK Database
    
    data = {
        'Pel_KWKK': Pgrid_B_opt-Pgrid_S_opt,
        'CHP_Switch': CHP_bin_opt,
        'HP_Switch': HP_bin_opt,
        'COIL_Switch': COIL_bin_opt,
        'CCM_Switch': CCM_bin_opt,
        'AdCM_Switch': AdCM_bin_opt,
        'T_HTES': T_HTES_opt[0:N],
        'T_CTES': T_CTES_opt[0:N],
        'T_Amb': T_Amb_f_15[0+i:(N)+i],
        'Heat_Load': Par_Load_H,
        'Cool_Load': Par_Load_C,
        'P_El_CHP': P_El_CHP_opt,
        'P_El_HP': E_El_HP_opt,
        'P_El_COIL': E_El_COIL_opt,
        'P_El_CCM': P_El_CCM_opt,
        'P_El_AdCM': P_El_AdCM_opt,
        'P_El_AUX': P_El_AUX_opt,
        'P_El_OC': P_El_OC_opt,
        'Pgrid_B': Pgrid_B_opt,
        'Pgrid_S': Pgrid_S_opt,
        'Pth_COIL': Pth_COIL_opt,
        'Pth_HP': Pth_HP_opt,
        'Pth_CHP': Pth_CHP_opt,
        'Pth_AdCM': Pth_AdCM_HT_opt,
        'Pth_AdCM_LT' :Pth_AdCM_LT_opt,
        'Pth_CCM': Pth_CCM_opt,
        'El_Price_Buy' : Par_C_El_B,
        'El_Price_Sell' : Par_C_El_S
            }

    DB_Comm.db_rw(N, date, (Pgrid_B_opt-Pgrid_S_opt), data, write = True)  # Activate or Deactivate

# %%
# Calculate the time correction. Also to make sure we start at multiple of the sampling_time 
    end_time = time.time()
    print('TOTAL TIME TAKEN = ',round(end_time-start_time,2),'s')
    time_correction = ((sampling_time - (((int(datetime.now().time().minute/(60/dt))+1)*(60/dt))-\
                                         (datetime.now().time().minute)))*60)+datetime.now().second


    time.sleep((sampling_time*60)-time_correction) #  ACTIVATE for experiments

# For simulation purpose next optimisation the initial temperature in tank is reset.
    if real:
        pass
    else:
        T_HTES_init_0 = model.getVal(T_HTES[1+past_values])
        T_CTES_init_0 = model.getVal(T_CTES[1+past_values])

    print('THE TOTAL COST OF OPERATION FOR THE FORECAST HORIZON IS=', round(model.getObjVal()-pl.sum(HTES_slack_opt)*1e4,2),'€')

    i = i+1  # End of the loop, rest of calculations and increment i