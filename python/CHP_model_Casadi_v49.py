
# coding: utf-8

# In[1]:

import pylab as pl
import casadi as ca
import numpy as np
print(ca.__version__)


# In[2]:

pl.close("all")

# Parameters for experiments

## Duration and time points

hours = 24
controls_actions_per_hour = 4

t0 = 0.0;
tf = hours * 3600.0;
N = hours * controls_actions_per_hour;

time_points = pl.linspace(t0, tf, N + 1)

dt = (tf - t0) / N  # Duration of a time interval

## Number of storage layers in the HOT tank
nlayer_htes = 90

## Number of storage layers in the COLD tank
nlayer_ctes = 40


# In[42]:

# Physical parameters of the system 

T_amb = 1
Pth_LOAD_H = 1
Pth_LOAD_C = 1
v_dot_CC_H = 1
T_CC_H_FL = 1
v_dot_CC_C =1
T_CC_C_FL =1

Pth_CHP_Nominal = 9.6e3 # in W
Pel_CHP_Nominal=1
CHP_eta_Thermal=1
CHP_eta_Electrical=1
CHP_Fuel_LHV=1
CHP_Fuel_HHV=12

## AdCM
v_dot_AdCM_LT_set=1
v_dot_AdCM_MT_set=1
v_dot_AdCM_HT_set=1
SF = 0

v_dot_HP_HT=1
v_dot_HP_MT=1
m_dot_HP_HT_FL_Set=1
m_dot_HP_MT_FL_Set=1

v_dot_OC1=1
v_dot_OC2=1

v_dot_CCM_MT=1
v_dot_CCM_LT=1
T_CCM_MT_RL=1
m_dot_CCM_MT_FL_Set=1
m_dot_CCM_LT_FL_Set=1


# Constants

## Heat exchangers
A_HX12 = 1
A_HX1 = A_HX12
A_HX2 = A_HX12
A_HX3 = 1
U_HX12 = 1
U_HX1 = U_HX12 
U_HX2 = U_HX12
U_HX3 =1

## Outdoor coils
A_OC =1
U_OC =1
RPM_max=1

rho_water=1

## Tanks
h=1
n=1
pi=3.14
rho=1
D=1.0
t=0.1

## Hot load
T_LOAD_H_CC_FL = 1

## Cold load
T_LOAD_C_CC_FL = 1


# In[37]:

# Secondary parameters to be used in equations (with conversion)
m_dot_CC_H = v_dot_CC_H*rho_water/3600
m_dot_CC_C = v_dot_CC_C*rho_water/3600
m_dot_AdCM_LT_Set = v_dot_AdCM_LT_set*rho_water/3600
m_dot_AdCM_MT_Set = v_dot_AdCM_MT_set*rho_water/3600
m_dot_AdCM_HT_Set = v_dot_AdCM_HT_set*rho_water/3600

m_dot_HP_HT = v_dot_HP_HT*rho_water/3600
m_dot_HP_MT = v_dot_HP_MT*rho_water/3600

m_dot_OC1 = v_dot_OC1*rho_water/3600
m_dot_OC2 = v_dot_OC2*rho_water/3600

m_dot_CCM_MT = v_dot_CCM_MT*rho_water/3600
m_dot_CCM_LT = v_dot_CCM_LT*rho_water/3600

## Parameters for a layer in the HTES
zi = h / n;
mi = pi * (D / 2) ** 2 * zi * rho;
di = D - 2 * t;
Aamb = pi * D * zi;
Alayer = pi * di ** 2 / 4;


# In[ ]:

# Some equations for intermediate quantities that are not real variables
# Can be eliminated by hand

# Pth_AdCM_LT = f(T_HTES_t, T_AdCM_MT_RL, T_CTES_t)
# COP_AdCM = f(T_HTES_t, T_AdCM_MT_RL, T_CTES_t)
# Pth_CCM_LT = 
# Pth_AdCM_HT =
# Pth_AdCM_MT = 
# Pth_CCM_MT


# In[31]:

# Declaration of variables

## Number of control variables
nu = 4

