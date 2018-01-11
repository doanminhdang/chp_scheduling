# -*- coding: utf-8 -*-
"""
Created on Mon Dec 18 13:47:31 2017
"""

#Import the libraries
import pandas
import pylab as pl
import casadi as ca

df = pandas.read_excel('winter_load_data.xlsx')
#print the column names
print(df.columns)
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
Pmin_HP_Th = 0
Pmax_HP_Th = 16#kW_Th

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

#Fuel consumption of CHP in m³/h
vdot_fuel = 1.8/ro_FUEL

"Costs" 
#Electricity costs
C_El_B= pl.array(epex_price_buy)
C_El_S= pl.array(epex_price_sell)

#Fuel Costs
Fuel= 510 #eur/m³

"Initial Values"
HTES_Warm = 75 + 273.15 #K Highest possible temperature in tank 
HTES_Cold = 35 + 273.15 #K
#T_Amb = 10 + 273.15 #K
T_A_N = 6 #Temperature at 0 in the night for the temp linspace
T_A_M = 15#Temperature at 16hrs in the evening for the temp linspace
T_HP_min = 10 #Temperature min to operate the HP.
T_HTES_init_0 = 50 +273.15#Initial temperature in the Tank K
Q_HTES_init = 30 #kW Initial Power in Tank


#Formulate the LP Problem
#Set the time Steps
n= int(Time.size) + 1

#define the ambient temperature linear increase or decrease
T_Amb=[]
days = int(round((n-1)/24.0))


T_Amb_1 = pl.linspace(T_A_N, T_A_M, (16))
T_Amb_2 = pl.linspace(T_A_M, T_A_N, (24)-16)


for i in range(days):
    T_Amb   = pl.append( pl.append(T_Amb_1, T_Amb_2),T_Amb)


T_Amb = T_Amb[:(n-1)]
T_Amb_bin = (T_Amb <=T_HP_min)*1

#Define the optimization variables
    #Electrical Energy 
E_El_COIL = ca.MX.sym("E_El_COIL", n-1)
E_El_HP = ca.MX.sym("E_El_HP", n-1)
E_El_CHP = ca.MX.sym("E_El_CHP", n-1)
Pgrid= ca.MX.sym("Pgrid", n-1)
   #Thermal energy
Q_COIL = ca.MX.sym("Q_COIL", n-1)
Q_HP= ca.MX.sym("Q_HP", n-1)
Q_CHP = ca.MX.sym("Q_CHP", n-1)
V_FUEL= ca.MX.sym("V_FUEL", n-1)
T_HTES = ca.MX.sym("T_HTES", n)
    #Binary
CHP_bin = ca.MX.sym("CHP_bin", n-1)
COIL_bin = ca.MX.sym("COIL_bin", n-1)
HP_bin = ca.MX.sym("HP_bin", n-1)


#Redefine the name of the opt variables
C_FUEL = Fuel
Pth_Load_Heat =pl.array(Pth_Load_Heat)/2
Pel_Load = pl.array(Pel_Load)

#Define the objective function
f = 0
t=0

#If Pgrid is +ve then use buying, if -ve then using selling price
#To restrict the optimisation only to buying, the Pgrid should be constrained to having only positive values (Adjust by making Pgrid_min limit = 0 )
#C_El=ca.if_else(Pgrid>0,C_El_B,C_El_S)
C_El = C_El_B # If "if_else statement wants to be avoided


for t in range(n-1):
#Cost function (Two cost functions are not needed since the Pgrid can be constrained to be only +ve)
    f +=  C_El[t]*Pgrid[t] + C_FUEL*V_FUEL[t]
    
#Define the constraints 
g = []
g_min = []
g_max = []


"Equality Constraints"

#electricity balance : E_Demand = E_supply i.e. Pel_HP + Pel_Coil + Pel_Load = Pel_CHP + Pel_Grid
for t in range(n-1):

    g.append(E_El_HP[t]+(E_El_COIL[t])+Pel_Load[t]-E_El_CHP[t]-Pgrid[t])#-((V_FUEL[t]*Pel_eff_CHP*LHV_FUEL*ro_FUEL)/3600)-Pgrid[t])
    g_min.append(0)
    g_max.append(0) 
    
