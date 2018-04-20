# -*- coding: utf-8 -*-
"""
Created on Thu Apr  5 17:54:08 2018

@author: INES
"""

# -*- coding: utf-8 -*-
"""
Created on Tue Feb 20 19:15:45 2018

@author: Oscar VM
"""

"""----------------------------------------Library import definition----------------------------------------"""
"""---------------------------------------------------------------------------------------------------------"""
import pandas
import pylab as pl
from pyscipopt import quicksum, Model
from datetime import datetime
from darksky import forecast
from microkwkkcom import microKWKKcom
#from matplotlib.backends.backend_pdf import PdfPages
import time
pl.close("all")


global elapsed_time
elapsed_time = 0
roll_times = 0

"""-------------------------------------------Function Definition-------------------------------------------"""
"""---------------------------------------------------------------------------------------------------------"""
        
def T_amb_forecast(f_hours,i,Total_F_T,sizeb,t_amb_m): 
     ##---- Call a forecast for the next "f_hours" (max168) if one key doesnt work call it with another key, if not then use the last forecast data as the next one.
     ## -  "i" iterate on the loop the required value is i
     ## -  Total_F_T is the actual list with the forecasted values 
     ## -  sizeb recieves the maximum size of the total forecast horizon (m value ) as for comparing with sizea (size of actual forecasted temp list) if there is enough forecasted data for continuing in case of an api retrieve failure.
    sizea = len(Total_F_T)    
    meas_temp = t_amb_m                
    Og_coord = 48.491445, 7.952259#
    key1='8273ad8cd9c3979df031488e4a1e4509'
    key2='ee1ae28de91506ee5679851fa8a84a0b'
    queries = {'extend': 'hourly', 'units': 'si'}
    meas_temp = t_amb_m
    
    try:
        offenburg =  forecast(key1, *Og_coord,time= None,timeout=None,**queries)
        T_Amb_Fore_C = pl.array([hour.temperature for hour in offenburg.hourly[:f_hours]])

        roll_times = 0
    except:
        try:
            offenburg =  forecast(key2, *Og_coord,time= None,timeout=None,**queries)
            T_Amb_Fore_C = pl.array([hour.temperature for hour in offenburg.hourly[:f_hours]])
         
            roll_times = 0
        except:
            try:
               if roll_times < 96:
                   T_Amb_Fore_C= pl.roll(Total_F_T[i:],-1) # If no internet connection use the same data and roll it each 25 min
                   
                   roll_times = roll_times + 1
            except:
                
                print("Forecast data not accesible, using values from the excel File")
                T_Amb_Fore_C = T_Amb[i:]

#                if sizea < sizeb: 
#
#                else:
#                    print("Forecast data not accesible, enough forecast data to finish... proceeding")
#                    T_Amb_Fore_C = Total_F_T[i:] 
                
    T_Amb_Forec_real = pl.array(T_Amb_Fore_C)
    
    if meas_temp==None:
        pass
    else:

        T_Amb_Fore_C[0]= float(meas_temp)
        T_Amb_Fore_C[1]= float(meas_temp)
        
    return  T_Amb_Fore_C,  T_Amb_Forec_real

   
def hour_to_15min(dt, Input_list ):   #interpolate the values in dt steps to transform from 1 hour to 15 min
    sz=int(Input_list.size)-1         #dt = 4 for 15 min
    Split_list = []
    for i in range(sz):
        Split_list =  pl.append(Split_list[:i*(dt)],pl.linspace(Input_list[i],Input_list[i+1],dt+1))
    return Split_list    

def price_to_15min(dt, Input_list ): #Don´t interpolate values but repeat the same value i+(dt-1) times e.g  1,2,3,4 = 1,1,1,1,2,2,2,2,3,3,3.....
    sz=int(Input_list.size)          #dt = 4 for 15 min
    Split_list = []
    for i in range(sz):
        Split_list =  pl.append(Split_list,pl.ones(dt)*Input_list[i])
    return Split_list   

def time_to_15min(dt, Input_list):   #change the time vector from its original value to a list from 0 to the total forecast horizon in hours *dt
    sz=int(Input_list.size)*dt       #dt = 4 for changing to 15 min
#    Split_list = []
    Split_list = pl.array(range(sz))
    return Split_list
        
def binarytransform(comparison_value, input_list):     #Transforms a list into a binary integer one given a specified condition input_list <= comparison_value
    input_list = (input_list <= comparison_value)*1
    return input_list

def T_sps_Celsius(beckhoff_var):     
    ##--- Retrieves the temperature of a given variable in the sps ----
    ## - beckhof var takes the name of the beckhoff variable to retrieve the vaalue. A list of the selected values are: 
    ## - T of a layer in HTES --> "HTES_H_W_T_M_IT_"+str(layer)+"_" <---
    ## - T_amb in sensor      --> "AUX_HC_A_T_M___" <---
    try:
        mc = microKWKKcom(server_address = "141.79.92.19", server_port = "4840")
        kwkk_meas = mc.get_all_values()
        T_meas = round(float(kwkk_meas[str(beckhoff_var)]),1)
        return T_meas
    except:
        T_meas = None
        print('Connection to sps failed, please check the variable name or connection to the network')
        return T_meas
    
    
def optmode(HP_Switch, CHP_Switch): 
    ## ---- Select an optimal mode depending on the optimized values  ----
     if (round(CHP_Switch) == 1) and (round(HP_Switch) ==0):
         optimal_mode = float(1)
         print('CHP_ON, HP_OFF. Optimal_Mode:', str(optimal_mode))
     elif (round(CHP_Switch) == 0) and (round(HP_Switch) ==1):
         optimal_mode = float(4)
         print('CHP_OFF, HP_ON. Optimal_Mode:', str(optimal_mode))
     elif (round(CHP_Switch) == 0) and (round(HP_Switch) ==0):
         optimal_mode = float(0)
         print('CHP_OFF, HP_OFF. Using Tank Energy, Optimal_Mode:', str(optimal_mode))       
     else: 
         optimal_mode = float(0)
         print('Unrecognized Mode. Optimal_Mode:', str(optimal_mode))
     return optimal_mode
 
