# -*- coding: utf-8 -*-
"""
Created on Thu Dec 21 22:08:26 2017

@author: Oscar VM
"""

#Import the libraries
import pandas
import pylab as pl
import casadi as ca

df = pandas.read_excel('winter_load_data_2days.xlsx')
#print the column names
print df.columns
##get the values for a given column
Pth_Load_Heat = df['Pth_Load_Heat'].values
Time = df['Time'].values
Pel_Load = df['Pel'].values
epex_price_buy = df['epex_price_buy'].values
epex_price_sell = df['epex_price_sell'].values


"Component Specifications"
#Powers
Pmin_CHP_Th = 0 #kW_Th
Pmax_CHP_Th = 10
Pmin_CHP_El = 0
Pmax_CHP_El = 5 #kW_El
Pmin_COIL_Th = 0
Pmax_COIL_Th = 5.8#kW_Th
Pmin_Hp_Th = 0
Pmax_Hp_Th = 16#kW_Th

#Efficiencies 
Pel_eff_CHP = 0.3
Pth_eff_CHP = 0.59
COP_HP = 4.45
Pth_eff_COIL = 0.95


#Storage Tank
HTES_Cap = 1.5 #m³

"Thermodynamical properties"
LHV_FUEL = 42600 #Kj/Kg
ro_FUEL = 853.5 #Kg/m³
ro_w = 977.8 #Kg/M3
Cp_w = 4.180 #KJ/Kg.K

"Costs"
#Electricity costs
C_El_B= pl.array(epex_price_buy)
C_El_S= pl.array(epex_price_sell)


#Fuel Costs
Fuel= 510 #eur/m³




"Initial Values"
HTES_Warm = 72 + 273.15 #K Highest possible temperature in tank 
HTES_Cold = 35 + 273.15 #K
T_HTES_init_0 = 45 +273.15#Initial temperature in the Tank K ALWAYS < HTES_Warm to avoid infeasibility
Q_HTES_init = 50 #kW Initial Power in Tank


#Formulate the LP Problem
#Set the time Steps
n= int(Time.size) + 1

#Define the optimization variables
Q_COIL = ca.MX.sym("Q_COIL", n-1)
Q_HP= ca.MX.sym("Q_HP", n-1)
Pgrid= ca.MX.sym("Pgrid", n-1)
V_FUEL= ca.MX.sym("V_FUEL", n-1)
T_HTES = ca.MX.sym("T_HTES", n)
Pgrid_B = ca.MX.sym("Pgrid_B", n-1)
Pgrid_S= ca.MX.sym("Pgrid_S", n-1)

#Redefine the name of the opt variables
C_FUEL = Fuel
Pth_Load_Heat =pl.array(Pth_Load_Heat)/1.2
Pel_Load = pl.array(Pel_Load)


#Define the objective function
f = 0
t=0

#If Pgrid is +ve then use buying, if -ve then using selling price
#To restrict the optimisation only to buying, the Pgrid should be constrained to having only positive values (Adjust by making Pgrid_min limit = 0 )
#C_El=ca.if_else(Pgrid>=0,C_El_B,C_El_S)
#C_El = C_El_B # If "if_else statement wants to be avoided


for t in range(n-1):
#Cost function (Two cost functions are not needed since the Pgrid can be constrained to be only +ve)
# Cost function changed to include two different types of prices for electricity, buying and selling
    f +=  (C_El_B[t]*Pgrid_B[t]) + (C_FUEL*V_FUEL[t]) - (C_El_S[t]*Pgrid_S[t])
    
#Define the constraints 
g = []
g_min = []
g_max = []


"Equality Constraints"

#electricity balance : E_Demand = E_supply i.e. Pel_HP + Pel_Coil + Pel_Load = Pel_CHP + Pel_Grid
for t in range(n-1):

    g.append((Q_HP[t]/COP_HP)+(Q_COIL[t]/Pth_eff_COIL)+Pel_Load[t]-((V_FUEL[t]*Pel_eff_CHP*LHV_FUEL*ro_FUEL)/3600)-Pgrid[t])
    g_min.append(0)
    g_max.append(0) 
    