#thermal energy balance :  Q_HTES(t+1) = Q_HTES(t) + Q_HP(t) + QCoil(t) + QCHP(t) - QLoad(t) 60674.15730337079
    g.append((((T_HTES[t+1]-T_HTES[t])/3600)*(HTES_Cap*ro_w*Cp_w))-(Q_HP[t]+Q_COIL[t]+Q_CHP[t]-Pth_Load_Heat[t]))#+((V_FUEL[t]*Pth_eff_CHP*LHV_FUEL*ro_FUEL)/3600)-Pth_Load_Heat[t]))
    g_min.append(0)
    g_max.append(0)
    
    
"Inequality Constraints" # but they are not inequality constraints in the mathematical sense??? its an equality
for t in range(n-1):
    #Component Characteristics
    #Pel_HP = Pth_HP max * HP_Switch
    g.append(E_El_HP[t] - ((Pmax_HP_Th /COP_HP) * HP_bin[t]) ) 
    g_min.append(0)
    g_max.append(0)
    
    g.append(E_El_COIL[t] - ((Pmax_COIL_Th/Pth_eff_COIL) * COIL_bin[t]) )
    g_min.append(0)
    g_max.append(0)
    
    g.append(E_El_CHP[t] - (Pmax_CHP_El *CHP_bin[t]) )
    g_min.append(0)
    g_max.append(0)
    
    
#    g.append((V_FUEL[t]*Pel_eff_CHP*LHV_FUEL*ro_FUEL)/3600)
#    g_min.append(0)
#    g_max.append(Pmax_CHP_El)
#    
#    g.append((V_FUEL[t]*Pth_eff_CHP*LHV_FUEL*ro_FUEL)/3600)
#    g_min.append(0)
#    g_max.append(Pmax_CHP_Th)   
    
    #Thermal Energy Constraints
    
    g.append(Q_HP[t]- (Pmax_HP_Th * HP_bin[t]))
    g_min.append(0)
    g_max.append(0)
      
    g.append(Q_COIL[t] - (Pmax_COIL_Th * COIL_bin[t]))
    g_min.append(0)
    g_max.append(0)
    
    g.append(Q_CHP[t] - (Pmax_CHP_Th * CHP_bin[t]))
    g_min.append(0)
    g_max.append(0)    
    
    g.append(T_HTES[0])
    g_min.append(T_HTES_init_0)
    g_max.append(T_HTES_init_0)  

    g.append(T_HTES[t+1])
    g_min.append(HTES_Cold)
    g_max.append(HTES_Warm)  
 
    #Optimal function constraints
    
    g.append(V_FUEL[t] - (vdot_fuel * CHP_bin[t]))
    g_min.append(0)
    g_max.append(0)
    
    #Binary constraints
    
    g.append(CHP_bin[t]+HP_bin[t])
    g_min.append(0)
    g_max.append(1)
    
    g.append(T_Amb_bin[t]+HP_bin[t]) 
    g_min.append(0)
    g_max.append(1)

    
discrete = []  
 
for t in range(n-1):     
    discrete += [False]
for t in range(n-1): 
    discrete += [False]
for t in range(n-1):
    discrete += [False]
for t in range(n-1): 
    discrete += [False]
for t in range(n-1): 
    discrete += [False]
for t in range(n-1): 
    discrete += [False]
for t in range(n-1): 
    discrete += [False]
for t in range(n-1): 
    discrete += [False]
for t in range(n-1): 
    discrete += [True]
for t in range(n-1): 
    discrete += [True]   
for t in range(n-1): 
    discrete += [True] 
for t in range(n): 
    discrete += [False]    
#Transform variables into vectors for the solver input
# Vertcat = vertical concatenation, solver accepts on vector iputs and not matrices
g = ca.vertcat(*g)
V = ca.vertcat(Pgrid, V_FUEL, E_El_HP, E_El_COIL, E_El_CHP, Q_HP,  Q_COIL, Q_CHP, HP_bin, COIL_bin, CHP_bin, T_HTES)
g_min = ca.vertcat(*g_min)
g_max = ca.vertcat(*g_max)

#define the linear program
lp = {"x": V, "f": f, "g": g}
# NLP solver options (ipopt)
opts = {}
#opts["expand"] = True
#opts["ipopt.max_iter"] = 10
#opts["verbose"] = True
#opts["ipopt.linear_solver"] = "ma86"
# opts["hessian_approximation"] = "limited-memory"

#initiate one of the solvers
#solver = ca.nlpsol("solver", "ipopt", lp, opts)
#solver = ca.qpsol("solver", "qpoases", lp, {"discrete": discrete})
solver = ca.nlpsol("solver", "bonmin", lp ,{"discrete": discrete})
#solver = ca.nlpsol("solver", "bonmin", lp)
#solver = ca.nlpsol("solver", "knitro", lp, {"discrete": discrete})
#solver = ca.conic("solver", "clp", lp)


#Define the initial guess values for the solver to start
Pgrid_init = pl.zeros(Pgrid.shape)
V_FUEL_init = pl.zeros(V_FUEL.shape)
E_El_HP_init = pl.zeros(E_El_HP.shape)
E_El_COIL_init = pl.zeros(E_El_COIL.shape)
E_El_CHP_init= pl.zeros(E_El_CHP.shape)
Q_HP_init = pl.zeros(Q_HP.shape)
Q_COIL_init = pl.zeros(Q_COIL.shape)
Q_CHP_init = pl.zeros(Q_CHP.shape)
HP_bin_init = pl.zeros(HP_bin.shape)
COIL_bin_init = pl.zeros(COIL_bin.shape)
CHP_bin_init = pl.zeros(CHP_bin.shape)
T_HTES_init = pl.ones(T_HTES.shape)*T_HTES_init_0

V_init = ca.vertcat(Pgrid_init, V_FUEL_init, E_El_HP_init, E_El_COIL_init, E_El_CHP_init, Q_HP_init,  Q_COIL_init, Q_CHP_init, HP_bin_init, COIL_bin_init, CHP_bin_init,  T_HTES_init)

#Define the limits of the optimization variables
Pgrid_max = pl.ones(Pgrid.shape) *  pl.inf
V_FUEL_max = pl.ones(V_FUEL.shape) * vdot_fuel
E_El_HP_max = pl.ones(E_El_HP.shape) * Pmax_HP_Th/COP_HP
E_El_COIL_max = pl.ones(E_El_COIL.shape)* Pmax_COIL_Th/Pth_eff_COIL
E_El_CHP_max = pl.ones(E_El_CHP.shape) * Pmax_CHP_El
Q_HP_max = pl.ones(Q_HP.shape) * Pmax_HP_Th
Q_COIL_max = pl.ones(Q_COIL.shape)  * Pmax_COIL_Th
Q_CHP_max = pl.ones(Q_COIL.shape)  * Pmax_CHP_Th
HP_bin_max = pl.ones(HP_bin.shape)
COIL_bin_max = pl.ones(COIL_bin.shape)
CHP_bin_max = pl.ones(CHP_bin.shape)
T_HTES_max = pl.ones(T_HTES.shape) * HTES_Warm

Pgrid_min = pl.ones(Pgrid.shape) * -pl.inf   #Selling Allowed if this is active
#Pgrid_min = pl.zeros(Pgrid.shape)             #Selling is not allowed if active
V_FUEL_min = pl.zeros(V_FUEL.shape)
E_El_HP_min = pl.zeros(E_El_HP.shape)
E_El_COIL_min = pl.zeros(E_El_COIL.shape)
E_El_CHP_min = pl.zeros(E_El_CHP.shape)
Q_HP_min = pl.zeros(Q_HP.shape)
Q_COIL_min = pl.zeros(Q_COIL.shape)
Q_CHP_min = pl.zeros(Q_CHP.shape) 
HP_bin_min = pl.zeros(HP_bin.shape)
COIL_bin_min = pl.zeros(COIL_bin.shape)
CHP_bin_min = pl.zeros(CHP_bin.shape)
T_HTES_min = pl.ones(T_HTES.shape) * HTES_Cold




V_max = ca.vertcat(Pgrid_max, V_FUEL_max, E_El_HP_max, E_El_COIL_max, E_El_CHP_max, Q_HP_max,  Q_COIL_max, Q_CHP_max, HP_bin_max, COIL_bin_max, CHP_bin_max,  T_HTES_max)
V_min = ca.vertcat(Pgrid_min, V_FUEL_min, E_El_HP_min, E_El_COIL_min, E_El_CHP_min, Q_HP_min,  Q_COIL_min, Q_CHP_min, HP_bin_min, COIL_bin_min, CHP_bin_min,  T_HTES_min)

#Save the solution
solution = solver(x0 = V_init, lbx = V_min, ubx = V_max, \
    lbg = g_min, ubg = g_max)


#Define the optimization as variables
K_opt = solution["f"]
V_opt = solution["x"]


#solver2 = ca.nlpsol("solver2", "bonmin", lp ,{"discrete": discrete})
#solution = solver2(x0 = V_opt, lbx = V_min, ubx = V_max, \
#    lbg = g_min, ubg = g_max)
#
#K_opt = solution["f"]
#V_opt = solution["x"]


#Print function 
tgrid =pl.array(Time)
def plot_sol(w_opt):
    w_opt = w_opt.full().flatten()
    Pgrid_opt = w_opt[0:n-1]
    V_FUEL_opt= w_opt[n-1:(n-1)*2]
    E_El_HP_opt = w_opt[(n-1)*2:(n-1)*3] 
    E_El_COIL_opt =  w_opt[(n-1)*3:(n-1)*4] 
    E_El_CHP_opt =  w_opt[(n-1)*4:(n-1)*5]  
    P_El_CHP_opt = E_El_CHP_opt
#    Pth_CHP_opt = ((V_FUEL_opt*Pth_eff_CHP*LHV_FUEL*ro_FUEL)/3600)    
#    P_El_CHP_opt = ((V_FUEL_opt*Pel_eff_CHP*LHV_FUEL*ro_FUEL)/3600)   
    Pth_HP_opt = w_opt[(n-1)*5:(n-1)*6] 
    Pth_COIL_opt= w_opt[(n-1)*6:(n-1)*7]
    Pth_CHP_opt =  w_opt[(n-1)*7:(n-1)*8] 
    HP_bin_opt =  w_opt[(n-1)*8:(n-1)*9] 
    COIL_bin_opt =  w_opt[(n-1)*9:(n-1)*10] 
    CHP_bin_opt =  w_opt[(n-1)*10:(n-1)*11] 
    T_HTES_opt = w_opt[(n-1)*11:(n-1)*12+1]
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
    line1 = ax1.plot(tgrid,Pth_Load_Heat, '-')
    bar1 = ax1.bar(pl.append(tgrid,pl.array(n-1)),Q_HTES_delta)
    bar2 = ax1.bar(tgrid,Pth_CHP_opt,bottom = Q_HTES_delta[0:n-1])
    bar3 = ax1.bar(tgrid,Pth_HP_opt ,bottom = Q_HTES_delta[0:n-1]+Pth_CHP_opt)
    bar4 = ax1.bar(tgrid,pl.absolute(Pth_COIL_opt) ,bottom =Q_HTES_delta[0:n-1]+Pth_CHP_opt+Pth_HP_opt)
    pl.xlabel('Time [h]')
    pl.ylabel('Power [kWth]')
    pl.legend(['Pth_LOAD','Q_HTES','Pth_CHP','Pth_HP','Pth_COIL'])
    ax2 = fig1.add_subplot(111, sharex=ax1, frameon=False)
    line2 = ax2.plot(tgrid,C_El_B, '--',color='r') 
    ax2.yaxis.tick_right()
    ax2.yaxis.set_label_position("right")
    pl.ylabel("Price [Euro/kWhel]")
    pl.legend(['El_Price'])
    pl.grid(True)  
     
    pl.figure(2)
    pl.clf()    
    pl.plot(tgrid,(E_El_HP_opt)+(E_El_COIL_opt)+Pel_Load, '-')
    pl.bar(tgrid,Pgrid_opt)
    pl.bar(tgrid,P_El_CHP_opt, bottom = pl.absolute(Pgrid_opt))
    pl.xlabel('Time [h]')
    pl.ylabel('Power [kWel]')
    pl.legend(['LOAD','PGRID','CHP','COIL', 'HP'])
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
    
    pl.figure(5)
    pl.clf()    
    pl.plot(tgrid, T_Amb, color = 'red')
    pl.xlabel('Time [h]')
    pl.ylabel('Temp [C]')
    pl.legend(['T_Amb'])
    pl.grid(True)
    
    pl.figure(6)
    pl.clf()
    pl.step(tgrid,CHP_bin_opt) 
    pl.legend(['Status CHP'])
    pl.figure(7)
    pl.clf()      
    pl.step(tgrid,HP_bin_opt, label = "Status HP opt")
    pl.legend(['Status HP'])
    pl.figure(8)
    pl.clf()
    pl.step(tgrid,COIL_bin_opt, label = "Status COIL opt")
    pl.legend(['Status COIL'])
    
#print(solver.stats())    
plot_sol(V_opt)
pl.show()    
    
print("Mininmal cost:" + str(K_opt))
##print " Optimal matrix:" + str(V_opt)
#    print(Pth_CHP_opt)
#    print(Pth_HP_opt)
#    print(Pth_COIL_opt)
#    print(Q_HTES_opt)
#    print(V_FUEL_opt)