def setspsvals(opt_mode, COIL_Switch): 
    ## ----- Set an optimal mode into the sps server, also set the coil switch value -------
   
    if round(COIL_Switch) == 1:
        coil_value = True
    else: 
        coil_value = False
    try:    
        mc = microKWKKcom(server_address = "141.79.92.19", server_port = "4840")
        mc.set_value("COIL_H_W_B_O_IT__", value = coil_value)
        print(mc.get_value (device = "COIL_H_W_B_O_IT__"))
        mc.set_value(device = "Optimal_Mode", value = opt_mode)
        print(mc.get_value (device = "Optimal_Mode"))
    except:
        print('Connection to SPS unsuccesful, please retry and check connection to the SPS server.')


    """-----------------------------------------------"""
    """----- Define the MILP model as a function -----"""
    """-----------------------------------------------"""

    ## - n recieves the number of time steps to solve per iteration
    ## - dt is the amount of steps to discretizice the model eg. dt =  4 is every 15 min = 1hr /  4 for every hour dt = 1.
    ## - Par* = the parameters that aresolved every iteration as the Cost of electricity per time window.
    ## - n_switching is the allowed number of switching times per iteration in the n horizon.
def kwkk_opt(n , dt, n_switching_CHP,n_switching_HP,min_runtime, Par_C_El_B , Par_C_El_S , Par_T_Amb_bin, Par_Load_El , Par_Load_Th,T_HP_max,T_HP_min,LS_CHP_S,LS_HP_S):
    
   ## ---Naming the model ( any name can be given ) ----
    model = Model("kwkk_milp")
    
   ## ----- Declare the variables of the model -----
    E_El_CHP = {}
    Pgrid_B =  {}
    Pgrid_S =  {}
    Q_COIL =   {}
    Q_HP =     {}
    Q_CHP =    {}
    V_FUEL =   {}
    CHP_bin =  {}
    COIL_bin = {}
    HP_bin =   {}
    T_HTES =   {}
    HP_S_bin = {}
    CHP_S_bin =  {}
    HP_ON_bin =  {}
    CHP_ON_bin = {}
    HP_OFF_bin = {}
    CHP_OFF_bin ={}
#    Q_CHP_LOSS = {}
#    Q_Slack = {}
    
  ## ------ Define the variables of ther model -----  
    for j in range((n-1)+min_runtime):
    
        E_El_CHP[j] = model.addVar(vtype = "C", \
                        name = "E_El_CHP_{0}".format(j), \
                        lb = 0.0, ub = Pmax_CHP_El)
        Pgrid_B[j] =  model.addVar(vtype = "C", \
                        name = "Pgrid_B{0}".format(j), \
                        lb = 0.0)
        Pgrid_S[j] =  model.addVar(vtype = "C", \
                        name = "Pgrid_S{0}".format(j), \
                        lb = 0.0)
        Q_COIL[j] =   model.addVar(vtype = "C", \
                        name = "Q_COIL_{0}".format(j), \
                        lb = 0.0, ub = Pmax_COIL_Th)
        Q_HP[j] =     model.addVar(vtype = "C", \
                        name = "Q_HP_{0}".format(j), \
                        lb = 0.0, ub = Pmax_HP_Th)
        Q_CHP[j] =    model.addVar(vtype = "C", \
                        name = "Q_CHP_{0}".format(j), \
                        lb = 0.0, ub = Pmax_CHP_Th)
        V_FUEL[j] =   model.addVar(vtype = "C", \
                        name = "V_FUEL_{0}".format(j), \
                        lb = 0.0, ub = vdot_fuel) 
        T_HTES[j] =   model.addVar(vtype = "C", \
                        name = "T_HTES_{0}".format(j), \
                        lb = HTES_Cold, ub = HTES_Warm)
        CHP_bin[j] =  model.addVar(vtype = "B", \
                        name = "CHP_bin_{0}".format(j))
        COIL_bin[j] = model.addVar(vtype = "B", \
                        name = "COIL_bin_{0}".format(j))
        HP_bin[j] =   model.addVar(vtype = "B", \
                        name = "HP_bin_{0}".format(j))
        
        HP_S_bin[j] =   model.addVar(vtype = "B", \
                        name = "HP_S_bin_{0}".format(j))
        CHP_S_bin[j] =  model.addVar(vtype = "B", \
                        name = "CHP_S_bin_{0}".format(j))
        
        HP_ON_bin[j] =   model.addVar(vtype = "B", \
                        name = "HP_ON_bin_{0}".format(j))
        CHP_ON_bin[j] =  model.addVar(vtype = "B", \
                        name = "CHP_ON_bin_{0}".format(j))
        HP_OFF_bin[j] =  model.addVar(vtype = "B", \
                        name = "HP_OFF_bin_{0}".format(j))
        CHP_OFF_bin[j] = model.addVar(vtype = "B", \
                        name = "CHP_OFF_bin_{0}".format(j))
    
    T_HTES[(n-1)+min_runtime] = model.addVar(vtype = "C", \
                    name = "T_HTES_{0}".format((n-1)+min_runtime), \
                    lb = HTES_Cold, ub = HTES_Warm)
    
    T_HTES[0+min_runtime] =     model.addVar(vtype = "C", \
                    name = "T_HTES_{0}".format(0+min_runtime), \
                    lb = T_HTES_init_0, ub = T_HTES_init_0)
    
    for j in range(0,min_runtime):
    
        HP_bin[j] =  model.addVar(vtype = "I", \
                        name = "HP_bin_{0}".format(j), \
                        lb = int(LS_HP_S[j]), ub = int(LS_HP_S[j]))
    
        CHP_bin[j] = model.addVar(vtype = "I", \
                        name = "CHP_bin_{0}".format(j), \
                        lb = int(LS_CHP_S[j]), ub = int(LS_CHP_S[j]))

    ##------ Define the constraints -------
    
    for t in range(min_runtime,(n-1)+min_runtime):
    
        model.addCons(0 == (Q_HP[t]*(1./COP_HP))+(Q_COIL[t]*(1./Pth_eff_COIL))+(Par_Load_El[t-min_runtime]*(1./dt))-(E_El_CHP[t])-Pgrid_B[t]+Pgrid_S[t])#-Pgrid[t])
    
        model.addCons(0 == (((T_HTES[t+1]-T_HTES[t])* (1./3600))*(HTES_Cap*rho_w*cp_w))-(((Q_HP[t]+Q_COIL[t]+(Q_CHP[t])))-Par_Load_Th[t-min_runtime]*(1./dt)))
    
        model.addCons(0 == (E_El_CHP[t]*dt) - (Pmax_CHP_El * CHP_bin[t]))
       
        model.addCons(0 == (Q_HP[t]*dt)- (Pmax_HP_Th * HP_bin[t]))
        model.addCons(0 == (Q_COIL[t]*dt) - (Pmax_COIL_Th * COIL_bin[t]))
        model.addCons(0 == (Q_CHP[t]*dt) - (Pmax_CHP_Th * CHP_bin[t]))
    
        model.addCons(0 == (V_FUEL[t]*dt) - (vdot_fuel * CHP_bin[t]))
        
  
      ##------System  constraints in terms of binaries-------
        
        model.addCons(0 <= (CHP_bin[t]+HP_bin[t] <= 1)) #HP and CHP cannot work at the same time
        model.addCons(0 <= (Par_T_Amb_bin[t-min_runtime]+HP_bin[t] <= 1)) #HP should not work if Tamb is less than a certain level. ParT_amb_bin is obtained via binfunction.