#thermal energy balance :  Q_HTES(t+1) = Q_HTES(t) + Q_HP(t) + QCoil(t) + QCHP(t) - QLoad(t) 
    g.append((((T_HTES[t+1]-T_HTES[t])/3600)*(HTES_Cap*ro_w*Cp_w))-(Q_HP[t]+Q_COIL[t]+((V_FUEL[t]*Pth_eff_CHP*LHV_FUEL*ro_FUEL)/3600)-Pth_Load_Heat[t]))
    g_min.append(0)
    g_max.append(0)
    
# if else statements to decide if electricity sold or bougnht depending on PelGrid > or < 0   
    
    g.append(Pgrid_B[t]-ca.if_else(Pgrid[t]>=0,Pgrid[t],0,False))
    g_min.append(0)
    g_max.append(0)   
    
    g.append(Pgrid_S[t]+ca.if_else(Pgrid[t]>=0,0,(Pgrid[t]),False))
    g_min.append(0)
    g_max.append(0)  
    
 
#    g.append((Pgrid[t]/Pgrid[t])+(Pgrid_S[t]/Pgrid_S[t]))
#    g_min.append(0)
#    g_max.append(1)
    
"Inequality Constraints"
for t in range(n-1):
    
    g.append((V_FUEL[t]*Pel_eff_CHP*LHV_FUEL*ro_FUEL)/3600)
    g_min.append(Pmin_CHP_El)
    g_max.append(Pmax_CHP_El)
    
    g.append((V_FUEL[t]*Pth_eff_CHP*LHV_FUEL*ro_FUEL)/3600)
    g_min.append(Pmin_CHP_Th)
    g_max.append(Pmax_CHP_Th)    

    g.append(Q_HP[t])
    g_min.append(Pmin_Hp_Th)
    g_max.append(Pmax_Hp_Th)
      
    g.append(Q_COIL[t])
    g_min.append(Pmin_COIL_Th)
    g_max.append(Pmax_COIL_Th)
    
    g.append(T_HTES[0])
    g_min.append(T_HTES_init_0)
    g_max.append(T_HTES_init_0)  

    g.append(T_HTES[t+1])
    g_min.append(HTES_Cold)
    g_max.append(HTES_Warm)  
 



#Transform variables into vectors for the solver iplut
# Vertcat = vertical concatenation, solver accepts on vector ipluts and not matrices
g = ca.vertcat(*g)
#V = ca.vertcat(Pgrid, V_FUEL, Q_HP, Q_COIL, Pgrid_B, Pgrid_S, T_HTES )
V = ca.vertcat(Pgrid, V_FUEL, Q_HP, Q_COIL, Pgrid_B, Pgrid_S, T_HTES )
g_min = ca.vertcat(*g_min)
g_max = ca.vertcat(*g_max)

#define the linear program
lp = {"x": V, "f": f, "g": g}
# NLP solver options (ipopt)
opts = {}
#opts["expand"] = True
# opts["ipopt.max_iter"] = 10
#opts["verbose"] = True
#opts["ipopt.linear_solver"] = "ma57"
#opts["ipopt.hessian_approximation"] = "limited-memory"


#initiate one of the solvers
solver = ca.nlpsol("solver", "ipopt", lp, opts)
#solver = ca.qpsol("solver", "qpoases", lp, {"discrete": discrete})
#solver = ca.nlpsol("solver", "bonmin", lp ,{"discrete": discrete})
#solver = ca.nlpsol("solver", "bonmin", lp)
#solver = ca.nlpsol("solver", "knitro", lp)
#solver = ca.conic("solver", "clp", lp)


#Define the initial guess values for the solver to start
Pgrid_init = pl.zeros(Pgrid.shape)
V_FUEL_init = pl.zeros(V_FUEL.shape)
Q_HP_init = pl.zeros(Q_HP.shape)
Q_COIL_init = pl.zeros(Q_COIL.shape)
T_HTES_init = pl.zeros(T_HTES.shape)
T_HTES_init[0] = T_HTES_init_0
Pgrid_S_init = pl.zeros(Pgrid_S.shape)
Pgrid_B_init = pl.zeros(Pgrid_B.shape)
V_init = ca.vertcat(Pgrid_init, V_FUEL_init, Q_HP_init, Q_COIL_init, Pgrid_B_init, Pgrid_S_init, T_HTES_init)

#Define the limits of the optimization variables
Pgrid_max = pl.ones(Pgrid.shape) *  pl.inf
Pgrid_S_max = pl.ones(Pgrid_S.shape) * pl.inf
Pgrid_B_max = pl.ones(Pgrid_B.shape) * pl.inf
V_FUEL_max = pl.ones(V_FUEL.shape) * pl.inf
Q_HP_max = pl.ones(Q_HP.shape) * Pmax_Hp_Th
Q_COIL_max = pl.ones(Q_COIL.shape)  * Pmax_COIL_Th
T_HTES_max = pl.ones(T_HTES.shape) * HTES_Warm


Pgrid_min = pl.ones(Pgrid.shape) * -pl.inf   #Selling Allowed if this is active
#Pgrid_min = pl.ones(Pgrid.shape)              #Selling is not allowed if active
Pgrid_S_min = pl.zeros(Pgrid_S.shape)
Pgrid_B_min = pl.zeros(Pgrid_B.shape) 
V_FUEL_min = pl.zeros(V_FUEL.shape)
Q_HP_min = pl.zeros(Q_HP.shape)
Q_COIL_min = pl.zeros(Q_COIL.shape)
T_HTES_min = pl.ones(T_HTES.shape) * HTES_Cold

V_max = ca.vertcat(Pgrid_max, V_FUEL_max, Q_HP_max,  Q_COIL_max, Pgrid_B_max, Pgrid_S_max, T_HTES_max)
V_min = ca.vertcat(Pgrid_min, V_FUEL_min, Q_HP_min,  Q_COIL_min, Pgrid_B_min, Pgrid_S_min, T_HTES_min)

#Save the solution
solution = solver(x0 = V_init, lbx = V_min, ubx = V_max, \
    lbg = g_min, ubg = g_max)


#Define the optimization as variables
K_opt = solution["f"]
V_opt = solution["x"]

#Print function 
tgrid =pl.array(Time)
def plot_sol(w_opt):
    w_opt = w_opt.full().flatten()
