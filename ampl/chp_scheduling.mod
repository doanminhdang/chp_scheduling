#You have 3432 variables, 3570 constraints, and 1 objective.
# of which: 48 inequalities for p_grid_item
# Hence: 3522 equality constraints vs. 3432 variables!


reset;

param N := 24; # steps

#param c_elec_buy{1..24};
#param c_elec_sell{1..24};

param Cel{1..24,1..2}; #Cel = [c_elec_buy c_elec_sell]

param Pel_CHP_Feed := 5.3; #(unit = "kW") = 5.3 "Electrical Power ouput in [kW]";
param Pel_CHP := 0.14; #kW CHP consumption when working
param Pel_ADCM := 0.23; #kW ADCM consumption when working
param Pel_RevHP_HP := 3.6; #kW RevHP_HP1 consumption when working
param Pel_RevHP_CC := 3.6; #kW RevHP_CC1 consumption when working
param Pel_OC1 := 1.32; #kW OC1 consumption when working
param Pel_OC2 := 1.32; #kW OC2 consumption when working
param Pel_OC_RevHP := 1.32; #kW OC3 (attached with RevHP) consumption when working

#Model of CHP

#  //============ Parameters CHP =====================
  param cHPUnit1__CHP_H_W_PT_M := 9.630000000000001; #(unit = "kW") = 9.630000000000001 "Thermal Power [kW]";
  param cHPUnit1__CHP_H_W_PE_M := 5.3; #(unit = "kW") = 5.3 "Electrical Power ouput in [kW]";
  param cHPUnit1__CHP_etha_Thermal := 0.59; #(unit = "1") = 0.59 "Thermal efficiency";
  param cHPUnit1__CHP_etha_Electrical := 0.3; #(unit = "1") = 0.3 "Electrical efficiency";
  param cHPUnit1__CHP_Fuel_HHV := 12.66; #(unit = "kW.h/kg") = 12.66 "Energy Fuel [kW.h/kg]";
# in optimization, this ON/OFF command become variable
#  param cHPUnit1__CHP_ON := 1; #(unit = "1") = 1.0 "CHP On/Off";

#  //============ Constants CHP =======================
  param cHPUnit1__rho_water := 985.0; #(quantity = "Density", unit = "kg/m3", displayUnit = "g/cm3", min = 0.0) = 985.0 "Water density [kg/m3]";
  param cHPUnit1__rho_fuel := 853.5; #(quantity = "Density", unit = "kg/m3", displayUnit = "g/cm3", min = 0.0) = 853.5 "Fuel density [kg/m3]";

#  //=============== Variables of the CHP ========================
  var cHPUnit1__CHP_ON{1..24} binary; #(unit = "1") = 1.0 "CHP On/Off";

  var cHPUnit1__CHP_H_W_MF_M{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Water mass flow out of the CHP [kg/s]";
  var cHPUnit1__CHP_H_W_PT{1..24}; #(unit = "kW") "Power Calculation Variable [kW]";
  var cHPUnit1__CHP_H_F_VF_M{1..24}; #(unit = "m3/h") "Fuel consumption of the CHP [m3/h]";
  var cHPUnit1__CHP_H_W_VF_M{1..24}; #(unit = "m3/h") "Water volume Flow Rate [m3/h]";
  var cHPUnit1__CHP_H_W_T_M_FL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Water temperature at the exit of CHP in [degC]";
  var cHPUnit1__CHP_H_W_T_M_RL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature of the return water to the CHP[degC]";
  var cHPUnit1__CHP_H_W_T_M_FL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0) "Water temperature at the exit of CHP in [K]";
  var cHPUnit1__CHP_H_W_T_M_RL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0) "Temperature of the return water to the CHP[K]";
  var cHPUnit1__cpw{1..24}; #(unit = "kJ/(kg.K)") "Specific heat transfer coefficient of water [kJ/(kg.K)]";
  var cHPUnit1__CHP_HTES_Out__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var cHPUnit1__CHP_HTES_Out__m_dot{1..24}; #(quantity = "MassFlowRate", unit = "kg/s");
  var cHPUnit1__CHP_HTES_In__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  

#Model of adCM

#  //============ Parameters adCM =====================
  param adCM1__set_v_dot_AdCM_LT := 2.0; #(unit = "m3/h") = 2.0 "Set Volume Flow in the LT Circuit going to the CTES [m3/h]";
  param adCM1__set_v_dot_AdCM_MT := 4.1; #(unit = "m3/h") = 4.1 " Set Volume Flow in the MT Circuit going to the OC [m3/h]";
  param adCM1__set_v_dot_AdCM_HT := 1.6; #(unit = "m3/h") = 1.6 "Set Volume Flow in the HT Circuit going to the HTES [m3/h]";
# in optimization, this ON/OFF command become variable
#  param adCM1__AdCM_ON := 1; #(unit = "1") = 1.0 "AdCM ON/OFF";

#  //============ Constants adCM =======================
  param adCM1__cpw := 4.18; #(unit = "kJ/(kg.K)") = 4.18 "Specific heat transfer coefficient of water [kJ/(kg.K)]";
  param adCM1__rho_water := 985.0; #(quantity = "Density", unit = "kg/m3", displayUnit = "g/cm3", min = 0.0) = 985.0 "Water density [kg/m3]";

#  //=============== Variables of the adCM ========================
  var adCM1__AdCM_ON{1..24} binary; #(unit = "1") = 1.0 "AdCM ON/OFF";

  var adCM1__T_AdCM_LT_RL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Feed Temperature going to the CTES [C]";
  var adCM1__T_AdCM_MT_RL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Medium Temperature Circuit - Cooling Water Coming Back from OC[degC]";
  var adCM1__T_AdCM_HT_RL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "High Temperature Circuit - Hot Water going to HTES[degC]";
  var adCM1__T_AdCM_LT_RL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0) "Low Temperature Circuit - Chilled Water[K]";
  var adCM1__T_AdCM_MT_RL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0) "Medium Temperature Circuit - Cooling Water[K]";
  var adCM1__T_AdCM_HT_RL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0) "High Temperature Circuit - Hot Water[K]";
  var adCM1__T_AdCM_MT_FL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0) "Feed Temperature going to the Outdoor Coil [K]";
  var adCM1__T_AdCM_LT_FL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0) "Feed Temperature coming from the CTES [K]";
  var adCM1__T_AdCM_HT_FL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0) "Feed Temperature coming from the HTES [K]";
  var adCM1__T_AdCM_MT_FL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Feed Temperature going to the Outdoor Coil [C]";
  var adCM1__T_AdCM_LT_FL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Low Temperature Circuit - Chilled Water coming back from CTES[degC]";
  var adCM1__T_AdCM_HT_FL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Feed Temperature coming from the HTES [C]";
  var adCM1__COP{1..24}; #(unit = "1") "Coeficient of Performance";
  var adCM1__CC{1..24}; #(unit = "kW") "Cooling Capacity [KW]";
  var adCM1__m_dot_AdCM_HT{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Mass Flow Rate taht goes to the HTES [kg/s]";
  var adCM1__m_dot_AdCM_LT{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Mass Flow Rate that goes to the CTES [kg/s]";
  var adCM1__m_dot_AdCM_MT{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Mass Flow Rate that goes to the OC [kg/s]";
  var adCM1__P_th_HT{1..24}; #(unit = "kW") "Power Thermal in HT circuit [kW]";
  var adCM1__P_th_MT{1..24}; #(unit = "kW") "Power Thermal in MT circuit [kW]";
  var adCM1__v_dot_AdCM_LT{1..24}; #(unit = "m3/h") "Volume Flow in the LT Circuit going to the CTES [m3/h]";
  var adCM1__v_dot_AdCM_MT{1..24}; #(unit = "m3/h") "Volume Flow in the MT Circuit going to the OC [m3/h]";
  var adCM1__v_dot_AdCM_HT{1..24}; #(unit = "m3/h") "Volume Flow in the HT Circuit going to the HTES [m3/h]";
  var adCM1__AdCM_CTES_Out__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var adCM1__AdCM_CTES_Out__m_dot{1..24}; #(quantity = "MassFlowRate", unit = "kg/s");
  var adCM1__AdCM_OC_In__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var adCM1__AdCM_CTES_In__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var adCM1__AdCM_HTES_Out__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var adCM1__AdCM_HTES_Out__m_dot{1..24}; #(quantity = "MassFlowRate", unit = "kg/s");
  var adCM1__AdCM_HTES_In__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var adCM1__AdCM_OC_Out__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var adCM1__AdCM_OC_Out__m_dot{1..24}; #(quantity = "MassFlowRate", unit = "kg/s");

#Model of lOAD1 - heating load

#  //============ Parameters lOAD1 =====================
  param lOAD1__Pth_CC{1..24}; #(unit = "kW") = 0.0 "Thermal Power of the LOAD";
  ### Heating load data is a series of 24 hour from Pth(kW) Heating
  ### Later in this model, it is input from ThermalLoad.dat  

  param lOAD1__delta_T_CC := 0.0; #(quantity = "ThermodynamicTemperature", unit = "degC") = 0.0 "Temperature difference between T_FL_CC and T_RL_CC";
  param lOAD1__T_CC_FL := 0.0; #(quantity = "ThermodynamicTemperature", unit = "degC") = 0.0 " Temeprature going to Climate Chamber";

#  //============ Constants lOAD1 =======================
  param lOAD1__rho_water := 985.0; #(quantity = "Density", unit = "kg/m3", displayUnit = "g/cm3", min = 0.0) = 985.0 "Water density [kg/m3]";

#  //=============== Variables of the lOAD1 ========================
  var lOAD1__T_LOAD_FL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temp from tank to 3-MV = HTES_6";
  var lOAD1__T_LOAD_RL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temp from 3-MV back to Tank, is the same as temp. coming back from climate chamber = T_CC_RL";
  var lOAD1__T_CC_RL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var lOAD1__T_LOAD_FL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var lOAD1__T_CC_RL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var lOAD1__cpw{1..24}; #(unit = "kJ/(kg.K)");
  var lOAD1__m_dot_LOAD{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Mass Flow going to the LOAD [kg/s]";
  var lOAD1__v_dot_LOAD{1..24}; #(unit = "m3/h") "Volume Flow going to the LOAD [m3/h]";
  var lOAD1__LOAD_In__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var lOAD1__LOAD_Out__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var lOAD1__LOAD_Out__m_dot{1..24}; #(quantity = "MassFlowRate", unit = "kg/s");

#Model of cTES1

#  //============ Parameters cTES1 =====================
  param cTES11__T_ini := 35.0; #(quantity = "ThermodynamicTemperature", unit = "degC") = 35.0 "Initial temperature of the tank [degC]";
  param cTES11__T_amb := 35.0; #(quantity = "ThermodynamicTemperature", unit = "degC") = 35.0 "Ambient temperature [degC]";
  param cTES11__zi := 0.55; #(quantity = "Length", unit = "m") = 0.55 "Height of tank / Number of Layers";
  param cTES11__Alayer := 0.746; #(quantity = "Area", unit = "m2") = 0.746 "Cross section of the respective layer in contact with above or below layer[m2]/   Considering Actual Diameter of Tank - 2*Thickness  = 1m - 2*0,0125m";
  param cTES11__Aamb := 1.684; #(quantity = "Area", unit = "m2") = 1.684 "Cross Section of the respective layer in contact with tank surface and transfering heat to ambient [m2] ,2*pi*r*L ";
  param cTES11__mi := 404.48; #(quantity = "Mass", unit = "kg", min = 0.0) = 404.48 "Water mass in the control volume [kg]. Pi*r²*L*rho water";
  param cTES11__kappa := 0.0005; #(unit = "kW/(K.m2)") = 0.0005 "Heat transfer coefficient of storage walls[kW/(m2.K)], depends on tank and insulation material";
  param cTES11__lambda_eff := 0.0015; #(unit = "kW/(m.K)") = 0.0015 "Effective vertical heat conductivity considering thermal conduction and convection [kW/(m.K)], Eicker Book/Paper";

#  //============ Constants cTES1 =======================

#  //=============== Variables of the cTES1 ========================
  var cTES11__T_CTES_AdCM_In{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature coming from the AdCM [degC]";
  var cTES11__T_CTES_RevHP_In{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature coming from the RevHP [degC]";
  var cTES11__CTES_H_W_T_M_IT_1{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature in the 1st layer (bottom Layer) [degC]";
  var cTES11__CTES_H_W_T_M_IT_2{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature in the 2nd layer [degC]";
  var cTES11__CTES_H_W_T_M_IT_3{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature in the 3rd layer [degC]";
  var cTES11__CTES_H_W_T_M_IT_4{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature in the 4th layer (top layer)[degC]";
  var cTES11__T_CTES_LOAD_RL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature coming back from the LOAD [degC]";
  var cTES11__T_ini_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var cTES11__T_amb_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var cTES11__T_CTES_AdCM_In_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var cTES11__T_CTES_RevHP_In_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var cTES11__CTES_H_W_T_M_IT_1_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var cTES11__CTES_H_W_T_M_IT_2_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var cTES11__CTES_H_W_T_M_IT_3_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var cTES11__CTES_H_W_T_M_IT_4_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var cTES11__T_CTES_LOAD_RL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var cTES11__m_dot1{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Mass Flow from Layer 1 (Bottom Layer)to Layer 2 [kg/s]";
  var cTES11__m_dot_AdCM{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Mass Flow at the entrance of the CTES (Bottom Layer) [kg/s]";
  var cTES11__m_dot_RevHP{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Mass Flow at the entrance of the CTES (Bottom Layer) [kg/s]";
  var cTES11__m_dot2{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Mass Flow from Layer 2 to Layer 3 [kg/s]";
  var cTES11__m_dot3{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Mass Flow from Layer 3 to Layer 4 [kg/s]";
  var cTES11__m_dot4{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Total mass flow at the exit of the CTES (Top Layer) [kg/s]";
  var cTES11__m_dot_LOAD{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Mass Flow going to the LOAD [kg/s]";
  var cTES11__cp1{1..24}; #(unit = "kJ/(kg.K)");
  var cTES11__cp2{1..24}; #(unit = "kJ/(kg.K)");
  var cTES11__cp3{1..24}; #(unit = "kJ/(kg.K)");
  var cTES11__cp4{1..24}; #(unit = "kJ/(kg.K)");
  var cTES11__CTES_AdCM_In__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var cTES11__CTES_AdCM_In__m_dot{1..24}; #(quantity = "MassFlowRate", unit = "kg/s");
  var cTES11__CTES_LOAD_In__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var cTES11__CTES_LOAD_In__m_dot{1..24}; #(quantity = "MassFlowRate", unit = "kg/s");
  var cTES11__CTES_AdCM_Out__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var cTES11__CTES_LOAD_Out__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var cTES11__CTES_RevHP_In__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var cTES11__CTES_RevHP_In__m_dot{1..24}; #(quantity = "MassFlowRate", unit = "kg/s");
  var cTES11__CTES_RevHP_Out__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");

#Model of revHP_HP1

#  //============ Parameters revHP_HP1 =====================
  param revHP_HP1__set_v_dot_HT_FL := 2.4; #(unit = "m3/h") = 2.4 "Volume Flow Rate from the RevHP to the Cold Storage Tank [m3/h]";
  param revHP_HP1__set_v_dot_MT_FL := 2.6; #(unit = "m3/h") = 2.6 "Volume Flow Rate from the RevHP to the Outdoor Coil [m3/h]";
# in optimization, this ON/OFF command become variable
#  param revHP_HP1__RevHP_HP_ON := 1; #(unit = "1") = 1.0 "RevHP_HP On/Off";

#  //============ Constants revHP_HP1 =======================
  param revHP_HP1__cpw := 4.18; #(unit = "kJ/(kg.K)") = 4.18 "Specific heat treansfer coefficient of water [kJ/(kg.K)]";
  param revHP_HP1__rho_water := 985.0; #(quantity = "Density", unit = "kg/m3", displayUnit = "g/cm3", min = 0.0) = 985.0 "Water density [kg/m3]";

#  //=============== Variables of the revHP_HP1 ========================
  var revHP_HP1__RevHP_HP_ON{1..24} binary; #(unit = "1") = 1.0 "RevHP_HP On/Off";

  var revHP_HP1__T_RevHP_HT_FL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "LWC";
  var revHP_HP1__T_RevHP_MT_FL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "LWE";
  var revHP_HP1__T_RevHP_HT_RL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var revHP_HP1__T_RevHP_MT_RL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var revHP_HP1__T_RevHP_HT_FL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var revHP_HP1__T_RevHP_MT_FL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var revHP_HP1__T_RevHP_HT_RL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var revHP_HP1__T_RevHP_MT_RL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var revHP_HP1__m_dot_HT_FL{1..24}; #(quantity = "MassFlowRate", unit = "kg/s");
  var revHP_HP1__m_dot_MT_FL{1..24}; #(quantity = "MassFlowRate", unit = "kg/s");
  var revHP_HP1__v_dot_HT_FL{1..24}; #(unit = "m3/h");
  var revHP_HP1__v_dot_MT_FL{1..24}; #(unit = "m3/h");
  var revHP_HP1__COPel{1..24}; #(unit = "1");
  var revHP_HP1__HC{1..24}; #(unit = "kW");
  var revHP_HP1__P_th_MT{1..24}; #(unit = "kW");
  var revHP_HP1__PI{1..24}; #(unit = "kW");
  var revHP_HP1__Range_RevHP_HP{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0) "Temperature difference in OC Circuit [K]";
  var revHP_HP1__RevHP_HTES_Out__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var revHP_HP1__RevHP_HTES_Out__m_dot{1..24}; #(quantity = "MassFlowRate", unit = "kg/s");
  var revHP_HP1__RevHP_OC_In__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var revHP_HP1__RevHP_HTES_In__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var revHP_HP1__RevHP_OC_Out__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var revHP_HP1__RevHP_OC_Out__m_dot{1..24}; #(quantity = "MassFlowRate", unit = "kg/s");

#Model of revHP_CC_Equation1

#  //============ Parameters revHP_CC_Equation1 =====================
  param revHP_CC_Equation1__set_v_dot_LT_FL := 2.4; #(unit = "m3/h") = 2.4 "Volume Flow Rate from the RevHP to the Cold Storage Tank [m3/h]";
  param revHP_CC_Equation1__set_v_dot_MT_FL := 2.6; #(unit = "m3/h") = 2.6 "Volume Flow Rate from the RevHP to the Outdoor Coil [m3/h]";
# in optimization, this ON/OFF command become variable
#  param revHP_CC_Equation1__RevHP_CC_ON := 1; #(unit = "1") = 1.0 "RevHP_CC On/Off";

#  //============ Constants revHP_CC_Equation1 =======================
  param revHP_CC_Equation1__cpw := 4.18; #(unit = "kJ/(kg.K)") = 4.18 "Specific heat transfer coefficient of water [kJ/(kg.K)]";
  param revHP_CC_Equation1__rho_water := 985.0; #(quantity = "Density", unit = "kg/m3", displayUnit = "g/cm3", min = 0.0) = 985.0 "Water density [kg/m3]";

#  //=============== Variables of the revHP_CC_Equation1 ========================
  var revHP_CC_Equation1__RevHP_CC_ON{1..24} binary; #(unit = "1") = 1.0 "RevHP_CC On/Off";

  var revHP_CC_Equation1__T_RevHP_LT_FL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temp. going to CTES";
  var revHP_CC_Equation1__T_RevHP_MT_FL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temp. going to OC";
  var revHP_CC_Equation1__T_RevHP_LT_RL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var revHP_CC_Equation1__T_RevHP_MT_RL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var revHP_CC_Equation1__T_RevHP_LT_FL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var revHP_CC_Equation1__T_RevHP_MT_FL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var revHP_CC_Equation1__T_RevHP_LT_RL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var revHP_CC_Equation1__T_RevHP_MT_RL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var revHP_CC_Equation1__m_dot_LT_FL{1..24}; #(quantity = "MassFlowRate", unit = "kg/s");
  var revHP_CC_Equation1__m_dot_MT_FL{1..24}; #(quantity = "MassFlowRate", unit = "kg/s");
  var revHP_CC_Equation1__P_th_MT{1..24}; #(unit = "kW");
  var revHP_CC_Equation1__CC{1..24}; #(unit = "kW");
  var revHP_CC_Equation1__PI{1..24}; #(unit = "kW");
  var revHP_CC_Equation1__COPel{1..24}; #(unit = "1");
  var revHP_CC_Equation1__v_dot_LT_FL{1..24}; #(unit = "m3/h");
  var revHP_CC_Equation1__v_dot_MT_FL{1..24}; #(unit = "m3/h");
  var revHP_CC_Equation1__Range_RevHP_CC{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0) "Temperature difference [K]";
  var revHP_CC_Equation1__RevHP_CTES_Out__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var revHP_CC_Equation1__RevHP_CTES_Out__m_dot{1..24}; #(quantity = "MassFlowRate", unit = "kg/s");
  var revHP_CC_Equation1__RevHP_CTES_In__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var revHP_CC_Equation1__RevHP_OC_In__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var revHP_CC_Equation1__RevHP_OC_Out__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var revHP_CC_Equation1__RevHP_OC_Out__m_dot{1..24}; #(quantity = "MassFlowRate", unit = "kg/s");

#Model of outdoorCoil_Equation1

#  //============ Parameters outdoorCoil_Equation1 =====================
  param outdoorCoil_Equation1__T_amb := 35.0; #(quantity = "ThermodynamicTemperature", unit = "degC") = 35.0 "ambient temperature [degC]";
  param outdoorCoil_Equation1__Volt := 10.0; #(quantity = "ElectricPotential", unit = "V") = 10.0 "Voltage input of the OC [V]";
# in optimization, this ON/OFF command become variable
#  param outdoorCoil_Equation1__OC_ON := 1; #(unit = "1") = 1.0;

#  //============ Constants outdoorCoil_Equation1 =======================
  param outdoorCoil_Equation1__cpw := 4.18; #(unit = "kJ/(kg.K)") = 4.18 "Specific heat transfer coefficient of water [kJ/(kg.K)]";
  param outdoorCoil_Equation1__rho_water := 985.0; #(quantity = "Density", unit = "kg/m3", displayUnit = "g/cm3", min = 0.0) = 985.0 "Water density [kg/m3]";

#  //=============== Variables of the outdoorCoil_Equation1 ========================
  var outdoorCoil_Equation1__OC_ON{1..24} binary; #(unit = "1") = 1.0;

  var outdoorCoil_Equation1__Pth_OC{1..24}; #(unit = "kW") "Thermal power that comes from the AdCM/Rev_HP [kW]";
  var outdoorCoil_Equation1__m_dot_OC{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Mass Flow rate that goes and comes to the AdCM/Rev_HP [kg/s]";
  var outdoorCoil_Equation1__T_OC_MT_FL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature that goes to the AdCM/Rev_HP [degC]";
  var outdoorCoil_Equation1__T_OC_MT_RL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature that comes from the AdCM/Rev_HP [degC]";
  var outdoorCoil_Equation1__T_OC_MT_FL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0) "Temperature that goes to the AdCM/Rev_HP [K]";
  var outdoorCoil_Equation1__T_OC_MT_RL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0) "Temperature that comes frome the AdCM/Rev_HP [K]";
  var outdoorCoil_Equation1__Range{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0) "Difference between in and out temperature [K]";
  var outdoorCoil_Equation1__v_dot_OC{1..24}; #(unit = "m3/h") "Volume Flow in OC Circuit [m³/h]";
  var outdoorCoil_Equation1__OC_Out__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var outdoorCoil_Equation1__OC_In__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var outdoorCoil_Equation1__OC_In__m_dot{1..24}; #(quantity = "MassFlowRate", unit = "kg/s");

#Model of outdoorCoil_Equation2

#  //============ Parameters outdoorCoil_Equation2 =====================
  param outdoorCoil_Equation2__T_amb := 35.0; #(quantity = "ThermodynamicTemperature", unit = "degC") = 35.0 "ambient temperature [degC]";
  param outdoorCoil_Equation2__Volt := 10.0; #(quantity = "ElectricPotential", unit = "V") = 10.0 "Voltage input of the OC [V]";
# in optimization, this ON/OFF command become variable
#  param outdoorCoil_Equation2__OC_ON := 1; #(unit = "1") = 1.0;

#  //============ Constants outdoorCoil_Equation2 =======================
  param outdoorCoil_Equation2__cpw := 4.18; #(unit = "kJ/(kg.K)") = 4.18 "Specific heat transfer coefficient of water [kJ/(kg.K)]";
  param outdoorCoil_Equation2__rho_water := 985.0; #(quantity = "Density", unit = "kg/m3", displayUnit = "g/cm3", min = 0.0) = 985.0 "Water density [kg/m3]";

#  //=============== Variables of the outdoorCoil_Equation2 ========================
  var outdoorCoil_Equation2__OC_ON{1..24} binary; #(unit = "1") = 1.0;

  var outdoorCoil_Equation2__Pth_OC{1..24}; #(unit = "kW") "Thermal power that comes from the AdCM/Rev_HP [kW]";
  var outdoorCoil_Equation2__m_dot_OC{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Mass Flow rate that goes and comes to the AdCM/Rev_HP [kg/s]";
  var outdoorCoil_Equation2__T_OC_MT_FL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature that goes to the AdCM/Rev_HP [degC]";
  var outdoorCoil_Equation2__T_OC_MT_RL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature that comes from the AdCM/Rev_HP [degC]";
  var outdoorCoil_Equation2__T_OC_MT_FL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0) "Temperature that goes to the AdCM/Rev_HP [K]";
  var outdoorCoil_Equation2__T_OC_MT_RL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0) "Temperature that comes frome the AdCM/Rev_HP [K]";
  var outdoorCoil_Equation2__Range{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0) "Difference between in and out temperature [K]";
  var outdoorCoil_Equation2__v_dot_OC{1..24}; #(unit = "m3/h") "Volume Flow in OC Circuit [m³/h]";
  var outdoorCoil_Equation2__OC_Out__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var outdoorCoil_Equation2__OC_In__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var outdoorCoil_Equation2__OC_In__m_dot{1..24}; #(quantity = "MassFlowRate", unit = "kg/s");

#Model of OutdoorCoil_RevHP

#  //============ Parameters OutdoorCoil_RevHP =====================
  param OutdoorCoil_RevHP__T_amb := 35.0; #(quantity = "ThermodynamicTemperature", unit = "degC") = 35.0 "ambient temperature [degC]";
  param OutdoorCoil_RevHP__Volt := 10.0; #(quantity = "ElectricPotential", unit = "V") = 10.0 "Voltage input of the OC [V]";
# in optimization, this ON/OFF command become variable
#  param OutdoorCoil_RevHP__OC_ON := 1; #(unit = "1") = 1.0;

#  //============ Constants OutdoorCoil_RevHP =======================
  param OutdoorCoil_RevHP__cpw := 4.18; #(unit = "kJ/(kg.K)") = 4.18 "Specific heat transfer coefficient of water [kJ/(kg.K)]";
  param OutdoorCoil_RevHP__rho_water := 985.0; #(quantity = "Density", unit = "kg/m3", displayUnit = "g/cm3", min = 0.0) = 985.0 "Water density [kg/m3]";

#  //=============== Variables of the OutdoorCoil_RevHP ========================
  var OutdoorCoil_RevHP__OC_ON{1..24} binary; #(unit = "1") = 1.0;

  var OutdoorCoil_RevHP__Pth_OC{1..24}; #(unit = "kW") "Thermal power that comes from the AdCM/Rev_HP [kW]";
  var OutdoorCoil_RevHP__m_dot_OC{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Mass Flow rate that goes and comes to the AdCM/Rev_HP [kg/s]";
  var OutdoorCoil_RevHP__T_OC_MT_FL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature that goes to the AdCM/Rev_HP [degC]";
  var OutdoorCoil_RevHP__T_OC_MT_RL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature that comes from the AdCM/Rev_HP [degC]";
  var OutdoorCoil_RevHP__T_OC_MT_FL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0) "Temperature that goes to the AdCM/Rev_HP [K]";
  var OutdoorCoil_RevHP__T_OC_MT_RL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0) "Temperature that comes frome the AdCM/Rev_HP [K]";
  var OutdoorCoil_RevHP__Range{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0) "Difference between in and out temperature [K]";
  var OutdoorCoil_RevHP__v_dot_OC{1..24}; #(unit = "m3/h") "Volume Flow in OC Circuit [m³/h]";
  var OutdoorCoil_RevHP__OC_Out__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var OutdoorCoil_RevHP__OC_In__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var OutdoorCoil_RevHP__OC_In__m_dot{1..24}; #(quantity = "MassFlowRate", unit = "kg/s");

#Model of lOAD_C1 - cooling load

#  //============ Parameters lOAD_C1 =====================
  param lOAD_C1__Pth_CC{1..24}; #(unit = "kW") = 0.0 "Thermal Power of the LOAD";
  ### Cooling load data is a series of 24 hour from Pth(kW) Cooling
  ### Later in this model, it is input from CoolingLoad.dat  
  
  param lOAD_C1__delta_T_CC := 0.0; #(quantity = "ThermodynamicTemperature", unit = "degC") = 0.0 "Temperature difference between T_FL_CC and T_RL_CC, to be given as Magnitude";
  param lOAD_C1__T_CC_FL := 0.0; #(quantity = "ThermodynamicTemperature", unit = "degC") = 0.0 " Temeprature going to Climate Chamber";

#  //============ Constants lOAD_C1 =======================
  param lOAD_C1__rho_water := 985.0; #(quantity = "Density", unit = "kg/m3", displayUnit = "g/cm3", min = 0.0) = 985.0 "Water density [kg/m3]";

#  //=============== Variables of the lOAD_C1 ========================
  var lOAD_C1__T_LOAD_FL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temp from tank to 3-MV = CTES_1";
  var lOAD_C1__T_LOAD_RL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temp from 3-MV back to Tank, is the same as temp. coming back from climate chamber = T_CC_RL";
  var lOAD_C1__T_CC_RL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var lOAD_C1__T_LOAD_FL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var lOAD_C1__T_CC_RL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var lOAD_C1__cpw{1..24}; #(unit = "kJ/(kg.K)");
  var lOAD_C1__m_dot_LOAD{1..24}; #(quantity = "MassFlowRate", unit = "kg/s");
  var lOAD_C1__v_dot_LOAD{1..24}; #(unit = "m3/h") "Volume Flow going to the LOAD [m3/h]";
  var lOAD_C1__LOAD_In__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var lOAD_C1__LOAD_Out__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var lOAD_C1__LOAD_Out__m_dot{1..24}; #(quantity = "MassFlowRate", unit = "kg/s");

#Model of hTES1

#  //============ Parameters hTES1 =====================
  param hTES1__T_ini := 35.0; #(quantity = "ThermodynamicTemperature", unit = "degC") = 35.0 "Initial temperature of the tank [degC]";
  param hTES1__T_amb := 35.0; #(quantity = "ThermodynamicTemperature", unit = "degC") = 35.0 "Ambient temperature [degC]";
  param hTES1__zi := 0.244; #(quantity = "Length", unit = "m") = 0.244 "Height of tank / Number of Layers";
  param hTES1__Alayer := 0.746; #(quantity = "Area", unit = "m2") = 0.746 "Cross section of the respective layer in contact with above or below layer[m2]/   Considering Actual Diameter of Tank - 2*Thickness  = 1m - 2*0,0125m";
  param hTES1__Aamb := 0.747; #(quantity = "Area", unit = "m2") = 0.747 "Cross Section of the respective layer in contact with tank surface and transfering heat to ambient [m2] ,2*pi*r*zi ";
  param hTES1__mi := 179.44; #(quantity = "Mass", unit = "kg", min = 0.0) = 179.44 "Water mass in the control volume [kg]. Pi*r²*zi*rho water";
  param hTES1__kappa := 0.0005; #(unit = "kW/(K.m2)") = 0.0005 "Heat transfer coefficient of storage walls[kW/(m2.K)], depends on tank and insulation material";
  param hTES1__lambda_eff := 0.0015; #(unit = "kW/(m.K)") = 0.0015 "Effective vertical heat conductivity considering thermal conduction and convection [kW/(m.K)], Eicker Book/Paper";

#  //============ Constants hTES1 =======================

#  //=============== Variables of the hTES1 ========================
  var hTES1__T_HTES_CHP_In{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature coming from the CHP [degC]";
  var hTES1__T_HTES_RevHP_In{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature coming from the RevHP [degC]";
  var hTES1__HTES_H_W_T_M_IT_1{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature in the 1st layer (bottom Layer) [degC]";
  var hTES1__HTES_H_W_T_M_IT_2{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature in the 2nd layer [degC]";
  var hTES1__HTES_H_W_T_M_IT_3{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature in the 3rd layer [degC]";
  var hTES1__HTES_H_W_T_M_IT_4{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature in the 4th layer [degC]";
  var hTES1__HTES_H_W_T_M_IT_5{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature in the 5th layer [degC]";
  var hTES1__HTES_H_W_T_M_IT_6{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature in the 6th layer [degC]";
  var hTES1__HTES_H_W_T_M_IT_7{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature in the 7th layer [degC]";
  var hTES1__HTES_H_W_T_M_IT_8{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature in the 8th layer [degC]";
  var hTES1__HTES_H_W_T_M_IT_9{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature in the 9th layer (top layer) [degC]";
  var hTES1__T_HTES_LOAD_RL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature coming back from the LOAD [degC]";
  var hTES1__T_HTES_AdCM_RL{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC") "Temperature coming back from the AdCM[degC]";
  var hTES1__T_ini_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var hTES1__T_amb_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var hTES1__T_HTES_CHP_In_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0) "Temperature coming from the CHP [degC]";
  var hTES1__T_HTES_RevHP_In_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0) "Temperature coming from the RevHP [degC]";
  var hTES1__HTES_H_W_T_M_IT_1_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var hTES1__HTES_H_W_T_M_IT_2_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var hTES1__HTES_H_W_T_M_IT_3_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var hTES1__HTES_H_W_T_M_IT_4_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var hTES1__HTES_H_W_T_M_IT_5_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var hTES1__HTES_H_W_T_M_IT_6_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var hTES1__HTES_H_W_T_M_IT_7_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var hTES1__HTES_H_W_T_M_IT_8_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var hTES1__HTES_H_W_T_M_IT_9_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var hTES1__T_HTES_LOAD_RL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var hTES1__T_HTES_AdCM_RL_K{1..24}; #(quantity = "ThermodynamicTemperature", unit = "K", displayUnit = "degC", min = 0.0, start = 288.15, nominal = 300.0);
  var hTES1__m_dot1{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Total Mass Flow at the exit of the HTES";
  var hTES1__m_dot2{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Mass flow from layer 2 to layer 1 of the HTES";
  var hTES1__m_dot3{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Mass flow from layer 3 to layer 2 of the HTES";
  var hTES1__m_dot4{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Mass flow from layer 4 to layer 3 of the HTES";
  var hTES1__m_dot5{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Mass flow from layer 5 to layer 4 of the HTES";
  var hTES1__m_dot6{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Mass flow from layer 6 to layer 5 of the HTES";
  var hTES1__m_dot7{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Mass flow from layer 7 to layer 6 of the HTES";
  var hTES1__m_dot8{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Mass flow from layer 8 to layer 7 of the HTES";
  var hTES1__m_dot_CHP{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Mass flow coming from the CHP(Top Layer)";
  var hTES1__m_dot_RevHP_HT{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Mass flow coming from the RevHP(Top Layer)";
  var hTES1__m_dot_LOAD{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Mass Flow in the LOAD Circuit[kg/s]";
  var hTES1__m_dot_AdCM_HT{1..24}; #(quantity = "MassFlowRate", unit = "kg/s") "Mass Flow in the AdCM circuit[kg/s]";
  var hTES1__cp1{1..24}; #(unit = "kJ/(kg.K)");
  var hTES1__cp2{1..24}; #(unit = "kJ/(kg.K)");
  var hTES1__cp3{1..24}; #(unit = "kJ/(kg.K)");
  var hTES1__cp4{1..24}; #(unit = "kJ/(kg.K)");
  var hTES1__cp5{1..24}; #(unit = "kJ/(kg.K)");
  var hTES1__cp6{1..24}; #(unit = "kJ/(kg.K)");
  var hTES1__cp7{1..24}; #(unit = "kJ/(kg.K)");
  var hTES1__cp8{1..24}; #(unit = "kJ/(kg.K)");
  var hTES1__cp9{1..24}; #(unit = "kJ/(kg.K)");
  var hTES1__HTES_CHP_Out__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var hTES1__HTES_CHP_In__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var hTES1__HTES_CHP_In__m_dot{1..24}; #(quantity = "MassFlowRate", unit = "kg/s");
  var hTES1__HTES_LOAD_Out__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var hTES1__HTES_LOAD_In__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var hTES1__HTES_LOAD_In__m_dot{1..24}; #(quantity = "MassFlowRate", unit = "kg/s");
  var hTES1__HTES_AdCM_In__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var hTES1__HTES_AdCM_In__m_dot{1..24}; #(quantity = "MassFlowRate", unit = "kg/s");
  var hTES1__HTES_AdCM_Out__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var hTES1__HTES_RevHP_In__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");
  var hTES1__HTES_RevHP_In__m_dot{1..24}; #(quantity = "MassFlowRate", unit = "kg/s");
  var hTES1__HTES_RevHP_Out__T{1..24}; #(quantity = "ThermodynamicTemperature", unit = "degC");

# TO DO: To be changed
param c_fuel := 10;

param p_load{1..24};

#param q_ther_load{1..24};


data ElectricityPrice.dat;

data ElectricalLoad.dat;

data HeatingLoad.dat;

data CoolingLoad.dat;

#param k_coil := 0.9; #efficiency 90% to transform from power to thermal energy


#var xp{1..N,1..4}; #P_grid, P_fuel, P_chp, p_coil, each for 24 hours
# xp[i,1] == P_grid[i]
# xp[i,2] == P_fuel[i]
# xp[i,3] == P_chp[i]
# xp[i,4] == p_coil[i]

# since P_grid can be plus (buy) or minus (sell to grid), I separate it into two components:
# P_grid = P_grid_buy - P_grid_sell, with both items are positive
# For each time step: p_grid_item = [p_grid_buy p_grid_sell]
var p_grid_item{1..24,1..2} >= 0;

#var xq{1..N,1..3}; #Q_ther_chp, Q_ther_coil, q_ther_tank, each for 24 hours
# xq[i,1] == Q_ther_chp[i]
# xq[i,2] == Q_ther_coil[i]
# xq[i,3] == q_ther_tank[i]

# P_grid: electricity buy from grid
# P_fuel: equivalent to fuel consumped

#var E_tank{1..24} >= 1.7, <= tank_capa_max; # #max capacity of tank
##q_ther_tank = diff(E_tank) = E_tank(t) - E_tank(t-1)

#var s_chp{1..24} binary; # whether the CHP is on or off

#var s_coil{1..24} binary; # whether the coil is on or off

#param P_chp_on := 5;

#param Q_chp_on := 10;

#param p_fuel_on := 10;

#param p_coil_on := 6;

#minimize obj: sum{i in 1..24} ( c_elec_buy*p_grid_buy - c_elec_sell*p_elec_sell + c_fuel*fuel);
# p_grid_sell = max {0, (Pel_CHP_Feed - Pel_CHP)*CHP_ON
#              - Pel_ADCM*ADCM_ON - Pel_RevHP_HP*RevHP_HP_ON
#              - Pel_RevHP_CC*RevHP_CC_ON - Pel_OC1*OC1_ON
#              - Pel_OC2*OC2_ON - Pel_OC_RevHP*OC_RevHP_ON)
#              - p_load}
# p_grid_buy = max {0, -...} if the above sum is negative
# fuel = CHP_ON*cHPUnit1__CHP_H_F_VF_M

minimize obj: sum{i in 1..24} ( Cel[i,1]*p_grid_item[i,1] - Cel[i,2]*p_grid_item[i,2] + c_fuel*cHPUnit1__CHP_H_F_VF_M[i]*cHPUnit1__CHP_ON[i]);

subject to

power_buy{i in 1..24}: p_grid_item[i,1] == -min (0, (Pel_CHP_Feed - Pel_CHP)*cHPUnit1__CHP_ON[i] - Pel_ADCM*adCM1__AdCM_ON[i] - Pel_RevHP_HP*revHP_HP1__RevHP_HP_ON[i] - Pel_RevHP_CC*revHP_CC_Equation1__RevHP_CC_ON[i] - Pel_OC1*outdoorCoil_Equation1__OC_ON[i] - Pel_OC2*outdoorCoil_Equation2__OC_ON[i] - Pel_OC_RevHP*OutdoorCoil_RevHP__OC_ON[i] - p_load[i]);
power_sell{i in 1..24}: p_grid_item[i,2] == max (0, (Pel_CHP_Feed - Pel_CHP)*cHPUnit1__CHP_ON[i] - Pel_ADCM*adCM1__AdCM_ON[i] - Pel_RevHP_HP*revHP_HP1__RevHP_HP_ON[i] - Pel_RevHP_CC*revHP_CC_Equation1__RevHP_CC_ON[i] - Pel_OC1*outdoorCoil_Equation1__OC_ON[i] - Pel_OC2*outdoorCoil_Equation2__OC_ON[i] - Pel_OC_RevHP*OutdoorCoil_RevHP__OC_ON[i] - p_load[i]);

# Constraints from Initial Equations
Init_constraint1{i in 1..24}:  cTES11__CTES_H_W_T_M_IT_1_K[i] == cTES11__T_ini_K[i];
Init_constraint2{i in 1..24}:  cTES11__CTES_H_W_T_M_IT_2_K[i] == cTES11__T_ini_K[i];
Init_constraint3{i in 1..24}:  cTES11__CTES_H_W_T_M_IT_3_K[i] == cTES11__T_ini_K[i];
Init_constraint4{i in 1..24}:  cTES11__CTES_H_W_T_M_IT_4_K[i] == cTES11__T_ini_K[i];
Init_constraint5{i in 1..24}:  hTES1__HTES_H_W_T_M_IT_1_K[i] == hTES1__T_ini_K[i];
Init_constraint6{i in 1..24}:  hTES1__HTES_H_W_T_M_IT_2_K[i] == hTES1__T_ini_K[i];
Init_constraint7{i in 1..24}:  hTES1__HTES_H_W_T_M_IT_3_K[i] == hTES1__T_ini_K[i];
Init_constraint8{i in 1..24}:  hTES1__HTES_H_W_T_M_IT_4_K[i] == hTES1__T_ini_K[i];
Init_constraint9{i in 1..24}:  hTES1__HTES_H_W_T_M_IT_5_K[i] == hTES1__T_ini_K[i];
Init_constraint10{i in 1..24}:  hTES1__HTES_H_W_T_M_IT_6_K[i] == hTES1__T_ini_K[i];
Init_constraint11{i in 1..24}:  hTES1__HTES_H_W_T_M_IT_7_K[i] == hTES1__T_ini_K[i];
Init_constraint12{i in 1..24}:  hTES1__HTES_H_W_T_M_IT_8_K[i] == hTES1__T_ini_K[i];
Init_constraint13{i in 1..24}:  hTES1__HTES_H_W_T_M_IT_9_K[i] == hTES1__T_ini_K[i];
  
# Constraints from model of CHP

#//================== CHP equations =============================
CHP_constraint1{i in 1..24}: cHPUnit1__cpw[i] == 4.20511 + -0.00136578 * cHPUnit1__CHP_H_W_T_M_RL_K[i] + 1.52341e-005 * cHPUnit1__CHP_H_W_T_M_RL_K[i] ^ 2 ;# "Specific heat in kJ/kg.K ...Temperature in K";
CHP_constraint2{i in 1..24}:   cHPUnit1__CHP_H_W_T_M_FL_K[i] == 273.15 + cHPUnit1__CHP_H_W_T_M_FL[i];
CHP_constraint3{i in 1..24}:   cHPUnit1__CHP_H_W_T_M_RL_K[i] == 273.15 + cHPUnit1__CHP_H_W_T_M_RL[i];
CHP_constraint4{i in 1..24}:   cHPUnit1__CHP_H_W_MF_M[i] == 0.2736111111111111 * cHPUnit1__CHP_H_W_VF_M[i] ;# "Volume of water against time [m³/h]";
CHP_constraint5{i in 1..24}:   cHPUnit1__CHP_H_W_T_M_RL[i] == cHPUnit1__CHP_HTES_In__T[i] ;# "Return Temperature that comes from the HTES [degC]";
CHP_constraint6{i in 1..24}:   cHPUnit1__CHP_H_W_T_M_FL[i] == cHPUnit1__CHP_HTES_Out__T[i] ;# "Feed Line temperature that goes to the HTES [degC]";
CHP_constraint7{i in 1..24}:   cHPUnit1__CHP_H_W_MF_M[i] == cHPUnit1__CHP_HTES_Out__m_dot[i] ;# "Mass Flow that goes to the HTES [kg/s]";
CHP_constraint8{i in 1..24}:   cHPUnit1__CHP_ON[i] * cHPUnit1__CHP_H_W_PT[i] == cHPUnit1__CHP_H_W_MF_M[i] * cHPUnit1__cpw[i] * (cHPUnit1__CHP_H_W_T_M_FL_K[i] - cHPUnit1__CHP_H_W_T_M_RL_K[i]);
CHP_constraint9{i in 1..24}:   cHPUnit1__CHP_H_W_T_M_FL[i] == 70.08 + 0.13875 * cHPUnit1__CHP_H_W_T_M_RL[i] + 0.0012 * cHPUnit1__CHP_H_W_T_M_RL[i] ^ 2;
CHP_constraint10{i in 1..24}:   cHPUnit1__CHP_H_F_VF_M[i] == 0.001171646162858817 * (cHPUnit1__CHP_H_W_PE_M + cHPUnit1__CHP_H_W_PT_M) / ((cHPUnit1__CHP_etha_Thermal + cHPUnit1__CHP_etha_Electrical) * cHPUnit1__CHP_Fuel_HHV);
 
#//================== adCM equations =============================
ADCM_constraint1{i in 1..24}:   adCM1__AdCM_HTES_Out__T[i] == adCM1__T_AdCM_HT_RL[i];
ADCM_constraint2{i in 1..24}:   adCM1__AdCM_OC_In__T[i] == adCM1__T_AdCM_MT_RL[i];
ADCM_constraint3{i in 1..24}:   adCM1__AdCM_CTES_Out__T[i] == adCM1__T_AdCM_LT_RL[i];
ADCM_constraint4{i in 1..24}:   adCM1__AdCM_CTES_In__T[i] == adCM1__T_AdCM_LT_FL[i];
ADCM_constraint5{i in 1..24}:   adCM1__AdCM_HTES_In__T[i] == adCM1__T_AdCM_HT_FL[i];
ADCM_constraint6{i in 1..24}:   adCM1__AdCM_OC_Out__T[i] == adCM1__T_AdCM_MT_FL[i];
ADCM_constraint7{i in 1..24}:   adCM1__AdCM_HTES_Out__m_dot[i] == adCM1__m_dot_AdCM_HT[i];
ADCM_constraint8{i in 1..24}:   adCM1__AdCM_CTES_Out__m_dot[i] == adCM1__m_dot_AdCM_LT[i];
ADCM_constraint9{i in 1..24}:   adCM1__AdCM_OC_Out__m_dot[i] == adCM1__m_dot_AdCM_MT[i];
ADCM_constraint10{i in 1..24}:   adCM1__m_dot_AdCM_LT[i] == 0.2736111111111111 * adCM1__v_dot_AdCM_LT[i];
ADCM_constraint11{i in 1..24}:   adCM1__m_dot_AdCM_MT[i] == 0.2736111111111111 * adCM1__v_dot_AdCM_MT[i];
ADCM_constraint12{i in 1..24}:   adCM1__m_dot_AdCM_HT[i] == 0.2736111111111111 * adCM1__v_dot_AdCM_HT[i];
ADCM_constraint13{i in 1..24}:   adCM1__T_AdCM_HT_RL_K[i] == 273.15 + adCM1__T_AdCM_HT_RL[i];
ADCM_constraint14{i in 1..24}:   adCM1__T_AdCM_LT_RL_K[i] == 273.15 + adCM1__T_AdCM_LT_RL[i];
ADCM_constraint15{i in 1..24}:   adCM1__T_AdCM_MT_RL_K[i] == 273.15 + adCM1__T_AdCM_MT_RL[i];
ADCM_constraint16{i in 1..24}:   adCM1__T_AdCM_MT_FL_K[i] == 273.15 + adCM1__T_AdCM_MT_FL[i];
ADCM_constraint17{i in 1..24}:   adCM1__T_AdCM_LT_FL_K[i] == 273.15 + adCM1__T_AdCM_LT_FL[i];
ADCM_constraint18{i in 1..24}:   adCM1__T_AdCM_HT_FL_K[i] == 273.15 + adCM1__T_AdCM_HT_FL[i];
ADCM_constraint19{i in 1..24}:   adCM1__v_dot_AdCM_LT[i] == adCM1__AdCM_ON[i] * adCM1__set_v_dot_AdCM_LT;
ADCM_constraint20{i in 1..24}:   adCM1__v_dot_AdCM_MT[i] == adCM1__AdCM_ON[i] * adCM1__set_v_dot_AdCM_MT;
ADCM_constraint21{i in 1..24}:   adCM1__v_dot_AdCM_HT[i] == adCM1__AdCM_ON[i] * adCM1__set_v_dot_AdCM_HT;
ADCM_constraint22{i in 1..24}:   adCM1__COP[i] == -0.059623287373 + 0.009093348591 * adCM1__T_AdCM_LT_FL[i] + 0.013340776694 * adCM1__T_AdCM_HT_FL[i] + 0.017822939671 * adCM1__T_AdCM_MT_RL[i] + -0.001280352166 * adCM1__T_AdCM_LT_FL[i] ^ 2 + -0.000190832894 * adCM1__T_AdCM_HT_FL[i] ^ 2 + -0.001993352016 * adCM1__T_AdCM_MT_RL[i] ^ 2 + adCM1__T_AdCM_LT_FL[i] * (-0.000334095159 * adCM1__T_AdCM_HT_FL[i] + 0.001455689548 * adCM1__T_AdCM_MT_RL[i]) + 0.000569253554 * adCM1__T_AdCM_HT_FL[i] * adCM1__T_AdCM_MT_RL[i] + 1.3421174e-005 * adCM1__T_AdCM_LT_FL[i] * adCM1__T_AdCM_HT_FL[i] * adCM1__T_AdCM_MT_RL[i];
ADCM_constraint23{i in 1..24}:   adCM1__CC[i] == 8.379509340989999 + 0.04152472361 * adCM1__T_AdCM_LT_FL[i] + 0.160630808297 * adCM1__T_AdCM_HT_FL[i] + -0.859860168466 * adCM1__T_AdCM_MT_RL[i] + 0.003462744142 * adCM1__T_AdCM_LT_FL[i] ^ 2 + -0.001049096999 * adCM1__T_AdCM_HT_FL[i] ^ 2 + 0.015142231276 * adCM1__T_AdCM_MT_RL[i] ^ 2 + adCM1__T_AdCM_LT_FL[i] * (0.016955368833 * adCM1__T_AdCM_HT_FL[i] + -0.016151596215 * adCM1__T_AdCM_MT_RL[i]) + -0.001917799045 * adCM1__T_AdCM_HT_FL[i] * adCM1__T_AdCM_MT_RL[i] + -0.000200778961 * adCM1__T_AdCM_LT_FL[i] * adCM1__T_AdCM_HT_FL[i] * adCM1__T_AdCM_MT_RL[i];
ADCM_constraint24{i in 1..24}:   adCM1__P_th_HT[i] == adCM1__CC[i] / adCM1__COP[i];
ADCM_constraint25{i in 1..24}:   adCM1__P_th_MT[i] == adCM1__P_th_HT[i] - adCM1__CC[i];
ADCM_constraint26{i in 1..24}:   adCM1__CC[i] == 4.18 * adCM1__m_dot_AdCM_LT[i] * (adCM1__T_AdCM_LT_FL_K[i] - adCM1__T_AdCM_LT_RL_K[i]);
ADCM_constraint27{i in 1..24}:   adCM1__P_th_MT[i] == 4.18 * adCM1__m_dot_AdCM_MT[i] * (adCM1__T_AdCM_MT_FL_K[i] - adCM1__T_AdCM_MT_RL_K[i]);
ADCM_constraint28{i in 1..24}:   adCM1__P_th_HT[i] == 4.18 * adCM1__m_dot_AdCM_HT[i] * (adCM1__T_AdCM_HT_FL_K[i] - adCM1__T_AdCM_HT_RL_K[i]);
 
#//================== lOAD1 equations =============================
LOAD1_constraint1{i in 1..24}:   lOAD1__m_dot_LOAD[i] == 0.2736111111111111 * lOAD1__v_dot_LOAD[i];
LOAD1_constraint2{i in 1..24}:   lOAD1__T_LOAD_FL[i] == lOAD1__LOAD_In__T[i];
LOAD1_constraint3{i in 1..24}:   lOAD1__T_LOAD_RL[i] == lOAD1__LOAD_Out__T[i];
LOAD1_constraint4{i in 1..24}:   lOAD1__m_dot_LOAD[i] == lOAD1__LOAD_Out__m_dot[i];
LOAD1_constraint5{i in 1..24}:   lOAD1__T_LOAD_FL_K[i] == 273.15 + lOAD1__T_LOAD_FL[i];
LOAD1_constraint6{i in 1..24}:   lOAD1__T_CC_RL_K[i] == 273.15 + lOAD1__T_CC_RL[i];
LOAD1_constraint7{i in 1..24}:   lOAD1__T_LOAD_RL[i] == lOAD1__T_CC_RL[i] ;# "Temp coming back from CC is the one going back to the Tank";
LOAD1_constraint8{i in 1..24}:   lOAD1__cpw[i] == 4.20511 + -0.00136578 * lOAD1__T_LOAD_FL[i] + 1.52341e-005 * lOAD1__T_LOAD_FL[i] ^ 2;
LOAD1_constraint9{i in 1..24}:   lOAD1__delta_T_CC == lOAD1__T_CC_FL - lOAD1__T_CC_RL[i];
LOAD1_constraint10{i in 1..24}:   lOAD1__Pth_CC[i] == lOAD1__m_dot_LOAD[i] * lOAD1__cpw[i] * (lOAD1__T_LOAD_FL_K[i] - lOAD1__T_CC_RL_K[i]);
 
#//================== cTES1 equations =============================
CTES_constraint1{i in 1..24}:   lOAD1__m_dot_LOAD[i] == 0.2736111111111111 * lOAD1__v_dot_LOAD[i];
CTES_constraint2{i in 1..24}:   lOAD1__T_LOAD_FL[i] == lOAD1__LOAD_In__T[i];
CTES_constraint3{i in 1..24}:   lOAD1__T_LOAD_RL[i] == lOAD1__LOAD_Out__T[i];
CTES_constraint4{i in 1..24}:   lOAD1__m_dot_LOAD[i] == lOAD1__LOAD_Out__m_dot[i];
CTES_constraint5{i in 1..24}:   lOAD1__T_LOAD_FL_K[i] == 273.15 + lOAD1__T_LOAD_FL[i];
CTES_constraint6{i in 1..24}:   lOAD1__T_CC_RL_K[i] == 273.15 + lOAD1__T_CC_RL[i];
CTES_constraint7{i in 1..24}:   lOAD1__T_LOAD_RL[i] == lOAD1__T_CC_RL[i] ;# "Temp coming back from CC is the one going back to the Tank";
CTES_constraint8{i in 1..24}:   lOAD1__cpw[i] == 4.20511 + -0.00136578 * lOAD1__T_LOAD_FL[i] + 1.52341e-005 * lOAD1__T_LOAD_FL[i] ^ 2;
CTES_constraint9{i in 1..24}:   lOAD1__delta_T_CC == lOAD1__T_CC_FL - lOAD1__T_CC_RL[i];
CTES_constraint10{i in 1..24}:   lOAD1__Pth_CC[i] == lOAD1__m_dot_LOAD[i] * lOAD1__cpw[i] * (lOAD1__T_LOAD_FL_K[i] - lOAD1__T_CC_RL_K[i]);
CTES_constraint11{i in 1..24}:   cTES11__T_CTES_AdCM_In[i] == cTES11__CTES_AdCM_In__T[i] ;# "Temperature coming from the AdCM [degC]";
CTES_constraint12{i in 1..24}:   cTES11__T_CTES_RevHP_In[i] == cTES11__CTES_RevHP_In__T[i] ;# "Temperature coming from the RevHP [degC]";
CTES_constraint13{i in 1..24}:   cTES11__m_dot_AdCM[i] == cTES11__CTES_AdCM_In__m_dot[i] ;# "Mass Flow at the entrance of the CTES (Bottom Layer[i]) [kg/s]";
CTES_constraint14{i in 1..24}:   cTES11__m_dot_RevHP[i] == cTES11__CTES_RevHP_In__m_dot[i] ;# "Mass Flow at the entrance of the CTES (Bottom Layer[i]) [kg/s]";
CTES_constraint15{i in 1..24}:   cTES11__CTES_H_W_T_M_IT_4[i] == cTES11__CTES_AdCM_Out__T[i] ;# "Return Temperature that goes to the AdCM[degC]";
CTES_constraint16{i in 1..24}:   cTES11__CTES_H_W_T_M_IT_4[i] == cTES11__CTES_RevHP_Out__T[i] ;# "Return Temperature that goes to the RevHP[degC]";
CTES_constraint17{i in 1..24}:   cTES11__CTES_H_W_T_M_IT_1[i] == cTES11__CTES_LOAD_Out__T[i] ;# "Temperature that goes to the Load[degC]";
CTES_constraint18{i in 1..24}:   cTES11__m_dot_LOAD[i] == cTES11__CTES_LOAD_In__m_dot[i] ;# "Mass flow coming back from the LOAD [kg/s]";
CTES_constraint19{i in 1..24}:   cTES11__T_CTES_LOAD_RL[i] == cTES11__CTES_LOAD_In__T[i] ;# "Temperature coming back from the LOAD [degC]";
CTES_constraint20{i in 1..24}:   cTES11__T_CTES_AdCM_In_K[i] == 273.15 + cTES11__T_CTES_AdCM_In[i];
CTES_constraint21{i in 1..24}:   cTES11__T_CTES_RevHP_In_K[i] == 273.15 + cTES11__T_CTES_RevHP_In[i];
CTES_constraint22{i in 1..24}:   cTES11__CTES_H_W_T_M_IT_1_K[i] == 273.15 + cTES11__CTES_H_W_T_M_IT_1[i];
CTES_constraint23{i in 1..24}:   cTES11__CTES_H_W_T_M_IT_2_K[i] == 273.15 + cTES11__CTES_H_W_T_M_IT_2[i];
CTES_constraint24{i in 1..24}:   cTES11__CTES_H_W_T_M_IT_3_K[i] == 273.15 + cTES11__CTES_H_W_T_M_IT_3[i];
CTES_constraint25{i in 1..24}:   cTES11__CTES_H_W_T_M_IT_4_K[i] == 273.15 + cTES11__CTES_H_W_T_M_IT_4[i];
CTES_constraint26{i in 1..24}:   cTES11__T_ini_K[i] == 273.15 + cTES11__T_ini;
CTES_constraint27{i in 1..24}:   cTES11__T_amb_K[i] == 273.15 + cTES11__T_amb;
CTES_constraint28{i in 1..24}:   cTES11__T_CTES_LOAD_RL_K[i] == 273.15 + cTES11__T_CTES_LOAD_RL[i];
CTES_constraint29{i in 1..24}:   cTES11__cp1[i] == 4.20511 + -0.00136578 * cTES11__CTES_H_W_T_M_IT_1_K[i] + 1.52341e-005 * cTES11__CTES_H_W_T_M_IT_1_K[i] ^ 2;
CTES_constraint30{i in 1..24}:   cTES11__cp2[i] == 4.20511 + -0.00136578 * cTES11__CTES_H_W_T_M_IT_2_K[i] + 1.52341e-005 * cTES11__CTES_H_W_T_M_IT_2_K[i] ^ 2;
CTES_constraint31{i in 1..24}:   cTES11__cp3[i] == 4.20511 + -0.00136578 * cTES11__CTES_H_W_T_M_IT_3_K[i] + 1.52341e-005 * cTES11__CTES_H_W_T_M_IT_3_K[i] ^ 2;
CTES_constraint32{i in 1..24}:   cTES11__cp4[i] == 4.20511 + -0.00136578 * cTES11__CTES_H_W_T_M_IT_4_K[i] + 1.52341e-005 * cTES11__CTES_H_W_T_M_IT_4_K[i] ^ 2;
CTES_constraint33{i in 1..24}:   cTES11__m_dot4[i] == cTES11__m_dot3[i] - cTES11__m_dot_LOAD[i] ;# "mass flow are subtracted because the flow is other way round";
#CTES_constraint34{i in 1..24}:   cTES11__cp4 * cTES11__mi * der(cTES11__CTES_H_W_T_M_IT_4_K[i]) == cTES11__Alayer * cTES11__lambda_eff * (cTES11__CTES_H_W_T_M_IT_3_K[i] - cTES11__CTES_H_W_T_M_IT_4_K[i]) / cTES11__zi + cTES11__cp3[i] * cTES11__m_dot3[i] * (cTES11__CTES_H_W_T_M_IT_3_K[i] - cTES11__CTES_H_W_T_M_IT_4_K[i]) - cTES11__Aamb * cTES11__kappa * (cTES11__CTES_H_W_T_M_IT_4_K[i] - cTES11__T_amb_K[i]);
#CTES_constraint35{i in 1..24}:   cTES11__m_dot3[i] == cTES11__m_dot2[i];
#CTES_constraint36{i in 1..24}:   cTES11__cp3[i] * cTES11__mi * der(cTES11__CTES_H_W_T_M_IT_3_K[i]) == cTES11__Alayer * cTES11__lambda_eff * (cTES11__CTES_H_W_T_M_IT_2_K[i] + -2.0 * cTES11__CTES_H_W_T_M_IT_3_K[i] + cTES11__CTES_H_W_T_M_IT_4_K[i]) / cTES11__zi + cTES11__cp2[i] * cTES11__m_dot2[i] * (cTES11__CTES_H_W_T_M_IT_2_K[i] - cTES11__CTES_H_W_T_M_IT_3_K[i]) + cTES11__cp3[i] * cTES11__m_dot3[i] * (cTES11__CTES_H_W_T_M_IT_4_K[i] - cTES11__CTES_H_W_T_M_IT_3_K[i]) - cTES11__Aamb * cTES11__kappa * (cTES11__CTES_H_W_T_M_IT_3_K[i] - cTES11__T_amb_K[i]);
#CTES_constraint37{i in 1..24}:   cTES11__m_dot2[i] == cTES11__m_dot1[i];
#CTES_constraint38{i in 1..24}:   cTES11__cp2[i] * cTES11__mi * der(cTES11__CTES_H_W_T_M_IT_2_K[i]) == cTES11__Alayer * cTES11__lambda_eff * (cTES11__CTES_H_W_T_M_IT_1_K[i] + -2.0 * cTES11__CTES_H_W_T_M_IT_2_K[i] + cTES11__CTES_H_W_T_M_IT_3_K[i]) / cTES11__zi + cTES11__cp2[i] * (cTES11__m_dot1[i] * (cTES11__CTES_H_W_T_M_IT_1_K[i] - cTES11__CTES_H_W_T_M_IT_2_K[i]) + cTES11__m_dot2[i] * (cTES11__CTES_H_W_T_M_IT_3_K[i] - cTES11__CTES_H_W_T_M_IT_2_K[i])) - cTES11__Aamb * cTES11__kappa * (cTES11__CTES_H_W_T_M_IT_2_K[i] - cTES11__T_amb_K[i]);
#CTES_constraint39{i in 1..24}:   cTES11__m_dot1[i] == cTES11__m_dot_AdCM[i] + cTES11__m_dot_RevHP[i] - cTES11__m_dot_LOAD[i];
#CTES_constraint40{i in 1..24}:   cTES11__cp1[i] * cTES11__mi * der(cTES11__CTES_H_W_T_M_IT_1_K[i]) == cTES11__Alayer * cTES11__lambda_eff * (cTES11__CTES_H_W_T_M_IT_2_K[i] - cTES11__CTES_H_W_T_M_IT_1_K[i]) / cTES11__zi + cTES11__cp1[i] * (cTES11__m_dot1[i] * (cTES11__CTES_H_W_T_M_IT_2_K[i] - cTES11__CTES_H_W_T_M_IT_1_K[i]) + cTES11__m_dot_AdCM[i] * (cTES11__T_CTES_AdCM_In_K[i] - cTES11__CTES_H_W_T_M_IT_1_K[i]) + cTES11__m_dot_RevHP[i] * (cTES11__T_CTES_RevHP_In_K[i] - cTES11__CTES_H_W_T_M_IT_1_K[i])) - cTES11__Aamb * cTES11__kappa * (cTES11__CTES_H_W_T_M_IT_1_K[i] - cTES11__T_amb_K[i]);
CTES_constraint34{i in 1..24}:   cTES11__cp4[i] * cTES11__mi * (cTES11__CTES_H_W_T_M_IT_4_K[i]) == cTES11__Alayer * cTES11__lambda_eff * (cTES11__CTES_H_W_T_M_IT_3_K[i] - cTES11__CTES_H_W_T_M_IT_4_K[i]) / cTES11__zi + cTES11__cp3[i] * cTES11__m_dot3[i] * (cTES11__CTES_H_W_T_M_IT_3_K[i] - cTES11__CTES_H_W_T_M_IT_4_K[i]) - cTES11__Aamb * cTES11__kappa * (cTES11__CTES_H_W_T_M_IT_4_K[i] - cTES11__T_amb_K[i]); # Dang: integrate with T=1h, for discretization
CTES_constraint35{i in 1..24}:   cTES11__m_dot3[i] == cTES11__m_dot2[i];
CTES_constraint36{i in 1..24}:   cTES11__cp3[i] * cTES11__mi * (cTES11__CTES_H_W_T_M_IT_3_K[i]) == cTES11__Alayer * cTES11__lambda_eff * (cTES11__CTES_H_W_T_M_IT_2_K[i] + -2.0 * cTES11__CTES_H_W_T_M_IT_3_K[i] + cTES11__CTES_H_W_T_M_IT_4_K[i]) / cTES11__zi + cTES11__cp2[i] * cTES11__m_dot2[i] * (cTES11__CTES_H_W_T_M_IT_2_K[i] - cTES11__CTES_H_W_T_M_IT_3_K[i]) + cTES11__cp3[i] * cTES11__m_dot3[i] * (cTES11__CTES_H_W_T_M_IT_4_K[i] - cTES11__CTES_H_W_T_M_IT_3_K[i]) - cTES11__Aamb * cTES11__kappa * (cTES11__CTES_H_W_T_M_IT_3_K[i] - cTES11__T_amb_K[i]);
CTES_constraint37{i in 1..24}:   cTES11__m_dot2[i] == cTES11__m_dot1[i];
CTES_constraint38{i in 1..24}:   cTES11__cp2[i] * cTES11__mi * (cTES11__CTES_H_W_T_M_IT_2_K[i]) == cTES11__Alayer * cTES11__lambda_eff * (cTES11__CTES_H_W_T_M_IT_1_K[i] + -2.0 * cTES11__CTES_H_W_T_M_IT_2_K[i] + cTES11__CTES_H_W_T_M_IT_3_K[i]) / cTES11__zi + cTES11__cp2[i] * (cTES11__m_dot1[i] * (cTES11__CTES_H_W_T_M_IT_1_K[i] - cTES11__CTES_H_W_T_M_IT_2_K[i]) + cTES11__m_dot2[i] * (cTES11__CTES_H_W_T_M_IT_3_K[i] - cTES11__CTES_H_W_T_M_IT_2_K[i])) - cTES11__Aamb * cTES11__kappa * (cTES11__CTES_H_W_T_M_IT_2_K[i] - cTES11__T_amb_K[i]);
CTES_constraint39{i in 1..24}:   cTES11__m_dot1[i] == cTES11__m_dot_AdCM[i] + cTES11__m_dot_RevHP[i] - cTES11__m_dot_LOAD[i];
CTES_constraint40{i in 1..24}:   cTES11__cp1[i] * cTES11__mi * (cTES11__CTES_H_W_T_M_IT_1_K[i]) == cTES11__Alayer * cTES11__lambda_eff * (cTES11__CTES_H_W_T_M_IT_2_K[i] - cTES11__CTES_H_W_T_M_IT_1_K[i]) / cTES11__zi + cTES11__cp1[i] * (cTES11__m_dot1[i] * (cTES11__CTES_H_W_T_M_IT_2_K[i] - cTES11__CTES_H_W_T_M_IT_1_K[i]) + cTES11__m_dot_AdCM[i] * (cTES11__T_CTES_AdCM_In_K[i] - cTES11__CTES_H_W_T_M_IT_1_K[i]) + cTES11__m_dot_RevHP[i] * (cTES11__T_CTES_RevHP_In_K[i] - cTES11__CTES_H_W_T_M_IT_1_K[i])) - cTES11__Aamb * cTES11__kappa * (cTES11__CTES_H_W_T_M_IT_1_K[i] - cTES11__T_amb_K[i]);

 
#//================== revHP_HP1 equations =============================
RevHP_HP1_constraint1{i in 1..24}:   revHP_HP1__T_RevHP_HT_FL[i] == revHP_HP1__RevHP_HTES_Out__T[i];
RevHP_HP1_constraint2{i in 1..24}:   revHP_HP1__T_RevHP_MT_FL[i] == revHP_HP1__RevHP_OC_Out__T[i];
RevHP_HP1_constraint3{i in 1..24}:   revHP_HP1__T_RevHP_HT_RL[i] == revHP_HP1__RevHP_HTES_In__T[i];
RevHP_HP1_constraint4{i in 1..24}:   revHP_HP1__T_RevHP_MT_RL[i] == revHP_HP1__RevHP_OC_In__T[i];
RevHP_HP1_constraint5{i in 1..24}:   revHP_HP1__m_dot_HT_FL[i] == revHP_HP1__RevHP_HTES_Out__m_dot[i];
RevHP_HP1_constraint6{i in 1..24}:   revHP_HP1__m_dot_MT_FL[i] == revHP_HP1__RevHP_OC_Out__m_dot[i];
RevHP_HP1_constraint7{i in 1..24}:   revHP_HP1__T_RevHP_HT_FL_K[i] == 273.15 + revHP_HP1__T_RevHP_HT_FL[i];
RevHP_HP1_constraint8{i in 1..24}:   revHP_HP1__T_RevHP_MT_FL_K[i] == 273.15 + revHP_HP1__T_RevHP_MT_FL[i];
RevHP_HP1_constraint9{i in 1..24}:   revHP_HP1__T_RevHP_HT_RL_K[i] == 273.15 + revHP_HP1__T_RevHP_HT_RL[i];
RevHP_HP1_constraint10{i in 1..24}:   revHP_HP1__T_RevHP_MT_RL_K[i] == 273.15 + revHP_HP1__T_RevHP_MT_RL[i];
RevHP_HP1_constraint11{i in 1..24}:   revHP_HP1__m_dot_HT_FL[i] == 0.2736111111111111 * revHP_HP1__v_dot_HT_FL[i];
RevHP_HP1_constraint12{i in 1..24}:   revHP_HP1__m_dot_MT_FL[i] == 0.2736111111111111 * revHP_HP1__v_dot_MT_FL[i];
RevHP_HP1_constraint13{i in 1..24}:   revHP_HP1__v_dot_HT_FL[i] == revHP_HP1__RevHP_HP_ON[i] * revHP_HP1__set_v_dot_HT_FL;
RevHP_HP1_constraint14{i in 1..24}:   revHP_HP1__v_dot_MT_FL[i] == revHP_HP1__RevHP_HP_ON[i] * revHP_HP1__set_v_dot_MT_FL;
RevHP_HP1_constraint15{i in 1..24}:   revHP_HP1__HC[i] == 13.87856214 + 0.294510922 * revHP_HP1__T_RevHP_MT_FL[i] + revHP_HP1__T_RevHP_HT_FL[i] * (0.064700246 + 0.002953381 * revHP_HP1__T_RevHP_MT_FL[i]) + -0.001625553 * revHP_HP1__T_RevHP_MT_FL[i] ^ 2 + -0.001627312 * revHP_HP1__T_RevHP_HT_FL[i] ^ 2;
RevHP_HP1_constraint16{i in 1..24}:   revHP_HP1__HC[i] == 4.18 * revHP_HP1__m_dot_HT_FL[i] * (revHP_HP1__T_RevHP_HT_FL_K[i] - revHP_HP1__T_RevHP_HT_RL_K[i]);
#old: RevHP_HP1_constraint17{i in 1..24}:   revHP_HP1__Range_RevHP_HP[i] == 2.3379 + 0.5878 * log(revHP_HP1__T_RevHP_HT_RL[i]);
RevHP_HP1_constraint17{i in 1..24}:   revHP_HP1__Range_RevHP_HP[i] == 2.0065 + 0.2183 * revHP_HP1__T_RevHP_HT_RL[i] - 0.0028 * revHP_HP1__T_RevHP_HT_RL[i] ^ 2;
RevHP_HP1_constraint18{i in 1..24}:   revHP_HP1__Range_RevHP_HP[i] == revHP_HP1__T_RevHP_MT_RL[i] - revHP_HP1__T_RevHP_MT_FL[i] ;# "Temp. otherway round because temp. coming back from OC is warmer";
RevHP_HP1_constraint19{i in 1..24}:   revHP_HP1__P_th_MT[i] == 4.18 * revHP_HP1__m_dot_MT_FL[i] * (revHP_HP1__T_RevHP_MT_RL_K[i] - revHP_HP1__T_RevHP_MT_FL_K[i]) ;# "Temp. otherway round because temp. coming back from OC is warmer";
RevHP_HP1_constraint20{i in 1..24}:   revHP_HP1__PI[i] == 2.233202228 + -0.007333788 * revHP_HP1__T_RevHP_MT_FL[i] + revHP_HP1__T_RevHP_HT_FL[i] * (0.019283658 + 0.000450498 * revHP_HP1__T_RevHP_MT_FL[i]) + -8.304799999999999e-005 * revHP_HP1__T_RevHP_MT_FL[i] ^ 2 + 0.000671146 * revHP_HP1__T_RevHP_HT_FL[i] ^ 2;
RevHP_HP1_constraint21{i in 1..24}:   revHP_HP1__COPel[i] == revHP_HP1__HC[i] / revHP_HP1__PI[i];
 
#//================== revHP_CC equations =============================
RevHP_CC_constraint1{i in 1..24}:   revHP_CC_Equation1__T_RevHP_LT_FL[i] == revHP_CC_Equation1__RevHP_CTES_Out__T[i];
RevHP_CC_constraint2{i in 1..24}:   revHP_CC_Equation1__T_RevHP_MT_FL[i] == revHP_CC_Equation1__RevHP_OC_Out__T[i];
RevHP_CC_constraint3{i in 1..24}:   revHP_CC_Equation1__T_RevHP_LT_RL[i] == revHP_CC_Equation1__RevHP_CTES_In__T[i] ;# "Temp. coming from CTES";
RevHP_CC_constraint4{i in 1..24}:   revHP_CC_Equation1__T_RevHP_MT_RL[i] == revHP_CC_Equation1__RevHP_OC_In__T[i];
RevHP_CC_constraint5{i in 1..24}:   revHP_CC_Equation1__m_dot_LT_FL[i] == revHP_CC_Equation1__RevHP_CTES_Out__m_dot[i];
RevHP_CC_constraint6{i in 1..24}:   revHP_CC_Equation1__m_dot_MT_FL[i] == revHP_CC_Equation1__RevHP_OC_Out__m_dot[i];
RevHP_CC_constraint7{i in 1..24}:   revHP_CC_Equation1__T_RevHP_LT_FL_K[i] == 273.15 + revHP_CC_Equation1__T_RevHP_LT_FL[i];
RevHP_CC_constraint8{i in 1..24}:   revHP_CC_Equation1__T_RevHP_MT_FL_K[i] == 273.15 + revHP_CC_Equation1__T_RevHP_MT_FL[i];
RevHP_CC_constraint9{i in 1..24}:   revHP_CC_Equation1__T_RevHP_LT_RL_K[i] == 273.15 + revHP_CC_Equation1__T_RevHP_LT_RL[i];
RevHP_CC_constraint10{i in 1..24}:   revHP_CC_Equation1__T_RevHP_MT_RL_K[i] == 273.15 + revHP_CC_Equation1__T_RevHP_MT_RL[i];
RevHP_CC_constraint11{i in 1..24}:   revHP_CC_Equation1__m_dot_LT_FL[i] == 0.2736111111111111 * revHP_CC_Equation1__v_dot_LT_FL[i];
RevHP_CC_constraint12{i in 1..24}:   revHP_CC_Equation1__m_dot_MT_FL[i] == 0.2736111111111111 * revHP_CC_Equation1__v_dot_MT_FL[i];
RevHP_CC_constraint13{i in 1..24}:   revHP_CC_Equation1__v_dot_LT_FL[i] == revHP_CC_Equation1__RevHP_CC_ON[i] * revHP_CC_Equation1__set_v_dot_LT_FL;
RevHP_CC_constraint14{i in 1..24}:   revHP_CC_Equation1__v_dot_MT_FL[i] == revHP_CC_Equation1__RevHP_CC_ON[i] * revHP_CC_Equation1__set_v_dot_MT_FL;
RevHP_CC_constraint15{i in 1..24}:   revHP_CC_Equation1__CC[i] == 11.55794683 + 0.308329176 * revHP_CC_Equation1__T_RevHP_LT_FL[i] + 0.045285097 * revHP_CC_Equation1__T_RevHP_MT_FL[i] + 0.002252906 * revHP_CC_Equation1__T_RevHP_LT_FL[i] * revHP_CC_Equation1__T_RevHP_MT_FL[i] + -0.001213212 * revHP_CC_Equation1__T_RevHP_LT_FL[i] ^ 2 + -0.002264659 * revHP_CC_Equation1__T_RevHP_MT_FL[i] ^ 2;
RevHP_CC_constraint16{i in 1..24}:   revHP_CC_Equation1__CC[i] == 4.18 * revHP_CC_Equation1__m_dot_LT_FL[i] * (revHP_CC_Equation1__T_RevHP_LT_RL_K[i] - revHP_CC_Equation1__T_RevHP_LT_FL_K[i]);
#old: RevHP_CC_constraint17{i in 1..24}:   revHP_CC_Equation1__Range_RevHP_CC[i] == 2.3379 + 0.5878 * log(revHP_CC_Equation1__T_RevHP_LT_RL[i]) ;# "The Temp. in this curve fitted equation is in C";
RevHP_CC_constraint17{i in 1..24}:   revHP_CC_Equation1__Range_RevHP_CC[i] == 2.0065 + 0.2183 * revHP_CC_Equation1__T_RevHP_LT_RL[i] - 0.0028 * revHP_CC_Equation1__T_RevHP_LT_RL[i] ^ 2 ;# "The Temp. in this curve fitted equation is in C";
RevHP_CC_constraint18{i in 1..24}:   revHP_CC_Equation1__Range_RevHP_CC[i] == revHP_CC_Equation1__T_RevHP_MT_FL[i] - revHP_CC_Equation1__T_RevHP_MT_RL[i];
RevHP_CC_constraint19{i in 1..24}:   revHP_CC_Equation1__P_th_MT[i] == 4.18 * revHP_CC_Equation1__m_dot_MT_FL[i] * (revHP_CC_Equation1__T_RevHP_MT_FL_K[i] - revHP_CC_Equation1__T_RevHP_MT_RL_K[i]);
RevHP_CC_constraint20{i in 1..24}:   revHP_CC_Equation1__PI[i] == 2.233202228 + -0.007333788 * revHP_CC_Equation1__T_RevHP_LT_FL[i] + 0.019283658 * revHP_CC_Equation1__T_RevHP_MT_FL[i] + 0.000450498 * revHP_CC_Equation1__T_RevHP_LT_FL[i] * revHP_CC_Equation1__T_RevHP_MT_FL[i] + -8.304799999999999e-005 * revHP_CC_Equation1__T_RevHP_LT_FL[i] ^ 2 + 0.000671146 * revHP_CC_Equation1__T_RevHP_MT_FL[i] ^ 2;
RevHP_CC_constraint21{i in 1..24}:   revHP_CC_Equation1__COPel[i] == revHP_CC_Equation1__CC[i] / revHP_CC_Equation1__PI[i];
 
#//================== outdoorCoil_Equation1 equations =============================
OutdoorCoil1_constraint1{i in 1..24}:   outdoorCoil_Equation1__OC_Out__T[i] == outdoorCoil_Equation1__T_OC_MT_FL[i];
OutdoorCoil1_constraint2{i in 1..24}:   outdoorCoil_Equation1__OC_In__T[i] == outdoorCoil_Equation1__T_OC_MT_RL[i];
OutdoorCoil1_constraint3{i in 1..24}:   outdoorCoil_Equation1__OC_In__m_dot[i] == outdoorCoil_Equation1__m_dot_OC[i];
OutdoorCoil1_constraint4{i in 1..24}:   outdoorCoil_Equation1__T_OC_MT_FL_K[i] == 273.15 + outdoorCoil_Equation1__T_OC_MT_FL[i];
OutdoorCoil1_constraint5{i in 1..24}:   outdoorCoil_Equation1__T_OC_MT_RL_K[i] == 273.15 + outdoorCoil_Equation1__T_OC_MT_RL[i];
OutdoorCoil1_constraint6{i in 1..24}:   outdoorCoil_Equation1__m_dot_OC[i] == 0.2736111111111111 * outdoorCoil_Equation1__v_dot_OC[i];
OutdoorCoil1_constraint7{i in 1..24}:   outdoorCoil_Equation1__T_OC_MT_FL[i] == -0.66146 + -1.51221 * outdoorCoil_Equation1__Volt + 1.607146 * outdoorCoil_Equation1__T_amb + -1.2369 * outdoorCoil_Equation1__Range[i] + outdoorCoil_Equation1__Volt * (-0.00361 * outdoorCoil_Equation1__T_amb + 0.072202 * outdoorCoil_Equation1__Range[i]) + 0.084311 * outdoorCoil_Equation1__T_amb * outdoorCoil_Equation1__Range[i] + -0.009090000000000001 * outdoorCoil_Equation1__Volt * outdoorCoil_Equation1__T_amb * outdoorCoil_Equation1__Range[i] + 0.131512 * outdoorCoil_Equation1__Volt ^ 2 + -0.0159 * outdoorCoil_Equation1__T_amb ^ 2 + 0.091754 * outdoorCoil_Equation1__Range[i] ^ 2;
OutdoorCoil1_constraint8{i in 1..24}:   outdoorCoil_Equation1__Range[i] == outdoorCoil_Equation1__T_OC_MT_RL[i] - outdoorCoil_Equation1__T_OC_MT_FL[i];
OutdoorCoil1_constraint9{i in 1..24}:   outdoorCoil_Equation1__Pth_OC[i] == 4.18 * outdoorCoil_Equation1__m_dot_OC[i] * (outdoorCoil_Equation1__T_OC_MT_RL[i] - outdoorCoil_Equation1__T_OC_MT_FL[i]);
 
#//================== outdoorCoil_Equation2 equations =============================
OutdoorCoil2_constraint1{i in 1..24}:   outdoorCoil_Equation2__OC_Out__T[i] == outdoorCoil_Equation2__T_OC_MT_FL[i];
OutdoorCoil2_constraint2{i in 1..24}:   outdoorCoil_Equation2__OC_In__T[i] == outdoorCoil_Equation2__T_OC_MT_RL[i];
OutdoorCoil2_constraint3{i in 1..24}:   outdoorCoil_Equation2__OC_In__m_dot[i] == outdoorCoil_Equation2__m_dot_OC[i];
OutdoorCoil2_constraint4{i in 1..24}:   outdoorCoil_Equation2__T_OC_MT_FL_K[i] == 273.15 + outdoorCoil_Equation2__T_OC_MT_FL[i];
OutdoorCoil2_constraint5{i in 1..24}:   outdoorCoil_Equation2__T_OC_MT_RL_K[i] == 273.15 + outdoorCoil_Equation2__T_OC_MT_RL[i];
OutdoorCoil2_constraint6{i in 1..24}:   outdoorCoil_Equation2__m_dot_OC[i] == 0.2736111111111111 * outdoorCoil_Equation2__v_dot_OC[i];
OutdoorCoil2_constraint7{i in 1..24}:   outdoorCoil_Equation2__T_OC_MT_FL[i] == -0.66146 + -1.51221 * outdoorCoil_Equation2__Volt + 1.607146 * outdoorCoil_Equation2__T_amb + -1.2369 * outdoorCoil_Equation2__Range[i] + outdoorCoil_Equation2__Volt * (-0.00361 * outdoorCoil_Equation2__T_amb + 0.072202 * outdoorCoil_Equation2__Range[i]) + 0.084311 * outdoorCoil_Equation2__T_amb * outdoorCoil_Equation2__Range[i] + -0.009090000000000001 * outdoorCoil_Equation2__Volt * outdoorCoil_Equation2__T_amb * outdoorCoil_Equation2__Range[i] + 0.131512 * outdoorCoil_Equation2__Volt ^ 2 + -0.0159 * outdoorCoil_Equation2__T_amb ^ 2 + 0.091754 * outdoorCoil_Equation2__Range[i] ^ 2;
OutdoorCoil2_constraint8{i in 1..24}:   outdoorCoil_Equation2__Range[i] == outdoorCoil_Equation2__T_OC_MT_RL[i] - outdoorCoil_Equation2__T_OC_MT_FL[i];
OutdoorCoil2_constraint9{i in 1..24}:   outdoorCoil_Equation2__Pth_OC[i] == 4.18 * outdoorCoil_Equation2__m_dot_OC[i] * (outdoorCoil_Equation2__T_OC_MT_RL[i] - outdoorCoil_Equation2__T_OC_MT_FL[i]);
 
#//================== OutdoorCoil_RevHP equations =============================
OutdoorCoil_RevHP_constraint1{i in 1..24}:   OutdoorCoil_RevHP__OC_Out__T[i] == OutdoorCoil_RevHP__T_OC_MT_FL[i];
OutdoorCoil_RevHP_constraint2{i in 1..24}:   OutdoorCoil_RevHP__OC_In__T[i] == OutdoorCoil_RevHP__T_OC_MT_RL[i];
OutdoorCoil_RevHP_constraint3{i in 1..24}:   OutdoorCoil_RevHP__OC_In__m_dot[i] == OutdoorCoil_RevHP__m_dot_OC[i];
OutdoorCoil_RevHP_constraint4{i in 1..24}:   OutdoorCoil_RevHP__T_OC_MT_FL_K[i] == 273.15 + OutdoorCoil_RevHP__T_OC_MT_FL[i];
OutdoorCoil_RevHP_constraint5{i in 1..24}:   OutdoorCoil_RevHP__T_OC_MT_RL_K[i] == 273.15 + OutdoorCoil_RevHP__T_OC_MT_RL[i];
OutdoorCoil_RevHP_constraint6{i in 1..24}:   OutdoorCoil_RevHP__m_dot_OC[i] == 0.2736111111111111 * OutdoorCoil_RevHP__v_dot_OC[i];
OutdoorCoil_RevHP_constraint7{i in 1..24}:   OutdoorCoil_RevHP__T_OC_MT_FL[i] == -0.66146 + -1.51221 * OutdoorCoil_RevHP__Volt + 1.607146 * OutdoorCoil_RevHP__T_amb + -1.2369 * OutdoorCoil_RevHP__Range[i] + OutdoorCoil_RevHP__Volt * (-0.00361 * OutdoorCoil_RevHP__T_amb + 0.072202 * OutdoorCoil_RevHP__Range[i]) + 0.084311 * OutdoorCoil_RevHP__T_amb * OutdoorCoil_RevHP__Range[i] + -0.009090000000000001 * OutdoorCoil_RevHP__Volt * OutdoorCoil_RevHP__T_amb * OutdoorCoil_RevHP__Range[i] + 0.131512 * OutdoorCoil_RevHP__Volt ^ 2 + -0.0159 * OutdoorCoil_RevHP__T_amb ^ 2 + 0.091754 * OutdoorCoil_RevHP__Range[i] ^ 2;
OutdoorCoil_RevHP_constraint8{i in 1..24}:   OutdoorCoil_RevHP__Range[i] == OutdoorCoil_RevHP__T_OC_MT_FL[i] - OutdoorCoil_RevHP__T_OC_MT_RL[i];# "Reversed for Heat Pump"
OutdoorCoil_RevHP_constraint9{i in 1..24}:   OutdoorCoil_RevHP__Pth_OC[i] == 4.18 * OutdoorCoil_RevHP__m_dot_OC[i] * (OutdoorCoil_RevHP__T_OC_MT_FL[i] - OutdoorCoil_RevHP__T_OC_MT_RL[i]);
 
#//================== lOAD_C1 equations =============================
LOAD_C1_constraint1{i in 1..24}:   lOAD_C1__T_LOAD_FL[i] == lOAD_C1__LOAD_In__T[i];
LOAD_C1_constraint2{i in 1..24}:   lOAD_C1__T_LOAD_RL[i] == lOAD_C1__LOAD_Out__T[i];
LOAD_C1_constraint3{i in 1..24}:   lOAD_C1__m_dot_LOAD[i] == lOAD_C1__LOAD_Out__m_dot[i];
LOAD_C1_constraint4{i in 1..24}:   lOAD_C1__m_dot_LOAD[i] == 0.2736111111111111 * lOAD_C1__v_dot_LOAD[i];
LOAD_C1_constraint5{i in 1..24}:   lOAD_C1__T_LOAD_FL_K[i] == 273.15 + lOAD_C1__T_LOAD_FL[i];
LOAD_C1_constraint6{i in 1..24}:   lOAD_C1__T_CC_RL_K[i] == 273.15 + lOAD_C1__T_CC_RL[i];
LOAD_C1_constraint7{i in 1..24}:   lOAD_C1__T_LOAD_RL[i] == lOAD_C1__T_CC_RL[i] ;# "Temp coming back from CC is the one going back to the Tank";
LOAD_C1_constraint8{i in 1..24}:   lOAD_C1__cpw[i] == 4.20511 + -0.00136578 * lOAD_C1__T_LOAD_FL[i] + 1.52341e-005 * lOAD_C1__T_LOAD_FL[i] ^ 2;
LOAD_C1_constraint9{i in 1..24}:   lOAD_C1__delta_T_CC == lOAD_C1__T_CC_RL[i] - lOAD_C1__T_CC_FL ;# "Temperature are other way round since it is cooling";
LOAD_C1_constraint10{i in 1..24}:   lOAD_C1__Pth_CC[i] == lOAD_C1__m_dot_LOAD[i] * lOAD_C1__cpw[i] * (lOAD_C1__T_CC_RL_K[i] - lOAD_C1__T_LOAD_FL_K[i]) ;# "Temperatures switched for cooling";
 
#//================== hTES1 equations =============================
 # TO DO: Still need to be checked: the model of hTES containing "if"
HTES_constraint1{i in 1..24}:   hTES1__T_HTES_CHP_In[i] == hTES1__HTES_CHP_In__T[i] ;# "Temperature coming from the CHP [degC]";
HTES_constraint2{i in 1..24}:   hTES1__T_HTES_RevHP_In[i] == hTES1__HTES_RevHP_In__T[i] ;# "Temperature coming from the RevHP [degC]";
HTES_constraint3{i in 1..24}:   hTES1__m_dot_CHP[i] == hTES1__HTES_CHP_In__m_dot[i] ;# "Mass flow coming from the CHP(Top Layer)";
HTES_constraint4{i in 1..24}:   hTES1__m_dot_RevHP_HT[i] == hTES1__HTES_RevHP_In__m_dot[i] ;# "Mass flow coming from the RevHP(Top Layer)";
HTES_constraint5{i in 1..24}:   hTES1__HTES_H_W_T_M_IT_1[i] == hTES1__HTES_CHP_Out__T[i] ;# "Return Temperature that goes to the CHP [degC]";
HTES_constraint6{i in 1..24}:   hTES1__HTES_H_W_T_M_IT_1[i] == hTES1__HTES_RevHP_Out__T[i] ;# "Return Temperature that goes to the RevHP[degC]";
HTES_constraint7{i in 1..24}:   hTES1__HTES_H_W_T_M_IT_6[i] == hTES1__HTES_LOAD_Out__T[i] ;# "Temperature that goes to the Load[degC]";
HTES_constraint8{i in 1..24}:   hTES1__m_dot_LOAD[i] == hTES1__HTES_LOAD_In__m_dot[i] ;# "Mass flow entering from the LOAD [kg/s]";
HTES_constraint9{i in 1..24}:   hTES1__T_HTES_LOAD_RL[i] == hTES1__HTES_LOAD_In__T[i] ;# "Temperature coming back from the LOAD [degC]";
HTES_constraint10{i in 1..24}:   hTES1__HTES_H_W_T_M_IT_6[i] == hTES1__HTES_AdCM_Out__T[i] ;# "Temperature that goes to the AdCM[degC]";
HTES_constraint11{i in 1..24}:   hTES1__m_dot_AdCM_HT[i] == hTES1__HTES_AdCM_In__m_dot[i] ;# "Mass flow entering from the AdCM [kg/s]";
HTES_constraint12{i in 1..24}:   hTES1__T_HTES_AdCM_RL[i] == hTES1__HTES_AdCM_In__T[i] ;# "Temperature coming back from the AdCM [degC]";
HTES_constraint13{i in 1..24}:   hTES1__T_HTES_CHP_In_K[i] == 273.15 + hTES1__T_HTES_CHP_In[i];
HTES_constraint14{i in 1..24}:   hTES1__T_HTES_RevHP_In_K[i] == 273.15 + hTES1__T_HTES_RevHP_In[i];
HTES_constraint15{i in 1..24}:   hTES1__HTES_H_W_T_M_IT_1_K[i] == 273.15 + hTES1__HTES_H_W_T_M_IT_1[i];
HTES_constraint16{i in 1..24}:   hTES1__HTES_H_W_T_M_IT_2_K[i] == 273.15 + hTES1__HTES_H_W_T_M_IT_2[i];
HTES_constraint17{i in 1..24}:   hTES1__HTES_H_W_T_M_IT_3_K[i] == 273.15 + hTES1__HTES_H_W_T_M_IT_3[i];
HTES_constraint18{i in 1..24}:   hTES1__HTES_H_W_T_M_IT_4_K[i] == 273.15 + hTES1__HTES_H_W_T_M_IT_4[i];
HTES_constraint19{i in 1..24}:   hTES1__HTES_H_W_T_M_IT_5_K[i] == 273.15 + hTES1__HTES_H_W_T_M_IT_5[i];
HTES_constraint20{i in 1..24}:   hTES1__HTES_H_W_T_M_IT_6_K[i] == 273.15 + hTES1__HTES_H_W_T_M_IT_6[i];
HTES_constraint21{i in 1..24}:   hTES1__HTES_H_W_T_M_IT_7_K[i] == 273.15 + hTES1__HTES_H_W_T_M_IT_7[i];
HTES_constraint22{i in 1..24}:   hTES1__HTES_H_W_T_M_IT_8_K[i] == 273.15 + hTES1__HTES_H_W_T_M_IT_8[i];
HTES_constraint23{i in 1..24}:   hTES1__HTES_H_W_T_M_IT_9_K[i] == 273.15 + hTES1__HTES_H_W_T_M_IT_9[i];
HTES_constraint24{i in 1..24}:   hTES1__T_ini_K[i] == 273.15 + hTES1__T_ini;
HTES_constraint25{i in 1..24}:   hTES1__T_amb_K[i] == 273.15 + hTES1__T_amb;
HTES_constraint26{i in 1..24}:   hTES1__T_HTES_LOAD_RL_K[i] == 273.15 + hTES1__T_HTES_LOAD_RL[i];
HTES_constraint27{i in 1..24}:   hTES1__T_HTES_AdCM_RL_K[i] == 273.15 + hTES1__T_HTES_AdCM_RL[i];
HTES_constraint28{i in 1..24}:   hTES1__cp1[i] == 4.20511 + -0.00136578 * hTES1__HTES_H_W_T_M_IT_1_K[i] + 1.52341e-005 * hTES1__HTES_H_W_T_M_IT_1_K[i] ^ 2;
HTES_constraint29{i in 1..24}:   hTES1__cp2[i] == 4.20511 + -0.00136578 * hTES1__HTES_H_W_T_M_IT_2_K[i] + 1.52341e-005 * hTES1__HTES_H_W_T_M_IT_2_K[i] ^ 2;
HTES_constraint30{i in 1..24}:   hTES1__cp3[i] == 4.20511 + -0.00136578 * hTES1__HTES_H_W_T_M_IT_3_K[i] + 1.52341e-005 * hTES1__HTES_H_W_T_M_IT_3_K[i] ^ 2;
HTES_constraint31{i in 1..24}:   hTES1__cp4[i] == 4.20511 + -0.00136578 * hTES1__HTES_H_W_T_M_IT_4_K[i] + 1.52341e-005 * hTES1__HTES_H_W_T_M_IT_4_K[i] ^ 2;
HTES_constraint32{i in 1..24}:   hTES1__cp5[i] == 4.20511 + -0.00136578 * hTES1__HTES_H_W_T_M_IT_5_K[i] + 1.52341e-005 * hTES1__HTES_H_W_T_M_IT_5_K[i] ^ 2;
HTES_constraint33{i in 1..24}:   hTES1__cp6[i] == 4.20511 + -0.00136578 * hTES1__HTES_H_W_T_M_IT_6_K[i] + 1.52341e-005 * hTES1__HTES_H_W_T_M_IT_6_K[i] ^ 2;
HTES_constraint34{i in 1..24}:   hTES1__cp7[i] == 4.20511 + -0.00136578 * hTES1__HTES_H_W_T_M_IT_7_K[i] + 1.52341e-005 * hTES1__HTES_H_W_T_M_IT_7_K[i] ^ 2;
HTES_constraint35{i in 1..24}:   hTES1__cp8[i] == 4.20511 + -0.00136578 * hTES1__HTES_H_W_T_M_IT_8_K[i] + 1.52341e-005 * hTES1__HTES_H_W_T_M_IT_8_K[i] ^ 2;
HTES_constraint36{i in 1..24}:   hTES1__cp9[i] == 4.20511 + -0.00136578 * hTES1__HTES_H_W_T_M_IT_9_K[i] + 1.52341e-005 * hTES1__HTES_H_W_T_M_IT_9_K[i] ^ 2;
#HTES_constraint37{i in 1..24}:   hTES1__cp9[i] * hTES1__mi * der(hTES1__HTES_H_W_T_M_IT_9_K[i]) == hTES1__Alayer * hTES1__lambda_eff * (hTES1__HTES_H_W_T_M_IT_8_K[i] - hTES1__HTES_H_W_T_M_IT_9_K[i]) / hTES1__zi + hTES1__cp9[i] * (hTES1__m_dot_CHP[i] * (hTES1__T_HTES_CHP_In_K[i] - hTES1__HTES_H_W_T_M_IT_9_K[i]) + hTES1__m_dot_RevHP_HT[i] * (hTES1__T_HTES_RevHP_In_K[i] - hTES1__HTES_H_W_T_M_IT_9_K[i])) - hTES1__Aamb * hTES1__kappa * (hTES1__HTES_H_W_T_M_IT_9_K[i] - hTES1__T_amb_K[i]); 
HTES_constraint37{i in 1..24}:   hTES1__cp9[i] * hTES1__mi * (hTES1__HTES_H_W_T_M_IT_9_K[i]) == hTES1__Alayer * hTES1__lambda_eff * (hTES1__HTES_H_W_T_M_IT_8_K[i] - hTES1__HTES_H_W_T_M_IT_9_K[i]) / hTES1__zi + hTES1__cp9[i] * (hTES1__m_dot_CHP[i] * (hTES1__T_HTES_CHP_In_K[i] - hTES1__HTES_H_W_T_M_IT_9_K[i]) + hTES1__m_dot_RevHP_HT[i] * (hTES1__T_HTES_RevHP_In_K[i] - hTES1__HTES_H_W_T_M_IT_9_K[i])) - hTES1__Aamb * hTES1__kappa * (hTES1__HTES_H_W_T_M_IT_9_K[i] - hTES1__T_amb_K[i]); 
HTES_constraint38{i in 1..24}:   hTES1__m_dot8[i] == hTES1__m_dot_CHP[i] + hTES1__m_dot_RevHP_HT[i];
#HTES_constraint39{i in 1..24}:   hTES1__cp8[i] * hTES1__mi * der(hTES1__HTES_H_W_T_M_IT_8_K[i]) == hTES1__Alayer * hTES1__lambda_eff * (hTES1__HTES_H_W_T_M_IT_7_K[i] + -2.0 * hTES1__HTES_H_W_T_M_IT_8_K[i] + hTES1__HTES_H_W_T_M_IT_9_K[i]) / hTES1__zi + hTES1__cp8[i] * hTES1__m_dot8[i] * (hTES1__HTES_H_W_T_M_IT_9_K[i] - hTES1__HTES_H_W_T_M_IT_8_K[i]) - hTES1__Aamb * hTES1__kappa * (hTES1__HTES_H_W_T_M_IT_8_K[i] - hTES1__T_amb_K[i]);
HTES_constraint39{i in 1..24}:   hTES1__cp8[i] * hTES1__mi * (hTES1__HTES_H_W_T_M_IT_8_K[i]) == hTES1__Alayer * hTES1__lambda_eff * (hTES1__HTES_H_W_T_M_IT_7_K[i] + -2.0 * hTES1__HTES_H_W_T_M_IT_8_K[i] + hTES1__HTES_H_W_T_M_IT_9_K[i]) / hTES1__zi + hTES1__cp8[i] * hTES1__m_dot8[i] * (hTES1__HTES_H_W_T_M_IT_9_K[i] - hTES1__HTES_H_W_T_M_IT_8_K[i]) - hTES1__Aamb * hTES1__kappa * (hTES1__HTES_H_W_T_M_IT_8_K[i] - hTES1__T_amb_K[i]);
HTES_constraint40{i in 1..24}:   hTES1__m_dot7[i] == hTES1__m_dot8[i];
#HTES_constraint41{i in 1..24}:   hTES1__cp7[i] * hTES1__mi * der(hTES1__HTES_H_W_T_M_IT_7_K[i]) == hTES1__Alayer * hTES1__lambda_eff * (hTES1__HTES_H_W_T_M_IT_6_K[i] + -2.0 * hTES1__HTES_H_W_T_M_IT_7_K[i] + hTES1__HTES_H_W_T_M_IT_8_K[i]) / hTES1__zi + hTES1__cp7[i] * hTES1__m_dot7[i] * (hTES1__HTES_H_W_T_M_IT_8_K[i] - hTES1__HTES_H_W_T_M_IT_7_K[i]) - hTES1__Aamb * hTES1__kappa * (hTES1__HTES_H_W_T_M_IT_7_K[i] - hTES1__T_amb_K[i]);
HTES_constraint41{i in 1..24}:   hTES1__cp7[i] * hTES1__mi * (hTES1__HTES_H_W_T_M_IT_7_K[i]) == hTES1__Alayer * hTES1__lambda_eff * (hTES1__HTES_H_W_T_M_IT_6_K[i] + -2.0 * hTES1__HTES_H_W_T_M_IT_7_K[i] + hTES1__HTES_H_W_T_M_IT_8_K[i]) / hTES1__zi + hTES1__cp7[i] * hTES1__m_dot7[i] * (hTES1__HTES_H_W_T_M_IT_8_K[i] - hTES1__HTES_H_W_T_M_IT_7_K[i]) - hTES1__Aamb * hTES1__kappa * (hTES1__HTES_H_W_T_M_IT_7_K[i] - hTES1__T_amb_K[i]);
HTES_constraint42{i in 1..24}:   hTES1__m_dot6[i] == hTES1__m_dot7[i] + (-hTES1__m_dot_LOAD[i]) - hTES1__m_dot_AdCM_HT[i];
#HTES_constraint43{i in 1..24}:   if hTES1__m_dot6[i] < 0.0 then
#     hTES1__cp6 * hTES1__mi * der(hTES1__HTES_H_W_T_M_IT_6_K[i]) == hTES1__Alayer * hTES1__lambda_eff * (hTES1__HTES_H_W_T_M_IT_5_K[i] + -2.0 * hTES1__HTES_H_W_T_M_IT_6_K[i] + hTES1__HTES_H_W_T_M_IT_7_K[i]) / hTES1__zi + hTES1__cp6[i] * hTES1__m_dot6[i] * (hTES1__HTES_H_W_T_M_IT_6_K[i] - hTES1__HTES_H_W_T_M_IT_5_K[i]) - hTES1__Aamb * hTES1__kappa * (hTES1__HTES_H_W_T_M_IT_6_K[i] - hTES1__T_amb_K[i]);
#   else
#    hTES1__cp6[i] * hTES1__mi * der(hTES1__HTES_H_W_T_M_IT_6_K[i]) == hTES1__Alayer * hTES1__lambda_eff * (hTES1__HTES_H_W_T_M_IT_5_K[i] + -2.0 * hTES1__HTES_H_W_T_M_IT_6_K[i] + hTES1__HTES_H_W_T_M_IT_7_K[i]) / hTES1__zi + hTES1__cp6[i] * hTES1__m_dot6[i] * (hTES1__HTES_H_W_T_M_IT_7_K[i] - hTES1__HTES_H_W_T_M_IT_6_K[i]) - hTES1__Aamb * hTES1__kappa * (hTES1__HTES_H_W_T_M_IT_6_K[i] - hTES1__T_amb_K[i]);
#   end if;
HTES_constraint43{i in 1..24}:   hTES1__cp6[i] * hTES1__mi * (hTES1__HTES_H_W_T_M_IT_6_K[i]) == hTES1__Alayer * hTES1__lambda_eff * (hTES1__HTES_H_W_T_M_IT_5_K[i] + -2.0 * hTES1__HTES_H_W_T_M_IT_6_K[i] + hTES1__HTES_H_W_T_M_IT_7_K[i]) / hTES1__zi + hTES1__cp6[i] * hTES1__m_dot6[i] * (hTES1__HTES_H_W_T_M_IT_6_K[i] - hTES1__HTES_H_W_T_M_IT_5_K[i]) - hTES1__Aamb * hTES1__kappa * (hTES1__HTES_H_W_T_M_IT_6_K[i] - hTES1__T_amb_K[i]) +    hTES1__cp7[i] * hTES1__m_dot7[i] * (hTES1__HTES_H_W_T_M_IT_7_K[i] - hTES1__HTES_H_W_T_M_IT_6_K[i]);

HTES_constraint44{i in 1..24}:   hTES1__m_dot5[i] == hTES1__m_dot6[i];
#HTES_constraint45{i in 1..24}:   if hTES1__m_dot6[i] < 0.0 then
#      hTES1__cp5[i] * hTES1__mi * der(hTES1__HTES_H_W_T_M_IT_5_K[i]) == hTES1__Alayer * hTES1__lambda_eff * (hTES1__HTES_H_W_T_M_IT_4_K[i] + -2.0 * hTES1__HTES_H_W_T_M_IT_5_K[i] + hTES1__HTES_H_W_T_M_IT_6_K[i]) / hTES1__zi + hTES1__cp5[i] * hTES1__m_dot5[i] * (hTES1__HTES_H_W_T_M_IT_5_K[i] - hTES1__HTES_H_W_T_M_IT_4_K[i]) - hTES1__Aamb * hTES1__kappa * (hTES1__HTES_H_W_T_M_IT_5_K[i] - hTES1__T_amb_K[i]);
#    else
#      hTES1__cp5[i] * hTES1__mi * der(hTES1__HTES_H_W_T_M_IT_5_K[i]) == hTES1__Alayer * hTES1__lambda_eff * (hTES1__HTES_H_W_T_M_IT_4_K[i] + -2.0 * hTES1__HTES_H_W_T_M_IT_5_K[i] + hTES1__HTES_H_W_T_M_IT_6_K[i]) / hTES1__zi + hTES1__cp5[i] * hTES1__m_dot5[i] * (hTES1__HTES_H_W_T_M_IT_6_K[i] - hTES1__HTES_H_W_T_M_IT_5_K[i]) - hTES1__Aamb * hTES1__kappa * (hTES1__HTES_H_W_T_M_IT_5_K[i] - hTES1__T_amb_K[i]);
#    end if;
HTES_constraint45{i in 1..24}:   hTES1__cp5[i] * hTES1__mi * (hTES1__HTES_H_W_T_M_IT_5_K[i]) == hTES1__Alayer * hTES1__lambda_eff * (hTES1__HTES_H_W_T_M_IT_4_K[i] + -2.0 * hTES1__HTES_H_W_T_M_IT_5_K[i] + hTES1__HTES_H_W_T_M_IT_6_K[i]) / hTES1__zi + hTES1__cp5[i] * hTES1__m_dot5[i] * (hTES1__HTES_H_W_T_M_IT_5_K[i] - hTES1__HTES_H_W_T_M_IT_4_K[i]) - hTES1__Aamb * hTES1__kappa * (hTES1__HTES_H_W_T_M_IT_5_K[i] - hTES1__T_amb_K[i]) + hTES1__cp5[i] * hTES1__m_dot5[i] * (hTES1__HTES_H_W_T_M_IT_6_K[i] - hTES1__HTES_H_W_T_M_IT_5_K[i]) ;

HTES_constraint46{i in 1..24}:   hTES1__m_dot4[i] == hTES1__m_dot5[i];
#HTES_constraint47{i in 1..24}:   if hTES1__m_dot6[i] < 0.0 then
#      hTES1__cp4[i] * hTES1__mi * der(hTES1__HTES_H_W_T_M_IT_4_K[i]) == hTES1__Alayer * hTES1__lambda_eff * (hTES1__HTES_H_W_T_M_IT_3_K[i] + -2.0 * hTES1__HTES_H_W_T_M_IT_4_K[i] + hTES1__HTES_H_W_T_M_IT_5_K[i]) / hTES1__zi + hTES1__cp4[i] * hTES1__m_dot4[i] * (hTES1__HTES_H_W_T_M_IT_4_K[i] - hTES1__HTES_H_W_T_M_IT_3_K[i]) - hTES1__Aamb * hTES1__kappa * (hTES1__HTES_H_W_T_M_IT_4_K[i] - hTES1__T_amb_K[i]);
#    else
#      hTES1__cp4[i] * hTES1__mi * der(hTES1__HTES_H_W_T_M_IT_4_K[i]) == hTES1__Alayer * hTES1__lambda_eff * (hTES1__HTES_H_W_T_M_IT_3_K[i] + -2.0 * hTES1__HTES_H_W_T_M_IT_4_K[i] + hTES1__HTES_H_W_T_M_IT_5_K[i]) / hTES1__zi + hTES1__cp4[i] * hTES1__m_dot4[i] * (hTES1__HTES_H_W_T_M_IT_5_K[i] - hTES1__HTES_H_W_T_M_IT_4_K[i]) - hTES1__Aamb * hTES1__kappa * (hTES1__HTES_H_W_T_M_IT_4_K[i] - hTES1__T_amb_K[i]);
#    end if;
HTES_constraint47{i in 1..24}:   hTES1__cp4[i] * hTES1__mi * (hTES1__HTES_H_W_T_M_IT_4_K[i]) == hTES1__Alayer * hTES1__lambda_eff * (hTES1__HTES_H_W_T_M_IT_3_K[i] + -2.0 * hTES1__HTES_H_W_T_M_IT_4_K[i] + hTES1__HTES_H_W_T_M_IT_5_K[i]) / hTES1__zi + hTES1__cp4[i] * hTES1__m_dot4[i] * (hTES1__HTES_H_W_T_M_IT_4_K[i] - hTES1__HTES_H_W_T_M_IT_3_K[i]) - hTES1__Aamb * hTES1__kappa * (hTES1__HTES_H_W_T_M_IT_4_K[i] - hTES1__T_amb_K[i]) + hTES1__cp4[i] * hTES1__m_dot4[i] * (hTES1__HTES_H_W_T_M_IT_5_K[i] - hTES1__HTES_H_W_T_M_IT_4_K[i]);

HTES_constraint48{i in 1..24}:   hTES1__m_dot3[i] == hTES1__m_dot4[i];
#HTES_constraint49{i in 1..24}:   if hTES1__m_dot6[i] < 0.0 then
#      hTES1__cp3[i] * hTES1__mi * der(hTES1__HTES_H_W_T_M_IT_3_K[i]) == hTES1__Alayer * hTES1__lambda_eff * (hTES1__HTES_H_W_T_M_IT_2_K[i] + -2.0 * hTES1__HTES_H_W_T_M_IT_3_K[i] + hTES1__HTES_H_W_T_M_IT_4_K[i]) / hTES1__zi + hTES1__cp3[i] * hTES1__m_dot3[i] * (hTES1__HTES_H_W_T_M_IT_3_K[i] - hTES1__HTES_H_W_T_M_IT_2_K[i]) - hTES1__Aamb * hTES1__kappa * (hTES1__HTES_H_W_T_M_IT_3_K[i] - hTES1__T_amb_K[i]);
#    else
#      hTES1__cp3[i] * hTES1__mi * der(hTES1__HTES_H_W_T_M_IT_3_K[i]) == hTES1__Alayer * hTES1__lambda_eff * (hTES1__HTES_H_W_T_M_IT_2_K[i] + -2.0 * hTES1__HTES_H_W_T_M_IT_3_K[i] + hTES1__HTES_H_W_T_M_IT_4_K[i]) / hTES1__zi + hTES1__cp3[i] * hTES1__m_dot3[i] * (hTES1__HTES_H_W_T_M_IT_4_K[i] - hTES1__HTES_H_W_T_M_IT_3_K[i]) - hTES1__Aamb * hTES1__kappa * (hTES1__HTES_H_W_T_M_IT_3_K[i] - hTES1__T_amb_K[i]);
#    end if;
HTES_constraint49{i in 1..24}:   hTES1__cp3[i] * hTES1__mi * (hTES1__HTES_H_W_T_M_IT_3_K[i]) == hTES1__Alayer * hTES1__lambda_eff * (hTES1__HTES_H_W_T_M_IT_2_K[i] + -2.0 * hTES1__HTES_H_W_T_M_IT_3_K[i] + hTES1__HTES_H_W_T_M_IT_4_K[i]) / hTES1__zi + hTES1__cp3[i] * hTES1__m_dot3[i] * (hTES1__HTES_H_W_T_M_IT_3_K[i] - hTES1__HTES_H_W_T_M_IT_2_K[i]) - hTES1__Aamb * hTES1__kappa * (hTES1__HTES_H_W_T_M_IT_3_K[i] - hTES1__T_amb_K[i]) + hTES1__cp3[i] * hTES1__m_dot3[i] * (hTES1__HTES_H_W_T_M_IT_4_K[i] - hTES1__HTES_H_W_T_M_IT_3_K[i]);

HTES_constraint50{i in 1..24}:   hTES1__m_dot2[i] == hTES1__m_dot3[i];
#HTES_constraint51{i in 1..24}:    if hTES1__m_dot6[i] < 0.0 then
#      hTES1__cp2[i] * hTES1__mi * der(hTES1__HTES_H_W_T_M_IT_2_K[i]) == hTES1__Alayer * hTES1__lambda_eff * (hTES1__HTES_H_W_T_M_IT_1_K[i] + -2.0 * hTES1__HTES_H_W_T_M_IT_2_K[i] + hTES1__HTES_H_W_T_M_IT_3_K[i]) / hTES1__zi + hTES1__cp2[i] * hTES1__m_dot2[i] * (hTES1__HTES_H_W_T_M_IT_2_K[i] - hTES1__HTES_H_W_T_M_IT_1_K[i]) - hTES1__Aamb * hTES1__kappa * (hTES1__HTES_H_W_T_M_IT_2_K[i] - hTES1__T_amb_K[i]);
#    else
#      hTES1__cp2[i] * hTES1__mi * der(hTES1__HTES_H_W_T_M_IT_2_K[i]) == hTES1__Alayer * hTES1__lambda_eff * (hTES1__HTES_H_W_T_M_IT_1_K[i] + -2.0 * hTES1__HTES_H_W_T_M_IT_2_K[i] + hTES1__HTES_H_W_T_M_IT_3_K[i]) / hTES1__zi + hTES1__cp2[i] * hTES1__m_dot2[i] * (hTES1__HTES_H_W_T_M_IT_3_K[i] - hTES1__HTES_H_W_T_M_IT_2_K[i]) - hTES1__Aamb * hTES1__kappa * (hTES1__HTES_H_W_T_M_IT_2_K[i] - hTES1__T_amb_K[i]);
#    end if;
HTES_constraint51{i in 1..24}:   hTES1__cp2[i] * hTES1__mi * (hTES1__HTES_H_W_T_M_IT_2_K[i]) == hTES1__Alayer * hTES1__lambda_eff * (hTES1__HTES_H_W_T_M_IT_1_K[i] + -2.0 * hTES1__HTES_H_W_T_M_IT_2_K[i] + hTES1__HTES_H_W_T_M_IT_3_K[i]) / hTES1__zi + hTES1__cp2[i] * hTES1__m_dot2[i] * (hTES1__HTES_H_W_T_M_IT_2_K[i] - hTES1__HTES_H_W_T_M_IT_1_K[i]) - hTES1__Aamb * hTES1__kappa * (hTES1__HTES_H_W_T_M_IT_2_K[i] - hTES1__T_amb_K[i]) + hTES1__cp2[i] * hTES1__m_dot2[i] * (hTES1__HTES_H_W_T_M_IT_3_K[i] - hTES1__HTES_H_W_T_M_IT_2_K[i]);

HTES_constraint52{i in 1..24}:   hTES1__m_dot1[i] == hTES1__m_dot2[i] + hTES1__m_dot_LOAD[i] + hTES1__m_dot_AdCM_HT[i] ;# "Total mass flow getting out of the layer 1";
HTES_constraint53{i in 1..24}:   hTES1__cp1[i] * hTES1__mi * (hTES1__HTES_H_W_T_M_IT_1_K[i]) == hTES1__Alayer * hTES1__lambda_eff * (hTES1__HTES_H_W_T_M_IT_2_K[i] - hTES1__HTES_H_W_T_M_IT_1_K[i]) / hTES1__zi + hTES1__cp1[i] * (hTES1__m_dot_LOAD[i] * (hTES1__T_HTES_LOAD_RL_K[i] - hTES1__HTES_H_W_T_M_IT_1_K[i]) + hTES1__m_dot_AdCM_HT[i] * (hTES1__T_HTES_AdCM_RL_K[i] - hTES1__HTES_H_W_T_M_IT_1_K[i])) + hTES1__cp2[i] * hTES1__m_dot2[i] * (hTES1__HTES_H_W_T_M_IT_2_K[i] - hTES1__HTES_H_W_T_M_IT_1_K[i]) - hTES1__Aamb * hTES1__kappa * (hTES1__HTES_H_W_T_M_IT_1_K[i] - hTES1__T_amb_K[i]);
  
#//==================== Constraints from Connectors ==================================
Connector_constraint1{i in 1..24}:   hTES1__HTES_RevHP_In__T[i] == revHP_HP1__RevHP_HTES_Out__T[i];
Connector_constraint2{i in 1..24}:   hTES1__HTES_RevHP_In__m_dot[i] == revHP_HP1__RevHP_HTES_Out__m_dot[i];
Connector_constraint3{i in 1..24}:   adCM1__AdCM_HTES_Out__T[i] == hTES1__HTES_AdCM_In__T[i];
Connector_constraint4{i in 1..24}:   adCM1__AdCM_HTES_Out__m_dot[i] == hTES1__HTES_AdCM_In__m_dot[i];
Connector_constraint5{i in 1..24}:   adCM1__AdCM_HTES_In__T[i] == hTES1__HTES_AdCM_Out__T[i];
Connector_constraint6{i in 1..24}:   cHPUnit1__CHP_HTES_In__T[i] == hTES1__HTES_CHP_Out__T[i];
Connector_constraint7{i in 1..24}:   adCM1__AdCM_CTES_Out__T[i] == cTES11__CTES_AdCM_In__T[i];
Connector_constraint8{i in 1..24}:   adCM1__AdCM_CTES_Out__m_dot[i] == cTES11__CTES_AdCM_In__m_dot[i];
Connector_constraint9{i in 1..24}:   adCM1__AdCM_CTES_In__T[i] == cTES11__CTES_AdCM_Out__T[i];
Connector_constraint10{i in 1..24}:   cTES11__CTES_RevHP_Out__T[i] == revHP_CC_Equation1__RevHP_CTES_In__T[i];
Connector_constraint11{i in 1..24}:   cTES11__CTES_RevHP_In__T[i] == revHP_CC_Equation1__RevHP_CTES_Out__T[i];
Connector_constraint12{i in 1..24}:   cTES11__CTES_RevHP_In__m_dot[i] == revHP_CC_Equation1__RevHP_CTES_Out__m_dot[i];
Connector_constraint13{i in 1..24}:   hTES1__HTES_RevHP_Out__T[i] == revHP_HP1__RevHP_HTES_In__T[i];
Connector_constraint14{i in 1..24}:   hTES1__HTES_LOAD_Out__T[i] == lOAD1__LOAD_In__T[i];
Connector_constraint15{i in 1..24}:   cHPUnit1__CHP_HTES_Out__T[i] == hTES1__HTES_CHP_In__T[i];
Connector_constraint16{i in 1..24}:   cHPUnit1__CHP_HTES_Out__m_dot[i] == hTES1__HTES_CHP_In__m_dot[i];
Connector_constraint17{i in 1..24}:   hTES1__HTES_LOAD_In__T[i] == lOAD1__LOAD_Out__T[i];
Connector_constraint18{i in 1..24}:   hTES1__HTES_LOAD_In__m_dot[i] == lOAD1__LOAD_Out__m_dot[i];
Connector_constraint19{i in 1..24}:   cTES11__CTES_LOAD_Out__T[i] == lOAD_C1__LOAD_In__T[i];
Connector_constraint20{i in 1..24}:   cTES11__CTES_LOAD_In__T[i] == lOAD_C1__LOAD_Out__T[i];
Connector_constraint21{i in 1..24}:   cTES11__CTES_LOAD_In__m_dot[i] == lOAD_C1__LOAD_Out__m_dot[i];
Connector_constraint22{i in 1..24}:   adCM1__AdCM_OC_In__T[i] == outdoorCoil_Equation1__OC_Out__T[i];
Connector_constraint23{i in 1..24}:   adCM1__AdCM_OC_Out__T[i] == outdoorCoil_Equation1__OC_In__T[i];
Connector_constraint24{i in 1..24}:   adCM1__AdCM_OC_Out__m_dot[i] == outdoorCoil_Equation1__OC_In__m_dot[i];
Connector_constraint25{i in 1..24}:   OutdoorCoil_RevHP__OC_Out__T[i] == revHP_HP1__RevHP_OC_In__T[i];
Connector_constraint26{i in 1..24}:   OutdoorCoil_RevHP__OC_In__T[i] == revHP_HP1__RevHP_OC_Out__T[i];
Connector_constraint27{i in 1..24}:   OutdoorCoil_RevHP__OC_In__m_dot[i] == revHP_HP1__RevHP_OC_Out__m_dot[i];
Connector_constraint28{i in 1..24}:   outdoorCoil_Equation2__OC_In__T[i] == revHP_CC_Equation1__RevHP_OC_Out__T[i];
Connector_constraint29{i in 1..24}:   outdoorCoil_Equation2__OC_In__m_dot[i] == revHP_CC_Equation1__RevHP_OC_Out__m_dot[i];
Connector_constraint30{i in 1..24}:   outdoorCoil_Equation2__OC_Out__T[i] == revHP_CC_Equation1__RevHP_OC_In__T[i];

#just some dump data
#param c_elec_buy: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24:=
#                1 1 2 3 4 5 6 7 8 9 10 10 10  9  8 10 10 10  8  6  5  4  2  1  1;
#
#param c_elec_sell: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24:=
#                 1 0 1 2 3 4 5 6 7 8  9  9  9  8  7  8  9  9  7  5  4  3  1  0  0;
#
#param p_load: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24:=
#            1 80 81 82 83 84 85 86 87 88  89  89 69 68 67 58  49 89 97 65 54 43 41 20 20;
#
#param q_ther_load: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24:=
#            1 380 281 182 183 184 185 186 187 8  9  10 9 8 7 58  79 89 197 265 254 443 441 320 320;



#option solver cplex;
#option cplex_options "reqconvex=2";

#option solver scip; # seems to diverge
option solver knitro;
option knitro_options "multistart=1";
#obj = 2540.71

#option solver xpress;
#option solver couenne;
#obj = 2540.71

solve;

#display xp, xq;

#display p_grid_item;

#display E_tank;

#display s_chp, s_coil;

display obj;