## Number of state variables
nx = 1 + nlayer_htes + nlayer_ctes

## Number of algebraic states (depending on the way we define variables)
ny = 48

## States and controls
u = ca.SX.sym("u", nu) # Control
x = ca.SX.sym("x", nx ) # Differential states: temperatures in the tank
y = ca.SX.sym("x", ny) # Output variable

# Input variables
CHP_Switch  = u[0]
HP_Switch   = u[1]
AdCM_Switch = u[2]
CCM_Switch  = u[3]

CHP_ON_int  = u[0]
RevHP_HP_ON_int   = u[1]
AdCM_ON_int = u[2]
RevHP_CC_ON_int  = u[3]


# State variables
Pth_CHP_x = x[0]
T_HTES = ca.SX.sym("T_HTES", nlayer_htes)
T_CTES = ca.SX.sym("T_CTES", nlayer_ctes)
for k in range(nlayer_htes):
    T_HTES[k] = x[1+k]
for k in range(nlayer_ctes):
    T_CTES[k] = x[1+nlayer_htes+k]

# Output variables. We will re-order the component y[i] from 0, 1, ...
mdot_FUEL    = y[0]
Pth_CHP      = y[1]
Pel_CHP      = y[2]
mdot_CHP_nonzero = y[3]
mdot_CHP     = y[4]
T_CHP_FL     = y[5]

T_HTES_t     = y[6]
T_HTES_l     = y[7]
T_HTES_b     = y[8]

Pth_LOAD_H = y[42]
mdot_LOAD_H  = y[9]
T_LOAD_H_FL  = y[10]

T_HX3_FL     = y[11]

Pel_HP = y[30]
Pth_HP_HT = y[31]
Pth_HP_MT = y[32]
T_HP_HT_FL   = y[12]
T_HP_HT_RL   = y[13]
T_HP_MT_FL   = y[14]
T_HP_MT_RL   = y[15]

Pel_OC2 = y[33]
v_dot_OC2 = y[41]
T_OC2_FL     = y[16]
T_OC2_RL     = y[17]

T_AdCM_HT_FL = y[18]
T_AdCM_MT_FL = y[19]
T_AdCM_MT_RL = y[20]
T_AdCM_LT_FL = y[21]
Pel_AdCM = y[34]

Pel_OC1 = y[35]
v_dot_OC1 = y[40]
T_OC1_FL     = y[22]
T_OC1_RL     = y[23]

T_CTES_t     = y[24]
T_CTES_b     = y[25]

Pel_CCM = y[36]
Pth_CCM_LT = y[37]
Pth_CCM_MT = y[38]
T_CCM_LT_FL  = y[26]
T_CCM_MT_FL  = y[27]

Pth_LOAD_C = y[43]
mdot_LOAD_C  = y[28]
T_LOAD_C_FL  = y[29]

Pel_OC3 = y[39]

m_dot_CHP_set = y[44]

T_LOAD_H_CC_RL = y[45]

T_LOAD_C_CC_RL = y[46]

#to_be_checked_and_added


# In[6]:

# Secondary variables
v_dot_LOAD_H = mdot_LOAD_H / rho_water
v_dot_LOAD_C = mdot_LOAD_C / rho_water


# In[7]:

# Initial values of variable at time t=0

## Initial states
Pth_CHP_x_t0 = 1

T_HTES_layer_top_t0 = 35.0
T_HTES_layer_bottom_t0 = 25.0
T_HTES_t0 = pl.linspace(T_HTES_layer_top_t0, T_HTES_layer_bottom_t0, nlayer_htes)

T_CTES_layer_top_t0 = 25.0
T_CTES_layer_bottom_t0 = 10.0
T_CTES_t0 = pl.linspace(T_CTES_layer_top_t0, T_CTES_layer_bottom_t0, nlayer_ctes)

x_0 = [Pth_CHP_x_t0] + list(T_HTES_t0) + list(T_CTES_t0)


## Initial controls

chp_status_init = 0.0 * pl.ones(time_points.size - 1)

u_init = chp_status_init # to check

u_0 = [1, 1, 0, 0]