#    Pgrid_opt = w_opt[0:n-1]
    V_FUEL_opt= w_opt[n-1:(n-1)*2]
    Pth_CHP_opt = ((V_FUEL_opt*Pth_eff_CHP*LHV_FUEL*ro_FUEL)/3600)    
    P_El_CHP_opt = ((V_FUEL_opt*Pel_eff_CHP*LHV_FUEL*ro_FUEL)/3600)   
    Pth_HP_opt = w_opt[(n-1)*2:(n-1)*3] 
    Pth_COIL_opt= w_opt[(n-1)*3:(n-1)*4]
    Pgrid_B_opt = w_opt[(n-1)*4:(n-1)*5]
    Pgrid_S_opt = w_opt[(n-1)*5:(n-1)*6]
    T_HTES_opt = w_opt[(n-1)*6:(n-1)*7+1]
    
    
    Q_HTES_opt=pl.zeros(T_HTES_opt.shape)
    

    for t in range (n-1):
        Q_HTES_opt[0] = Q_HTES_init         
        Q_HTES_opt[t+1] = ((((T_HTES_opt[t+1]-T_HTES_opt[t])/3600)*(HTES_Cap*ro_w*Cp_w)))+Q_HTES_opt[t]
        
    Q_HTES_shift = pl.zeros(T_HTES_opt.shape)
    Q_HTES_delta = pl.zeros(T_HTES_opt.shape)
    
    for k in range (n-1):    
        Q_HTES_shift[k] = Q_HTES_opt[k+1]
        Q_HTES_delta[k] = -Q_HTES_shift[k]+Q_HTES_opt[k]
    
  
    fig1 = pl.figure()
    ax1 = fig1.add_subplot(111)
    ax1.plot(tgrid,Pth_Load_Heat, '-')
    ax1.bar(pl.append(tgrid,pl.array(n-1)),Q_HTES_delta)
    ax1.bar(tgrid,Pth_CHP_opt,bottom = Q_HTES_delta[0:n-1])
    ax1.bar(tgrid,Pth_HP_opt ,bottom = Q_HTES_delta[0:n-1]+Pth_CHP_opt)
    ax1.bar(tgrid,pl.absolute(Pth_COIL_opt) ,bottom =Q_HTES_delta[0:n-1]+Pth_CHP_opt+Pth_HP_opt)
    pl.xlabel('Time [h]')
    pl.ylabel('Power [kWth]')
    pl.legend(['Pth_LOAD','Q_HTES','Pth_CHP','Pth_HP','Pth_COIL'])
    ax2 = fig1.add_subplot(111, sharex=ax1, frameon=False)
    ax2.plot(tgrid,C_El_B, '--',color='r') 
    ax2.yaxis.tick_right()
    ax2.yaxis.set_label_position("right")
    pl.ylabel("Price [Euro/kWhel]")
    pl.legend(['El_Price'])
    pl.grid(True)  
    
    fig2 = pl.figure()    
    pl.clf()    
    ax1 = fig2.add_subplot(111)
    ax1.plot(tgrid,(Pth_HP_opt/COP_HP)+(Pth_COIL_opt/Pth_eff_COIL)+Pel_Load, '-')
    ax1.bar(tgrid,Pgrid_B_opt)
    ax1.bar(tgrid,-Pgrid_S_opt)
    ax1.bar(tgrid,P_El_CHP_opt, bottom = pl.absolute(Pgrid_B_opt))
    pl.xlabel('Time [h]')
    pl.ylabel('Power [kWel]')
    pl.legend(['LOAD','PGRID_Buy','PGRID_Sell','CHP','COIL', 'HP'], loc = 4)
    ax2 = fig2.add_subplot(111, sharex=ax1, frameon=False)
    ax2.plot(tgrid,C_El_B, '--',color='r') 
    ax2.yaxis.tick_right()
    ax2.yaxis.set_label_position("right")
    pl.ylabel("Price [Euro/kWhel]")
    pl.legend(['El_Price'], loc = 0)
    pl.grid(True)
            
    pl.figure(3)
    pl.clf()
    pl.plot(tgrid,Pth_Load_Heat, '-',color = 'red')
    pl.bar(pl.append(tgrid,pl.array(n-1)),Q_HTES_opt)
    pl.xlabel('Time [h]')
    pl.ylabel('Power [kWth]')
    pl.legend(['LOAD','Q_HTES'])
    pl.grid(True)

    pl.figure(4)
    pl.clf()    
    pl.plot(pl.append(tgrid,pl.array(n-1)),pl.array(T_HTES_opt)-pl.ones(T_HTES_opt.shape)*273.15, color = 'red')
    pl.xlabel('Time [h]')
    pl.ylabel('Temp [C]')
    pl.legend(['T_HTES'])
    pl.grid(True)
    
    
#print(solver.stats())    
plot_sol(V_opt)
pl.show()    
    
print "Mininmal cost:" + str(K_opt)
#print " Optimal matrix:" + str(V_opt)
#    print(Pth_CHP_opt)
#    print(Pth_HP_opt)
#    print(Pth_COIL_opt)
#    print(Q_HTES_opt)
#    print(V_FUEL_opt)
