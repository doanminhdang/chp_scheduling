# -*- coding: utf-8 -*-
"""
Created on Wed Dec 06 14:08:59 2017

@author: INES
"""
#Import the libraries
import pandas
import numpy as np
import casadi as ca
from matplotlib import pyplot as plt
df = pandas.read_excel('winter_load_data.xlsx')
#print the column names
print df.columns
##get the values for a given column
Pth_Load_Heat = df['Pth_Load_Heat'].values
Time = df['Time'].values
Pel_Load = df['Pel'].values
epex_price_buy = df['epex_price_buy'].values
epex_price_sell = df['epex_price_sell'].values
#Set constant definitions
#System Power

Pmin_CHP_Th = 0 #kW_Th
Pmax_CHP_Th = 10
Pmin_CHP_El = 0
Pmax_CHP_El = 5 #kW_El
Pmin_COIL_Th = 0
Pmax_COIL_Th = 5.8#kW_Th
Pmin_COIL_El = 0
Pmax_COIL_El = 10#kW_El
Pmin_Hp_Th = 0
Pmax_Hp_Th = 16#kW_Th
Pmin_Hp_El = 0
Pmax_Hp_El = 10 #kW_El
#Heat Storage Data
HTES_Cap = 1.5 #m3
HTES_h = 2.196
HTES_D=1
HTES_LTE=0.002
HTES_Warm = 75 + 273.15
HTES_Cold = 35 + 273.15
T_Amb = 10 + 273.15
#Electricity costs
C_El_B= np.array(epex_price_buy)
C_El_S= np.array(epex_price_sell)
#Fuel Costs
Fuel= 510 #eur/m3
#Machine_EFF
P_El_Wirk = 0.3
Q_Wirk = 0.59
COP_HP = 4.45
EFF_COIL = 0.95
#Thermodynamical properties
Cp_gas = 45600 #Kj/Kg
ro_gas = 853.5 #Kg/M3
ro_w = 977.8 #Kg/M3
Cp_w = 4.180 #KJ/Kg.K

#Formulate the LP Problem
#Set the time Steps
n= int(Time.size) + 1

#Define the optimization variables
Q_COIL = ca.MX.sym("Q_COIL", n-1)
Q_HP= ca.MX.sym("Q_HP", n-1)
Pgrid= ca.MX.sym("Pgrid", n-1)
V_Gas= ca.MX.sym("V_Gas", n-1)
Q_HTES = ca.MX.sym("Q_HTES", n)
T_HTES = ca.MX.sym("T_HTES", n)
Q_CHP_Th= ca.MX.sym("Q_CHP_Th",n-1)
P_CHP_El= ca.MX.sym("P_CHP_El",n-1)
# Define Switches (ontrols)
CHP_bin = ca.MX.sym("CHP_bin", n-1)
COIL_bin = ca.MX.sym("COIL_bin", n-1)
HP_bin = ca.MX.sym("HP_bin", n-1)

#Redefine the name of the opt variables for fixed or 
C_Gas = Fuel
#Set an initial state for the HTES
HTES_init = 50 #Initial Ênergy in the Tank kWh
Pth_Load_Heat =np.array(Pth_Load_Heat)/10.0
Pel_Load = np.array(Pel_Load)/5



#Define the objective function
steps = 1 # steps per hour
dt = 1/steps
f = 0
t=0

#C_El=ca.if_else(Pgrid>0,C_El_B,C_El_S)

for t in range(n-1):

    f +=  C_El_B[t]*Pgrid[t] + C_Gas*((Q_CHP_Th[t]+P_CHP_El[t])/(Q_Wirk + P_El_Wirk))*CHP_bin[t] 
#     f +=  C_El_B[t]*Pgrid[t]
#Define the constraints 

g = []
g_min = []
g_max = []
discrete = []

#electricity balance : E_Demand {Pel_HP + Pel_Coil + Pel_Load} = (Pel_CHP + Pgrid_buy - Pgrid_Sell)#---((V_Gas[t]*P_El_Wirk*Cp_gas*ro_gas)/3600)
for t in range(n-1):

    g.append((Q_HP[t]/COP_HP)+(Q_COIL[t]/EFF_COIL)+Pel_Load[t]-P_CHP_El[t]-Pgrid[t])
    g_min.append(0)
    g_max.append(10) 
    
#thermal energy balance :  Qk+1 = Qk + Qhpk + QCoilk + QCHPk - QLoadk 
for t in range(n-1):

    g.append((Q_HTES[t+1])-(Q_HTES[t]+(Q_HP[t])+Q_COIL[t]+(Q_CHP_Th[t])-Pth_Load_Heat[t]))
    g_min.append(0)
    g_max.append(10)
    
    

for t in range(n-1):
    g.append((Q_CHP_Th[t]/dt)-(Pmax_CHP_Th*CHP_bin[t]))
    g_min.append(0)
    g_max.append(0)
        
for t in range(n-1):    
    
    g.append((P_CHP_El[t]/dt)-(Pmax_CHP_El*CHP_bin[t]))
    g_min.append(0)
    g_max.append(0)


for t in range(n-1):
    g.append((Q_HP[t])-(HP_bin[t]*Pmax_Hp_Th))
    g_min.append(0)
    g_max.append(0)
        
for t in range(n-1):    
    
    g.append((Q_COIL[t]/dt)-(Pmax_COIL_Th*COIL_bin[t]))
    g_min.append(0)
    g_max.append(0)
    
    g.append(Q_HTES[0])
    g_min.append(HTES_init)
    g_max.append(HTES_init)  

#Define which variables are discrete (True = discrete) ' has to be the same length as vector V.
discrete = []  
 
for t in range(n-1):     #Pgrid
    discrete += [False] 
for t in range(n-1):    #Q_HP
    discrete += [False]
for t in range(n-1):    #V_Gas
    discrete += [False]
for t in range(n-1):    #Q_Coil
    discrete += [False]
for t in range(n):      #Q_HTES
    discrete += [False]
for t in range(n-1):    #CHP_bin
    discrete += [True]
for t in range(n-1):    #HP_bin
    discrete += [True]
for t in range(n-1):    #Coil_bin
    discrete += [True]
for t in range(n-1):    #Q_CHP_th
    discrete += [False]
for t in range(n-1):    #P_CHP_el
    discrete += [False]
    

#Transform variables into vectors for the solver input
# Vertcat = vertical concatenation, solver accepts on vector inputs and not matrices
g = ca.vertcat(*g)
V = ca.vertcat(Pgrid, Q_HP, V_Gas, Q_COIL, Q_HTES, CHP_bin, HP_bin, COIL_bin, Q_CHP_Th, P_CHP_El)
#V = ca.vertcat(Pgrid, Q_HP, V_Gas, Q_COIL, Q_HTES, CHP_bin, HP_bin, COIL_bin, Q_CHP_Th, P_CHP_El)
g_min = ca.vertcat(*g_min)
g_max = ca.vertcat(*g_max)

#define the linear program
lp = {"x": V, "f": f, "g": g}
# NLP solver options (ipopt)
opts = {}
#opts["expand"] = True
# opts["ipopt.max_iter"] = 10
# opts["verbose"] = True
#opts["ipopt.linear_solver"] = "ma27"
# opts["hessian_approximation"] = "limited-memory"

#initiate one of the solvers
#solver = ca.nlpsol("solver", "ipopt", lp, opts)
#solver = ca.qpsol("solver", "qpoases", lp, {"discrete": discrete})
solver = ca.nlpsol("solver", "bonmin", lp ,{"discrete": discrete})
#solver = ca.nlpsol("solver", "bonmin", lp)
#solver = ca.nlpsol("solver", "knitro", lp)
#solver = ca.conic("solver", "clp", lp)


#Define the initial guess values for the solver to start
Pgrid_init = np.zeros(Pgrid.shape)
V_Gas_init = np.zeros(V_Gas.shape)
Q_HP_init = np.zeros(Q_HP.shape)
Q_COIL_init = np.zeros(Q_COIL.shape)
Q_HTES_init = np.append(np.array(Pth_Load_Heat),np.array(0))
Q_HTES_init[0] = HTES_init
CHP_bin_init = np.zeros(CHP_bin.shape)
HP_bin_init = np.zeros(CHP_bin.shape)
COIL_bin_init = np.zeros(CHP_bin.shape)
Q_CHP_Th_init= np.zeros(Q_CHP_Th.shape)
P_CHP_El_init= np.zeros(P_CHP_El.shape)



V_init = ca.vertcat(Pgrid_init, V_Gas_init, Q_HP_init,  Q_COIL_init, Q_HTES_init, CHP_bin_init, HP_bin_init, COIL_bin_init, Q_CHP_Th_init, P_CHP_El_init )
gasmax = (Pmax_CHP_Th)/(Cp_gas*ro_gas/3600)
#Define the limits of the optimization variables
Pgrid_max = np.ones(Pgrid.shape) *  np.inf
V_Gas_max = np.ones(V_Gas.shape) * gasmax
Q_HP_max = np.ones(Q_HP.shape) *(Pmax_Hp_Th)
Q_COIL_max = np.ones(Q_COIL.shape)  * (Pmax_COIL_Th/1)
Q_HTES_max = np.ones(Q_HTES.shape) * 110 #((HTES_Warm-HTES_Cold)*(HTES_Cap*ro_w*Cp_w))/3600
CHP_bin_max = np.ones(CHP_bin.shape)
HP_bin_max = np.ones(HP_bin.shape)
COIL_bin_max = np.ones(COIL_bin.shape)
Q_CHP_Th_max= np.ones(Q_CHP_Th.shape)*Pmax_CHP_Th
P_CHP_El_max= np.ones(P_CHP_El.shape)*Pmax_CHP_El

Pgrid_min = np.ones(Pgrid.shape) * -np.inf
V_Gas_min = np.zeros(V_Gas.shape)
Q_HP_min = np.zeros(Q_HP.shape)
Q_COIL_min = np.zeros(Q_COIL.shape)
Q_HTES_min = np.zeros(Q_HTES.shape)
CHP_bin_min = np.zeros(CHP_bin.shape)
HP_bin_min = np.zeros(HP_bin.shape)
COIL_bin_min = np.zeros(COIL_bin.shape)
Q_CHP_Th_min= np.zeros(Q_CHP_Th.shape)
P_CHP_El_min= np.zeros(P_CHP_El.shape)

V_max = ca.vertcat(Pgrid_max, V_Gas_max, Q_HP_max,  Q_COIL_max, Q_HTES_max, CHP_bin_max, HP_bin_max, COIL_bin_max, Q_CHP_Th_max, P_CHP_El_max)
V_min = ca.vertcat(Pgrid_min, V_Gas_min, Q_HP_min,  Q_COIL_min, Q_HTES_min, CHP_bin_min, HP_bin_min, COIL_bin_min, Q_CHP_Th_min, P_CHP_El_min)

#Save the solution
solution = solver(x0 = V_init, lbx = V_min, ubx = V_max, \
    lbg = g_min, ubg = g_max)


#Define the optimization as variables
K_opt = solution["f"]
V_opt = solution["x"]

#Print function 
tgrid =np.array(Time)
def plot_sol(w_opt):
    w_opt = w_opt.full().flatten()
    Pgrid_opt = w_opt[0:n-1]
    V_Gas_opt= w_opt[n-1:(n-1)*2]
    Q_CHP_opt = ((V_Gas_opt*Q_Wirk*Cp_gas*ro_gas)/3600)    
    P_El_CHP_opt = ((V_Gas_opt*P_El_Wirk*Cp_gas*ro_gas)/3600)   
    Q_HP_opt = w_opt[(n-1)*2:(n-1)*3] 
    P_El_HP_opt = Q_HP_opt /COP_HP

    Q_COIL_opt= w_opt[(n-1)*3:(n-1)*4]
    P_El_COIL_opt = Q_COIL_opt / EFF_COIL
    Q_HTES_opt = w_opt[(n-1)*4:(n-1)*5+1]
    T_HTES_opt=np.zeros(Q_HTES_opt.shape)
    CHP_bin_opt = w_opt[(n-1)*5+1:(n-1)*6+1]
    HP_bin_opt = w_opt[(n-1)*6+1:(n-1)*7+1]
    COIL_bin_opt= w_opt[(n-1)*7+1:(n-1)*8+1]
    Q_CHP_Th_opt= w_opt[(n-1)*8+1:(n-1)*9+1]
    P_CHP_El_opt= w_opt[(n-1)*9+1:(n-1)*10+1]
    Q_HTES_shift = np.zeros(Q_HTES_opt.shape)
    Q_HTES_delta = np.zeros(Q_HTES_opt.shape)
    
    
    for t in range (n-1):
        T_HTES_opt[0] = 273.15 + 50
        T_HTES_opt[t+1] = (((Q_HTES_opt[t+1]-Q_HTES_opt[t])*3600)/(HTES_Cap*ro_w*Cp_w))+(T_HTES_opt[t])
    
    
    for k in range (n-1):    
        Q_HTES_shift[k] = Q_HTES_opt[k+1]
        Q_HTES_delta[k] = -Q_HTES_shift[k]+Q_HTES_opt[k]
    
    plt.figure(1)
    plt.clf()
    plt.plot(tgrid,Pth_Load_Heat, '-')
    plt.plot(tgrid,C_El_B, '*')
    plt.bar(np.append(tgrid,np.array(n-1)),Q_HTES_delta)
    plt.bar(tgrid,Q_CHP_Th_opt,bottom = Q_HTES_delta[0:n-1])
    plt.bar(tgrid,Q_HP_opt ,bottom = Q_HTES_delta[0:n-1]+Q_CHP_Th_opt)
    plt.bar(tgrid,np.abs(Q_COIL_opt) ,bottom =Q_HTES_delta[0:n-1]+Q_CHP_Th_opt+Q_HP_opt)
    plt.xlabel('t')
    plt.ylabel('Power')
    plt.legend(['LOAD','El_Price','HTES','CHP','HP','COIL'])
    plt.grid(True)
     
     
    plt.figure(2)
    plt.clf()    
    plt.plot(tgrid,(Q_HP_opt/COP_HP)+(Q_COIL_opt/EFF_COIL)+Pel_Load, '-')
    plt.bar(tgrid,Pgrid_opt)
    plt.bar(tgrid,P_CHP_El_opt, bottom = np.abs(Pgrid_opt))
    plt.xlabel('t')
    plt.ylabel('Power')
    plt.legend(['LOAD','PGRID','CHP','COIL', 'HP'])
    plt.grid(True)
#    print(Q_CHP_opt)
#    print(Q_HP_opt)
#    print(Q_COIL_opt)
#    print(Q_CHP_Th_opt)
#    print(CHP_bin_opt)
#    print(Q_HP_opt)
#    print(HP_bin_opt)
#    print(Q_COIL_opt)
#    print(COIL_bin_opt)
#    print(V_Gas_opt)
    
    plt.figure(3)
    plt.clf()
    plt.plot(tgrid,Pth_Load_Heat, '-')
    plt.bar(np.append(tgrid,np.array(n-1)),Q_HTES_opt)
    plt.xlabel('t')
    plt.ylabel('Power')
    plt.grid(True)

    plt.figure(4)
    plt.clf()    
    plt.plot(np.append(tgrid,np.array(n-1)),T_HTES_opt-(np.ones(T_HTES_opt.shape)*273.15))
    
    plt.figure(5)
    plt.clf()
    plt.step(tgrid,CHP_bin_opt, color= 'r', label = "Status CHP opt") 
    plt.step(tgrid,HP_bin_opt, color = 'b', label = "Status HP opt")
    plt.step(tgrid,COIL_bin_opt, color = 'g', label = "Status COIL opt")
    plt.legend(['CHP','HP', 'COIL'])
   
#print(solver.stats())
plot_sol(V_opt)
plt.show()

print "Mininmal cost:" + str(K_opt)
print " Optimal matrix:" + str(V_opt)

##notify to message --- This section is used just as test of other services, not for optimization
#import requests
#def notification(message):
#   report = {}
#   report["value1"] = message
#   requests.post("https://maker.ifttt.com/trigger/TIME/with/key/dHLtp-NRYmhNXSbDeoyQay9FK2Ql2dWgWTG2GASqbJb", data=report)
##   requests.post("https://maker.ifttt.com/trigger/OPTCHP/with/key/dHLtp-NRYmhNXSbDeoyQay9FK2Ql2dWgWTG2GASqbJb", data=report)
#
#stats = solver.stats()
 
#if stats['return_status'] == 'SUCCESS':
#    message = 'Solution found, Min Cost =' , float(K_opt)
#else: 
#    message = 'Solution not found.'
#    
#print(message)




#notification(message)