# In[10]:

# Equations
# TODO: make the separate lists of equations from Open Modelica initiated model,
#       one file for differential equations, one file for algebraic equations

## Differential equations
dxdt = []
## Use equations like:
# dxdt.append((1.0 / m_s_i) * status_CHP * (mdot_CHP_to_9 * T_out_CHP - mdot_9_to_8 * T_s[8])) # T_9_dot
# ...
# dxdt = ca.vertcat(*dxdt)



## Algebraic equation, left hand side = 0
f_z = []
## Use equations like:
# f_z.append(P_th_CC/c_p - mdot_6_to_LOAD * (T_s[5] - T_LOAD_RL))
# f_z = ca.vertcat(*f_z)



# In[46]:

## Equations copied from Open Modelica initiated model, with variable names changed to Casadi name set
#560.794 * der(Pth_CHP) + Pth_CHP = Pth_CHP * CHP_ON_int 
v_dot_CHP = 0.433352645 + -0.01514531 * T_HTES_b + 0.00024329 * T_HTES_b ** 2.0
CHP_H_W_T_M_FL_K = (T_HTES_b+273.15) + 0.2392344497607656 * Pth_CHP / m_dot_CHP_set
v_dot_FUEL = 1000.0 * (Pel_CHP + Pth_CHP) / (853.5 * (CHP_eta_Thermal + CHP_eta_Electrical) * CHP_Fuel_HHV) 
Pth_CC = 4.18 * m_dot_CC_H * (T_LOAD_H_CC_FL - T_LOAD_H_CC_RL)
Pth_CC = 4.18 * (v_dot_LOAD_H*rho_water/3600) * ((T_LOAD_H_FL+273.15) - (T_LOAD_H_CC_RL+273.15))
COP = -0.049623287373 + 0.01893348591 * T_CTES_t + 0.013340776694 * T_AdCM_HT_FL + 0.017822939671 * T_AdCM_MT_RL + -0.001280352166 * T_CTES_t ** 2.0 + -0.000190832894 * T_AdCM_HT_FL ** 2.0 + -0.001993352016 * T_AdCM_MT_RL ** 2.0 + T_CTES_t * (-0.000334095159 * T_AdCM_HT_FL + 0.001455689548 * T_AdCM_MT_RL) + 0.000569253554 * T_AdCM_HT_FL * T_AdCM_MT_RL + 1.3421174e-05 * T_CTES_t * T_AdCM_HT_FL * T_AdCM_MT_RL
Pth_AdCM_LT = AdCM_ON_int * (4.07950934099 + 0.04152472361 * T_CTES_t + 0.160630808297 * T_AdCM_HT_FL + -0.859860168466 * T_AdCM_MT_RL + 0.003462744142 * T_CTES_t ** 2.0 + -0.001049096999 * T_AdCM_HT_FL ** 2.0 + 0.015142231276 * T_AdCM_MT_RL ** 2.0 + T_CTES_t * (0.016955368833 * T_AdCM_HT_FL + -0.016151596215 * T_AdCM_MT_RL) + -0.001917799045 * T_AdCM_HT_FL * T_AdCM_MT_RL + -0.000200778961 * T_CTES_t * T_AdCM_HT_FL * T_AdCM_MT_RL)
Pth_AdCM_HT = Pth_AdCM_LT / COP - SF 
Pth_AdCM_MT = Pth_AdCM_HT + Pth_AdCM_LT 
T_AdCM_LT_FL_K = (T_CTES_t+273.15) + -0.2392344497607656 * Pth_AdCM_LT / m_dot_AdCM_LT_Set
T_AdCM_MT_FL_K = (T_AdCM_MT_RL+273.15) + 0.2392344497607656 * Pth_AdCM_MT / m_dot_AdCM_MT_Set
ADCM_C_W_T_M_HT_FL_K = (T_AdCM_HT_FL+273.15) + -0.2392344497607656 * Pth_AdCM_HT / m_dot_AdCM_HT_Set
Pth_HP_HT = HP_Switch * (9.0 + 0.294510922 * T_HP_MT_FL + T_HP_HT_RL * (0.064700246 + 0.002953381 * T_HP_MT_FL) + -0.001625553 * T_HP_MT_FL ** 2.0 + -0.001627312 * T_HP_HT_RL ** 2.0)
Pth_HP_MT = Pth_HP_HT - Pel_HP 
T_HP_HT_FL__K = (T_HP_HT_RL+273.15) + 0.2392344497607656 * Pth_HP_HT / m_dot_HP_HT_FL_Set
RevHP_HC_W_T_M_LT_FL__K = (T_HP_MT_FL+273.15) + -0.2392344497607656 * Pth_HP_MT / m_dot_HP_MT_FL_Set
Pel_HP = HP_Switch * (1.733202228 + -0.007333788 * T_HP_MT_FL + T_HP_HT_RL * (0.019283658 + 0.000450498 * T_HP_MT_FL) + -8.304799999999999e-05 * T_HP_MT_FL ** 2.0 + 0.000671146 * T_HP_HT_RL ** 2.0)
Pth_CCM_LT = CCM_Switch * (9.0 + 0.308329176 * T_CCM_LT_FL + 0.045285097 * T_CCM_MT_RL + 0.002252906 * T_CCM_LT_FL * T_CCM_MT_RL + -0.001213212 * T_CCM_LT_FL ** 2.0 + -0.002264659 * T_CCM_MT_RL ** 2.0)
Pel_CCM = CCM_Switch * (1.833202228 + -0.007333788 * T_CCM_LT_FL + 0.019283658 * T_CCM_MT_RL + 0.000450498 * T_CCM_LT_FL * T_CCM_MT_RL + -8.304799999999999e-05 * T_CCM_LT_FL ** 2.0 + 0.000671146 * T_CCM_MT_RL ** 2.0)
Pth_CCM_MT = Pel_CCM + Pth_CCM_LT
RevHP_HC_W_T_M_LT_FL_K = (T_CCM_LT_FL+273.15) + -0.2392344497607656 * Pth_CCM_LT / m_dot_CCM_LT_FL_Set
T_CCM_MT_FL_K = (T_CCM_MT_RL+273.15) + 0.2392344497607656 * Pth_CCM_MT / m_dot_CCM_MT_FL_Set
Pth_CC = 4.18 * m_dot_CC_C * (T_LOAD_C_CC_RL - T_LOAD_C_CC_FL) 
Pth_CC = 4.18 * (v_dot_LOAD_C*rho_water/3600) * ((T_LOAD_C_CC_RL+273.15) - (T_LOAD_C_FL+273.15)) 
#4.18 * mi * der(HTES_H_W_T_M_IT_K[1]) = Alayer * lambda_eff * (HTES_H_W_T_M_IT_K[2] - HTES_H_W_T_M_IT_K[1]) / zi + 4.18 * (m_dot_LOAD * (T_HTES_LOAD_RL_K - HTES_H_W_T_M_IT_K[1]) + m_dot_AdCM_HT * (T_HTES_AdCM_RL_K - HTES_H_W_T_M_IT_K[1]) + d_pos * m_dot[2] * (HTES_H_W_T_M_IT_K[2] - HTES_H_W_T_M_IT_K[1])) + -20.0 * Aamb * kappa * (HTES_H_W_T_M_IT_K[1] - T_amb_K)
#4.18 * mi * der(HTES_H_W_T_M_IT_K[2]) = Alayer * lambda_eff * (HTES_H_W_T_M_IT_K[1] + -2.0 * HTES_H_W_T_M_IT_K[2] + HTES_H_W_T_M_IT_K[3]) / zi + 4.18 * m_dot[2] * (d_pos * (HTES_H_W_T_M_IT_K[3] - HTES_H_W_T_M_IT_K[2]) + d_neg * (HTES_H_W_T_M_IT_K[2] - HTES_H_W_T_M_IT_K[1])) + COIL_H_E_PT_M / /*Real*/(n) - Aamb * kappa * (HTES_H_W_T_M_IT_K[2] - T_amb_K)
#Chot = 3.66736 * (v_dot_OC1*rho_water/3600)
#Ccold = 1.005 * (v_dot_air_OC1*rho_water/3600)
#Cmin = min(Chot, Ccold)
#Cmax = max(Chot, Ccold)
#qmax = Cmin * (T_OC1_RL - T)
#q = eff * qmax
#eff = (1.0 - exp(NTU * (Cr - 1.0))) / (1.0 - Cr * exp(NTU * (Cr - 1.0)))
#RPM_max / RPM_real = Volt_max / Volt_real
#Pel_max / Pel_OC1 = (RPM_max / RPM_real) ** 3.0
#v_dot_air_max / v_dot_air_real = RPM_max / RPM_real
#Chot = 3.66736 * (v_dot_OC2*rho_water/3600)
#Ccold = 1.005 * (v_dot_air_OC2*rho_water/3600)
#Cmin = min(Chot, Ccold)
#Cmax = max(Chot, Ccold)
#qmax = Cmin * (T_OC2_RL - T)
#q = eff * qmax
#eff = (1.0 - exp(NTU * (Cr - 1.0))) / (1.0 - Cr * exp(NTU * (Cr - 1.0)))
#RPM_max / RPM_real = Volt_max / Volt_real
#Pel_max / Pel_OC2 = (RPM_max / RPM_real) ** 3.0
#v_dot_air_max / v_dot_air_real = RPM_max / RPM_real
#Chot = 4.18 * m_dot_OC
#Ccold = 1.005 * m_dot_air
#Cmin = min(Chot, Ccold)
#Cmax = max(Chot, Ccold)
#qmax = Cmin * (T_CCM_MT_RL - T)
#q = eff * qmax
#eff = (1.0 - exp(NTU * (Cr - 1.0))) / (1.0 - Cr * exp(NTU * (Cr - 1.0)))
#q = Chot * (T_CCM_MT_RL - T_CCM_MT_FL)
#q = Ccold * (T_air_out - T)
#RPM_max / RPM_real = Volt_max / Volt_real
#Pel_max / Pel_OC3 = (RPM_max / RPM_real) ** 3.0
#v_dot_air_max / v_dot_air_real = RPM_max / RPM_real
#4.18 * mi * der(CTES_H_W_T_M_IT_K[1]) = 4.18 * (m_dot_AdCM * (T_CTES_AdCM_In_K - CTES_H_W_T_M_IT_K[1]) + m_dot_RevHP * (T_CTES_RevHP_In_K - CTES_H_W_T_M_IT_K[1])) + Alayer * lambda_eff * (CTES_H_W_T_M_IT_K[2] - CTES_H_W_T_M_IT_K[1]) / zi + 4.18 * d_neg * m_dot[2] * (CTES_H_W_T_M_IT_K[1] - CTES_H_W_T_M_IT_K[2]) - Aamb * kappa * (CTES_H_W_T_M_IT_K[1] - T_amb_K)
#4.18 * mi * der(CTES_H_W_T_M_IT_K[2]) = Alayer * lambda_eff * (CTES_H_W_T_M_IT_K[1] + -2.0 * CTES_H_W_T_M_IT_K[2] + CTES_H_W_T_M_IT_K[3]) / zi + 4.18 * m_dot[2] * (d_neg * (CTES_H_W_T_M_IT_K[2] - CTES_H_W_T_M_IT_K[3]) + d_pos * (CTES_H_W_T_M_IT_K[1] - CTES_H_W_T_M_IT_K[2])) - Aamb * kappa * (CTES_H_W_T_M_IT_K[2] - T_amb_K)


# In[44]:




# In[4]:

# TODO: bring new equations into the form of an optimal control problem
#### (below is untouched)



# In[70]:

# Constraints

T_min_all = 0.0
T_max_all = 100.0

x_lbw = list(T_min_all*pl.ones(nlayer_htes))
x_ubw = list(T_max_all*pl.ones(nlayer_htes))

#zeros_z = list(0.0*pl.ones(f_z.numel()))
#zeros_x = list(0.0*pl.ones(dxdt.numel()))


# In[ ]:



