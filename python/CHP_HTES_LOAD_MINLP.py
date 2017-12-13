# -*- coding: utf-8 -*-
# <nbformat>3.0</nbformat>

# <codecell>

import pylab as pl
import casadi as ca
import numpy as np
print(ca.__version__)

# <codecell>

pl.close("all")

# Number of Storage Layers 

N_s = 9

# Number of algebraic states (depending on the way we define variables)

N_z = 18

# States and controls

x = ca.SX.sym("x", N_s ) # Differential states: temperatures in the tank
z = ca.SX.sym("x", N_z) # Algebraic variable
#u = ca.SX.sym("u",1) # Control
u = ca.SX.sym("u", 2) # 1st element is Control, 2nd element is Power thermal used by the Load


# Parameters

m_s = 1.5e3
c_p = 4.182e3
P_th_CHP = 9.6e3 # in W
p_CHP = [0.306565505429308, 0.0108903851122254, 0.000207768653760159]

T_CC_FL = 35
delta_T_CC = 10
T_LOAD_RL = T_CC_RL = T_CC_FL - delta_T_CC
P_th_CC_constant = 2e3

# Objective is to track the temperature of the upper layer in the tank to T_ref
T_ref = 70

# <codecell>

# States initials

T_s_0_0 = 25.0
T_s_N_0 = 35.0
T_s_init = pl.linspace(T_s_0_0, T_s_N_0, N_s)

x_0 = list(T_s_init)

# Duration and time points

hours = 6
controls_actions_per_hour = 1

t0 = 0.0;
tf = hours * 3600.0;
N = hours * controls_actions_per_hour;

time_points = pl.linspace(t0, tf, N + 1)

# Initial controls

chp_status_init = 0.0 * pl.ones(time_points.size - 1)

u_init = chp_status_init # to check

u_0 = [1,2000]

# Duration of a time interval

dt = (tf - t0) / N

# <codecell>

# System dynamics

T_s = x # NOTE the meaning: Ts[0] is temperature of the 1st layer, Ts[8] is for the 9th layer

mdot_CHP_to_9 = z[0]
mdot_9_to_8 = z[1]
mdot_8_to_7 = z[2]
mdot_7_to_6 = z[3]
mdot_6_to_LOAD = z[4]
mdot_6_to_5 = z[5]
mdot_5_to_6 = z[6]
mdot_5_to_4 = z[7]
mdot_4_to_5 = z[8]
mdot_4_to_3 = z[9]
mdot_3_to_4 = z[10]
mdot_3_to_2 = z[11]
mdot_2_to_3 = z[12]
mdot_2_to_1 = z[13]
mdot_1_to_2 = z[14]
mdot_LOAD_to_1 = z[15]
mdot_1_to_CHP = z[16]
T_out_CHP = z[17] # It does not contribute anything to the DAE model

status_CHP = u[0] # Real control input
P_th_CC = u[1] # Consider the power thermal of the load as a parameter in the DAE, similar to a control

m_s_i = m_s / N_s

# Differential equation, left hand side = xdot
dxdt = []
# Energy balance equations, note that dEnergy/dt = m*cp*dT/dt
dxdt.append((1.0 / m_s_i) * status_CHP * (mdot_2_to_1 * T_s[1] - mdot_1_to_2 * T_s[0] + mdot_LOAD_to_1 * T_LOAD_RL - mdot_1_to_CHP * T_s[0])) # T_1_dot
dxdt.append((1.0 / m_s_i) * status_CHP * (mdot_3_to_2 * T_s[2] - mdot_2_to_3 * T_s[1] + mdot_1_to_2 * T_s[0] - mdot_2_to_1 * T_s[1])) # T_2_dot
dxdt.append((1.0 / m_s_i) * status_CHP * (mdot_4_to_3 * T_s[3] - mdot_3_to_4 * T_s[2] + mdot_2_to_3 * T_s[1] - mdot_3_to_2 * T_s[2])) # T_3_dot
dxdt.append((1.0 / m_s_i) * status_CHP * (mdot_5_to_4 * T_s[4] - mdot_4_to_5 * T_s[3] + mdot_3_to_4 * T_s[2] - mdot_4_to_3 * T_s[3])) # T_4_dot
dxdt.append((1.0 / m_s_i) * status_CHP * (mdot_7_to_6 * T_s[6] - mdot_6_to_5 * T_s[5] + mdot_5_to_6 * T_s[4] - mdot_6_to_LOAD * T_s[5])) # T_6_dot
dxdt.append((1.0 / m_s_i) * status_CHP * (mdot_6_to_5 * T_s[5] - mdot_5_to_6 * T_s[4] + mdot_4_to_5 * T_s[3] - mdot_5_to_4 * T_s[4])) # T_5_dot
dxdt.append((1.0 / m_s_i) * status_CHP * (mdot_8_to_7 * T_s[7] - mdot_7_to_6 * T_s[6])) # T_7_dot
dxdt.append((1.0 / m_s_i) * status_CHP * (mdot_9_to_8 * T_s[8] - mdot_8_to_7 * T_s[7])) # T_8_dot
dxdt.append((1.0 / m_s_i) * status_CHP * (mdot_CHP_to_9 * T_out_CHP - mdot_9_to_8 * T_s[8])) # T_9_dot

dxdt = ca.vertcat(*dxdt)

# f_x = ca.vertcat(dxdt)

# Algebraic equations, left hand side = 0
f_z = []
f_z.append(mdot_CHP_to_9 - (p_CHP[0] - p_CHP[1] * T_s[0] + p_CHP[2] * T_s[0]**2) / 3.6 )# the curve was fit to temperature go into CHP
f_z.append(T_out_CHP - ((P_th_CHP / (mdot_CHP_to_9 * c_p+0.1)) + T_s[0]) )
# Mass conservation equations
f_z.append(mdot_9_to_8 - mdot_CHP_to_9) # mdot_9_to_CHP = 0
f_z.append(mdot_8_to_7 - mdot_9_to_8) # mdot_8_to_9 = 0
f_z.append(mdot_7_to_6 - mdot_8_to_7) # mdot_7_to_8 = 0
f_z.append(- mdot_6_to_5 + mdot_7_to_6 + mdot_5_to_6 - mdot_6_to_LOAD) # mdot_6_to_7 = 0, water flow 1 direction from 6th layer to LOAD
f_z.append(- mdot_5_to_4 + mdot_6_to_5 - mdot_5_to_6 + mdot_4_to_5)
f_z.append(- mdot_4_to_3 + mdot_5_to_4 - mdot_4_to_5 + mdot_3_to_4)
f_z.append(- mdot_3_to_2 + mdot_4_to_3 - mdot_3_to_4 + mdot_2_to_3)
f_z.append(- mdot_2_to_1 + mdot_3_to_2 - mdot_2_to_3 + mdot_1_to_2)
f_z.append(- mdot_1_to_CHP + mdot_2_to_1 - mdot_1_to_2 + mdot_LOAD_to_1) # water flow 1 direction from LOAD to 1st layer, and 1st to CHP
f_z.append(- mdot_6_to_LOAD + mdot_LOAD_to_1) # only need this, then it automatically guarantee mdot_CHP_to_9 = mdot_1_to_CHP
# f_z.append(mdot_CHP_to_9 - mdot_1_to_CHP)
# Complementarity constraint
f_z.append(mdot_6_to_5 * mdot_5_to_6) # either mdot_6_to_5 =0 or mdot_5_to_6 = 0
f_z.append(mdot_5_to_4 * mdot_4_to_5)
f_z.append(mdot_4_to_3 * mdot_3_to_4)
f_z.append(mdot_3_to_2 * mdot_2_to_3)
f_z.append(mdot_2_to_1 * mdot_1_to_2)
f_z.append(P_th_CC/c_p - mdot_6_to_LOAD * (T_s[5] - T_LOAD_RL))
f_z = ca.vertcat(*f_z)

# <codecell>

# Constraints

T_min_all = 0.0
T_max_all = 100.0

x_lbw = list(T_min_all*pl.ones(N_s))
x_ubw = list(T_max_all*pl.ones(N_s))

zeros_z = list(0.0*pl.ones(f_z.numel()))
zeros_x = list(0.0*pl.ones(dxdt.numel()))

# <codecell>

# Create dynamical model in form of a DAE (Differential Algebraic Equations) system

dae = {'x':x, 'z':z, 'p':u, 'ode':dxdt, 'alg':f_z}
#opts = {'tf':0.5} # interval length
I = ca.integrator('I','collocation', dae)

f = ca.Function('f', [x, z, u], [dxdt,f_z], ['x', 'z', 'p'], ['ode','alg'])
fz = ca.Function('fz', [z, x, u], [f_z], ['z','x', 'p'], ['alg'])
G1 = ca.rootfinder('G1','newton',fz)

# Test simulation
z_0_guess = [0.511 for i in range(N_z)]
outz=G1(z=z_0_guess, x=x_0, p=u_0)
z_0_solve=outz['alg']

z_start=z_0_solve

r = I(x0=x_0,z0=z_start,p=u_0)
print(x_0)
print(r['xf'])

print(z_start)
print(r['zf'])

# <codecell>

# Optimal control problem formulation
X = [ ca.MX.sym("x", N_s) for i in range(N+1)]
U = [ ca.MX.sym("u", 2) for i in range(N)]
# X and U are lists of MX variables

# Multiple shooting

J = 0

X_next = []
Xs = []

gaps = []
g_min = []
g_max = []

lbw = [] # Lower bounds on variables
ubw = [] # Upper bounds on variables

# Generate the multiple shooting equality constraints, and set which
# optimization variables are discrete

discrete = []

V = []

V_init = []

z0 = z_0_solve

for k in range(N):
    r = I(x0=X[k],z0=z0,p=U[k])
    z0 = r["zf"]
    #X_next.append(r["xf"])
    gaps.append(X[k+1]-r["xf"])
    #Xs.append(X[k])
    
    V.append(X[k])
    V.append(U[k])
    
    g_min.append(np.zeros(N_s))
    g_max.append(np.zeros(N_s))
    discrete += [False] * N_s # for states
    discrete += [True, False] # true control is ON/OFF
    lbw += x_lbw
    lbw += [0, 0]
    ubw += x_ubw
    ubw += [1, ca.inf]
    J = J + (r['xf'][-1]-T_ref)**2
    
    V_init.append(x_0)
    V_init.append(u_0)
    

V_init.append(x_0)    
    
V.append(X[-1])    
discrete += [False] * N_s

lbw += x_lbw
ubw += x_ubw

u_true = ca.MX.sym("u",N)
p = ca.MX.sym("p",N)

# Stack the constraints as well as their bounds

gaps = ca.vertcat(*gaps)
g_min = ca.vertcat(*g_min)
g_max = ca.vertcat(*g_max)

p_track = P_th_CC_constant*np.array(range(1,N+1))

# Set up the NLP and the solver accordingly, and solve the optimization problem

nlp = {"x": ca.veccat(*V), "p": p, "f": J, "g": gaps}

## Solve MINLP with bonmin
# VERY time consuming
#opts = {"discrete": discrete}#, "bonmin":{"ipopt.print_level":5}}
#nlpsolver = ca.nlpsol("nlpsolver", "bonmin", nlp, opts) #, "bonmin.linear_solver": "ma86"})
#solution = nlpsolver(x0 = ca.vertcat(*V_init), p = p_track, lbx = lbw, ubx = ubw, lbg = g_min, ubg = g_max)

# Relax MINLP to NLP, solve with IPOPT
#opts = {"ipopt": {"hessian_approximation": "limited-memory", "linear_solver":"mumps"}}
opts = {"ipopt": {"hessian_approximation": "limited-memory", "linear_solver":"ma97"}}
solver = ca.nlpsol('solver','ipopt',nlp,opts)
solution = solver(x0 = ca.vertcat(*V_init), p = p_track, lbx = lbw, ubx = ubw, lbg = g_min, ubg = g_max)

print(solution)


# <codecell>

# Plot the solution. TO DO: need to be checked, this plotting block is a verbatim copy of Andrian code before

V_opt = solution["x"]

pl.figure()

for k in range(N_s):
    pl.plot(time_points, V_opt[k::N_s+2], label = "T_s_" + str(k))

pl.title("Simulation with optimized controls")
pl.ylabel("Temperature (deg C)")
pl.xlabel("Time (s)")
pl.legend(loc = "best")
pl.show()


# Controls, massflows, CHP outlet temperature

T_in_CHP_opt = pl.array([V_opt[N_s-1::N_s+2][k] for k in range(N)])
status_CHP_opt = pl.array([V_opt[N_s::N_s+2][k] for k in range(N)])

CHP_on = ca.MX.sym("CHP_on")
T_in_CHP = ca.MX.sym("T_in_CHP")
f_mdot = ca.Function("f_mdot", [CHP_on, T_in_CHP], \
    [CHP_on * ((p_CHP[0] + p_CHP[1] * T_in_CHP + p_CHP[2] * T_in_CHP) / 3.6)])

mdot_eval = []

for k in range(N):
    mdot_eval.append(f_mdot(status_CHP_opt[k], T_in_CHP_opt[k]))

mdot_eval = ca.vertcat(*mdot_eval)

pl.figure()
pl.subplot(2, 1, 1)
pl.title("Optimized controls and resulting mass flow")
pl.step(time_points[:-1], status_CHP_opt, label = "Status CHP opt")
pl.ylim(-0.2, 1.2)
pl.ylabel("Status CHP (on/off)")
pl.xlabel("Time (s)")
pl.legend(loc = "best")
pl.subplot(2, 1, 2)
pl.plot(time_points[:-1], mdot_eval, label = "mdot opt")
pl.ylim(-0.05, 0.3)
pl.ylabel("Mass flow (kg/s)")
pl.xlabel("Time (s)")
pl.legend(loc = "best")
pl.show()

# <codecell>

V

# <codecell>