#        model.addCons(0 <= (Par_T_Amb_bin[t-min_runtime]+HP_bin[t]-HP_S_bin[0]-HP_S_bin[1]-HP_S_bin[2]-HP_S_bin[3] <= 1)) #HP should not work if Tamb is less than a certain level. ParT_amb_bin is obtained via binfunction.
    
      
        ##------ System  constraints big M ------- 
        
        model.addCons( (T_HTES[t] - 500*(1-HP_bin[t]))<= T_HP_max) # --- if THTES > THP max(in K) it it not possible to turn on.
###     model.addCons( (T_HTES[t] + 200*(1-HP_bin[t]))>= T_HP_min) # in dev..-----if Tamb < Thp min x it it not possible   to turn on 
    
    
        ##------ System  constraints vanishing variables-------
     
#       model.addCons(0 >= HP_bin[t] *(T_HTES[t]-T_HP_max))     # --- if THTES > THP max(in k) it it not possible
###     model.addCons(0 >= HP_bin[t] *((T_HP_min+273.15)-T_Amb[t]))     # in dev..-----if Tamb < Thp min x it it not possible 
        
    
    ## ---- System maximum switching constraints -----
    for k in range(1,min_runtime+1):
        model.addCons((CHP_bin[k-1]-CHP_bin[k]-CHP_S_bin[k] <= 0)) 
        model.addCons((-CHP_bin[k-1]+CHP_bin[k]-CHP_S_bin[k] <= 0))
        model.addCons((HP_bin[k-1]-HP_bin[k]-HP_S_bin[k] <= 0)) 
        model.addCons((-HP_bin[k-1]+HP_bin[k]-HP_S_bin[k] <= 0))
            
    for k in range(1+min_runtime,(n-1)+min_runtime):   
       
        model.addCons((CHP_bin[k-1]-CHP_bin[k]-CHP_S_bin[k] <= 0)) 
        model.addCons((-CHP_bin[k-1]+CHP_bin[k]-CHP_S_bin[k] <= 0))
        
        model.addCons((HP_bin[k-1]-HP_bin[k]-HP_S_bin[k] <= 0)) 
        model.addCons((-HP_bin[k-1]+HP_bin[k]-HP_S_bin[k] <= 0))
     
  
    model.addCons(0<=(quicksum(CHP_S_bin[k] for k in range( min_runtime,(n-1)+min_runtime)) <= n_switching_CHP))
    model.addCons(0<=(quicksum( HP_S_bin[k] for k in range( min_runtime,(n-1)+min_runtime)) <= n_switching_HP))
#    model.addCons(0<=(quicksum(CHP_S_bin[k] for k in range((n-1))) <= n_switching_CHP))
#    model.addCons(0<=(quicksum( HP_S_bin[k] for k in range((n-1))) <= n_switching_HP))

    ##---Minimum runtime Constrains--------
    for k in range((min_runtime-1),(n-1)+min_runtime): 
            
        model.addCons((quicksum(CHP_S_bin[k-j]  for j in range(min_runtime)) <= 1))
        model.addCons((quicksum( HP_S_bin[k-j]  for j in range(min_runtime)) <= 1))

        
     ##  ---- ---- Add objective term. ------------
     
    model.setObjective(quicksum((Par_C_El_B[t-min_runtime]*Pgrid_B[t]) + (C_FUEL*V_FUEL[t]) - (Par_C_El_S[t-min_runtime]*Pgrid_S[t]) for t in range(min_runtime,(n-1)+min_runtime)))
    
     ## ---- Add the variables to the data set, for later retrieval ----
     
    model.data = E_El_CHP, Pgrid_B, Pgrid_S, Q_COIL, Q_HP, Q_CHP, V_FUEL, CHP_bin, COIL_bin, HP_bin, T_HTES, CHP_S_bin, HP_S_bin
    return model

    """-----------------------------------------------"""
    """------- Function for plotting the data --------"""
    """-----------------------------------------------"""

def plotall(Time,i,dt, Pth_Load_Heat,Pth_CHP_opt,Pth_HP_opt,Pth_COIL_opt,C_El_B,C_El_S,E_El_HP_opt,E_El_COIL_opt,Pel_Load,Pgrid_B_opt,Pgrid_S_opt,P_El_CHP_opt,T_HTES_opt,T_Amb_f,T_HP_min,COIL_bin_opt,CHP_bin_opt,HP_bin_opt,T_Amb_Forec_real,Pth_Load_Heat_File):
#    import matplotlib.ticker as ticker
    Q_HTES_opt=pl.zeros(T_HTES_opt.shape)
    
    for t in range ((n-1)+(i-1)):
        Q_HTES_opt[0] = Q_HTES_init         
        Q_HTES_opt[t+1] = ((((T_HTES_opt[t+1]-T_HTES_opt[t])/3600.)*(HTES_Cap*rho_w*cp_w)))+Q_HTES_opt[t]
        
    Q_HTES_shift = pl.zeros(T_HTES_opt.shape)
    Q_HTES_delta = pl.zeros(T_HTES_opt.shape)
    
    for k in range ((n-1)+(i-1)):    
        Q_HTES_shift[k] = Q_HTES_opt[k+1]
        Q_HTES_delta[k] = (-Q_HTES_shift[k]+Q_HTES_opt[k])*dt
    
#    tgrid = pl.around(pl.array(Time[0:(n-1)+(i-1)])%24)
    tgrid = pl.array(Time[0:(n-1)+(i-1)])
#    tgrid = pl.arange(0,24,0.25)

    fig1 = pl.figure(1)
    ax1 = fig1.add_subplot(111)
    ax1.plot(tgrid,Pth_Load_Heat[0:(n-1)+(i-1)], '-')
    ax1.bar(pl.append(tgrid,tgrid[-1]+1),Q_HTES_delta)
    ax1.bar(tgrid,Pth_CHP_opt,bottom = Q_HTES_delta[0:(n-1)+(i-1)])
    ax1.bar(tgrid,Pth_HP_opt ,bottom = Q_HTES_delta[0:(n-1)+(i-1)]+Pth_CHP_opt)
    ax1.bar(tgrid,pl.absolute(Pth_COIL_opt) ,bottom =Q_HTES_delta[0:(n-1)+(i-1)]+Pth_CHP_opt+Pth_HP_opt)
    pl.xlabel('Time [h]')
    pl.ylabel('Power [kWth]')
    pl.legend(['Pth_LOAD','Q_HTES','Pth_CHP','Pth_HP','Pth_COIL'])
    ax2 = fig1.add_subplot(111, sharex=ax1, frameon=False)
    ax2.plot(tgrid,C_El_B[0:(n-1)+(i-1)], '--',color='r') 
    ax2.yaxis.tick_right()
    ax2.yaxis.set_label_position("right")
#    pl.xticks(tgrid, pl.around(tgrid%24))
#    ax1.xaxis.set_major_locator(ticker.MultipleLocator(1.))
#    ax2.xaxis.set_major_locator(ticker.MultipleLocator(1.))
#    ax1.xaxis.set_major_formatter(ticker.FormatStrFormatter('%1.f'))
#    ax2.xaxis.set_major_formatter(ticker.FormatStrFormatter('%1.f'))
    pl.ylabel("Price [Euro/kWhel]")
    pl.legend(['El_Price'])
    pl.grid(True)  
     
    
    fig2 = pl.figure(2)    
    pl.clf()    
    ax1 = fig2.add_subplot(111)
    ax1.plot(tgrid,(E_El_HP_opt)+(E_El_COIL_opt)+Pel_Load[0:(n-1)+(i-1)], '-')
    ax1.bar(tgrid,Pgrid_B_opt)
    ax1.bar(tgrid,P_El_CHP_opt, bottom = pl.absolute(Pgrid_B_opt+Pgrid_S_opt))
    ax1.bar(tgrid,-Pgrid_S_opt)
    pl.xlabel('Time [h]')
    pl.ylabel('Power [kWel]')
    pl.legend(['LOAD','Pgrid_buy','Pel_CHP','Pgrid-sell'],loc=2)
    ax2 = fig2.add_subplot(111, sharex=ax1, frameon=False)
    ax2.plot(tgrid,C_El_B[0:(n-1)+(i-1)], '--',color='r') 
    ax2.yaxis.tick_right()
    ax2.yaxis.set_label_position("right")
#    pl.xticks(tgrid, tgrid/dt)
#    pl.xticks(tgrid, pl.around(tgrid%24))
#    pl.xaxis.set_major_locator(pl.ticker.MultipleLocator(1))
    pl.ylabel("Price [Euro/kWhel]")
    pl.legend(['El_Price'], loc = 0)
    pl.grid(True)
    pl.close
    
    
    fig3 = pl.figure(3)
    pl.clf()
    ax1 = fig3.add_subplot(111)
    ax1.plot(tgrid,Pth_Load_Heat_File[0:(n-1)+(i-1)], '-*',color = 'red')
    ax1.plot(tgrid,Pth_Load_Heat[0:(n-1)+(i-1)], '-*',color = 'blue')
    ax1.bar(pl.append(tgrid,tgrid[-1]+1),Q_HTES_opt)
    pl.xlabel('Time [h]')
    pl.ylabel('Power [kWth]')
    pl.legend(['LOAD','Q_HTES'],loc=4)
    ax2 = fig3.add_subplot(111, sharex=ax1, frameon = False)
    ax2.plot(pl.append(tgrid,tgrid[-1]+1),pl.array(T_HTES_opt)-pl.ones(T_HTES_opt.shape)*273.15, color = 'red')
    ax2.yaxis.tick_right()
    ax2.yaxis.set_label_position("right")
#    pl.xticks(tgrid, tgrid/dt)
#    pl.xticks(tgrid, pl.around(tgrid%24))
#    pl.xaxis.set_major_locator(pl.ticker.MultipleLocator(1))
    pl.ylabel('Temp [C]')
    pl.legend(['T_HTES'])
    pl.grid(True)
    pl.close

    fig4 = pl.figure(4)
    pl.clf()    
    pl.plot(tgrid, T_Amb_Forec_real[0:(n-1)+(i-1)], color = 'blue')
    pl.plot(tgrid, T_Amb_f[0:(n-1)+(i-1)], color = 'red')
    pl.plot(tgrid, pl.ones(tgrid.size)*T_HP_min,'*' ,color = 'orange')
#    pl.xticks(tgrid, tgrid/dt)
#    pl.xticks(tgrid, pl.around(tgrid%24))
#    pl.xaxis.set_major_locator(pl.ticker.MultipleLocator(1))
    pl.xlabel('Time [h]')
    pl.ylabel('Temp [C]')
    pl.legend(['T_Amb_Fore','T_Amb_F_Adjusted','T_HP_min'])
    pl.grid(True)
    pl.close
    
#    fig4 = pl.figure(4)
#    pl.clf()  
#    ax1 = fig4.add_subplot(111)
#    ax1.plot(tgrid,Pth_Load_Heat_File[0:(n-1)+(i-1)], '-*',color = 'blue')
#    ax1.plot(tgrid,Pth_Load_Heat[0:(n-1)+(i-1)], '-*',color = 'red')
#    pl.ylabel('Power [kWth]')
#    pl.legend(['Load','Load_Adjusted'],loc=4)
#    ax2 = fig4.add_subplot(111, sharex=ax1, frameon = False)
#    ax2.plot(tgrid, T_Amb_Forec_real[0:(n-1)+(i-1)], color = 'blue')
#    ax2.plot(tgrid, T_Amb_f[0:(n-1)+(i-1)], color = 'red')
#    ax2.plot(tgrid, pl.ones(tgrid.size)*T_HP_min,'*' ,color = 'orange')
#    ax2.yaxis.tick_right()
#    ax2.yaxis.set_label_position("right")
#    pl.xlabel('Time [h]')
#    pl.ylabel('Temp [C]')
#    pl.legend(['T_Amb_Fore','T_Amb_F_Adjusted','T_HP_min'])
#    pl.grid(True)
#    pl.close
 
    fig5 = pl.figure(5)
    pl.subplot(311)
    pl.step(tgrid,COIL_bin_opt)
    pl.legend('COIL',loc=2)
    pl.subplot(312)
    pl.step(tgrid,CHP_bin_opt)
    pl.legend('CHP',loc=2)        
    pl.subplot(313)
    pl.step(tgrid,HP_bin_opt)
    pl.legend('HP',loc=2)
#    pl.xticks(tgrid, tgrid/dt)
#    pl.xticks(tgrid, pl.around(tgrid%24))
#    pl.xaxis.set_major_locator(pl.ticker.MultipleLocator(1))
    pl.close
    
#    with PdfPages('test1.pdf') as pdf:
#        pdf.savefig(fig1)
#        pdf.savefig(fig2)
#        pdf.savefig(fig3)
#        pdf.savefig(fig4)
#        pdf.savefig(fig5)
    
    pl.show()  
    
def plotTdev(T_HTES_actual, T_HTES_opt,i,plotart):
    pl.figure(1)
    pl.clf()    
    xgrid = pl.array(range(len(T_HTES_opt[i:-1])))
#    print(T_HTES_actual,i,T_HTES_actual[0])
    pl.plot(xgrid, pl.array(T_HTES_actual[i:])-273.15,plotart, color = 'red')
#    pl.plot(tgrid, T_Amb_Meas[0:(n-1)+(i-1)],"--", color = 'red')
    
    pl.plot(xgrid, (pl.array(T_HTES_opt[i:-1])-273.15),plotart,color = 'orange')
    pl.xlabel('Iteration [h]')
    pl.ylabel('Temp [C]')
    pl.legend(['T_HTES_actual','T_HTES_predicted'])
    pl.grid(True)
#    pl.savefig('test.pdf')
    pl.show()

    """-----------------------------------------------"""
    """---------- Retrieve data from excel -----------"""
    """-----------------------------------------------"""

def read_excel(filename):
    
    #df = pandas.read_excel('Winter_24_Hrs_EPEX.xlsx')
    #df = pandas.read_excel('Winter_Campus_EPEX.xlsx')
    #df = pandas.read_excel('Winter_Campus_Ewerk.xlsx')
    #df = pandas.read_excel('Transition_Dairy_EPEX.xlsx')
    #df = pandas.read_excel('Transition_Home_EPEX.xlsx')
    #df = pandas.read_excel('Transition_Home_Ewerk.xlsx')
    #df = pandas.read_excel('Winter_2days_EPEX.xlsx')
    #df = pandas.read_excel('Winter_2days_Ewerk.xlsx')
    #df = pandas.read_excel('Summer_2days_EPEX.xlsx')
    #df = pandas.read_excel('Summer_2days_Ewerk.xlsx')
    #df = pandas.read_excel('Winter_2_Weeks.xlsx')
    #df = pandas.read_excel('NR_Winter_2_Weeks_EPEX_29.03.2018.xlsx')
    #df = pandas.read_excel('Winter_2_Weeks_EPEX.xlsx')
    df = pandas.read_excel(filename)#'NR_Winter_2_Weeks_EPEX_16.04.2018.xlsx')
    
       ##---Retrieve all the data from the file as variables---
       ##-------#get the values for a given column
    Pth_Load_Heat = df['Pth_Load_Heat'].values
    Time = df['Time'].values
    Pel_Load = df['Pel'].values
    epex_price_buy = df['Elect_Price_Buy'].values
    epex_price_sell = df['Elect_Price_Sell'].values
    T_Amb = df['T_Amb'].values
    
    return Pth_Load_Heat,Time,Pel_Load,epex_price_buy, epex_price_sell,T_Amb

       
def correction_load(i,st,Pth_Load_Heat_File,Pth_Load_Heat,real_load):#T_sps_Celsius("LOAD_HC_W_PT_M___")
    
    if i== 0:
       Pth_Load_Heat= pl.append(pl.array(Pth_Load_Heat),Pth_Load_Heat_File)
    else: 
       Pth_Load_Heat = pl.append(Pth_Load_Heat[:i+st],Pth_Load_Heat_File[i+st:])
    
    meas_load = real_load/1000.
    
    if meas_load==None:
        pass
    else:
    #       T_Amb_Forec_real = T_Amb_Fore_C
        Pth_Load_Heat[i+st]= float(meas_load)
        Pth_Load_Heat[i+st+1]= float(meas_load)
        Pth_Load_Heat[i+st+2]= float(meas_load)
        Pth_Load_Heat[i+st+3]= float(meas_load)
    return Pth_Load_Heat
    

def interpolate_values(dt,Pth_Load_Heat,Pel_Load,T_Amb,Time,epex_price_buy,epex_price_sell,Fuel):
    
         ##---interpolate the data---
    #Pth_Load_Heat = hour_to_15min(dt, Pth_Load_Heat)
    #Pel_Load = hour_to_15min(dt,  Pel_Load)
    #T_Amb = hour_to_15min(dt, T_Amb)
       
        ##---Repeat the data not interpolate---
    Pth_Load_Heat = price_to_15min(dt, Pth_Load_Heat)
    Pel_Load = price_to_15min(dt,  Pel_Load)
    T_Amb = price_to_15min(dt, T_Amb)
    
    Time = time_to_15min(dt, Time)
    
         ##---Electricity costs to dt data---
    C_El_B= price_to_15min(dt,epex_price_buy)
    C_El_S= price_to_15min(dt,epex_price_sell)
    
         ##-----------------redefine the fuel variables------------------------
    C_FUEL = Fuel
    
         ##--- set the whole time horizon available from the given file and discreetization
    m= int(Pth_Load_Heat.size)# + 1
    
    return Pth_Load_Heat,Pel_Load,T_Amb,Time,C_El_B,C_El_S,C_FUEL,m

    
"""---------------------------------------------------------------------------------------------------------"""
""" ----------------------------- Define The problem and the required variables ----------------------------"""
"""---------------------------------------------------------------------------------------------------------"""
"""_________________________________________________________________________________________________________"""

    
"""Variable definition""" 

    ##---- for storing the data of all the optimizations----
    
Step_E_El_CHP = []
Step_Pgrid_B = []
Step_Pgrid_S = []
Step_Q_COIL = []
Step_Q_HP = []
Step_Q_CHP = []
Step_V_FUEL = []
Step_CHP_bin = []
Step_COIL_bin = []
Step_HP_bin = []
Step_T_HTES = []
Stepplus_T_HTES=[273.15]

T_Amb_f_15 = []
T_Amb_Forec_real_15 = []
T_Amb_Meas = []


""" ---------- Real or simulation ----------"""
"""xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"""

real = False            # """ True or false """

"""xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"""
"""-----------------------------------------"""


"""-------------- Component Specifications ---------------"""
"""-------------------------------------------------------"""

     ##-------  Powers  ------- 
Pmin_CHP_Th = 0                 #kW_Th
Pmax_CHP_Th = 10 
Pmin_CHP_El = 0
Pmax_CHP_El = 5                 #kW_El
Pmin_COIL_Th = 0
Pmax_COIL_Th = 5                #kW_Th       ##5.8
Pmin_HP_Th = 0
Pmax_HP_Th = 13 + 3             #kW_Th       ##16

     ##------ Efficiencies --------
Pel_eff_CHP = 0.3
Pth_eff_CHP = 0.59
COP_HP = 4.45
Pth_eff_COIL = 0.95

    #---- Storage Tank ----
HTES_Cap = 1.5                  # m3 -- Assuming no loss in the tank. 

    ##---Thermodynamical properties----
LHV_FUEL = 42600                #Kj/kg , lower heating value
rho_FUEL = 853.5                #kg/m³
rho_w = 977.8                   #kg/m³
cp_w = 4.180                    #kJ/kg.K

    ##---Volume flow of Fuel for CHP----
vdot_fuel = 1.8/1000            #m³/h

    ##---Fuel Costs---
Fuel= 510                       #eur/m³

""" Problem Initial Values"""

HTES_Warm = 72 + 273.15         #K Highest possible temperature in tank 
HTES_Cold = 35 + 273.15         #K
T_HP_min = 12                   #Temperature min of ambient to operate the HP.
T_HP_max = 40 + 273.15          #Max T_HTES_temperature to operate the HP.

if real:
    T_HTES_init_0 =T_sps_Celsius("HTES_H_W_T_M_IT_"+str(1)+"_") + 273.15              # layer from the tank to retrieve
    
else:
    T_HTES_init_0 = 37 +273.15 

                                                       #Initial temperature in the Tank

Q_HTES_init = ((((T_HTES_init_0-HTES_Cold)/3600.)*(HTES_Cap*rho_w*cp_w)))#77.5        #kW Initial Power in Tank
LS_CHP_S = pl.array([0,0,0,0])
LS_HP_S = pl.array([0,0,0,0])

"""-----------Formulation of the MILP problem-------------"""
"""-------------------------------------------------------"""
   ##--- time formulation parameters-----
   
dt = 4                         # hour splitting factor
hours = 24                     # hours to solve each iteration
n= hours * dt + 1              # window time horizon
sampling_time = 15             # in min  --- Time to wait between iterations              
forecast_horizon = hours + 1   # 168hours in total can be set. this means weather will be forecasted for the next forecast_horizon hours. 25 is the min required as it is forecasting for the 24 h + 15 min next hours
sub_cost = 0
n_flanks_HP = 6
n_flanks_CHP = 4
min_runtime = 4

   ## ---------------start the load depending on the hour----------
st = datetime.now().time().hour*dt + int(datetime.now().time().minute/(60/dt))
#st = 0

   

""" --------------------------------------Start the solving iteration loop------------------------------------------------"""
"""-----------------------------------------------------------------------------------------------------------------------"""


    ##---------------variable declaration of the looping-------------------
i=0
steps = 10
Pth_Load_Heat = []

#while True:                   # Solve for an undefined time.
while i != steps:              # To solve for the amount of time steps defined
#while i != ((m-st)-n):        #To solve for the whole forecast horizon      ##---- This means to solve for n horizon (24 hrs[96- 15mins], 48 hrs, etc.) within a m total horizon (1 week, 2 weeks... etc) a total of m-n times in a loop    
       
    ##----------------Define the incomming variables------------------
        
    start_time = time.time()
    
    print('CPU_Clock_Time',datetime.now().time())  
    
    Pth_Load_Heat_File,Time,Pel_Load,epex_price_buy,epex_price_sell,T_Amb = read_excel('NR_Winter_2_Weeks_EPEX_16.04.2018.xlsx')      #Read excel file
    Pth_Load_Heat_File,Pel_Load,T_Amb,Time,C_El_B,C_El_S,C_FUEL,m = interpolate_values(dt,Pth_Load_Heat_File,Pel_Load,T_Amb,Time,epex_price_buy,epex_price_sell,Fuel)     #interpolate the values and give them back
   
    #Pth_load_File = pl.array(Pth_Load_Heat)
#    Pth_Load_Heat = correction_load(i,st,Pth_Load_Heat_File,Pth_Load_Heat,T_sps_Celsius("LOAD_HC_W_PT_M___"))  
    Pth_Load_Heat = correction_load(i,st,Pth_Load_Heat_File,Pth_Load_Heat,10)  
    if i%n == 0:                                      # Each 96 iterations reset flanks to defined values
        n_switching_CHP = n_flanks_CHP        
        n_switching_HP = n_flanks_HP
        
    if real:                                          # If running real mode, read from sps the initial value
        T_HTES_init_0 =T_sps_Celsius("HTES_H_W_T_M_IT_"+str(1)+"_") + 273.15
        
    Par_C_El_B = C_El_B[0+i+st:(n-1)+i+st]            # updating the parameter acccording to where we want to start
    Par_C_El_S = C_El_S[0+i+st:(n-1)+i+st]
    
     ##------ call the forecast up to "forecast_horizon" times, transform it to 15 min intevals and append each one to the last forecast ´+ 1 step. Also first hour is same as real Aux_Tamb value
    T_Amb_Fore_C, T_Amb_Forec_real = T_amb_forecast(forecast_horizon,i,T_Amb_f_15,m,T_sps_Celsius("AUX_HC_A_T_M___"))
#    T_Amb_f_15 = pl.append(T_Amb_f_15[:i],hour_to_15min(dt,T_amb_forecast(forecast_horizon,i,T_Amb_f_15,m,T_sps_Celsius("AUX_HC_A_T_M___"))))
    T_Amb_f_15 = pl.append(T_Amb_f_15[:i],hour_to_15min(dt,T_Amb_Fore_C))
    T_Amb_Forec_real_15 = pl.append(T_Amb_Forec_real_15[:i],hour_to_15min(dt,T_Amb_Forec_real))

    Par_T_Amb_bin = binarytransform(T_HP_min, T_Amb_f_15[0+i:(n-1)+i])
    Par_Load_El = Pel_Load[0+i+st:(n-1)+i+st]
    Par_Load_Th = Pth_Load_Heat[0+i+st:(n-1)+i+st] 
    Par_Load_Th_File =Pth_Load_Heat_File[0+i+st:(n-1)+i+st] 

     
    """------ Create the model as stated on the function ----"""
        
    model = kwkk_opt(n,dt,n_switching_CHP,n_switching_HP,min_runtime,Par_C_El_B ,Par_C_El_S , Par_T_Amb_bin, Par_Load_El, Par_Load_Th,T_HP_max,T_HP_min,LS_CHP_S,LS_HP_S)
    print("Initial Temp = ",T_HTES_init_0-273.15)
    print("iteration No.= ",i) 
    print("N_Switch_CHP.= ",n_switching_CHP)
    print("N_Switch_HP.= ",n_switching_HP)

    
    """---------------- Optimize the model ------------------"""
       
    model.setRealParam('limits/time',40)               # for limiting to n sec sec the solving time
    model.optimize()                                   # optimize the model

    
       ##----extract the variables from the model
       
    E_El_CHP, Pgrid_B, Pgrid_S, Q_COIL, Q_HP, Q_CHP, V_FUEL, CHP_bin, COIL_bin, HP_bin, T_HTES, CHP_S_bin, HP_S_bin = model.data
      
       ##---Retrieve the  values of each optimization and append them as the optimal values----.
   
    P_El_CHP_opt = pl.array([model.getVal(E_El_CHP[j]) for j in range(min_runtime,(n-1)+min_runtime)])*dt
    Pgrid_B_opt = pl.array([model.getVal(Pgrid_B[j]) for j in range(min_runtime,(n-1)+min_runtime)])*dt
    Pgrid_S_opt = pl.array([model.getVal(Pgrid_S[j]) for j in range(min_runtime,(n-1)+min_runtime)])*dt
    Pth_COIL_opt = pl.array([model.getVal(Q_COIL[j]) for j in range(min_runtime,(n-1)+min_runtime)])*dt
    Pth_HP_opt = pl.array([model.getVal(Q_HP[j]) for j in range(min_runtime,(n-1)+min_runtime)])*dt
    Pth_CHP_opt = pl.array([model.getVal(Q_CHP[j]) for j in range(min_runtime,(n-1)+min_runtime)])*dt
    V_FUEL_opt = pl.array([model.getVal(V_FUEL[j]) for j in range(min_runtime,(n-1)+min_runtime)])
    CHP_bin_opt = pl.array([model.getVal(CHP_bin[j]) for j in range(min_runtime,(n-1)+min_runtime)])
    COIL_bin_opt = pl.array([model.getVal(COIL_bin[j]) for j in range(min_runtime,(n-1)+min_runtime)])
    HP_bin_opt = pl.array([model.getVal(HP_bin[j]) for j in range(min_runtime,(n-1)+min_runtime)])
    T_HTES_opt = pl.array([model.getVal(T_HTES[j]) for j in range(min_runtime,(n)+min_runtime)])
    E_El_HP_opt = Pth_HP_opt*(1./COP_HP)
    E_El_COIL_opt = Pth_COIL_opt*(1./Pth_eff_COIL)

       ##-----Save the first optimal actions from each optimal solution for printing the whole optimal actions in time.----
        
    Step_E_El_CHP.append(P_El_CHP_opt[0])
    Step_Pgrid_B.append(Pgrid_B_opt[0])
    Step_Pgrid_S.append(Pgrid_S_opt[0])
    Step_Q_COIL.append(Pth_COIL_opt[0])
    Step_Q_HP.append(Pth_HP_opt[0])
    Step_Q_CHP.append(Pth_CHP_opt[0])
    Step_V_FUEL.append(V_FUEL_opt[0])
    Step_CHP_bin.append(CHP_bin_opt[0])
    Step_COIL_bin.append(COIL_bin_opt[0])
    Step_HP_bin.append(HP_bin_opt[0])
    Step_T_HTES.append(T_HTES_opt[0])
    
    Stepplus_T_HTES.append(T_HTES_opt[1])
    
    
    LS_CHP_S = pl.delete(pl.append(LS_CHP_S,pl.array([model.getVal(CHP_bin[0+min_runtime])])),0)       # part to append optimal control value to past four and delete first value of the past four. Acts like shifing mechanism
    LS_HP_S  = pl.delete(pl.append(LS_HP_S ,pl.array([model.getVal( HP_bin[0+min_runtime])])),0)
#    LS_CHP_ON_S = pl.array([model.getVal(CHP_ON_bin[0+min_runtime])])
#    LS_HP_ON_S  = pl.array([model.getVal( HP_ON_bin[0+min_runtime])])
    HP_S_opt = pl.array([model.getVal(HP_S_bin[j]) for j in range(min_runtime,(n-1)+min_runtime)])
    CHP_S_opt = pl.array([model.getVal(CHP_S_bin[j]) for j in range(min_runtime,(n-1)+min_runtime)])

            
    if n_switching_CHP == 0:
        pass
    else:
        if model.getVal(CHP_S_bin[0+min_runtime]) == 1:
            n_switching_CHP = n_switching_CHP - 1

    if n_switching_HP == 0:
        pass
    else:
        if model.getVal(HP_S_bin[0+min_runtime]) == 1:
            n_switching_HP = n_switching_HP - 1
 
        ##---Get the cost of the model each time at k = 0 and add it to the sub_total. Sub_total means from 0 to (m-n)
        
    step_cost = (Par_C_El_B[0]*Pgrid_B_opt[0]) + (C_FUEL*V_FUEL_opt[0]) - (Par_C_El_S[0]*Pgrid_S_opt[0])
    sub_cost = sub_cost + step_cost
   
        ##---Retrieve the optimal mode... then send it to the SPS by the setspsvals(opt_mode, COIL_Switch) function.
        
    optimal_mode = optmode(HP_bin_opt[0],CHP_bin_opt[0])
    
    print('Solv Time=',str(model.getSolvingTime()))
    print('Total Time=',str(model.getTotalTime()))
   
    if real:
        setspsvals(optimal_mode, COIL_bin_opt[0]) #-->activate to set the optimal mode and coil switch on the sps 
    plotall(Time[0+i+st:(n-1)+i+st], 1 ,dt,Par_Load_Th,Pth_CHP_opt,Pth_HP_opt,Pth_COIL_opt, Par_C_El_B,Par_C_El_S,E_El_HP_opt,E_El_COIL_opt,Par_Load_El,Pgrid_B_opt,Pgrid_S_opt,P_El_CHP_opt,T_HTES_opt,T_Amb_f_15[0+i:(n-1)+i],T_HP_min,COIL_bin_opt,CHP_bin_opt,HP_bin_opt,T_Amb_Forec_real_15[0+i:(n-1)+i],Par_Load_Th_File)
    plotTdev(Step_T_HTES, Stepplus_T_HTES,0,'*')

        ##---iterate waiting timepause miniutes----
        
    end_time =time.time()
    solv_time = (end_time-start_time)
       

    if i == 0:
        time_correction = ((sampling_time - (((int(datetime.now().time().minute/(60/dt))+1)*(60/dt))-(datetime.now().time().minute)))*60)+datetime.now().second
        solv_time = 0 
    else: 
        time_correction = 0
        
#    time.sleep((sampling_time*60)-solv_time-time_correction)

    
           ##---Set the new value of the initial temperature. This is done for test purposes on the optimized value.
    if real:
        pass
    else:
        T_HTES_init_0 = model.getVal(T_HTES[1+min_runtime])
    
    
    
    i =i+1
        
""" ------------------------------------- End of the loop, rest of calculations ------------------------------------------"""
"""-----------------------------------------------------------------------------------------------------------------------"""

    ##---Calculate the total costs

cost = model.getObjVal()
Total_cost = cost + sub_cost - step_cost  # total cost = cost each 0 step, + cost of the last iteration. Because the last 0step ist summed in the last vector, it is then substracted.

    ##----add the previous step optimal values to the last ones and make a list for printing the whole time horizon.   

P_El_CHP_opt = pl.append(Step_E_El_CHP[0:(i-1)], P_El_CHP_opt)
Pth_HP_opt = pl.append(Step_Q_HP[0:(i-1)], Pth_HP_opt)
E_El_HP_opt = Pth_HP_opt*(1./COP_HP)
Pth_COIL_opt= pl.append(Step_Q_COIL[0:(i-1)], Pth_COIL_opt)
E_El_COIL_opt = Pth_COIL_opt*(1./Pth_eff_COIL)
Pth_CHP_opt =  pl.append(Step_Q_CHP[0:(i-1)], Pth_CHP_opt)
HP_bin_opt =  pl.append(Step_HP_bin[0:(i-1)], HP_bin_opt)
COIL_bin_opt =  pl.append(Step_COIL_bin[0:(i-1)], COIL_bin_opt)
CHP_bin_opt =  pl.append(Step_CHP_bin[0:(i-1)], CHP_bin_opt)
Pgrid_B_opt = pl.append(Step_Pgrid_B[0:(i-1)],Pgrid_B_opt)
Pgrid_S_opt = pl.append(Step_Pgrid_S[0:(i-1)],Pgrid_S_opt)
T_HTES_opt = pl.append(Step_T_HTES[0:(i-1)],T_HTES_opt)

     ##----apply the last n-2 hours for the last optimization in fixed time hoizon applications.   
     
#for lastv in range(n-1):
#    optimal_mode = optmode(HP_bin_opt[i+lastv],CHP_bin_opt[i+lastv])
#    #setspsvals(optimal_mode, COIL_bin_opt[i]) #-->activate to set the optimal mode and coil switch on the sps 
#    time.sleep((sampling_time*60)-solv_time-time_correction)



print('--------------------------- Total time plot -------------------------')
print('---------------------------------------------------------------------')

plotall(Time[0+st:], i,dt,Pth_Load_Heat[0+st:],Pth_CHP_opt,Pth_HP_opt,Pth_COIL_opt,C_El_B[0+st:],C_El_S[0+st:],E_El_HP_opt,E_El_COIL_opt,Pel_Load[0+st:],Pgrid_B_opt,Pgrid_S_opt,P_El_CHP_opt,T_HTES_opt,T_Amb_f_15,T_HP_min,COIL_bin_opt,CHP_bin_opt,HP_bin_opt,T_Amb_Forec_real_15,Pth_Load_Heat_File[0+st:])
plotTdev(Step_T_HTES, Stepplus_T_HTES,0,'-')

print('Total_Obj=',Total_cost)
print('Solv Time=',str(model.getSolvingTime()))
print('Total Time=',str(model.getTotalTime()))
print('Nodes=',str(model.getNNodes()))


