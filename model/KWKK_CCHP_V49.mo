package KWKK_CCHP_V49
  package SimModels
    model KWKK_LOOP
      KWKK_CCHP_V49.Components.Switch Switch(AdCM_ON = false, CHP_ON = true, Coil_ON = false, RevHP_CC_ON = true, RevHP_HP_ON = false) annotation(
        Placement(visible = true, transformation(origin = {-60, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Components.CHPUnit CHP(Higher_Temp_Limit = 50, Lower_Temp_Limit = 50) annotation(
        Placement(visible = true, transformation(origin = {-70, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Components.LOAD Load(Pth_CC = 2, T_CC_FL = 35, v_dot_CC = 1) annotation(
        Placement(visible = true, transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      KWKK_CCHP_V49.Components.PlateHeatExchanger_NTU HX_3_Small annotation(
        Placement(visible = true, transformation(origin = {-30, -30}, extent = {{10, 10}, {-10, -10}}, rotation = -90)));
      Components.AdCM AdCM(Lower_Temp_Limit = 12) annotation(
        Placement(visible = true, transformation(origin = {-10, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Components.PlateHeatExchanger_NTU HX_1_Big(A = 7.83, U = 2.151) annotation(
        Placement(visible = true, transformation(origin = {-10, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Components.RevHP_HP RevHP_HP(Lower_Temp_Limit = 40, v_dot_HT_FL_set = 2.79, v_dot_MT_FL_set = 2.45) annotation(
        Placement(visible = true, transformation(origin = {10, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Components.PlateHeatExchanger_NTU HX_2_Big(A = 7.83, U = 2.151) annotation(
        Placement(visible = true, transformation(origin = {10, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
      Components.RevHP_CC RevHP_CC(v_dot_LT_FL_set = 2.45, v_dot_MT_FL_set = 2.62) annotation(
        Placement(visible = true, transformation(origin = {70, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Components.LOAD_C Load_C(Pth_CC = 2, T_CC_FL = 16, v_dot_CC = 1) annotation(
        Placement(visible = true, transformation(origin = {70, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Components.Ambient_T Ambient(T_amb = 22) annotation(
        Placement(visible = true, transformation(origin = {-126, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Components.HTES_Loop HTES_Loop(AdCM_FL_Layer = 80, T_ini_set = 50, v_dot_RevHP_HT_Set = 1.1) annotation(
        Placement(visible = true, transformation(origin = {-70, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Components.OutdoorCoil_NTU OC_1 annotation(
        Placement(visible = true, transformation(origin = {-10, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Components.OutdoorCoil_NTU OC_2 annotation(
        Placement(visible = true, transformation(origin = {10, -88}, extent = {{-8, 8}, {8, -8}}, rotation = 0)));
      Components.OutdoorCoil_NTU_CCM OC_3_RevHP annotation(
        Placement(visible = true, transformation(origin = {70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Components.CTES_Loop CTES_Loop(T_ini_set = 15, kappa = 0.001) annotation(
        Placement(visible = true, transformation(origin = {70, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(HTES_Loop.v_HT, RevHP_HP.V_HT) annotation(
        Line(points = {{-62, -20}, {-62, -20}, {-62, -50}, {-10, -50}, {-10, -40}, {2, -40}, {2, -40}}, color = {255, 255, 255}, pattern = LinePattern.DashDotDot));
      connect(HX_3_Small.HX_OC_in, HTES_Loop.HTES_HX_Out) annotation(
        Line(points = {{-34, -40}, {-34, -40}, {-34, -44}, {-54, -44}, {-54, -16}, {-60, -16}, {-60, -16}}));
      connect(HX_3_Small.HX_OC_Out, HTES_Loop.HTES_HX_In) annotation(
        Line(points = {{-34, -20}, {-34, -20}, {-34, -12}, {-60, -12}, {-60, -12}}));
      connect(RevHP_HP.RevHP_HX_HT_In, HX_3_Small.HX_AdCM_Out) annotation(
        Line(points = {{0, -34}, {-16, -34}, {-16, -44}, {-26, -44}, {-26, -40}, {-26, -40}, {-26, -40}}));
      connect(RevHP_HP.RevHP_HX_HT_Out, HX_3_Small.HX_AdCM_in) annotation(
        Line(points = {{0, -26}, {-10, -26}, {-10, -12}, {-26, -12}, {-26, -20}, {-26, -20}, {-26, -20}}));
      connect(Switch.Coil_Switch, HTES_Loop.Coil_ON) annotation(
        Line(points = {{-80, 88}, {-90, 88}, {-90, -8}, {-80, -8}, {-80, -8}}, pattern = LinePattern.DashDotDot));
      connect(Ambient.Amb_Temp, HTES_Loop.T_amb) annotation(
        Line(points = {{-106, 0}, {-94, 0}, {-94, -16}, {-80, -16}, {-80, -16}}, color = {255, 255, 255}));
      connect(Switch.RevHP_CC_Switch, RevHP_CC.RevHP_CC_ON) annotation(
        Line(points = {{-48, 60}, {-48, 54}, {-32, 54}, {-32, 88}, {20, 88}, {20, 38}, {60, 38}}, pattern = LinePattern.DashDotDot, thickness = 0));
      connect(Switch.CHP_Switch, CHP.CHP_ON) annotation(
        Line(points = {{-72, 60}, {-72, 49}, {-76, 49}, {-76, 40}}, pattern = LinePattern.DashDotDot, thickness = 0));
      connect(Switch.AdCM_Switch, AdCM.AdCM_ON) annotation(
        Line(points = {{-64, 60}, {-64, 44}, {-54, 44}, {-54, 20}, {-20, 20}}, pattern = LinePattern.DashDotDot, thickness = 0));
      connect(Switch.RevHP_HP_Switch, RevHP_HP.RevHP_HP_ON) annotation(
        Line(points = {{-56, 60}, {-56, 48}, {-40, 48}, {-40, -6}, {4, -6}, {4, -20}}, pattern = LinePattern.DashDotDot, thickness = 0, arrowSize = 1));
      connect(HTES_Loop.DobleTempOut, RevHP_HP.DobleTempIn) annotation(
        Line(points = {{-70, 0}, {-70, 0}, {-70, 2}, {-30, 2}, {-30, -4}, {10, -4}, {10, -20}, {10, -20}}, color = {255, 255, 255}));
      connect(AdCM.DobleT_In_CTES, CTES_Loop.DobleTempOut) annotation(
        Line(points = {{0, 10}, {70, 10}, {70, 0}, {70, 0}}, color = {255, 255, 255}));
      connect(CTES_Loop.DobleTempOut, RevHP_CC.DoubleTempIn) annotation(
        Line(points = {{70, 0}, {70, 0}, {70, 20}, {70, 20}}, color = {255, 255, 255}));
      connect(HTES_Loop.DobleTempOut, CHP.DobleTempIn) annotation(
        Line(points = {{-70, 0}, {-70, 0}, {-70, 20}, {-70, 20}}, color = {255, 255, 255}));
      connect(Ambient.Amb_Temp, OC_2.T_amb) annotation(
        Line(points = {{-106, 0}, {-106, -96}, {10, -96}}, color = {255, 255, 255}));
      connect(CTES_Loop.T_amb, Ambient.Amb_Temp) annotation(
        Line(points = {{80, -10}, {96, -10}, {96, 102}, {-106, 102}, {-106, 0}}, color = {255, 255, 255}));
      connect(OC_3_RevHP.T_amb, Ambient.Amb_Temp) annotation(
        Line(points = {{70, 80}, {70, 102}, {-106, 102}, {-106, 0}}, color = {255, 255, 255}));
      connect(Ambient.Amb_Temp, OC_1.T_amb) annotation(
        Line(points = {{-106, 0}, {-106, 102}, {-10, 102}, {-10, 80}}, color = {255, 255, 255}));
      connect(OC_2.OC_HX_Out, HX_2_Big.HX_AdCM_in) annotation(
        Line(points = {{7, -80}, {7, -72}, {-6, -72}, {-6, -64}, {0, -64}}, color = {0, 170, 0}, pattern = LinePattern.Dash));
      connect(OC_2.OC_HX_in, HX_2_Big.HX_AdCM_Out) annotation(
        Line(points = {{13, -80}, {13, -72}, {26, -72}, {26, -64}, {20, -64}}, color = {0, 170, 0}));
      connect(HX_2_Big.HX_OC_in, RevHP_HP.RevHP_HX_MT_Out) annotation(
        Line(points = {{20, -56}, {26, -56}, {26, -48}, {14, -48}, {14, -40}, {14, -40}}, color = {0, 170, 0}, pattern = LinePattern.Dash));
      connect(HX_2_Big.HX_OC_Out, RevHP_HP.RevHP_HX_MT_In) annotation(
        Line(points = {{0, -56}, {-6, -56}, {-6, -48}, {6, -48}, {6, -40}, {6, -40}}, color = {0, 170, 0}));
      connect(OC_1.OC_HX_in, HX_1_Big.HX_OC_Out) annotation(
        Line(points = {{-6, 60}, {-6, 60}, {-6, 52}, {6, 52}, {6, 44}, {0, 44}, {0, 44}, {0, 44}}, color = {0, 170, 0}, pattern = LinePattern.Dash));
      connect(OC_1.OC_HX_Out, HX_1_Big.HX_OC_in) annotation(
        Line(points = {{-14, 60}, {-14, 60}, {-14, 52}, {-26, 52}, {-26, 44}, {-20, 44}, {-20, 44}}, color = {0, 170, 0}));
      connect(OC_3_RevHP.OC_RevHP_Out, RevHP_CC.RevHP_OC_In) annotation(
        Line(points = {{66, 60}, {66, 60}, {66, 40}, {66, 40}}, color = {0, 170, 0}, pattern = LinePattern.Dash));
      connect(OC_3_RevHP.OC_RevHP_In, RevHP_CC.RevHP_OC_Out) annotation(
        Line(points = {{74, 60}, {74, 60}, {74, 40}, {74, 40}}, color = {0, 170, 0}));
      connect(RevHP_CC.RevHP_CTES_In, CTES_Loop.CTES_RevHP_Out) annotation(
        Line(points = {{66, 20}, {66, 20}, {66, 0}, {66, 0}}, color = {0, 0, 255}, pattern = LinePattern.Dash));
      connect(RevHP_CC.RevHP_CTES_Out, CTES_Loop.CTES_RevHP_In) annotation(
        Line(points = {{74, 20}, {74, 20}, {74, 0}, {74, 0}}, color = {0, 0, 255}));
      connect(CTES_Loop.CTES_LOAD_In, Load_C.LOAD_Out) annotation(
        Line(points = {{66, -20}, {66, -20}, {66, -60}, {66, -60}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
      connect(CTES_Loop.CTES_LOAD_Out, Load_C.LOAD_In) annotation(
        Line(points = {{74, -20}, {74, -20}, {74, -60}, {74, -60}}, color = {0, 0, 255}));
      connect(HX_1_Big.HX_AdCM_Out, AdCM.AdCM_HX_In) annotation(
        Line(points = {{-20, 36}, {-26, 36}, {-26, 26}, {-14, 26}, {-14, 20}, {-14, 20}}, color = {0, 170, 0}, pattern = LinePattern.Dash));
      connect(AdCM.AdCM_HX_Out, HX_1_Big.HX_AdCM_in) annotation(
        Line(points = {{-6, 20}, {-6, 20}, {-6, 26}, {6, 26}, {6, 36}, {0, 36}, {0, 36}}, color = {0, 170, 0}));
      connect(AdCM.AdCM_CTES_Out, CTES_Loop.CTES_AdCM_In) annotation(
        Line(points = {{0, 6}, {20, 6}, {20, -14}, {60, -14}, {60, -14}}, color = {0, 0, 255}, pattern = LinePattern.Dash));
      connect(AdCM.AdCM_CTES_In, CTES_Loop.CTES_AdCM_Out) annotation(
        Line(points = {{0, 14}, {32, 14}, {32, -6}, {60, -6}, {60, -6}}, color = {0, 85, 255}));
      connect(HTES_Loop.HTES_AdCM_In, AdCM.AdCM_HTES_Out) annotation(
        Line(points = {{-60, -8}, {-48, -8}, {-48, 6}, {-20, 6}, {-20, 6}}, color = {255, 0, 0}, pattern = LinePattern.Dash));
      connect(HTES_Loop.HTES_AdCM_Out, AdCM.AdCM_HTES_In) annotation(
        Line(points = {{-60, -4}, {-54, -4}, {-54, 14}, {-20, 14}, {-20, 14}}, color = {255, 0, 0}));
      connect(HTES_Loop.HTES_LOAD_Out, Load.LOAD_In) annotation(
        Line(points = {{-74, -20}, {-74, -20}, {-74, -60}, {-74, -60}}, color = {255, 0, 0}, pattern = LinePattern.Dash));
      connect(HTES_Loop.HTES_LOAD_In, Load.LOAD_Out) annotation(
        Line(points = {{-66, -20}, {-66, -20}, {-66, -60}, {-66, -60}}, color = {255, 0, 0}));
      connect(CHP.CHP_HTES_In, HTES_Loop.HTES_CHP_Out) annotation(
        Line(points = {{-74, 20}, {-74, 20}, {-74, 0}, {-74, 0}}, color = {255, 0, 0}, pattern = LinePattern.Dash));
      connect(CHP.CHP_HTES_Out, HTES_Loop.HTES_CHP_In) annotation(
        Line(points = {{-66, 20}, {-66, 20}, {-66, 0}, {-66, 0}}, color = {255, 0, 0}));
      annotation(
        experiment(StartTime = 0, StopTime = 160000, Tolerance = 1e-06, Interval = 109.589),
        __OpenModelica_simulationFlags(jacobian = "coloredNumerical", s = "dassl", lv = "LOG_STATS"));
    end KWKK_LOOP;



    model Table_test
      Components.CHPUnit CHP annotation(
        Placement(visible = true, transformation(origin = {-70, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Components.HTES_Loop HTES(AdCM_FL_Layer = 72, Coil_Safety_Layer = 31, Load_FL_Layer = 61, T_ini_set = 30, Temp1 = 61, h = 2.2, n = 90) annotation(
        Placement(visible = true, transformation(origin = {-70, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Components.Ambient_Table_T Ambient_T annotation(
        Placement(visible = true, transformation(origin = {-124, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Components.LOAD Load(Pth_CC = 2, T_CC_FL = 25, v_dot_CC = 1) annotation(
        Placement(visible = true, transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Components.CTES_Loop CTES(AdCM_RL_Layer = 37, Load_FL_Layer = 6, RevHP_RL_Layer = 37, T_ini_set = 16, Temp1 = 37, Temp2 = 6, h = 2.2, n = 40) annotation(
        Placement(visible = true, transformation(origin = {70, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Components.AdCM AdCM(Lower_Temp_Limit = 8, SF = 0) annotation(
        Placement(visible = true, transformation(origin = {-10, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Components.PlateHeatExchanger_NTU HX_3_Small annotation(
        Placement(visible = true, transformation(origin = {-30, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      Components.OutdoorCoil_NTU OC_1 annotation(
        Placement(visible = true, transformation(origin = {-10, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Components.PlateHeatExchanger_NTU HX_1_Big(A = 7.83, U = 2.151) annotation(
        Placement(visible = true, transformation(origin = {-10, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Components.RevHP_HP RevHP_HP annotation(
        Placement(visible = true, transformation(origin = {10, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Components.PlateHeatExchanger_NTU HX_2_Big(A = 7.83, U = 2.151) annotation(
        Placement(visible = true, transformation(origin = {10, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
      KWKK_CCHP_V49.Components.RevHP_CC Rev_HP_CC(Lower_Temp_Limit = 8, v_dot_MT_FL_set = 2.65) annotation(
        Placement(visible = true, transformation(origin = {70, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Components.OutdoorCoil_NTU_CCM OC_CCM annotation(
        Placement(visible = true, transformation(origin = {70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Components.LOAD_C LOAD_C(Pth_CC = 0, T_CC_FL = 25, v_dot_CC = 0) annotation(
        Placement(visible = true, transformation(origin = {70, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Components.OutdoorCoil_NTU OC_2 annotation(
        Placement(visible = true, transformation(origin = {10, -90}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
      KWKK_CCHP_V49.Components.Switch Switch(AdCM_ON = false, CHP_ON = false, Coil_ON = false, RevHP_CC_ON = false, RevHP_HP_ON = true) annotation(
        Placement(visible = true, transformation(origin = {-60, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    equation
      connect(Switch.RevHP_HP_Switch, RevHP_HP.RevHP_HP_ON) annotation(
        Line(points = {{-56, 60}, {-56, 60}, {-56, 44}, {-32, 44}, {-32, -6}, {4, -6}, {4, -20}, {4, -20}}, color = {0, 0, 127}));
      connect(Switch.AdCM_Switch, AdCM.AdCM_ON) annotation(
        Line(points = {{-64, 60}, {-64, 60}, {-64, 42}, {-52, 42}, {-52, 20}, {-20, 20}, {-20, 20}}, color = {0, 0, 127}));
      connect(Switch.RevHP_CC_Switch, Rev_HP_CC.RevHP_CC_ON) annotation(
        Line(points = {{-48, 60}, {-48, 60}, {-48, 52}, {-34, 52}, {-34, 88}, {18, 88}, {18, 40}, {60, 40}, {60, 40}}, color = {0, 0, 127}));
      connect(Switch.CHP_Switch, CHP.CHP_ON) annotation(
        Line(points = {{-72, 60}, {-72, 60}, {-72, 50}, {-76, 50}, {-76, 40}, {-76, 40}}, color = {0, 0, 127}));
      connect(HTES.v_HT, RevHP_HP.V_HT) annotation(
        Line(points = {{-62, -20}, {-62, -20}, {-62, -52}, {-12, -52}, {-12, -40}, {2, -40}, {2, -40}}, color = {0, 0, 127}));
      connect(Switch.Coil_Switch, HTES.Coil_ON) annotation(
        Line(points = {{-80, 88}, {-90, 88}, {-90, -8}, {-80, -8}, {-80, -8}}, color = {0, 0, 127}));
      connect(HX_3_Small.HX_OC_in, RevHP_HP.RevHP_HX_HT_Out) annotation(
        Line(points = {{-26, -20}, {-26, -12}, {-16, -12}, {-16, -26}, {0, -26}}));
      connect(HX_3_Small.HX_OC_Out, RevHP_HP.RevHP_HX_HT_In) annotation(
        Line(points = {{-26, -40}, {-26, -46}, {-16, -46}, {-16, -34}, {0, -34}}));
      connect(RevHP_HP.RevHP_HX_MT_In, HX_2_Big.HX_OC_Out) annotation(
        Line(points = {{6, -40}, {6, -46}, {-6, -46}, {-6, -56}, {0, -56}}));
      connect(RevHP_HP.RevHP_HX_MT_Out, HX_2_Big.HX_OC_in) annotation(
        Line(points = {{14, -40}, {14, -46}, {26, -46}, {26, -56}, {20, -56}}));
      connect(HTES.DobleTempOut, RevHP_HP.DobleTempIn) annotation(
        Line(points = {{-70, 0}, {-70, 2}, {-38, 2}, {-38, -10}, {10, -10}, {10, -20}}));
      connect(OC_CCM.OC_RevHP_Out, Rev_HP_CC.RevHP_OC_In) annotation(
        Line(points = {{66, 60}, {66, 42}}));
      connect(OC_CCM.OC_RevHP_In, Rev_HP_CC.RevHP_OC_Out) annotation(
        Line(points = {{74, 60}, {74, 42}}));
      connect(Rev_HP_CC.RevHP_CTES_Out, CTES.CTES_RevHP_In) annotation(
        Line(points = {{74, 22}, {74, 0}}));
      connect(Rev_HP_CC.RevHP_CTES_In, CTES.CTES_RevHP_Out) annotation(
        Line(points = {{66, 22}, {66, 0}}));
      connect(CTES.DobleTempOut, Rev_HP_CC.DoubleTempIn) annotation(
        Line(points = {{70, 0}, {70, 22}}));
      connect(AdCM.DobleT_In_CTES, CTES.DobleTempOut) annotation(
        Line(points = {{0, 10}, {70, 10}, {70, 0}, {70, 0}}));
      connect(HTES.DobleTempOut, CHP.DobleTempIn) annotation(
        Line(points = {{-70, 0}, {-70, 0}, {-70, 20}, {-70, 20}}));
      connect(HTES.HTES_LOAD_Out, Load.LOAD_In) annotation(
        Line(points = {{-74, -20}, {-74, -60}}));
      connect(HTES.HTES_LOAD_In, Load.LOAD_Out) annotation(
        Line(points = {{-66, -20}, {-66, -60}}));
      connect(HTES.HTES_HX_In, HX_3_Small.HX_AdCM_Out) annotation(
        Line(points = {{-60, -12}, {-34, -12}, {-34, -20}}));
      connect(HTES.HTES_HX_Out, HX_3_Small.HX_AdCM_in) annotation(
        Line(points = {{-60, -16}, {-44, -16}, {-44, -46}, {-34, -46}, {-34, -40}}));
      connect(CHP.CHP_HTES_In, HTES.HTES_CHP_Out) annotation(
        Line(points = {{-74, 20}, {-74, 0}}));
      connect(CHP.CHP_HTES_Out, HTES.HTES_CHP_In) annotation(
        Line(points = {{-66, 20}, {-66, 0}}));
      connect(HTES.HTES_AdCM_Out, AdCM.AdCM_HTES_In) annotation(
        Line(points = {{-60, -4}, {-52, -4}, {-52, 14}, {-20, 14}}));
      connect(HTES.HTES_AdCM_In, AdCM.AdCM_HTES_Out) annotation(
        Line(points = {{-60, -8}, {-46, -8}, {-46, 6}, {-20, 6}}));
      connect(Ambient_T.Amb_Temp_out, HTES.T_amb) annotation(
        Line(points = {{-104, 0}, {-100, 0}, {-100, -16}, {-80, -16}}));
      connect(Ambient_T.Amb_Temp_out, CTES.T_amb) annotation(
        Line(points = {{-104, 0}, {-100, 0}, {-100, 100}, {100, 100}, {100, -10}, {80, -10}, {80, -10}}));
      connect(Ambient_T.Amb_Temp_out, OC_2.T_amb) annotation(
        Line(points = {{-104, 0}, {-100, 0}, {-100, -100}, {10, -100}, {10, -100}}));
      connect(Ambient_T.Amb_Temp_out, OC_CCM.T_amb) annotation(
        Line(points = {{-104, 0}, {-100, 0}, {-100, 100}, {70, 100}, {70, 80}, {70, 80}}));
      connect(Ambient_T.Amb_Temp_out, OC_1.T_amb) annotation(
        Line(points = {{-104, 0}, {-100, 0}, {-100, 100}, {-10, 100}, {-10, 80}, {-10, 80}}));
      connect(OC_2.OC_HX_in, HX_2_Big.HX_AdCM_Out) annotation(
        Line(points = {{14, -80}, {14, -80}, {14, -74}, {26, -74}, {26, -64}, {20, -64}, {20, -64}}));
      connect(OC_2.OC_HX_Out, HX_2_Big.HX_AdCM_in) annotation(
        Line(points = {{6, -80}, {6, -80}, {6, -74}, {-6, -74}, {-6, -64}, {0, -64}, {0, -64}}));
      connect(AdCM.AdCM_CTES_Out, CTES.CTES_AdCM_In) annotation(
        Line(points = {{0, 6}, {30, 6}, {30, -14}, {60, -14}, {60, -14}}));
      connect(AdCM.AdCM_CTES_In, CTES.CTES_AdCM_Out) annotation(
        Line(points = {{0, 14}, {40, 14}, {40, -6}, {60, -6}, {60, -6}}));
      connect(AdCM.AdCM_HX_Out, HX_1_Big.HX_AdCM_in) annotation(
        Line(points = {{-6, 20}, {-6, 20}, {-6, 26}, {6, 26}, {6, 36}, {0, 36}, {0, 36}}));
      connect(HX_1_Big.HX_AdCM_Out, AdCM.AdCM_HX_In) annotation(
        Line(points = {{-20, 36}, {-26, 36}, {-26, 26}, {-14, 26}, {-14, 20}, {-14, 20}}));
      connect(CTES.CTES_LOAD_Out, LOAD_C.LOAD_In) annotation(
        Line(points = {{74, -20}, {74, -20}, {74, -60}, {74, -60}}));
      connect(CTES.CTES_LOAD_In, LOAD_C.LOAD_Out) annotation(
        Line(points = {{66, -20}, {66, -20}, {66, -60}, {66, -60}}));
      connect(OC_1.OC_HX_in, HX_1_Big.HX_OC_Out) annotation(
        Line(points = {{-6, 60}, {-6, 60}, {-6, 54}, {6, 54}, {6, 44}, {0, 44}, {0, 44}}));
      connect(OC_1.OC_HX_Out, HX_1_Big.HX_OC_in) annotation(
        Line(points = {{-14, 60}, {-14, 60}, {-14, 54}, {-26, 54}, {-26, 44}, {-20, 44}, {-20, 44}}));
      annotation(
        experiment(StartTime = 0, StopTime = 15000, Tolerance = 1e-06, Interval = 60));
    end Table_test;

    model KWKK_Time_model
      KWKK_CCHP_V49.Components.Time_Switch Time_Switch annotation(
        Placement(visible = true, transformation(origin = {-60, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      KWKK_CCHP_V49.Components.LOAD_H_Block LOAD_H(T_CC_FL = 23, v_dot_CC = 1) annotation(
        Placement(visible = true, transformation(origin = {-70, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      KWKK_CCHP_V49.Components.Power_Table_kW Power_Table_C annotation(
        Placement(visible = true, transformation(origin = {70, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      KWKK_CCHP_V49.Components.Power_Table_kW Power_Table_H annotation(
        Placement(visible = true, transformation(origin = {-70, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      KWKK_CCHP_V49.Components.LOAD_C_Block LOAD_C(T_CC_FL = 23, v_dot_CC = 1) annotation(
        Placement(visible = true, transformation(origin = {70, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      KWKK_CCHP_V49.Components.HTES_Loop HTES(T_ini_set = 30) annotation(
        Placement(visible = true, transformation(origin = {-70, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      KWKK_CCHP_V49.Components.CTES_Loop CTES annotation(
        Placement(visible = true, transformation(origin = {70, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      KWKK_CCHP_V49.Components.CHPUnit CHP annotation(
        Placement(visible = true, transformation(origin = {-70, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      KWKK_CCHP_V49.Components.AdCM AdCM annotation(
        Placement(visible = true, transformation(origin = {-10, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      KWKK_CCHP_V49.Components.RevHP_HP HP annotation(
        Placement(visible = true, transformation(origin = {10, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      KWKK_CCHP_V49.Components.RevHP_CC CCM annotation(
        Placement(visible = true, transformation(origin = {70, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Components.OutdoorCoil_NTU OC_1 annotation(
        Placement(visible = true, transformation(origin = {-10, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Components.PlateHeatExchanger_NTU HX_1_Big(A = 7.83, U = 2.151) annotation(
        Placement(visible = true, transformation(origin = {-10, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Components.OutdoorCoil_NTU_CCM OC_3_CCM annotation(
        Placement(visible = true, transformation(origin = {70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      KWKK_CCHP_V49.Components.PlateHeatExchanger_NTU HX_2_Big(A = 7.83, U = 2.151) annotation(
        Placement(visible = true, transformation(origin = {10, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
      KWKK_CCHP_V49.Components.PlateHeatExchanger_NTU HX_3_Small annotation(
        Placement(visible = true, transformation(origin = {-30, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      KWKK_CCHP_V49.Components.OutdoorCoil_NTU OC_2 annotation(
        Placement(visible = true, transformation(origin = {10, -90}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
      KWKK_CCHP_V49.Components.Ambient_Table_T Ambient_Table_T annotation(
        Placement(visible = true, transformation(origin = {-120, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    equation
      connect(HTES.v_HT, HP.V_HT) annotation(
        Line(points = {{-62, -20}, {-62, -20}, {-62, -34}, {-52, -34}, {-52, -52}, {-8, -52}, {-8, -42}, {2, -42}, {2, -40}, {2, -40}}, color = {0, 0, 127}));
      connect(LOAD_C.Power_C_In, Power_Table_C.Power1) annotation(
        Line(points = {{70, -60}, {70, -60}, {70, -80}, {70, -80}}));
      connect(LOAD_H.Power_H_in, Power_Table_H.Power1) annotation(
        Line(points = {{-70, -60}, {-70, -60}, {-70, -80}, {-70, -80}}));
      connect(OC_2.OC_HX_in, HX_2_Big.HX_AdCM_Out) annotation(
        Line(points = {{14, -80}, {14, -80}, {14, -74}, {26, -74}, {26, -64}, {20, -64}, {20, -64}}));
      connect(HP.RevHP_HX_MT_Out, HX_2_Big.HX_OC_in) annotation(
        Line(points = {{14, -40}, {14, -40}, {14, -46}, {26, -46}, {26, -56}, {20, -56}, {20, -56}}));
      connect(HX_2_Big.HX_AdCM_in, OC_2.OC_HX_Out) annotation(
        Line(points = {{0, -64}, {-6, -64}, {-6, -74}, {6, -74}, {6, -80}, {6, -80}}));
      connect(HP.RevHP_HX_MT_In, HX_2_Big.HX_OC_Out) annotation(
        Line(points = {{6, -40}, {6, -40}, {6, -46}, {-6, -46}, {-6, -56}, {0, -56}, {0, -56}}));
      connect(Ambient_Table_T.Amb_Temp_out, OC_2.T_amb) annotation(
        Line(points = {{-100, 0}, {-100, -100}, {10, -100}}));
      connect(Time_Switch.RevHP_CC_Switch, CCM.RevHP_CC_ON) annotation(
        Line(points = {{-48, 60}, {-48, 60}, {-48, 56}, {-34, 56}, {-34, 90}, {28, 90}, {28, 38}, {60, 38}, {60, 38}}, color = {0, 0, 127}));
      connect(Time_Switch.RevHP_HP_Switch, HP.RevHP_HP_ON) annotation(
        Line(points = {{-56, 60}, {-56, 60}, {-56, 48}, {-50, 48}, {-50, -2}, {4, -2}, {4, -20}, {4, -20}}, color = {0, 0, 127}));
      connect(Time_Switch.AdCM_Switch, AdCM.AdCM_ON) annotation(
        Line(points = {{-64, 60}, {-64, 60}, {-64, 44}, {-56, 44}, {-56, 18}, {-20, 18}, {-20, 20}}, color = {0, 0, 127}));
      connect(Time_Switch.Coil_Switch, HTES.Coil_ON) annotation(
        Line(points = {{-80, 88}, {-92, 88}, {-92, -10}, {-80, -10}, {-80, -8}}, color = {0, 0, 127}));
      connect(Time_Switch.CHP_Switch, CHP.CHP_ON) annotation(
        Line(points = {{-72, 60}, {-72, 60}, {-72, 52}, {-76, 52}, {-76, 40}, {-76, 40}}, color = {0, 0, 127}));
      connect(AdCM.AdCM_CTES_Out, CTES.CTES_AdCM_In) annotation(
        Line(points = {{0, 6}, {30, 6}, {30, -14}, {60, -14}, {60, -14}}));
      connect(AdCM.AdCM_CTES_In, CTES.CTES_AdCM_Out) annotation(
        Line(points = {{0, 14}, {40, 14}, {40, -6}, {60, -6}, {60, -6}}));
      connect(AdCM.DobleT_In_CTES, CTES.DobleTempOut) annotation(
        Line(points = {{0, 10}, {70, 10}, {70, 0}, {70, 0}}));
      connect(OC_3_CCM.OC_RevHP_In, CCM.RevHP_OC_Out) annotation(
        Line(points = {{74, 60}, {74, 60}, {74, 40}, {74, 40}}));
      connect(OC_3_CCM.OC_RevHP_Out, CCM.RevHP_OC_In) annotation(
        Line(points = {{66, 60}, {66, 60}, {66, 40}, {66, 40}}));
      connect(CCM.DoubleTempIn, CTES.DobleTempOut) annotation(
        Line(points = {{70, 20}, {70, 20}, {70, 0}, {70, 0}}));
      connect(CCM.RevHP_CTES_Out, CTES.CTES_RevHP_In) annotation(
        Line(points = {{74, 20}, {74, 20}, {74, 0}, {74, 0}}));
      connect(CCM.RevHP_CTES_In, CTES.CTES_RevHP_Out) annotation(
        Line(points = {{66, 20}, {66, 20}, {66, 0}, {66, 0}}));
      connect(HTES.DobleTempOut, HP.DobleTempIn) annotation(
        Line(points = {{-70, 0}, {-70, 0}, {-70, 8}, {-38, 8}, {-38, -10}, {10, -10}, {10, -20}, {10, -20}}));
      connect(OC_1.OC_HX_in, HX_1_Big.HX_OC_Out) annotation(
        Line(points = {{-6, 60}, {-6, 60}, {-6, 52}, {6, 52}, {6, 44}, {0, 44}, {0, 44}}));
      connect(OC_1.OC_HX_Out, HX_1_Big.HX_OC_in) annotation(
        Line(points = {{-14, 60}, {-14, 60}, {-14, 52}, {-26, 52}, {-26, 44}, {-20, 44}, {-20, 44}}));
      connect(AdCM.AdCM_HX_Out, HX_1_Big.HX_AdCM_in) annotation(
        Line(points = {{-6, 20}, {-6, 20}, {-6, 26}, {6, 26}, {6, 36}, {0, 36}, {0, 36}}));
      connect(HX_1_Big.HX_AdCM_Out, AdCM.AdCM_HX_In) annotation(
        Line(points = {{-20, 36}, {-24, 36}, {-24, 26}, {-14, 26}, {-14, 20}, {-14, 20}}));
      connect(HTES.HTES_AdCM_In, AdCM.AdCM_HTES_Out) annotation(
        Line(points = {{-60, -8}, {-24, -8}, {-24, 6}, {-20, 6}, {-20, 6}}));
      connect(HTES.HTES_AdCM_Out, AdCM.AdCM_HTES_In) annotation(
        Line(points = {{-60, -4}, {-30, -4}, {-30, 14}, {-20, 14}, {-20, 14}}));
      connect(HX_3_Small.HX_OC_Out, HP.RevHP_HX_HT_In) annotation(
        Line(points = {{-26, -40}, {-26, -40}, {-26, -46}, {-12, -46}, {-12, -34}, {0, -34}, {0, -34}}));
      connect(HX_3_Small.HX_OC_in, HP.RevHP_HX_HT_Out) annotation(
        Line(points = {{-26, -20}, {-26, -20}, {-26, -14}, {-12, -14}, {-12, -26}, {0, -26}, {0, -26}}));
      connect(HTES.HTES_HX_Out, HX_3_Small.HX_AdCM_in) annotation(
        Line(points = {{-60, -16}, {-44, -16}, {-44, -46}, {-34, -46}, {-34, -40}, {-34, -40}}));
      connect(HTES.HTES_HX_In, HX_3_Small.HX_AdCM_Out) annotation(
        Line(points = {{-60, -12}, {-34, -12}, {-34, -20}, {-34, -20}}));
      connect(CHP.DobleTempIn, HTES.DobleTempOut) annotation(
        Line(points = {{-70, 20}, {-70, 20}, {-70, 0}, {-70, 0}}));
      connect(CHP.CHP_HTES_Out, HTES.HTES_CHP_In) annotation(
        Line(points = {{-66, 20}, {-66, 20}, {-66, 0}, {-66, 0}}));
      connect(CHP.CHP_HTES_In, HTES.HTES_CHP_Out) annotation(
        Line(points = {{-74, 20}, {-74, 20}, {-74, 0}, {-74, 0}}));
      connect(CTES.CTES_LOAD_Out, LOAD_C.LOAD_In) annotation(
        Line(points = {{74, -20}, {74, -20}, {74, -40}, {74, -40}}));
      connect(CTES.CTES_LOAD_In, LOAD_C.LOAD_Out) annotation(
        Line(points = {{66, -20}, {66, -20}, {66, -40}, {66, -40}}));
      connect(HTES.HTES_LOAD_In, LOAD_H.LOAD_Out) annotation(
        Line(points = {{-66, -20}, {-66, -20}, {-66, -40}, {-66, -40}}));
      connect(HTES.HTES_LOAD_Out, LOAD_H.LOAD_In) annotation(
        Line(points = {{-74, -20}, {-74, -20}, {-74, -40}, {-74, -40}}));
      connect(Ambient_Table_T.Amb_Temp_out, CTES.T_amb) annotation(
        Line(points = {{-100, 0}, {-100, 0}, {-100, 100}, {100, 100}, {100, -10}, {80, -10}, {80, -10}}));
      connect(Ambient_Table_T.Amb_Temp_out, OC_3_CCM.T_amb) annotation(
        Line(points = {{-100, 0}, {-100, 0}, {-100, 100}, {70, 100}, {70, 80}, {70, 80}}));
      connect(Ambient_Table_T.Amb_Temp_out, OC_1.T_amb) annotation(
        Line(points = {{-100, 0}, {-100, 0}, {-100, 100}, {-10, 100}, {-10, 80}, {-10, 80}}));
      connect(Ambient_Table_T.Amb_Temp_out, HTES.T_amb) annotation(
        Line(points = {{-100, 0}, {-100, 0}, {-100, -16}, {-80, -16}, {-80, -16}}));
      annotation(
        experiment(StartTime = 0, StopTime = 21600, Tolerance = 1e-06, Interval = 60));
    end KWKK_Time_model;
  end SimModels;


  package Interfaces "In this package all the connectors necessary for creating the object oriented system/sub-system model are specified.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                <p>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                The first class of variables we will discuss are across variables (also called potential or effort variables). Differences in the values of across variables across a component are what trigger components to react. Typical examples of across variables, that we will be discussing shortly, are temperature, voltage and pressure. Differences in these quantities typically lead to dynamic behavior in the system.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                <p>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                The second class of variables we will discuss are through variables (also called flow variables). Flow variables normally represent the flow of some conserved quantity like mass, momentum, energy, charge, etc. These flows are usually the result of some difference in the across variables across a component model. For example, current flowing through a resistor is in response to a voltage difference across the two sides of the resistor. As we will see in many of the examples to come, there are many different types of relationships between the through and across variables.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                <p>
                                                                                                      
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                The general syntax for a connector definition is:
                                                                                                      
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                connector ConnectorName Description of the connector
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                Declarations for connector variables
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                end ConnectorName;
                                                                                                      
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                "
    connector Temp_HT
      Modelica.SIunits.Temp_C T;
      annotation(
        Icon(graphics = {Rectangle(fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}})}));
    end Temp_HT;

    connector MassFlow_out_MT
      extends MFlowSource;
      annotation(
        Icon(graphics = {Ellipse(fillColor = {0, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}, endAngle = 360), Ellipse(origin = {22, -24}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-82, 84}, {38, -36}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)));
    end MassFlow_out_MT;

    connector MassFlow_In_LT
      extends MFlowSource;
      annotation(
        Icon(graphics = {Ellipse(fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)));
    end MassFlow_In_LT;

    connector MassFlow_out_LT
      extends MFlowSource;
      annotation(
        Icon(graphics = {Ellipse(fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}, endAngle = 360), Ellipse(origin = {22, -24}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-82, 84}, {38, -36}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)));
    end MassFlow_out_LT;

    connector MassFlow_In_HT
      extends MFlowSource;
      annotation(
        Icon(graphics = {Ellipse(fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)));
    end MassFlow_In_HT;

    connector MassFlow_out_HT
      extends MFlowSource;
      annotation(
        Icon(graphics = {Ellipse(fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}, endAngle = 360), Ellipse(origin = {22, -24}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-82, 84}, {38, -36}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)));
    end MassFlow_out_HT;

    connector MassFlow_In_MT
      extends MFlowSource;
      annotation(
        Icon(graphics = {Ellipse(fillColor = {0, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)));
    end MassFlow_In_MT;

    connector RealInput = input Real "'input Real' as connector" annotation(
      defaultComponentName = "u",
      Icon(graphics = {Polygon(lineColor = {0, 0, 127}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, points = {{-100, 100}, {100, 0}, {-100, -100}, {-100, 100}})}, coordinateSystem(initialScale = 0.2)),
      Diagram(coordinateSystem(preserveAspectRatio = true, initialScale = 0.2, extent = {{-100.0, -100.0}, {100.0, 100.0}}), graphics = {Polygon(lineColor = {0, 0, 127}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, points = {{0.0, 50.0}, {100.0, 0.0}, {0.0, -50.0}, {0.0, 50.0}}), Text(lineColor = {0, 0, 127}, extent = {{-10.0, 60.0}, {-10.0, 85.0}}, textString = "%name")}),
      Documentation(info = "<html>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     <p>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     Connector with one input signal of type Real.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     <p>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     Block connectors are used to model the flow of information through a system. Here we are not concerned with physical quantities, like current, which might flow in one direction for a while and then reverse direction. Here we will consider how to model signals where some components produce information and others consume it (and then, in turn, produce other information). In this kind of situation, we frequently refer to such signals as input signals and output signals.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     </p>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     </html>"));
    connector RealOutput = output Real "'output Real' as connector" annotation(
      defaultComponentName = "y",
      Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100.0, -100.0}, {100.0, 100.0}}), graphics = {Polygon(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-100.0, 100.0}, {100.0, 0.0}, {-100.0, -100.0}})}),
      Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100.0, -100.0}, {100.0, 100.0}}), graphics = {Polygon(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-100.0, 50.0}, {0.0, 0.0}, {-100.0, -50.0}}), Text(lineColor = {0, 0, 127}, extent = {{30.0, 60.0}, {30.0, 110.0}}, textString = "%name")}),
      Documentation(info = "<html>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   <p>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   Connector with one output signal of type Real.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   </p>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   </html>"));

    connector MFlowSource "MORE DOCUMENTATION IS NECESSARY AND PLEASE SAVE AS CONNECTOR"
      Modelica.SIunits.Temp_C T;
      Modelica.SIunits.MassFlowRate m_dot;
    end MFlowSource;

    connector Temp_MT
      Modelica.SIunits.Temp_C T;
      annotation(
        Icon(graphics = {Rectangle(fillColor = {0, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}})}, coordinateSystem(initialScale = 0.1)));
    end Temp_MT;

    connector Temp_LT
      Modelica.SIunits.Temp_C T;
      annotation(
        Icon(graphics = {Rectangle(fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}})}, coordinateSystem(initialScale = 0.1)));
    end Temp_LT;

    connector Temp_AdCM_HT
      Modelica.SIunits.Temp_C T;
      annotation(
        Icon(graphics = {Rectangle(fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}})}));
    end Temp_AdCM_HT;

    connector Amb_Temp
      Modelica.SIunits.Temp_C T;
      annotation(
        Icon(graphics = {Rectangle(fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}})}, coordinateSystem(initialScale = 0.1)));
    end Amb_Temp;

    connector Power
      Units.Power_kW P;
      annotation(
        Icon(graphics = {Rectangle(fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}})}, coordinateSystem(initialScale = 0.1)));
    end Power;

    model Realtophys_power
      Real Power_real;
      Units.Power_kW Power;
      Interfaces.RealInput u annotation(
        Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-98, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Interfaces.Power Power1 annotation(
        Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      Power_real = u;
      Power_real = Power;
      Power = Power1.P;
    end Realtophys_power;

    connector DobleTemp
      Modelica.SIunits.Temp_C T1;
      Modelica.SIunits.Temp_C T2;
      annotation(
        Diagram(coordinateSystem(initialScale = 0.1)),
        Icon(graphics = {Polygon(origin = {0, -0.28}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, points = {{-100, -99.7236}, {100, -99.7236}, {0, 100.276}, {-100, -99.7236}})}));
    end DobleTemp;
  end Interfaces;

  package Components
    model CHPUnit
      //============ Imported Library ===============
      import SI = Modelica.SIunits;
      //============ Parameters =====================
      parameter Units.Power_kW Pth_CHP_Nominal = 10.2 "Nominal Thermal Power [kW]" annotation(
        HideResult = true);
      parameter Units.Power_kW Pel_CHP_Nominal = 5.3 "Electrical Power ouput in [kW]" annotation(
        HideResult = true);
      parameter Units.unitless CHP_eta_Thermal = 0.59 "Thermal efficiency" annotation(
        HideResult = true);
      parameter Units.unitless CHP_eta_Electrical = 0.3 "Electrical efficiency" annotation(
        HideResult = true);
      parameter Units.FuelEnergy CHP_Fuel_HHV = 12.66 "Energy Fuel [kW.h/kg]" annotation(
        HideResult = true);
      parameter SI.Temp_C Lower_Temp_Limit = 75 "Lower temp limit below which CHP goes ON, Temperature corresponding to layer at top of tank selected by user in Tank Model" annotation(
        HideResult = true);
      parameter SI.Temp_C Higher_Temp_Limit = 72 "Upper temp limit above which CHP goes OFF, Temperature corresponding to layer at bottom of tank selected by user in Tank Model" annotation(
        HideResult = true);
      //============ Constants =======================
      constant SI.Density rho_water = 994.3025 "Water density [kg/m3], use data sheet";
      constant SI.Density rho_fuel = 853.5 "Fuel density [kg/m3]";
      constant Units.HeatConductivity lambda_water = 0.001 "Heat conductivity of water [kW/(m.K)]";
      constant Units.SpecificHeat cpw = 4.18 "Specific heat transfer coefficient of water [kJ/(kg.K)]";
      //=============== Variables of the CHP ========================
      Boolean heat "Boolean Parameter to introduce Hysteresis" annotation(
        HideResult = true);
      SI.MassFlowRate CHP_H_W_MF_M "Water mass flow out of the CHP [kg/s]" annotation(
        HideResult = true);
      SI.MassFlowRate CHP_H_W_MF_M_Set annotation(
        HideResult = true);
      Units.Power_kW CHP_H_W_PT_M "Real thermal power produced by CHP [kW]";
      Units.Power_kW CHP_H_W_PE_M "Real electrical power produced by CHP [kW]";
      Units.Power_kW Pth_CHP "Power Calculation Variable [kW]" annotation(
        HideResult = true);
      Units.FuelFlow CHP_H_F_VF_M "Fuel consumption of the CHP [l/h]";
      Units.VolumeFlow CHP_H_W_VF_M "Water volume Flow Rate [m3/h]";
      SI.Temp_C CHP_H_W_T_M_FL "Water temperature at the exit of CHP in [°C]";
      SI.Temp_C CHP_H_W_T_M_RL "Temperature of the return water to the CHP[°C]";
      SI.Temp_K CHP_H_W_T_M_FL_K "Water temperature at the exit of CHP in [K]" annotation(
        HideResult = true);
      SI.Temp_K CHP_H_W_T_M_RL_K "Temperature of the return water to the CHP[K]" annotation(
        HideResult = true);
      Units.unitless CHP_ON_int "for internal control logic";
      Units.unitless PartLoad_Ratio "Part Load ratio for Thermal part load operation of CHP" annotation(
        HideResult = true);
      SI.Temp_C Temp_Low "Temperature corresponding to layer selected by user in Tank Model. This is at top of tank" annotation(
        HideResult = true);
      SI.Temp_C Temp_High "Temperature corresponding to layer selected by user in Tank Model. This is at bottom of tank" annotation(
        HideResult = true);
      //==================== Connectors ==================================
      Interfaces.MassFlow_out_HT CHP_HTES_Out annotation(
        Placement(visible = true, transformation(origin = {40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.Temp_HT CHP_HTES_In annotation(
        Placement(visible = true, transformation(origin = {-40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput CHP_ON annotation(
        Placement(visible = true, transformation(origin = {-60, 100}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-60, 100}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
      Interfaces.DobleTemp DobleTempIn annotation(
        Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      //================== Algorithm Section: CHP Safety Shut Down=============================
    initial equation
      heat = true;
    algorithm
// Hysteresis Loop for internal control of CHP
      when Temp_Low <= Lower_Temp_Limit then
        heat := true;
      end when;
//  "when temp. at top of tank is lower then limit then CHP goes ON"
      when Temp_High >= Higher_Temp_Limit then
        heat := false;
      end when;
// when temp. at bottom of tank is higher then limit then CHP goes OFF"
//================== CHP equations =============================
    equation
//=================== Temperature Conversion from °C to K =============================
      CHP_H_W_T_M_FL_K = CHP_H_W_T_M_FL + 273.15;
      CHP_H_W_T_M_RL_K = CHP_H_W_T_M_RL + 273.15;
//========== Convert Mass Flow [kg/s] to Volume Flow [m³/h]=================
      CHP_H_W_MF_M = CHP_ON_int * CHP_H_W_VF_M * rho_water / 3600;
      CHP_H_W_MF_M_Set = CHP_H_W_VF_M * rho_water / 3600;
//=================== Connector equations =================================
      CHP_H_W_T_M_RL = CHP_HTES_In.T "Return Temperature that comes from the HTES [°C]";
      CHP_H_W_T_M_FL = CHP_HTES_Out.T "Feed Line temperature that goes to the HTES [°C]";
      CHP_H_W_MF_M = CHP_HTES_Out.m_dot "Mass Flow that goes to the HTES [kg/s]";
      Temp_Low = DobleTempIn.T1 "Temperature corresponding to layer selected by user in Tank Model";
      Temp_High = DobleTempIn.T2 "Temperature corresponding to layer selected by user in Tank Model";
//===================Operational Logic Equations===================
//If CHP_ON_int is true then it takes value of Supervisory Controller
      CHP_ON_int = if heat then CHP_ON else 0;
//
//====================Part Load Behaviour=============================
      PartLoad_Ratio = 0.935962276499541 + 0.00389339241401334 * CHP_H_W_T_M_RL - 0.0000518855946923975 * CHP_H_W_T_M_RL ^ 2;
      Pth_CHP = PartLoad_Ratio * Pth_CHP_Nominal;
      CHP_H_W_PE_M = CHP_ON_int * Pel_CHP_Nominal "assuming electrical output is always constant";
//====================Dynamic equation for Pth_CHP using step-response and I/O equation of PT1 Glied================
      der(CHP_H_W_PT_M) * 560.794 + CHP_H_W_PT_M = Pth_CHP * CHP_ON_int " T*der(y) + y = K*u";
//========== Volume Flow as a function of the Return Line Temperature=============
/********************** Test 2 at 32°C ***********************************/
      CHP_H_W_VF_M = 0.433352645 - 0.01514531 * CHP_H_W_T_M_RL + 0.00024329 * CHP_H_W_T_M_RL ^ 2;
//========== Energy Equation to find CHP_H_W_T_M_FL_K [K](Feed Line Temperature at the exit of the CHP)=============
      CHP_H_W_T_M_FL_K = CHP_H_W_T_M_RL_K + CHP_H_W_PT_M / (CHP_H_W_MF_M_Set * cpw);
//
//======================== Fuel consumption [l/h] ========================================
      CHP_H_F_VF_M = (CHP_H_W_PE_M + CHP_H_W_PT_M) * 1000 / ((CHP_eta_Thermal + CHP_eta_Electrical) * CHP_Fuel_HHV * rho_fuel) "[kW] * 1000 / [(kWh/kg) *(kg/m³)] = (l/h) ";
//=========================== Color and Shape ====================================
      annotation(
        Icon(coordinateSystem(initialScale = 0.1), graphics = {Bitmap(origin = {-2, 2}, extent = {{-98, 96}, {104, -102}}, imageSource = "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")}),
        Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})),
        experiment(StartTime = 0, StopTime = 39600, Tolerance = 1e-06, Interval = 79.3587));
    end CHPUnit;

    model AdCM
      //============ Imported Library ===============
      import SI = Modelica.SIunits;
      //================= Parameters =====================
      parameter Units.VolumeFlow v_dot_AdCM_LT_set = 1.7 "Volume Flow in the LT Circuit going to the CTES [m3/h]" annotation(
        HideResult = true);
      parameter Units.VolumeFlow v_dot_AdCM_MT_set = 4.2 "Volume Flow in the MT Circuit going to the OC [m3/h]" annotation(
        HideResult = true);
      parameter Units.VolumeFlow v_dot_AdCM_HT_set = 1.3 "Volume Flow in the HT Circuit going to the HTES [m3/h]" annotation(
        HideResult = true);
      parameter Real SF = 0 "Smoothing factor for Cyclic Thermal Power Curves" annotation(
        HideResult = true);
      parameter SI.Temp_C Lower_Temp_Limit = 12 "Lower temp limit below which AdCM goes OFF, Temperature corresponding to layer at bottom of tank selected by user in Tank Model" annotation(
        HideResult = true);
      parameter SI.Temp_C Higher_Temp_Limit = 15 "Upper temp limit above which AdCM goes ON, Temperature corresponding to layer at top of tank selected by user in Tank Model" annotation(
        HideResult = true);
      //================= Constants =======================
      constant Units.SpecificHeat cpw = 4.18 "Specific heat transfer coefficient of water [kJ/(kg.K)]";
      constant SI.Density rho_water = 994.3025 "Water density [kg/m3], use data sheet!!!";
      //
      //=============== Variables of the AdCM ========================
      //
      Boolean cool "Boolean Parameter to introduce Hysteresis" annotation(
        HideResult = true);
      /********************** Return line temperature ***********************/
      SI.Temp_C ADCM_C_W_T_M_LT_RL "Low Temperature Circuit - Chilled Water coming back from CTES[°C]";
      SI.Temp_C ADCM_C_W_T_M_MT_RL "Medium Temperature Circuit - Cooling Water Coming Back from OC[°C]";
      SI.Temp_C ADCM_C_W_T_M_HT_RL "Driving Heat Temperature coming from the HTES [C]";
      SI.Temp_K ADCM_C_W_T_M_LT_RL_K "Low Temperature coming from the CTES [K]" annotation(
        HideResult = true);
      SI.Temp_K ADCM_C_W_T_M_HT_RL_K "Hot Temperature coming from the HTES [K]" annotation(
        HideResult = true);
      SI.Temp_K ADCM_C_W_T_M_MT_RL_K "Medium Temperature Circuit - Cooling Water[K]" annotation(
        HideResult = true);
      /********************** Feed Line Temperature *************************/
      SI.Temp_K ADCM_C_W_T_M_MT_FL_K "Medium Temperature Circuit going to the Outdoor Coil [K]" annotation(
        HideResult = true);
      SI.Temp_K ADCM_C_W_T_M_HT_FL_K "High Temperature Circuit - Hot Water[K]" annotation(
        HideResult = true);
      SI.Temp_K ADCM_C_W_T_M_LT_FL_K "Low Temperature Circuit - Chilled Water[K]" annotation(
        HideResult = true);
      SI.Temp_C ADCM_C_W_T_M_MT_FL "Medium Temperature Circuit Temperature going to the Outdoor Coil [C]";
      SI.Temp_C ADCM_C_W_T_M_LT_FL "Low Temperature Circuit - going to the CTES [C]";
      SI.Temp_C ADCM_C_W_T_M_HT_FL "High Temperature Circuit - Hot Water going to HTES[°C]";
      /**********************************************************************/
      Units.unitless COP "Coeficient of Performance";
      Units.Power_kW ADCM_C_W_PT_M_LT_ "Cooling Capacity [KW]";
      SI.MassFlowRate m_dot_AdCM_HT "Mass Flow Rate that goes to the HTES [kg/s]" annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_AdCM_LT "Mass Flow Rate that goes to the CTES [kg/s]" annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_AdCM_MT "Mass Flow Rate that goes to the OC [kg/s]" annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_AdCM_HT_Set "Mass Flow Rate that goes to the HTES [kg/s]" annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_AdCM_LT_Set "Mass Flow Rate that goes to the CTES [kg/s]" annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_AdCM_MT_Set "Mass Flow Rate that goes to the OC [kg/s]" annotation(
        HideResult = true);
      Units.Power_kW ADCM_C_W_PT_M_HT_ "Power Thermal in HT circuit [kW]";
      Units.Power_kW ADCM_C_W_PT_M_MT_ "Power Thermal in MT circuit [kW]";
      Units.VolumeFlow ADCM_C_W_VF_M_LT_;
      Units.VolumeFlow ADCM_C_W_VF_M_MT_;
      Units.VolumeFlow ADCM_C_W_VF_M_HT_;
      Units.unitless AdCM_ON_int "for control logic";
      SI.Temp_C Temp_Low annotation(
        HideResult = true);
      SI.Temp_C Temp_High annotation(
        HideResult = true);
      //==================== Connectors ==================================
      Interfaces.MassFlow_out_LT AdCM_CTES_Out annotation(
        Placement(visible = true, transformation(origin = {100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.Temp_MT AdCM_HX_In annotation(
        Placement(visible = true, transformation(origin = {-40, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.Temp_LT AdCM_CTES_In annotation(
        Placement(visible = true, transformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.MassFlow_out_HT AdCM_HTES_Out annotation(
        Placement(visible = true, transformation(origin = {-100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.Temp_HT AdCM_HTES_In annotation(
        Placement(visible = true, transformation(origin = {-100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.MassFlow_out_MT AdCM_HX_Out annotation(
        Placement(visible = true, transformation(origin = {40, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.RealInput AdCM_ON annotation(
        Placement(visible = true, transformation(origin = {-98, 90}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-98, 90}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Interfaces.DobleTemp DobleT_In_CTES annotation(
        Placement(visible = true, transformation(origin = {100, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      //==============================================================
      //================== Algorithm Section: AdCM Safety Shut Down=============================
    initial equation
      cool = true;
    algorithm
// Hysteresis Loop for LT circuit control of AdCM
      when Temp_Low <= Lower_Temp_Limit then
        cool := false;
      end when;
      when Temp_High >= Higher_Temp_Limit then
        cool := true;
      end when;
//================== AdCM equations =============================
    equation
//Conversion of Temperature from °C to K
      ADCM_C_W_T_M_HT_FL_K = ADCM_C_W_T_M_HT_FL + 273.15;
      ADCM_C_W_T_M_LT_FL_K = ADCM_C_W_T_M_LT_FL + 273.15;
      ADCM_C_W_T_M_MT_RL_K = ADCM_C_W_T_M_MT_RL + 273.15;
      ADCM_C_W_T_M_MT_FL_K = ADCM_C_W_T_M_MT_FL + 273.15;
      ADCM_C_W_T_M_LT_RL_K = ADCM_C_W_T_M_LT_RL + 273.15;
      ADCM_C_W_T_M_HT_RL_K = ADCM_C_W_T_M_HT_RL + 273.15;
//================= Mass and Volume set equations ========================
      ADCM_C_W_VF_M_LT_ = AdCM_ON_int * v_dot_AdCM_LT_set;
      ADCM_C_W_VF_M_MT_ = AdCM_ON_int * v_dot_AdCM_MT_set;
      ADCM_C_W_VF_M_HT_ = AdCM_ON_int * v_dot_AdCM_HT_set;
//Conversion of Volume Flow to Mass Flow
      m_dot_AdCM_LT = ADCM_C_W_VF_M_LT_ * rho_water / 3600 "Volume of water against time [m³/h]. Forcing the mass flow to be 0 when component is OFF";
      m_dot_AdCM_MT = ADCM_C_W_VF_M_MT_ * rho_water / 3600;
      m_dot_AdCM_HT = ADCM_C_W_VF_M_HT_ * rho_water / 3600;
      m_dot_AdCM_LT_Set = v_dot_AdCM_LT_set * rho_water / 3600 "Volume of water against time [m³/h]. Forcing the mass flow to be 0 when component is OFF";
      m_dot_AdCM_MT_Set = v_dot_AdCM_MT_set * rho_water / 3600;
      m_dot_AdCM_HT_Set = v_dot_AdCM_HT_set * rho_water / 3600;
/**************** Connector Equations ****************************/
//
//Connector variables: Temperature Return Line
      AdCM_HTES_Out.T = ADCM_C_W_T_M_HT_FL;
      AdCM_HX_In.T = ADCM_C_W_T_M_MT_RL;
      AdCM_CTES_Out.T = ADCM_C_W_T_M_LT_FL;
//Connector variables: Temperature Feed Line
      AdCM_CTES_In.T = ADCM_C_W_T_M_LT_RL;
      AdCM_HTES_In.T = ADCM_C_W_T_M_HT_RL;
      AdCM_HX_Out.T = ADCM_C_W_T_M_MT_FL;
//Connector variables Mass Flow
      AdCM_HTES_Out.m_dot = m_dot_AdCM_HT;
      AdCM_CTES_Out.m_dot = m_dot_AdCM_LT;
      AdCM_HX_Out.m_dot = m_dot_AdCM_MT;
//Doble Temp Connector
      DobleT_In_CTES.T1 = Temp_Low;
      DobleT_In_CTES.T2 = Temp_High;
//
/***************** Main equations ********************************/
//===================Operational Logic Equations===================
//If AdCM is turned off over hysteresis control then AdCM_ON is also = 0
      AdCM_ON_int = if cool then AdCM_ON else 0;
//  if AdCM_ON_int == 0 then
//    COP = 0;
//    ADCM_C_W_PT_M_LT_ = 0;
//    ADCM_C_W_PT_M_HT_ = 0;
//    ADCM_C_W_PT_M_MT_ = 0;
//    ADCM_C_W_T_M_LT_RL_K - ADCM_C_W_T_M_LT_FL_K = 0;
//    ADCM_C_W_T_M_MT_FL_K - ADCM_C_W_T_M_MT_RL_K = 0;
//    ADCM_C_W_T_M_HT_RL_K - ADCM_C_W_T_M_HT_FL_K = 0;
//  else
//COP Equation with curve fit from data sheet
/*COP = (-0.059623287373) + 0.009093348591 * ADCM_C_W_T_M_LT_RL + 0.013340776694 * ADCM_C_W_T_M_HT_RL + 0.017822939671 * ADCM_C_W_T_M_MT_RL - 0.001280352166 * ADCM_C_W_T_M_LT_RL ^ 2 - 0.000190832894 * ADCM_C_W_T_M_HT_RL ^ 2 - 0.001993352016 * ADCM_C_W_T_M_MT_RL ^ 2 - 0.000334095159 * ADCM_C_W_T_M_LT_RL * ADCM_C_W_T_M_HT_RL + 0.001455689548 * ADCM_C_W_T_M_LT_RL * ADCM_C_W_T_M_MT_RL + 0.000569253554 * ADCM_C_W_T_M_HT_RL * ADCM_C_W_T_M_MT_RL + 0.000013421174 * ADCM_C_W_T_M_LT_RL * ADCM_C_W_T_M_HT_RL * ADCM_C_W_T_M_MT_RL;*/
      COP = (-0.049623287373) + 0.01893348591 * ADCM_C_W_T_M_LT_RL + 0.013340776694 * ADCM_C_W_T_M_HT_RL + 0.017822939671 * ADCM_C_W_T_M_MT_RL - 0.001280352166 * ADCM_C_W_T_M_LT_RL ^ 2 - 0.000190832894 * ADCM_C_W_T_M_HT_RL ^ 2 - 0.001993352016 * ADCM_C_W_T_M_MT_RL ^ 2 - 0.000334095159 * ADCM_C_W_T_M_LT_RL * ADCM_C_W_T_M_HT_RL + 0.001455689548 * ADCM_C_W_T_M_LT_RL * ADCM_C_W_T_M_MT_RL + 0.000569253554 * ADCM_C_W_T_M_HT_RL * ADCM_C_W_T_M_MT_RL + 0.000013421174 * ADCM_C_W_T_M_LT_RL * ADCM_C_W_T_M_HT_RL * ADCM_C_W_T_M_MT_RL;
//Cooling Capacity equation with curve fit from data sheet
/*
        ADCM_C_W_PT_M_LT_ = 8.379509340990 + 0.041524723610 * ADCM_C_W_T_M_LT_RL + 0.160630808297 * ADCM_C_W_T_M_HT_RL - 0.859860168466 * ADCM_C_W_T_M_MT_RL + 0.003462744142 * ADCM_C_W_T_M_LT_RL ^ 2 - 0.001049096999 * ADCM_C_W_T_M_HT_RL ^ 2 + 0.015142231276 * ADCM_C_W_T_M_MT_RL ^ 2 + 0.016955368833 * ADCM_C_W_T_M_LT_RL * ADCM_C_W_T_M_HT_RL - 0.016151596215 * ADCM_C_W_T_M_LT_RL * ADCM_C_W_T_M_MT_RL - 0.001917799045 * ADCM_C_W_T_M_HT_RL * ADCM_C_W_T_M_MT_RL - 0.000200778961 * ADCM_C_W_T_M_LT_RL * ADCM_C_W_T_M_HT_RL * ADCM_C_W_T_M_MT_RL;
        */
      ADCM_C_W_PT_M_LT_ = AdCM_ON_int * (4.079509340990 + 0.041524723610 * ADCM_C_W_T_M_LT_RL + 0.160630808297 * ADCM_C_W_T_M_HT_RL - 0.859860168466 * ADCM_C_W_T_M_MT_RL + 0.003462744142 * ADCM_C_W_T_M_LT_RL ^ 2 - 0.001049096999 * ADCM_C_W_T_M_HT_RL ^ 2 + 0.015142231276 * ADCM_C_W_T_M_MT_RL ^ 2 + 0.016955368833 * ADCM_C_W_T_M_LT_RL * ADCM_C_W_T_M_HT_RL - 0.016151596215 * ADCM_C_W_T_M_LT_RL * ADCM_C_W_T_M_MT_RL - 0.001917799045 * ADCM_C_W_T_M_HT_RL * ADCM_C_W_T_M_MT_RL - 0.000200778961 * ADCM_C_W_T_M_LT_RL * ADCM_C_W_T_M_HT_RL * ADCM_C_W_T_M_MT_RL);
//ADCM_C_W_PT_M_HT_ with COP
      ADCM_C_W_PT_M_HT_ = ADCM_C_W_PT_M_LT_ / COP - SF "the SF is a fit value for real life experiments, but not true, we need to find the real value";
//Power Thermal in MT circuit as sum of LT and HT circuits Refer Nünez Paper- This equation is correct and considers the isoteric balance of the entire ad/de-sorption cycle
      ADCM_C_W_PT_M_MT_ = ADCM_C_W_PT_M_HT_ + ADCM_C_W_PT_M_LT_ "This means a 100% Efficiency. However we are already considering COP and ADCM_C_W_PT_M_LT_ curve fits";
//Energy Equation LT, to calculate ADCM_C_W_T_M_LT_FL_K
      ADCM_C_W_T_M_LT_FL_K = ADCM_C_W_T_M_LT_RL_K - ADCM_C_W_PT_M_LT_ / (cpw * m_dot_AdCM_LT_Set);
//Energy Equation MT, to calculate ADCM_C_W_T_M_MT_FL_K
      ADCM_C_W_T_M_MT_FL_K = ADCM_C_W_T_M_MT_RL_K + ADCM_C_W_PT_M_MT_ / (cpw * m_dot_AdCM_MT_Set);
//Energy Equation HT, to calculate ADCM_C_W_T_M_HT_FL_K
      ADCM_C_W_T_M_HT_FL_K = ADCM_C_W_T_M_HT_RL_K - ADCM_C_W_PT_M_HT_ / (cpw * m_dot_AdCM_HT_Set);
//  end if;
//=========================Color and Shape================
      annotation(
        Icon(coordinateSystem(initialScale = 0.1), graphics = {Bitmap(extent = {{-100, -100}, {100, 100}}, imageSource = "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")}),
        experiment(StartTime = 0, StopTime = 21600, Tolerance = 1e-06, Interval = 43.8134));
    end AdCM;

    model LOAD
      import SI = Modelica.SIunits;
      //================== Parameters =======================
      parameter Units.Power_kW Pth_CC "Thermal Power of the LOAD";
      //parameter SI.Temp_C delta_T_CC "Temperature difference between T_FL_CC and T_RL_CC";
      parameter SI.Temp_C T_CC_FL " Temeprature going to Climate Chamber";
      parameter Units.VolumeFlow v_dot_CC "Volume Flow going to the Climate Chamber [m3/h]";
      //==================Constants=====================
      constant SI.Density rho_water = 994.3025 "Water density [kg/m3]";
      constant Units.SpecificHeat cpw = 4.18 "Specific heat transfer coefficient of water" annotation(
        HideResult = false);
      //================== Variable =========================
      SI.Temp_C LOAD_HC_W_T_M__FL_ "Temp from tank to 3-MV";
      SI.Temp_C LOAD_HC_W_T_M__RL_ "Temp from 3-MV back to Tank, is the same as temp. coming back from climate chamber = T_CC_RL";
      SI.Temp_C T_CC_RL;
      SI.Temp_K LOAD_HC_W_T_M__FL__K annotation(
        HideResult = true);
      SI.Temp_K T_CC_RL_K annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_LOAD "Mass Flow going to the LOAD [kg/s]" annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_CC "Mass Flow going to the Climate Chamber[kg/s]" annotation(
        HideResult = true);
      Units.VolumeFlow LOAD_HC_W_VF_M___ "Volume Flow going to the LOAD [m3/h]";
      //================== Connector =========================
      Interfaces.Temp_HT LOAD_In annotation(
        Placement(visible = true, transformation(origin = {-40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.MassFlow_out_HT LOAD_Out annotation(
        Placement(visible = true, transformation(origin = {40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
//============ Mass flow kg/s to Volume Flow m3/h ==============
      m_dot_LOAD = LOAD_HC_W_VF_M___ * rho_water / 3600;
      m_dot_CC = v_dot_CC * rho_water / 3600;
//============== Connector equation ==================
      LOAD_HC_W_T_M__FL_ = LOAD_In.T;
      LOAD_HC_W_T_M__RL_ = LOAD_Out.T;
      m_dot_LOAD = LOAD_Out.m_dot;
//================== Temperature equation from °C to K ==================
      LOAD_HC_W_T_M__FL__K = LOAD_HC_W_T_M__FL_ + 273.15;
      T_CC_RL_K = T_CC_RL + 273.15;
//================== Main equations =====================================
      LOAD_HC_W_T_M__RL_ = T_CC_RL "Temp coming back from CC is the one going back to the Tank";
////============== dT in Climate Chamber ==================
//  delta_T_CC = T_CC_FL - T_CC_RL;
//============== Energy Balance in Climate Chamber to calculate T_CC_RL ==================
      Pth_CC = m_dot_CC * cpw * (T_CC_FL - T_CC_RL);
//============== Energy Balance Based on 3-MV Equations. Here the mass flow from Tank is calculated Check Documentation==================
      Pth_CC = m_dot_LOAD * cpw * (LOAD_HC_W_T_M__FL__K - T_CC_RL_K);
//================== Color and shape =================
      annotation(
        Icon(coordinateSystem(initialScale = 0.1), graphics = {Bitmap(extent = {{-100, 100}, {100, -100}}, imageSource = "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")}));
    end LOAD;

    // This is workin but the CC not

    model RevHP_HP "Model for the Reversible heat pump - Heating Mode"
      //==================================================================
      //================== Algorithm Section: RevHP Conventional Control=============================
      //============ Imported Library ===============
      import SI = Modelica.SIunits;
      //================== Parameters ==================================
      parameter Units.VolumeFlow v_dot_HT_FL_set = 2.79 "Volume Flow Rate from the RevHP to the Hot Storage Tank [m3/h]" annotation(
        HideResult = true);
      parameter Units.VolumeFlow v_dot_MT_FL_set = 2.45 "Volume Flow Rate from the RevHP to the Outdoor Coil [m3/h]" annotation(
        HideResult = true);
      parameter SI.Temp_C Lower_Temp_Limit = 38 "Lower temp limit below which RevHP goes ON, Temperature corresponding to layer at top of tank selected by user in Tank Model" annotation(
        HideResult = true);
      parameter SI.Temp_C Higher_Temp_Limit = 45 "Upper temp limit above which RevHP goes OFF, Temperature corresponding to layer at bottom of tank selected by user in Tank Model" annotation(
        HideResult = true);
      //
      //================== Constants ===================================
      constant Units.SpecificHeat cpw = 4.18 "Specific heat treansfer coefficient of water [kJ/(kg.K)]";
      constant SI.Density rho_water = 994.3025 "Water density [kg/m3]";
      //=============== Variables of the RevHP =========================
      Boolean heat "Boolean Parameter to introduce Hysteresis" annotation(
        HideResult = true);
      SI.Temp_C RevHP_HC_W_T_M_MT_FL_ "LWC Temp. going to HTES";
      SI.Temp_C RevHP_HC_W_T_M_LT_FL_ "LWE Temp. going to OC";
      SI.Temp_C RevHP_HC_W_T_M_MT_RL_;
      SI.Temp_C RevHP_HC_W_T_M_LT_RL_;
      SI.Temp_C Temp_Low "Temperature corresponding to layer selected by user in Tank Model. This is at top of tank" annotation(
        HideResult = true);
      SI.Temp_C Temp_High "Temperature corresponding to layer selected by user in Tank Model. This is at bottom of tank" annotation(
        HideResult = true);
      SI.Temp_K RevHP_HC_W_T_M_MT_FL__K annotation(
        HideResult = true);
      SI.Temp_K RevHP_HC_W_T_M_LT_FL__K annotation(
        HideResult = true);
      SI.Temp_K RevHP_HC_W_T_M_MT_RL__K annotation(
        HideResult = true);
      SI.Temp_K RevHP_HC_W_T_M_LT_RL__K annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_HT_FL annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_MT_FL annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_HT_FL_Set annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_MT_FL_Set annotation(
        HideResult = true);
      Units.Power_kW RevHP_HC_W_PT_M_MT__;
      Units.Power_kW RevHP_HC_W_PT_M_LT__;
      Units.Power_kW RevHP_HC_E_PE_M___;
      Units.VolumeFlow RevHP_HC_W_VF_M_MT__;
      Units.VolumeFlow RevHP_HC_W_VF_M_LT__;
      Units.unitless RevHP_HP_ON_int "for control logic";
      //==================== Connectors ================================
      Interfaces.MassFlow_out_HT RevHP_HX_HT_Out annotation(
        Placement(visible = true, transformation(origin = {-100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.Temp_MT RevHP_HX_MT_In annotation(
        Placement(visible = true, transformation(origin = {-40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.Temp_HT RevHP_HX_HT_In annotation(
        Placement(visible = true, transformation(origin = {-100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.MassFlow_out_MT RevHP_HX_MT_Out annotation(
        Placement(visible = true, transformation(origin = {40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.RealInput RevHP_HP_ON annotation(
        Placement(visible = true, transformation(origin = {-60, 100}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-60, 100}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
      Interfaces.DobleTemp DobleTempIn annotation(
        Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.RealOutput V_HT annotation(
        Placement(visible = true, transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-80, -100}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
    initial equation
      heat = true;
    algorithm
// Hysteresis Loop for Conventional control of RevHP.//
      when Temp_Low <= Lower_Temp_Limit then
        heat := true;
      end when;
// "when temp. at top of tank is lower then limit then RevHP_HP goes ON"
      when Temp_High >= Higher_Temp_Limit then
        heat := false;
      end when;
//================== RevHP equations =============================
    equation
//================== Temperatures from °C to K ====================
      RevHP_HC_W_T_M_MT_FL__K = RevHP_HC_W_T_M_MT_FL_ + 273.15;
      RevHP_HC_W_T_M_LT_FL__K = RevHP_HC_W_T_M_LT_FL_ + 273.15;
      RevHP_HC_W_T_M_MT_RL__K = RevHP_HC_W_T_M_MT_RL_ + 273.15;
      RevHP_HC_W_T_M_LT_RL__K = RevHP_HC_W_T_M_LT_RL_ + 273.15;
//================= Mass Flow and Volume Flow Set equations ========================
//use similar logic to CHP for flow if HP internally turned OFF
      RevHP_HC_W_VF_M_MT__ = RevHP_HP_ON_int * v_dot_HT_FL_set;
      RevHP_HC_W_VF_M_LT__ = RevHP_HP_ON_int * v_dot_MT_FL_set;
//========== Convert Mass Flow [kg/s] to Volume Flow [m³/h]=================
      m_dot_HT_FL = RevHP_HC_W_VF_M_MT__ * rho_water / 3600 "Volume of water against time [m³/h]. Forcing the mass flow to be 0 when component is OFF";
      m_dot_MT_FL = RevHP_HC_W_VF_M_LT__ * rho_water / 3600;
      m_dot_HT_FL_Set = v_dot_HT_FL_set * rho_water / 3600;
      m_dot_MT_FL_Set = v_dot_MT_FL_set * rho_water / 3600;
//================== Connectors equations ========================
      RevHP_HC_W_T_M_MT_FL_ = RevHP_HX_HT_Out.T;
      RevHP_HC_W_T_M_LT_FL_ = RevHP_HX_MT_Out.T;
      RevHP_HC_W_T_M_MT_RL_ = RevHP_HX_HT_In.T;
      RevHP_HC_W_T_M_LT_RL_ = RevHP_HX_MT_In.T;
      m_dot_HT_FL = RevHP_HX_HT_Out.m_dot;
      m_dot_MT_FL = RevHP_HX_MT_Out.m_dot;
      DobleTempIn.T1 = Temp_Low "Temperature corresponding to layer selected by user in Tank Model, This is at top of tank";
      DobleTempIn.T2 = Temp_High "Temperature corresponding to layer selected by user in Tank Model, This is at bottom of tank";
      RevHP_HP_ON_int = V_HT;
/***************** Main equations ********************************/
//================== Operational Logic Equations===================
//If RevHP_HP is turned off over hysteresis control then RevHP_HP_ON_int is also = 0
      RevHP_HP_ON_int = if heat then RevHP_HP_ON else 0;
//=========== Heating Capacity equation using curve fit from data sheet ===========
// data is fit for temperature in data sheet LWE -10 to 20 and LWC  20 to 55
//    RevHP_HC_W_PT_M_MT__ = 13.87856214 + 0.294510922 * RevHP_HC_W_T_M_LT_RL_ + 0.064700246 * RevHP_HC_W_T_M_MT_RL_ + 0.002953381 * RevHP_HC_W_T_M_MT_RL_ * RevHP_HC_W_T_M_LT_RL_ - 0.001625553 * RevHP_HC_W_T_M_LT_RL_ ^ 2 - 0.001627312 * RevHP_HC_W_T_M_MT_RL_ ^ 2;
/*******************************************************************************************
        RevHP_HC_W_PT_M_MT__ = 11.67856214 + 0.294510922 * RevHP_HC_W_T_M_LT_RL_ + 0.064700246 * RevHP_HC_W_T_M_MT_RL_ + 0.002953381 * RevHP_HC_W_T_M_MT_RL_ * RevHP_HC_W_T_M_LT_RL_ - 0.001625553 * RevHP_HC_W_T_M_LT_RL_ ^ 2 - 0.001627312 * RevHP_HC_W_T_M_MT_RL_ ^ 2;
    *********************************************************************************************/
      RevHP_HC_W_PT_M_MT__ = RevHP_HP_ON_int * (9.0 + 0.294510922 * RevHP_HC_W_T_M_LT_RL_ + 0.064700246 * RevHP_HC_W_T_M_MT_RL_ + 0.002953381 * RevHP_HC_W_T_M_MT_RL_ * RevHP_HC_W_T_M_LT_RL_ - 0.001625553 * RevHP_HC_W_T_M_LT_RL_ ^ 2 - 0.001627312 * RevHP_HC_W_T_M_MT_RL_ ^ 2);
//=========== Energy Balance over the Heat Pump Cycle =============
      RevHP_HC_W_PT_M_LT__ = RevHP_HC_W_PT_M_MT__ - RevHP_HC_E_PE_M___ "Equation based on the Heat Pump Cycle, check literature";
//==== Calculate RevHP_HC_W_T_M_MT_FL__K using Energy Balance in HT Circuit =====
//    RevHP_HC_W_PT_M_MT__ = m_dot_HT_FL * cpw * (RevHP_HC_W_T_M_MT_FL__K - RevHP_HC_W_T_M_MT_RL__K);
      RevHP_HC_W_T_M_MT_FL__K = RevHP_HC_W_T_M_MT_RL__K + RevHP_HC_W_PT_M_MT__ / (m_dot_HT_FL_Set * cpw);
//==== Calculate RevHP_HC_W_T_M_LT_FL__K using Energy Balance in MT Circuit =====
//    RevHP_HC_W_PT_M_LT__ = m_dot_MT_FL * cpw * (RevHP_HC_W_T_M_LT_RL__K - RevHP_HC_W_T_M_LT_FL__K) "Temp. otherway round because temp. coming back from OC is warmer";
      RevHP_HC_W_T_M_LT_FL__K = RevHP_HC_W_T_M_LT_RL__K - RevHP_HC_W_PT_M_LT__ / (m_dot_MT_FL_Set * cpw);
//================== Power Input =============================
// Electrical Power Input using curve fit from data sheet
//  RevHP_HC_E_PE_M___ = 2.233202228 - 0.007333788 * RevHP_HC_W_T_M_LT_RL_ + 0.019283658 * RevHP_HC_W_T_M_MT_RL_ + 0.000450498 * RevHP_HC_W_T_M_MT_RL_ * RevHP_HC_W_T_M_LT_RL_ - 0.000083048 * RevHP_HC_W_T_M_LT_RL_ ^ 2 + 0.000671146 * RevHP_HC_W_T_M_MT_RL_ ^ 2;
      RevHP_HC_E_PE_M___ = RevHP_HP_ON_int * (1.733202228 - 0.007333788 * RevHP_HC_W_T_M_LT_RL_ + 0.019283658 * RevHP_HC_W_T_M_MT_RL_ + 0.000450498 * RevHP_HC_W_T_M_MT_RL_ * RevHP_HC_W_T_M_LT_RL_ - 0.000083048 * RevHP_HC_W_T_M_LT_RL_ ^ 2 + 0.000671146 * RevHP_HC_W_T_M_MT_RL_ ^ 2);
//  end if;
//=========================Color and Shape========================
      annotation(
        Icon(graphics = {Ellipse(extent = {{-48, -18}, {-48, -18}}, endAngle = 360), Rectangle(extent = {{-24, 84}, {-24, 84}}), Rectangle(extent = {{-22, 82}, {-22, 82}}), Rectangle(extent = {{-50, 74}, {-50, 74}}), Bitmap(extent = {{64, 14}, {64, 14}}), Bitmap(extent = {{-100, 100}, {100, -100}}, imageSource = "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")}, coordinateSystem(initialScale = 0.1)),
        experiment(StartTime = 0, StopTime = 9000, Tolerance = 1e-06, Interval = 60));
    end RevHP_HP;

    model RevHP_CC "Model for the Reversible heat pump - Cooling Mode"
      //============ Imported Library ===============
      import SI = Modelica.SIunits;
      //================== Parameters ==================================
      parameter Units.VolumeFlow v_dot_LT_FL_set = 2.45 "Volume Flow Rate from the RevHP to the Cold Storage Tank in evaporator circuit[m3/h]" annotation(
        HideResult = true);
      parameter Units.VolumeFlow v_dot_MT_FL_set = 2.62 "Volume Flow Rate from the RevHP to the Outdoor Coil in condenser circuit [m3/h]" annotation(
        HideResult = true);
      parameter SI.Temp_C Lower_Temp_Limit = 10 "Lower temp limit below which RevHP_CCM goes OFF, Temperature corresponding to layer at bottom of tank selected by user in Tank Model" annotation(
        HideResult = true);
      parameter SI.Temp_C Higher_Temp_Limit = 15 "Upper temp limit above which RevHP_CCM goes ON, Temperature corresponding to layer at top of tank selected by user in Tank Model" annotation(
        HideResult = true);
      //================== Constants ===================================
      constant Units.SpecificHeat cpw = 4.18 "Specific heat transfer coefficient of water [kJ/(kg.K)]";
      constant SI.Density rho_water = 994.3025 "Water density [kg/m3]";
      //=============== Variables of the RevHP =========================
      Boolean cool "Boolean Parameter to introduce Hysteresis" annotation(
        HideResult = true);
      SI.Temp_C RevHP_HC_W_T_M_LT_FL "LWE: Temp. going to CTES";
      SI.Temp_C RevHP_HC_W_T_M_MT_FL "LWC: Temp. going to OC";
      SI.Temp_C RevHP_HC_W_T_M_LT_RL;
      SI.Temp_C RevHP_HC_W_T_M_MT_RL;
      SI.Temp_C Temp_Low annotation(
        HideResult = true);
      SI.Temp_C Temp_High annotation(
        HideResult = true);
      SI.Temp_K RevHP_HC_W_T_M_LT_FL_K annotation(
        HideResult = true);
      SI.Temp_K RevHP_HC_W_T_M_MT_FL_K annotation(
        HideResult = true);
      SI.Temp_K RevHP_HC_W_T_M_LT_RL_K annotation(
        HideResult = true);
      SI.Temp_K RevHP_HC_W_T_M_MT_RL_K annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_LT_FL annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_MT_FL annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_LT_FL_Set annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_MT_FL_Set annotation(
        HideResult = true);
      Units.Power_kW RevHP_HC_W_PT_M_LT__;
      Units.Power_kW RevHP_HC_W_PT_M_MT__;
      Units.Power_kW RevHP_HC_E_PE_M___;
      Units.unitless RevHP_CC_ON_int;
      Units.VolumeFlow RevHP_HC_W_VF_M_LT__;
      Units.VolumeFlow RevHP_HC_W_VF_M_MT__;
      //==================== Connectors ================================
      Interfaces.MassFlow_out_LT RevHP_CTES_Out annotation(
        Placement(visible = true, transformation(origin = {40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.Temp_LT RevHP_CTES_In annotation(
        Placement(visible = true, transformation(origin = {-40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.Temp_MT RevHP_OC_In annotation(
        Placement(visible = true, transformation(origin = {-40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.MassFlow_out_MT RevHP_OC_Out annotation(
        Placement(visible = true, transformation(origin = {40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.RealInput RevHP_CC_ON annotation(
        Placement(visible = true, transformation(origin = {-100, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-98, 78}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Interfaces.DobleTemp DoubleTempIn annotation(
        Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      //================================================================
      //================== Algorithm Section: RevHP Conventional Control=============================
    initial equation
      cool = true;
    algorithm
// Hysteresis Loop for internal control of RevHP. The cooling differential is based on inlet to evaporator and dT is defined as parameter
      when Temp_High >= Higher_Temp_Limit then
        cool := true;
      end when;
//  "when temp. at bottom of CTES is higher than limit then CCM goes ON"
      when Temp_Low <= Lower_Temp_Limit then
        cool := false;
      end when;
//================== RevHP equations =============================
    equation
//================== Temperatures from °C to K ====================
      RevHP_HC_W_T_M_LT_FL_K = RevHP_HC_W_T_M_LT_FL + 273.15;
      RevHP_HC_W_T_M_MT_FL_K = RevHP_HC_W_T_M_MT_FL + 273.15;
      RevHP_HC_W_T_M_LT_RL_K = RevHP_HC_W_T_M_LT_RL + 273.15;
      RevHP_HC_W_T_M_MT_RL_K = RevHP_HC_W_T_M_MT_RL + 273.15;
//================= Volume set equations ========================
      RevHP_HC_W_VF_M_LT__ = RevHP_CC_ON_int * v_dot_LT_FL_set;
      RevHP_HC_W_VF_M_MT__ = RevHP_CC_ON_int * v_dot_MT_FL_set;
//================== Volume Flow to Mass Flow =====================
//With new conventional control mass flow is zero when temperatures in tanks are reached as the pumps are also shut down//
      m_dot_LT_FL = RevHP_HC_W_VF_M_LT__ * rho_water / 3600 "Volume of water against time [m³/h]. Forcing the mass flow to be 0 when component is OFF";
      m_dot_MT_FL = RevHP_HC_W_VF_M_MT__ * rho_water / 3600;
      m_dot_LT_FL_Set = v_dot_LT_FL_set * rho_water / 3600 "Volume of water against time [m³/h]. Forcing the mass flow to be 0 when component is OFF";
      m_dot_MT_FL_Set = v_dot_MT_FL_set * rho_water / 3600;
//================== Connectors equations ========================
      RevHP_HC_W_T_M_LT_FL = RevHP_CTES_Out.T "LWE: Temp. going to CTES";
      RevHP_HC_W_T_M_MT_FL = RevHP_OC_Out.T "LWC: Temp. going to OC";
      RevHP_HC_W_T_M_LT_RL = RevHP_CTES_In.T "Temp. coming from CTES";
      RevHP_HC_W_T_M_MT_RL = RevHP_OC_In.T;
      m_dot_LT_FL = RevHP_CTES_Out.m_dot;
      m_dot_MT_FL = RevHP_OC_Out.m_dot;
      Temp_Low = DoubleTempIn.T1;
      Temp_High = DoubleTempIn.T2;
/***************** Main equations ********************************/
//================== Operational Logic Equations===================
//If RevHP_CC is turned off over hysteresis control then RevHP_CC_ON_int is also = 0
      RevHP_CC_ON_int = if cool then RevHP_CC_ON else 0;
//================== RevHP equations =============================
// data is fit for temperature in data sheet LWE -10 to 20 and LWC  20 to 55
//Cooling Capacity equation using curve fit from data sheet
//    RevHP_HC_W_PT_M_LT__ = 11.55794683 + 0.308329176 * RevHP_HC_W_T_M_LT_FL + 0.045285097 * RevHP_HC_W_T_M_MT_FL + 0.002252906 * RevHP_HC_W_T_M_LT_FL * RevHP_HC_W_T_M_MT_FL - 0.001213212 * RevHP_HC_W_T_M_LT_FL ^ 2 - 0.002264659 * RevHP_HC_W_T_M_MT_FL ^ 2;
//    RevHP_HC_W_PT_M_LT__ = 11.55794683 + 0.308329176 * RevHP_HC_W_T_M_LT_RL + 0.045285097 * RevHP_HC_W_T_M_MT_RL + 0.002252906 * RevHP_HC_W_T_M_LT_RL * RevHP_HC_W_T_M_MT_RL - 0.001213212 * RevHP_HC_W_T_M_LT_RL ^ 2 - 0.002264659 * RevHP_HC_W_T_M_MT_RL ^ 2;
      RevHP_HC_W_PT_M_LT__ = RevHP_CC_ON_int * (9.000 + 0.308329176 * RevHP_HC_W_T_M_LT_RL + 0.045285097 * RevHP_HC_W_T_M_MT_RL + 0.002252906 * RevHP_HC_W_T_M_LT_RL * RevHP_HC_W_T_M_MT_RL - 0.001213212 * RevHP_HC_W_T_M_LT_RL ^ 2 - 0.002264659 * RevHP_HC_W_T_M_MT_RL ^ 2);
// Electrical Power Input using curve fit from data sheet
//    RevHP_HC_E_PE_M___ = 2.233202228 - 0.007333788 * RevHP_HC_W_T_M_LT_FL + 0.019283658 * RevHP_HC_W_T_M_MT_FL + 0.000450498 * RevHP_HC_W_T_M_LT_FL * RevHP_HC_W_T_M_MT_FL - 0.000083048 * RevHP_HC_W_T_M_LT_FL ^ 2 + 0.000671146 * RevHP_HC_W_T_M_MT_FL ^ 2;
//    RevHP_HC_E_PE_M___ = 2.233202228 - 0.007333788 * RevHP_HC_W_T_M_LT_RL + 0.019283658 * RevHP_HC_W_T_M_MT_RL + 0.000450498 * RevHP_HC_W_T_M_LT_RL * RevHP_HC_W_T_M_MT_RL - 0.000083048 * RevHP_HC_W_T_M_LT_RL ^ 2 + 0.000671146 * RevHP_HC_W_T_M_MT_RL ^ 2;
      RevHP_HC_E_PE_M___ = RevHP_CC_ON_int * (1.833202228 - 0.007333788 * RevHP_HC_W_T_M_LT_RL + 0.019283658 * RevHP_HC_W_T_M_MT_RL + 0.000450498 * RevHP_HC_W_T_M_LT_RL * RevHP_HC_W_T_M_MT_RL - 0.000083048 * RevHP_HC_W_T_M_LT_RL ^ 2 + 0.000671146 * RevHP_HC_W_T_M_MT_RL ^ 2);
//Calculate RevHP_HC_W_PT_M_MT__ using Energy Balance, this should be equal to P_th_OC
      RevHP_HC_W_PT_M_MT__ = RevHP_HC_E_PE_M___ + RevHP_HC_W_PT_M_LT__;
//Calculate RevHP_HC_W_T_M_LT_FL_K using this equation
//    RevHP_HC_W_PT_M_LT__ = m_dot_LT_FL_Set * cpw * (RevHP_HC_W_T_M_LT_RL_K - RevHP_HC_W_T_M_LT_FL_K);
      RevHP_HC_W_T_M_LT_FL_K = RevHP_HC_W_T_M_LT_RL_K - RevHP_HC_W_PT_M_LT__ / (m_dot_LT_FL_Set * cpw);
//Calculate RevHP_HC_W_T_M_MT_FL_K using this equation
      RevHP_HC_W_T_M_MT_FL_K = RevHP_HC_W_T_M_MT_RL_K + RevHP_HC_W_PT_M_MT__ / (m_dot_MT_FL_Set * cpw);
//  end if;
//======================== Color and Shape ============================
      annotation(
        Icon(graphics = {Ellipse(extent = {{-48, -18}, {-48, -18}}, endAngle = 360), Rectangle(extent = {{-24, 84}, {-24, 84}}), Rectangle(extent = {{-22, 82}, {-22, 82}}), Rectangle(extent = {{-50, 74}, {-50, 74}}), Bitmap(extent = {{64, 14}, {64, 14}}), Bitmap(extent = {{-98, 98}, {100, -100}}, imageSource = "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")}, coordinateSystem(initialScale = 0.1)));
    end RevHP_CC;

    model LOAD_C
      import SI = Modelica.SIunits;
      //================== Parameters =======================
      parameter Units.Power_kW Pth_CC "Thermal Power of the LOAD";
      //parameter SI.Temp_C delta_T_CC "Temperature difference between T_FL_CC and T_RL_CC";
      parameter SI.Temp_C T_CC_FL " Temeprature going to Climate Chamber";
      parameter Units.VolumeFlow v_dot_CC "Volume Flow going to the Climate Chamber [m3/h]";
      //================== Constants ========================
      constant SI.Density rho_water = 994.3025 "Water density [kg/m3]";
      constant Units.SpecificHeat cpw = 4.18 "Specific heat transfer coefficient of water" annotation(
        HideResult = false);
      //================== Variable =========================
      SI.Temp_C LOAD_HC_W_T_M__FL_ "Temp from tank to 3-MV";
      SI.Temp_C LOAD_HC_W_T_M__RL_ "Temp from 3-MV back to Tank, is the same as temp. coming back from climate chamber = T_CC_RL";
      SI.Temp_C T_CC_RL;
      SI.Temp_K LOAD_HC_W_T_M__FL__K annotation(
        HideResult = true);
      SI.Temp_K T_CC_RL_K annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_LOAD "Mass Flow going to the LOAD [kg/s]" annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_CC "Mass Flow going to the Climate Chamber[kg/s]" annotation(
        HideResult = true);
      Units.VolumeFlow LOAD_HC_W_VF_M___ "Volume Flow going to the LOAD [m3/h]";
      //================== Connector =========================
      Interfaces.Temp_LT LOAD_In annotation(
        Placement(visible = true, transformation(origin = {40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.MassFlow_out_LT LOAD_Out annotation(
        Placement(visible = true, transformation(origin = {-40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
//============== Connector equation ==================
      LOAD_HC_W_T_M__FL_ = LOAD_In.T;
      LOAD_HC_W_T_M__RL_ = LOAD_Out.T;
      m_dot_LOAD = LOAD_Out.m_dot;
//============ Mass flow kg/s to Volume Flow m3/h ==============
      m_dot_LOAD = LOAD_HC_W_VF_M___ * rho_water / 3600;
      m_dot_CC = v_dot_CC * rho_water / 3600;
//================== Temperature equation from °C to K ==================
      LOAD_HC_W_T_M__FL__K = LOAD_HC_W_T_M__FL_ + 273.15;
      T_CC_RL_K = T_CC_RL + 273.15;
//================== Main equations =====================================
      LOAD_HC_W_T_M__RL_ = T_CC_RL "Temp coming back from CC is the one going back to the Tank";
//============== dT in Climate Chamber ==================
//  delta_T_CC = T_CC_RL - T_CC_FL "Temperature are other way round since it is cooling";
//============== Energy Balance in Climate Chamber to calculate T_RL_CC==================
      Pth_CC = m_dot_CC * cpw * (T_CC_RL - T_CC_FL) "Temperature are other way round since it is cooling";
//============== Energy Balance Based on 3-MV Equations.Check Documentation==================
      Pth_CC = m_dot_LOAD * cpw * (T_CC_RL_K - LOAD_HC_W_T_M__FL__K) "Temperatures switched for cooling";
//================== Color and shape =================
      annotation(
        Icon(coordinateSystem(initialScale = 0.1), graphics = {Bitmap(extent = {{-100, 100}, {100, -100}}, imageSource = "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")}));
    end LOAD_C;

    model PlateHeatExchanger_NTU "Model for heat exchanger"
      //=============Imported units ============= (types)
      import SI = Modelica.SIunits;
      //==================== Parameters ==============
      parameter SI.Area A = 0.52 "Heat exchange surface area [m2]" annotation(
        HideResult = true);
      parameter Units.HeatTransfer U = 2.22 "Overall heat transfer coefficient [kW/m2.°C]" annotation(
        HideResult = true);
      constant Units.SpecificHeat cph = 4.16991 "Specific heat coefficient of water [kJ/kg.K]" annotation(
        HideResult = true);
      constant Units.SpecificHeat cpc = 3.66736 "Specific heat coefficient of Ethylene glycol 34% [kJ/kg.K]" annotation(
        HideResult = true);
      //
      //==================== Varialbles ==============
      //***************** Temperature variables **********************
      SI.Temp_C T_h_in "Inlet Temperature of hot fluid [°C]" annotation(
        HideResult = true);
      SI.Temp_C T_h_out "Outlet Temperature of hot fluid [°C]" annotation(
        HideResult = true);
      SI.Temp_C T_c_in "Inlet Temperature of cold fluid [°C]" annotation(
        HideResult = true);
      SI.Temp_C T_c_out "Outlet Temperature of cold fluid [°C]" annotation(
        HideResult = true);
      Units.HeatCapacityRate Cmax "Maximum heat capacity rate [kW/K]" annotation(
        HideResult = true);
      Units.HeatCapacityRate Cmin "Minimum heat capacity rate [kW/K]" annotation(
        HideResult = true);
      Units.HeatCapacityRate Chot "Heat capacity rate of the hot fluid [kW/K]" annotation(
        HideResult = true);
      Units.HeatCapacityRate Ccold "Heat capacity rate of the cold fluid [kW/K]" annotation(
        HideResult = true);
      Units.HeatCapacityRate Cr "Heat capacity ratio  " annotation(
        HideResult = true);
      SI.Power qmax "Maximum heat that could be transferred between the fluids per unit time [kW]" annotation(
        HideResult = true);
      SI.Power q "Heat transfer between the fluid [kW]" annotation(
        HideResult = true);
      Units.unitless NTU "Number of Transfer Units (NTU)" annotation(
        HideResult = true);
      Units.unitless eff "Effectiveness" annotation(
        HideResult = true);
      //***************mass flow varibles**************
      SI.MassFlowRate m_dot_c_in "Outlet mass flow of cold fluid [kg/s]" annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_h_in "Inlet mass flow of hot fluid [kg/s]" annotation(
        HideResult = true);
      //***********************************************
      SI.Temp_K T_h_in_K annotation(
        HideResult = true);
      SI.Temp_K T_h_out_K annotation(
        HideResult = true);
      SI.Temp_K T_c_in_K annotation(
        HideResult = true);
      SI.Temp_K T_c_out_K annotation(
        HideResult = true);
      //
      //==================== Connector Variables ==================
      Interfaces.MassFlow_In_LT HX_OC_in annotation(
        HideResult = true,
        Placement(visible = true, transformation(origin = {-100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.Temp_LT HX_OC_Out annotation(
        HideResult = true,
        Placement(visible = true, transformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.MassFlow_In_HT HX_AdCM_in annotation(
        HideResult = true,
        Placement(visible = true, transformation(origin = {100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.Temp_HT HX_AdCM_Out annotation(
        HideResult = true,
        Placement(visible = true, transformation(origin = {-100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      //
    equation
//==================== Connector Equations =================
      T_h_in = HX_AdCM_in.T "inlet hot fluid temperature";
      T_h_out = HX_AdCM_Out.T "outlet hot fluid temperature";
      T_c_in = HX_OC_in.T "inlet cold fluid temperature";
      T_c_out = HX_OC_Out.T "outlet cold fluid temperature";
//
      m_dot_c_in = HX_OC_in.m_dot "outlet cold mass flow";
      m_dot_h_in = HX_AdCM_in.m_dot "inlet hot mass flow";
//==================== Temperature from °C to K ======================
      T_h_in_K = T_h_in + 273.15;
      T_c_in_K = T_c_in + 273.15;
      T_h_out_K = T_h_out + 273.15;
      T_c_out_K = T_c_out + 273.15;
//==================== Heat capacity rate ============================
      Chot = m_dot_h_in * cph;
      Ccold = m_dot_c_in * cpc;
//==================== Conditional for maximum and minimum C =========
      Cmin = min(Chot, Ccold);
      Cmax = max(Chot, Ccold);
//==================== NTU method ====================================
      qmax = Cmin * (T_h_in - T_c_in);
      eff = (1 - exp(-NTU * (1 - Cr))) / (1 - Cr * exp(-NTU * (1 - Cr)));
      q = eff * qmax;
//==================== Operational logic equations==========
      if Cmax == 0 or Cmin == 0 then
        Cr = 0;
        NTU = 0;
        T_h_in - T_h_out = 0;
        T_c_out - T_c_in = 0;
      else
        Cr = Cmin / Cmax;
        NTU = U * A / Cmin;
        q = Chot * (T_h_in - T_h_out);
        q = Ccold * (T_c_out - T_c_in);
      end if;
//Color and Shape
      annotation(
        Icon(graphics = {Rectangle(extent = {{-100, 80}, {100, -80}}), Line(origin = {0, 40.13}, points = {{-110, -0.129947}, {-80, -0.129947}, {-60, 19.8701}, {-40, -20.1299}, {-20, 19.8701}, {0, -20.1299}, {20, 19.8701}, {40, -20.1299}, {60, 19.8701}, {80, -0.129947}, {110, -0.129947}, {110, -0.129947}}, color = {0, 85, 255}, thickness = 1), Line(origin = {0, -39.87}, points = {{-108, -0.129947}, {-80, -0.129947}, {-60, 19.8701}, {-40, -20.1299}, {-20, 19.8701}, {0, -20.1299}, {20, 19.8701}, {40, -20.1299}, {60, 19.8701}, {80, -0.129947}, {108, -0.129947}}, color = {255, 0, 0}, thickness = 1)}, coordinateSystem(initialScale = 0.1)));
      annotation(
        HideResult = true);
    end PlateHeatExchanger_NTU;

    model OutdoorCoil_NTU_CCM "Check documentation for Excel File and Parameter Values"
      //================= Imported Library =============================
      import SI = Modelica.SIunits;
      //================== Parameters ==================================
      parameter Units.VolumeFlow v_dot_air_max = 18000 "Maximum volume flow of air [m3/h]" annotation(
        HideResult = true);
      parameter SI.Voltage Volt_max = 10 "Max voltage signal input to the OC [V]" annotation(
        HideResult = true);
      parameter SI.Voltage Volt_Input = 10 "Voltage signal input to the OC [V]" annotation(
        HideResult = true);
      parameter SI.Area A = 221.4 "Heat exchange surface area [m2]" annotation(
        HideResult = true);
      parameter Units.HeatTransfer U = 37.49723032 / 1000 "Overall heat transfer coefficient [kW/m2.°C]" annotation(
        HideResult = true);
      parameter Units.RPM RPM_max = 900 "Max RPM of the fan" annotation(
        HideResult = true);
      parameter SI.Power Pel_max = 1.4 "Maximum electrical power consumption of OC" annotation(
        HideResult = true);
      //================== Constants ===================================
      constant SI.Density rho = 1039.7392 "34% Glycol-Water  Mixture Density [kg/m3]";
      constant SI.Density rho_air = 1.225 "Density of Air[kg/m3]";
      constant Units.SpecificHeat cp_air = 1.005 "Specific heat transfer coefficient of air [kJ/(kg.K)]";
      constant Units.SpecificHeat cpw = 4.18 "Specific heat transfer coefficient of water[kJ/(kg.K)]";
      //================== Variables of the OC =========================
      /********************* Temperature ***********************/
      SI.Temp_C OC_HC_B_T_M__FL "Temperature that leaves the OC going to AdCM/Rev_HP [°C]";
      SI.Temp_C OC_HC_B_T_M__RL "Temperature that enters the OC coming from the AdCM/Rev_HP [°C]";
      SI.Temp_C T_air_out "Air temperature at fan outlet[°C]" annotation(
        HideResult = true);
      /*********************************************************/
      SI.Temp_K OC_HC_B_T_M__FL_K annotation(
        HideResult = true);
      SI.Temp_K OC_HC_B_T_M__RL_K annotation(
        HideResult = true);
      SI.Temp_K T_air_out_K annotation(
        HideResult = true);
      /**************** Mass and Volume flow rate **************/
      SI.MassFlowRate m_dot_OC "Mass flow rate of glycol-water mixture in the OC circuit[kg/s]" annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_air "Mass flow rate of air at fan inlet [kg/s]" annotation(
        HideResult = true);
      Units.VolumeFlow v_dot_OC "Volume flow rate of glycol-water mixture in the OC circuit [m³/h]";
      /******************* Heat capacity rate ******************/
      Units.HeatCapacityRate Chot "Heat capacity rate of the hot fluid[kW/K]" annotation(
        HideResult = true);
      Units.HeatCapacityRate Ccold "Heat capacity rate of cold fluid[kW/K]" annotation(
        HideResult = true);
      Units.HeatCapacityRate Cmax "Maximum heat capacity rate [kW/K]" annotation(
        HideResult = true);
      Units.HeatCapacityRate Cmin "Minimum heat capacity rate [kW/K]" annotation(
        HideResult = true);
      Units.HeatCapacityRate Cr "Heat capacity ratio" annotation(
        HideResult = true);
      /******************* Heat rate and cp ********************/
      SI.Power qmax "Maximum heat that could be transferred between the fluids per unit time[kW]" annotation(
        HideResult = true);
      SI.Power q "Real heat transfer between the fluid [kW]";
      /***************** NTU and Effectiveness *****************/
      Units.unitless NTU "Number of Transfer Units (NTU)" annotation(
        HideResult = true);
      Units.unitless eff "Effectiveness" annotation(
        HideResult = true);
      /***************** Variables for Fan Affinity Laws ***********************/
      SI.Voltage Volt_real "Real Voltage Signal to OC [V]";
      Units.RPM RPM_real "Real RPM of the fan" annotation(
        HideResult = true);
      SI.Power OC_HC_E_PE_M "Real electrical power consumption of OC";
      Units.VolumeFlow v_dot_air_real "Real air volume flow [m3/h]" annotation(
        HideResult = true);
      //==================== Connectors ================================
      Interfaces.Temp_MT OC_RevHP_Out annotation(
        Placement(visible = true, transformation(origin = {-40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.MassFlow_In_MT OC_RevHP_In annotation(
        Placement(visible = true, transformation(origin = {40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.Amb_Temp T_amb annotation(
        Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      //================== OC equations ================================
    equation
//================== Connector equations =========================
      OC_RevHP_Out.T = OC_HC_B_T_M__FL;
      OC_RevHP_In.T = OC_HC_B_T_M__RL;
      OC_RevHP_In.m_dot = m_dot_OC;
//================== Temperature Conversion ======================
      OC_HC_B_T_M__FL_K = OC_HC_B_T_M__FL + 273.15;
      OC_HC_B_T_M__RL_K = OC_HC_B_T_M__RL + 273.15;
      T_air_out_K = T_air_out + 273.15;
//=========== Conversion of Volume Flow to Mass Flow ==============
      m_dot_OC = v_dot_OC * rho / 3600;
      m_dot_air = v_dot_air_real * rho_air / 3600;
//================== Main equations ===============================
//==================== Heat capacity rate ==========================
      Chot = m_dot_OC * cpw;
      Ccold = m_dot_air * cp_air;
//==================== NTU method ====================================
      Cmin = min(Chot, Ccold);
      Cmax = max(Chot, Ccold);
      qmax = Cmin * (OC_HC_B_T_M__RL - T_amb.T);
      q = eff * qmax;
      eff = (1 - exp(-NTU * (1 - Cr))) / (1 - Cr * exp(-NTU * (1 - Cr)));
//================== Operational Logic Equations ==================
      if Cmin == 0 or Cmax == 0 then
        Cr = 0 "to avoid division by zero";
        NTU = 0 "to avoid division by zero";
      else
        Cr = Cmin / Cmax;
        NTU = U * A / Cmin;
      end if;
//====== Energy equations for temperature calculation ====================================
      q = Chot * (OC_HC_B_T_M__RL - OC_HC_B_T_M__FL);
      q = Ccold * (T_air_out - T_amb.T);
//==================== Fan Affinity Laws==========================
      if v_dot_OC == 0 then
        Volt_real = 0.001;
      else
        Volt_real = Volt_Input;
      end if;
      RPM_max / RPM_real = Volt_max / Volt_real;
      Pel_max / OC_HC_E_PE_M = RPM_max ^ 3 / RPM_real ^ 3;
      v_dot_air_max / v_dot_air_real = RPM_max / RPM_real;
//======================= Color and Shape ========================
      annotation(
        Icon(coordinateSystem(initialScale = 0.1), graphics = {Bitmap(extent = {{-100, 100}, {100, -100}}, imageSource = "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")}));
    end OutdoorCoil_NTU_CCM;

    model OutdoorCoil_NTU "Check documentation for Excel File and Parameter Values"
      //================= Imported Library =============================
      import SI = Modelica.SIunits;
      //==================Parameters ==================================
      parameter Units.VolumeFlow v_dot_air_max = 18000 "Maximum volume flow of air [m3/h]" annotation(
        HideResult = true);
      parameter SI.Voltage Volt_max = 10 "Max voltage signal input to the OC [V]" annotation(
        HideResult = true);
      parameter SI.Voltage Volt_real = 10 "Max voltage signal input to the OC [V]" annotation(
        HideResult = true);
      parameter SI.Area A = 221.4 "Heat exchange surface area [m2]" annotation(
        HideResult = true);
      parameter Units.HeatTransfer U = 37.49723032 / 1000 "Overall heat transfer coefficient [kW/m2.°C]" annotation(
        HideResult = true);
      parameter Units.VolumeFlow v_dot_OC = 4.76 "Volume flow of Ethynele Glycol 34% that goes to the HX [m3/h]" annotation(
        HideResult = true);
      parameter Units.RPM RPM_max = 900 "Max RPM of the fan" annotation(
        HideResult = true);
      parameter SI.Power Pel_max = 1.4 "Maximum electrical power consumption of OC" annotation(
        HideResult = true);
      //================== Constants ===================================
      constant SI.Density rho_brine = 1039.7392 "Density of Ethylene Glycol 34% [kg/m3]";
      constant SI.Density rho_air = 1.225 "Air density [kg/m3]";
      constant Units.SpecificHeat cp_air = 1.005 "Specific heat transfer coefficient of air [kJ/(kg.K)]";
      constant Units.SpecificHeat cp_brine = 3.66736 "Specific heat transfer coefficient of Ethynele Glycol 34%[kJ/(kg.K)]";
      //================== Variables of the OC =========================
      /********************* Temperature ***********************/
      SI.Temp_C OC_HC_B_T_M__FL "Temperature that leaves the OC going to AdCM/Rev_HP [°C]";
      SI.Temp_C OC_HC_B_T_M__RL "Temperature that enters the OC coming from the AdCM/Rev_HP [°C]";
      SI.Temp_C T_air_out "Air temperature at fan outlet[°C]" annotation(
        HideResult = true);
      /*********************************************************/
      SI.Temp_K OC_HC_B_T_M__FL_K annotation(
        HideResult = true);
      SI.Temp_K OC_HC_B_T_M__RL_K annotation(
        HideResult = true);
      SI.Temp_K T_air_out_K annotation(
        HideResult = true);
      /**************** Mass and Volume flow rate **************/
      SI.MassFlowRate m_dot_OC "Mass flow rate of glycol-water mixture in the OC circuit [kg/s]" annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_air "Mass flow rate of air at fan inlet [kg/s]" annotation(
        HideResult = true);
      /******************* Heat capacity rate ******************/
      Units.HeatCapacityRate Chot "Heat capacity rate of the hot fluid[kW/K] [kW/K]" annotation(
        HideResult = true);
      Units.HeatCapacityRate Ccold "Heat capacity rate of the cold fluid[kW/K] [kW/K]" annotation(
        HideResult = true);
      Units.HeatCapacityRate Cmax "Maximum heat capacity rate [kW/K]" annotation(
        HideResult = true);
      Units.HeatCapacityRate Cmin "Minimum heat capacity rate [kW/K]" annotation(
        HideResult = true);
      Units.HeatCapacityRate Cr "Heat capacity ratio" annotation(
        HideResult = true);
      /******************* Heat rate and cp ********************/
      SI.Power qmax "Maximum heat that could be transferred between the fluids per unit time [kW]" annotation(
        HideResult = true);
      SI.Power q "Real heat transfer between the fluids [kW]";
      /***************** NTU and Effectiveness *****************/
      Units.unitless NTU "Number of Transfer Units (NTU)" annotation(
        HideResult = true);
      Units.unitless eff "Effectiveness" annotation(
        HideResult = true);
      /***************** Other variables ***********************/
      Units.RPM RPM_real "Real RPM of the fan" annotation(
        HideResult = true);
      SI.Power OC_HC_E_PE_M "Real electrical power consumption of OC";
      Units.VolumeFlow v_dot_air_real "Real air volume flow [m3/h]" annotation(
        HideResult = true);
      //==================== Connectors ================================
      Interfaces.Temp_MT OC_HX_in annotation(
        Placement(visible = true, transformation(origin = {40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.MassFlow_out_MT OC_HX_Out annotation(
        Placement(visible = true, transformation(origin = {-40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.Amb_Temp T_amb annotation(
        Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      //
      /*********************** OC equations **************************/
      //
    equation
//================== Connector equations ===========================
      OC_HX_in.T = OC_HC_B_T_M__RL;
      OC_HX_Out.T = OC_HC_B_T_M__FL;
      OC_HX_Out.m_dot = m_dot_OC;
//================== Temperature Conversion ========================
      OC_HC_B_T_M__FL_K = OC_HC_B_T_M__FL + 273.15;
      OC_HC_B_T_M__RL_K = OC_HC_B_T_M__RL + 273.15;
      T_air_out_K = T_air_out + 273.15;
//=========== Conversion of Volume Flow to Mass Flow ===============
      m_dot_OC = v_dot_OC * rho_brine / 3600;
      m_dot_air = v_dot_air_real * rho_air / 3600;
/********************* Main equations ******************************/
//
//==================== Heat capacity rate ==========================
      Chot = m_dot_OC * cp_brine;
      Ccold = m_dot_air * cp_air;
//==================== NTU method ==================================
      Cmin = min(Chot, Ccold);
      Cmax = max(Chot, Ccold);
      qmax = Cmin * (OC_HC_B_T_M__RL - T_amb.T);
      q = eff * qmax;
      eff = (1 - exp(-NTU * (1 - Cr))) / (1 - Cr * exp(-NTU * (1 - Cr)));
//================== Operational Logic Equations ===================
      if Cmax == 0 or Cmin == 0 then
        Cr = 0;
        NTU = 0;
        OC_HC_B_T_M__RL - OC_HC_B_T_M__FL = 0;
        T_air_out - T_amb.T = 0;
      else
        Cr = Cmin / Cmax;
        NTU = U * A / Cmin;
//====== Energy equations for temperature calculation ==============
        q = Chot * (OC_HC_B_T_M__RL - OC_HC_B_T_M__FL);
        q = Ccold * (T_air_out - T_amb.T);
      end if;
//==================== Fan Affinity Laws==========================
      RPM_max / RPM_real = Volt_max / Volt_real;
      Pel_max / OC_HC_E_PE_M = RPM_max ^ 3 / RPM_real ^ 3;
      v_dot_air_max / v_dot_air_real = RPM_max / RPM_real;
//=================== Electricity costs [€] ===============
//  Op_costs = OC_HC_E_PE_M * elect_price * time / 3600;
//================== Color and Shape ======================================
      annotation(
        Icon(coordinateSystem(initialScale = 0.1), graphics = {Bitmap(extent = {{-100, 100}, {100, -100}}, imageSource = "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")}),
        experiment(StartTime = 0, StopTime = 10800, Tolerance = 1e-06, Interval = 60.3352));
    end OutdoorCoil_NTU;

    model Switch
      parameter Boolean CHP_ON annotation(
        HideResult = true);
      parameter Boolean AdCM_ON annotation(
        HideResult = true);
      parameter Boolean RevHP_HP_ON annotation(
        HideResult = true);
      parameter Boolean RevHP_CC_ON annotation(
        HideResult = true);
      //  parameter Boolean HTES_V_HT annotation(
      //    HideResult = true);
      parameter Boolean Coil_ON annotation(
        HideResult = true);
      //================ Connector variables ==========
      Interfaces.RealOutput AdCM_Switch annotation(
        Placement(visible = true, transformation(origin = {-30, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-20, -98}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      Interfaces.RealOutput RevHP_HP_Switch annotation(
        Placement(visible = true, transformation(origin = {30, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {20, -98}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      Interfaces.RealOutput RevHP_CC_Switch annotation(
        Placement(visible = true, transformation(origin = {70, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {60, -98}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      Interfaces.RealOutput CHP_Switch annotation(
        Placement(visible = true, transformation(origin = {-70, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-60, -98}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealOutput Coil_Switch annotation(
        Placement(visible = true, transformation(origin = {-100, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-100, 40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    equation
//================ CHP switch ===================
      if CHP_ON == true then
        CHP_Switch = 1;
      else
        CHP_Switch = 0;
      end if;
//================ AdCM switch ==================
      if AdCM_ON == true then
        AdCM_Switch = 1;
      else
        AdCM_Switch = 0;
      end if;
//================ RevHP_HP switch ==============
      if RevHP_HP_ON == true then
        RevHP_HP_Switch = 1;
      else
        RevHP_HP_Switch = 0;
      end if;
//================ RevHP_CC switch ==============
      if RevHP_CC_ON == true then
        RevHP_CC_Switch = 1;
      else
        RevHP_CC_Switch = 0;
      end if;
//================ Volume for HTES_HT ===========
//  if HTES_V_HT == true then
//    v_HT = 1;
//  else
//    v_HT = 0;
//  end if;
//================ Switch for the coil ==========
      if Coil_ON == true then
        Coil_Switch = 1;
      else
        Coil_Switch = 0;
      end if;
//================ Color and shape ==============
      annotation(
        Icon(graphics = {Rectangle(origin = {-60, 0}, fillColor = {135, 135, 135}, fillPattern = FillPattern.Solid, extent = {{-8, 60}, {8, -60}}), Rectangle(origin = {-20, 0}, fillColor = {120, 120, 120}, fillPattern = FillPattern.Solid, extent = {{-8, 60}, {8, -60}}), Rectangle(origin = {20, 0}, fillColor = {126, 126, 126}, fillPattern = FillPattern.Solid, extent = {{-8, 60}, {8, -60}}), Rectangle(origin = {61, 0}, fillColor = {135, 135, 135}, fillPattern = FillPattern.Solid, extent = {{-9, 60}, {7, -60}}), Rectangle(origin = {-60, 40}, fillColor = {0, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-20, 8}, {20, -8}}), Rectangle(origin = {-20, -41}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-20, 9}, {20, -7}}), Rectangle(origin = {20, 41}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-20, 7}, {20, -9}}), Rectangle(origin = {60, -40}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-20, 8}, {20, -8}}), Text(origin = {1, 82}, extent = {{-65, 12}, {65, -12}}, textString = "On"), Text(origin = {0, -72}, extent = {{-40, 12}, {40, -12}}, textString = "Off")}));
    end Switch;

    model HTES_Loop "Hot storage stratified tank (HTES) based on eicker book / paper"
      //============= Imported units =============
      import SI = Modelica.SIunits;
      //============= Parameters of temperature and Mass flow =========
      parameter SI.Temp_C T_ini_set = 30 "Initial temperature of the tank [°C], Should always be higher than T_AdCM_RL/T_Load_RL and lower then heat hysteresis loop" annotation(
        HideResult = true);
      //============= Parameters For Tank Dimensions===============
      parameter SI.Length D = 1 " Outer Diameter of the tank [m]" annotation(
        HideResult = true);
      parameter SI.Length h = 2.196 "Height of the tank [m]" annotation(
        HideResult = true);
      parameter SI.Length t = 0.0125 "Thickness of walls [m]" annotation(
        HideResult = true);
      //============= Parameters for Heat Transfer==============
      parameter Units.HeatTransfer kappa = 0.002 "Heat transfer coefficient of storage walls[kW/(m2.K)], depends on tank and insulation material" annotation(
        HideResult = true);
      parameter Units.HeatConductivity lambda_eff = 0.0015 "Effective vertical heat conductivity considering thermal conduction and convection [kW/(m.K)], Eicker Book/Paper" annotation(
        HideResult = true);
      parameter Units.Power_kW P_COIL_Set = 5.9 "Heating Power of COIL [kW]. Since addition of heat to layers in coil is almost linear then heating power is added to each layer above the layers in which COIL is located. For reason see test results" annotation(
        HideResult = true);
      /**************Loop parameter***************/
      parameter Integer n = 90 "Number of Layers in Tank" annotation(
        HideResult = true);
      /*******************************************/
      parameter Units.VolumeFlow v_dot_RevHP_HT_Set = 1.1 "Volumetric flow in the HT circuit that flows in the HX [m3/h]" annotation(
        HideResult = true);
      Boolean heat "Boolean Parameter to introduce Hysteresis" annotation(
        HideResult = true);
      /***************Parameters for deciding Layers****************************/
      parameter Integer Coil_Safety_Layer = 30 "Define layer whose temperature decides COIL Safety" annotation(
        HideResult = true);
      parameter Integer Load_FL_Layer = 60 "Define layer from which water goes to LOAD" annotation(
        HideResult = true);
      parameter Integer AdCM_FL_Layer = 80 "Define layer from which water goes to AdCM" annotation(
        HideResult = true);
      parameter Integer CHP_Layer = 10 "Define Layer from which water goes to the CHP" annotation(
        HideResult = true);
      parameter Integer HX_Layer = 10 "Define Layer from which water goes to the HX" annotation(
        HideResult = true);
      parameter Integer Temp1 = 60 "Layer of the tank which controls the Hysteresis (Lower Temperature Limit)" annotation(
        HideResult = true);
      parameter Integer Temp2 = 10 "Layer of the tank which controls the hysteresis (Higher Temperature Limit)" annotation(
        HideResult = true);
      //================== Constants=====================
      constant SI.Density rho = 994.3025 "Density of water";
      constant Units.SpecificHeat cp = 4.18 "Specific heat transfer coefficient of water[kJ/kg.K]";
      constant Real pi = 3.14159265358979;
      //================== Variables of temperature for the HTES ===================
      /********************* Temperatures in °C ************************/
      SI.Temp_C HTES_H_W_T_M_IT[n] "Array of of size n denoting temperature of 1 to nth layer [°C]";
      SI.Temp_C T_HTES_CHP_In "Temperature coming from the CHP [°C]" annotation(
        HideResult = true);
      SI.Temp_C T_HTES_RevHP_In "Temperature coming from the RevHP [°C]" annotation(
        HideResult = true);
      SI.Temp_C T_HTES_LOAD_RL "Temperature coming back from the LOAD [°C]" annotation(
        HideResult = true);
      SI.Temp_C T_HTES_AdCM_RL "Temperature coming back from the AdCM[°C]" annotation(
        HideResult = true);
      SI.Temp_C T_ini[n] = fill(T_ini_set, n) "fill an array of size n with value T_ini_set that is defined as parameter" annotation(
        HideResult = true);
      /********************* Temperatures in K *************************/
      SI.Temp_K HTES_H_W_T_M_IT_K[n] annotation(
        HideResult = true);
      SI.Temp_K T_ini_K[n] annotation(
        HideResult = true);
      SI.Temp_K T_amb_K annotation(
        HideResult = true);
      SI.Temp_K T_HTES_CHP_In_K annotation(
        HideResult = true);
      SI.Temp_K T_HTES_RevHP_In_K annotation(
        HideResult = true);
      SI.Temp_K T_HTES_LOAD_RL_K annotation(
        HideResult = true);
      SI.Temp_K T_HTES_AdCM_RL_K annotation(
        HideResult = true);
      //================== Variables of mass flow for each layer =================
      SI.MassFlowRate m_dot_CHP "Mass flow coming from the CHP (Top Layer) [kg/s]" annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_RevHP_HT "Mass flow rate in the RevHP_HT circuit (Top Layer) [kg/s]" annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_LOAD "Mass Flow in the LOAD Circuit[kg/s] WHICH LAYER??" annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_AdCM_HT "Mass Flow in the HT AdCM circuit[kg/s] WHICH LAYER??" annotation(
        HideResult = true);
      Units.VolumeFlow v_dot_RevHP_HT "Volume Flow rate in the RevHP_HT circuit [m3/h] WHICH LAYER??" annotation(
        HideResult = true);
      SI.MassFlowRate m_dot[n] "Array of size 'n' representing the effective mass flows between the layers, where layer 1 is at bottom and n at top" annotation(
        HideResult = true);
      //===================== Other Variables =======================================
      Units.Power_kW COIL_H_E_PT_M__ "Power of coil [kW]" annotation(
        HideResult = true);
      SI.Area Alayer "Cross section of the respective layer in contact with above or below layer[m2]" annotation(
        HideResult = true);
      SI.Area Aamb "Cross Section of the respective layer in contact with tank surface and transfering heat to ambient [m2]" annotation(
        HideResult = true);
      SI.Length zi "Height of each layer. Height of tank / Number of Layers zi=h/n" annotation(
        HideResult = true);
      SI.Mass mi "Water mass in the control volume [kg]" annotation(
        HideResult = true);
      SI.Length di "Internal diameter of tank" annotation(
        HideResult = true);
      Units.unitless Coil_ON_int "For internal control logic of COIL" annotation(
        HideResult = true);
      Units.unitless d_pos annotation(
        HideResult = true);
      Units.unitless d_neg annotation(
        HideResult = true);
        
        
      //================= Connectors ===================
      Interfaces.Temp_HT HTES_CHP_Out annotation(
        Placement(visible = true, transformation(origin = {-40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.MassFlow_In_HT HTES_CHP_In annotation(
        Placement(visible = true, transformation(origin = {40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.Temp_HT HTES_LOAD_Out annotation(
        Placement(visible = true, transformation(origin = {-40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.MassFlow_In_HT HTES_LOAD_In annotation(
        Placement(visible = true, transformation(origin = {40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.MassFlow_In_HT HTES_AdCM_In annotation(
        HideResult = true,
        Placement(visible = true, transformation(origin = {100, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.Temp_HT HTES_AdCM_Out annotation(
        HideResult = true,
        Placement(visible = true, transformation(origin = {100, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.MassFlow_out_HT HTES_HX_Out annotation(
        Placement(visible = true, transformation(origin = {100, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.Temp_HT HTES_HX_In annotation(
        Placement(visible = true, transformation(origin = {100, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput v_HT annotation(
        Placement(visible = true, transformation(origin = {80, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {80, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
      Modelica.Blocks.Interfaces.RealInput Coil_ON annotation(
        Placement(visible = true, transformation(origin = {-100, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Interfaces.Amb_Temp T_amb annotation(
        Placement(visible = true, transformation(origin = {-100, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.DobleTemp DobleTempOut annotation(
        Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      //=====================================================
      //============= Equations for the HTES===============
      //================== Initial Equation=============================
    initial equation
/*********** initial temperature values for loop ***********/
      HTES_H_W_T_M_IT_K = T_ini_K "Equating both directly since they are both arrays of size n";
//================== Algorithm Section: COIL Safety Shut Down=============================
      heat = true;
    algorithm
// Hysteresis Loop for internal control of Coil (Coil Shut down)
      when HTES_H_W_T_M_IT[Coil_Safety_Layer] <= 75 then
        heat := true;
      end when;
      when HTES_H_W_T_M_IT[Coil_Safety_Layer] >= 80 then
        heat := false;
      end when;
//================== Main Equations Section=============================
    equation
//=================== Connectors equation ====================================
      T_HTES_CHP_In = HTES_CHP_In.T "Temperature coming from the CHP [°C]";
      T_HTES_RevHP_In = HTES_HX_In.T "Temperature coming from the RevHP [°C]";
      m_dot_CHP = HTES_CHP_In.m_dot "Mass flow coming from the CHP(Top Layer)";
      m_dot_RevHP_HT = HTES_HX_Out.m_dot "Mass flow coming from the RevHP(Top Layer)";
      HTES_H_W_T_M_IT[CHP_Layer] = HTES_CHP_Out.T "Return Temperature that goes to the CHP [°C]";
      HTES_H_W_T_M_IT[HX_Layer] = HTES_HX_Out.T "Return Temperature that goes to the RevHP[°C]";
      HTES_H_W_T_M_IT[Load_FL_Layer] = HTES_LOAD_Out.T "Temperature that goes to the Load[°C]";
      m_dot_LOAD = HTES_LOAD_In.m_dot "Mass flow entering from the LOAD [kg/s]";
      T_HTES_LOAD_RL = HTES_LOAD_In.T "Temperature coming back from the LOAD [°C]";
      HTES_H_W_T_M_IT[AdCM_FL_Layer] = HTES_AdCM_Out.T "Temperature that goes to the AdCM[°C]";
      m_dot_AdCM_HT = HTES_AdCM_In.m_dot "Mass flow entering from the AdCM [kg/s]";
      T_HTES_AdCM_RL = HTES_AdCM_In.T "Temperature coming back from the AdCM [°C]";
      DobleTempOut.T1 = HTES_H_W_T_M_IT[Temp1] "Layer of the tank which controls the Hysteresis OFF";
      DobleTempOut.T2 = HTES_H_W_T_M_IT[Temp2] "Layer of the tank which controls the Hysteresis ON";
//============ Temperature Conversion from °C to K ==========
      T_HTES_CHP_In_K = T_HTES_CHP_In + 273.15;
      T_HTES_RevHP_In_K = T_HTES_RevHP_In + 273.15;
      T_amb_K = T_amb.T + 273.15;
      T_HTES_LOAD_RL_K = T_HTES_LOAD_RL + 273.15;
      T_HTES_AdCM_RL_K = T_HTES_AdCM_RL + 273.15;
//============ Loop temperature conversion =======================//
      for i in 1:n loop
        HTES_H_W_T_M_IT_K[i] = HTES_H_W_T_M_IT[i] + 273.15;
      end for;
/**************************************************************/
      for i in 1:n loop
        T_ini_K[i] = T_ini[i] + 273.15;
      end for;
//============ Geometric parameters equations ===================//
      zi = h / n;
      mi = pi * (D / 2) ^ 2 * zi * rho;
      di = D - 2 * t;
      Aamb = pi * D * zi;
      Alayer = pi * di ^ 2 / 4;
//============ Volume flow from P13 in ReV_HP secondary circuit ================//
      if v_HT == 0 then
        v_dot_RevHP_HT = 0;
      else
        v_dot_RevHP_HT = v_dot_RevHP_HT_Set;
      end if;
//Conversion of Volume Flow to Mass Flow//
      m_dot_RevHP_HT = v_dot_RevHP_HT * rho / 3600;
//=================== COIL Operational Logic Equations===================//
      Coil_ON_int = if heat then Coil_ON else 0;
      if Coil_ON_int == 0 then
        COIL_H_E_PT_M__ = 0;
      else
        COIL_H_E_PT_M__ = P_COIL_Set;
      end if;
//============ Equations for Stratifications ===========================
//Simple forward difference model. Heat flow is calculated using Fourier equation.Solution is substantially simplified if only the energy from the preceding layer is considered. For the first and the last layer the effective mass flow is zero

      m_dot[1] = 0 "Effective mass flow in the bottom most layer";
      m_dot[n] = 0 "Effective mass flow in the top most layer is 0";
      
      for i in 2:n - 1 loop
        m_dot[i] = m_dot_CHP + m_dot_RevHP_HT - m_dot_AdCM_HT - m_dot_LOAD "effective mass flow for ith layer";
      end for;   
      
      if m_dot[n-1] > 0 then
        d_pos = 1; 
        d_neg = 0;
      else
        d_pos = 0; 
        d_neg = 1;  
      end if;   
         
    //===1st Layer at Bottom of the tank has a different equation; Temp going to the CHP/RevHP.Return Temp coming from Load and AdCM. Heat loss to ambient used x times higher then other layers. This paramter can be found by estimation. ===============//
    
    //forced convection considered from preceding layer only when d_pos = 1
        cp * mi * der(HTES_H_W_T_M_IT_K[1]) = Alayer * lambda_eff * (HTES_H_W_T_M_IT_K[2] - HTES_H_W_T_M_IT_K[1]) / zi + cp * m_dot_LOAD * (T_HTES_LOAD_RL_K - HTES_H_W_T_M_IT_K[1]) + cp * m_dot_AdCM_HT * (T_HTES_AdCM_RL_K - HTES_H_W_T_M_IT_K[1])+ d_pos * cp * m_dot[2] * (HTES_H_W_T_M_IT_K[2] - HTES_H_W_T_M_IT_K[1]) - Aamb * 20 * kappa * (HTES_H_W_T_M_IT_K[1] - T_amb_K);
    
//================== 2nd to(n-1)th Layer========
       
      for i in 2:n - 1 loop
        cp * mi * der(HTES_H_W_T_M_IT_K[i]) = Alayer * lambda_eff * (HTES_H_W_T_M_IT_K[i - 1] - 2 * HTES_H_W_T_M_IT_K[i] + HTES_H_W_T_M_IT_K[i + 1]) / zi + d_pos * cp * m_dot[i] * (HTES_H_W_T_M_IT_K[i + 1] - HTES_H_W_T_M_IT_K[i]) + d_neg * cp * m_dot[i] * (HTES_H_W_T_M_IT_K[i] - HTES_H_W_T_M_IT_K[i - 1]) - Aamb * kappa * (HTES_H_W_T_M_IT_K[i] - T_amb_K) + COIL_H_E_PT_M__ / n;
      end for;

    //===nth layer at top of the tank has a different equation; Return temp coming from CHP/RevHP.Temp going to Load and AdCM. ==================
      
    // forced convection cooling occurs from preceding layer only when d_neg = 1
        cp * mi * der(HTES_H_W_T_M_IT_K[n]) = Alayer * lambda_eff * (HTES_H_W_T_M_IT_K[n - 1] - HTES_H_W_T_M_IT_K[n]) / zi + cp * m_dot_CHP * (T_HTES_CHP_In_K - HTES_H_W_T_M_IT_K[n]) + cp * m_dot_RevHP_HT * (T_HTES_RevHP_In_K - HTES_H_W_T_M_IT_K[n]) + d_neg * cp * m_dot[n - 1] * (HTES_H_W_T_M_IT_K[n] - HTES_H_W_T_M_IT_K[n - 1]) - Aamb * kappa * (HTES_H_W_T_M_IT_K[n] - T_amb_K) + COIL_H_E_PT_M__ / n;
     
//================= Shape and Color =================
      annotation(
        Icon(coordinateSystem(initialScale = 0.1), graphics = {Bitmap(extent = {{-100, 100}, {100, -100}}, imageSource = "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")}),
        experiment(StartTime = 0, StopTime = 40000, Tolerance = 1e-06, Interval = 81.1359));
    end HTES_Loop;












    model CTES_Loop "Cold Storage Tank"
      //=====================================================
      //============= Equations for the CTES===============
      //================== Initial Equation=============================
      //=============Imported units =============
      import SI = Modelica.SIunits;
      //=========== Parameters of temperature and Mass_Flow =========
      parameter SI.Temp_C T_ini_set = 20 "Initial temperature of the tank, for AdCM this should be 18<= Tini <= 28°C [°C]" annotation(
        HideResult = true);
      //==============Parameters For Tank Dimensions===============
      parameter SI.Length D = 1 "Diameter of the tank [m]" annotation(
        HideResult = true);
      parameter SI.Length h = 2.196 "Height of the tank [m]" annotation(
        HideResult = true);
      parameter SI.Length t = 0.0125 "Thickness of walls [m]" annotation(
        HideResult = true);
      //==============Parameters for Heat Transfer==============
      parameter Units.HeatTransfer kappa = 0.001 "Heat transfer coefficient of storage walls[kW/(m2.K)], depends on tank and insulation material" annotation(
        HideResult = true);
      parameter Units.HeatConductivity lambda_eff = 0.0015 "Effective vertical heat conductivity considering thermal conduction and convection [kW/(m.K)], Eicker Book/Paper" annotation(
        HideResult = true);
      /************** Loop parameter ***************/
      parameter Integer n = 40 "Number of Layers in Tank" annotation(
        HideResult = true);
      /***************Parameters for deciding Layers****************************/
      parameter Integer RevHP_RL_Layer = 40 "Define layer from which water goes to RevHP" annotation(
        HideResult = true);
      parameter Integer Load_FL_Layer = 10 "Define layer from which water goes to Load" annotation(
        HideResult = true);
      parameter Integer AdCM_RL_Layer = 40 "Define layer from which water goes to AdCM" annotation(
        HideResult = true);
      parameter Integer Temp1 = 40 "Layer which controls the Hysteresis" annotation(
        HideResult = true);
      parameter Integer Temp2 = 10 "Layer which controls the Hysteresis" annotation(
        HideResult = true);
      //==================Constants=====================
      constant SI.Density rho = 994.3025 "Water density [kg/m3]";
      constant Units.SpecificHeat cp = 4.18 "Specific heat transfer coefficient of water [kJ/(kg.K)]";
      constant Real pi = 3.14159265358979;
      //==================Variables of temperature for the CTES ===================
      /********************* Temperatures in °C ************************/
      SI.Temp_C CTES_H_W_T_M_IT[n] "Array of of size n denoting temperature of 1 to nth layer [°C]" annotation(
        HideResult = false);
      SI.Temp_C T_CTES_AdCM_In "Temperature coming from the AdCM [°C]" annotation(
        HideResult = true);
      SI.Temp_C T_CTES_RevHP_In "Temperature coming from the RevHP [°C]" annotation(
        HideResult = true);
      SI.Temp_C T_CTES_LOAD_RL "Temperature coming back from the LOAD [°C]" annotation(
        HideResult = true);
      SI.Temp_C T_ini[n] = fill(T_ini_set, n) "fill an array of size n with value T_ini_set that is defined as parameter" annotation(
        HideResult = true);
      //********************* Temperatures in K *************************//
      SI.Temp_K CTES_H_W_T_M_IT_K[n] annotation(
        HideResult = true);
      SI.Temp_K T_ini_K[n] annotation(
        HideResult = true);
      SI.Temp_K T_amb_K annotation(
        HideResult = true);
      SI.Temp_K T_CTES_AdCM_In_K annotation(
        HideResult = true);
      SI.Temp_K T_CTES_RevHP_In_K annotation(
        HideResult = true);
      SI.Temp_K T_CTES_LOAD_RL_K annotation(
        HideResult = true);
      //===================== Variables of mass flow for each layer =================
      SI.MassFlowRate m_dot[n] "Array of size 'n' representing the effective mass flows between the layers, where layer 1 is at bottom and n at top" annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_AdCM "Mass Flow at the entrance of the CTES (Bottom Layer) [kg/s]" annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_RevHP "Mass Flow at the entrance of the CTES (Bottom Layer) [kg/s]" annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_LOAD "Mass Flow going to the LOAD (Bottom Layer) [kg/s]" annotation(
        HideResult = true);
      //===================== Other Variables =======================================
      SI.Area Alayer "Cross section of the respective layer in contact with above or below layer[m2]" annotation(
        HideResult = true);
      SI.Area Aamb "Cross Section of the respective layer in contact with tank surface and transfering heat to ambient [m2]" annotation(
        HideResult = true);
      SI.Length zi "Height of each layer. Height of tank / Number of Layers zi=h/n" annotation(
        HideResult = true);
      SI.Mass mi "Water mass in the control volume [kg]" annotation(
        HideResult = true);
      SI.Length di "Considering internal diameter of Tank" annotation(
        HideResult = true);
      Units.unitless d_pos annotation(
        HideResult = true);
      Units.unitless d_neg annotation(
        HideResult = true);
      //
      //================= Connectors ===================
      Interfaces.MassFlow_In_LT CTES_AdCM_In annotation(
        Placement(visible = true, transformation(origin = {-100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.MassFlow_In_LT CTES_LOAD_In annotation(
        Placement(visible = true, transformation(origin = {-40, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.Temp_LT CTES_AdCM_Out annotation(
        Placement(visible = true, transformation(origin = {-100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.Temp_LT CTES_LOAD_Out annotation(
        Placement(visible = true, transformation(origin = {40, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.MassFlow_In_LT CTES_RevHP_In annotation(
        Placement(visible = true, transformation(origin = {40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.Temp_LT CTES_RevHP_Out annotation(
        Placement(visible = true, transformation(origin = {-40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.Amb_Temp T_amb annotation(
        Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.DobleTemp DobleTempOut annotation(
        Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    initial equation
/*********** initial temperature values for loop ***********/
      CTES_H_W_T_M_IT_K = T_ini_K "Equating both directly since they are both arrays of size n";
//================== Main Equations Section=============================
    equation
//=================== Connectors equation ====================================
      T_CTES_AdCM_In = CTES_AdCM_In.T "Temperature coming from the AdCM [°C]";
      T_CTES_RevHP_In = CTES_RevHP_In.T "Temperature coming from the RevHP [°C]";
      m_dot_AdCM = CTES_AdCM_In.m_dot "Mass Flow at the entrance of the CTES (Bottom Layer) [kg/s]";
      m_dot_RevHP = CTES_RevHP_In.m_dot "Mass Flow at the entrance of the CTES (Bottom Layer) [kg/s]";
      CTES_H_W_T_M_IT[AdCM_RL_Layer] = CTES_AdCM_Out.T "Return Temperature that goes to the AdCM[°C]";
      CTES_H_W_T_M_IT[RevHP_RL_Layer] = CTES_RevHP_Out.T "Return Temperature that goes to the RevHP[°C]";
      CTES_H_W_T_M_IT[Load_FL_Layer] = CTES_LOAD_Out.T "Temperature that goes to the Load[°C]";
      m_dot_LOAD = CTES_LOAD_In.m_dot "Mass flow coming back from the LOAD [kg/s]";
      T_CTES_LOAD_RL = CTES_LOAD_In.T "Temperature coming back from the LOAD [°C]";
      CTES_H_W_T_M_IT[Temp1] = DobleTempOut.T1;
      CTES_H_W_T_M_IT[Temp2] = DobleTempOut.T2;
//============ Temperature Conversion from °C to K ==========
      T_CTES_AdCM_In_K = T_CTES_AdCM_In + 273.15;
      T_CTES_RevHP_In_K = T_CTES_RevHP_In + 273.15;
      T_amb_K = T_amb.T + 273.15;
      T_CTES_LOAD_RL_K = T_CTES_LOAD_RL + 273.15;
/************** Loop temperature conversion *******************/
      for i in 1:n loop
        CTES_H_W_T_M_IT_K[i] = CTES_H_W_T_M_IT[i] + 273.15;
      end for;
/**************************************************************/
      for i in 1:n loop
        T_ini_K[i] = T_ini[i] + 273.15;
      end for;
//============ Geometric parameters ecuations =============================
      zi = h / n;
      mi = pi * (D / 2) ^ 2 * zi * rho;
      di = D - 2 * t;
      Aamb = pi * D * zi;
      Alayer = pi * di ^ 2 / 4;
//============ Equations for Stratfications ==========================

      m_dot[1] = 0 "Effective mass flow in the bottom most layer is 0";
      m_dot[n] = 0 "Effective mass flow in the top most layer is 0";
      
      for i in 2:n - 1 loop
        m_dot[i] = m_dot_AdCM + m_dot_RevHP - m_dot_LOAD;
      end for;
      
      if m_dot[n-1] > 0 then
        d_pos = 1; 
        d_neg = 0;
      else
        d_pos = 0; 
        d_neg = 1;  
      end if;
      
    
    
    //==== 1st Layer at Bottom of the tank has a different equation; Cold temp going to the LOAD. Chilled temp coming from AdCM and RevHP====//
//
//forced convection heating occurs from preceding layer only when d_neg is 1.
        cp * mi * der(CTES_H_W_T_M_IT_K[1]) = m_dot_AdCM * cp * (T_CTES_AdCM_In_K - CTES_H_W_T_M_IT_K[1]) + cp * m_dot_RevHP * (T_CTES_RevHP_In_K - CTES_H_W_T_M_IT_K[1]) - Aamb * kappa * (CTES_H_W_T_M_IT_K[1] - T_amb_K) + Alayer * lambda_eff * (CTES_H_W_T_M_IT_K[2] - CTES_H_W_T_M_IT_K[1]) / zi + d_neg *cp * m_dot[2] * (CTES_H_W_T_M_IT_K[1] - CTES_H_W_T_M_IT_K[2]);

//================== From 2nd to (n-1)th Layer; middle of the tank ========
      for i in 2:n - 1 loop
        
        cp * mi * der(CTES_H_W_T_M_IT_K[i]) = Alayer * lambda_eff * (CTES_H_W_T_M_IT_K[i - 1] - 2 * CTES_H_W_T_M_IT_K[i] + CTES_H_W_T_M_IT_K[i + 1]) / zi + d_neg * cp * m_dot[i] * (CTES_H_W_T_M_IT_K[i] - CTES_H_W_T_M_IT_K[i + 1]) + d_pos * cp * m_dot[i] * (CTES_H_W_T_M_IT_K[i - 1] - CTES_H_W_T_M_IT_K[i]) - Aamb * kappa * (CTES_H_W_T_M_IT_K[i] - T_amb_K);
        
      end for;
//===== nth Control Volume: nth Layer, Top of the tank, Return Load & Feeds to AdCM/RevHP, Has Different Equation ====
      
      // forced convection cooling occuring from preceding layer only when d_pos is 1.
        cp * mi * der(CTES_H_W_T_M_IT_K[n]) = Alayer * lambda_eff * (CTES_H_W_T_M_IT_K[n - 1] - CTES_H_W_T_M_IT_K[n]) / zi + cp * m_dot_LOAD * (T_CTES_LOAD_RL_K - CTES_H_W_T_M_IT_K[n]) + d_pos * cp * m_dot[n - 1] * (CTES_H_W_T_M_IT_K[n - 1] - CTES_H_W_T_M_IT_K[n]) - Aamb * 20 * kappa * (CTES_H_W_T_M_IT_K[n] - T_amb_K);
      
//================= Shape and Color =================
      annotation(
        Icon(coordinateSystem(initialScale = 0.1), graphics = {Bitmap(extent = {{-100, 100}, {100, -100}}, imageSource = "/9j/4AAQSkZJRgABAQEAYABgAAD/4QBaRXhpZgAATU0AKgAAAAgABQMBAAUAAAABAAAASgMDAAEAAAABAAAAAFEQAAEAAAABAQAAAFERAAQAAAABAAAOw1ESAAQAAAABAAAOwwAAAAAAAYagAACxj//bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIAJUAlQMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/AOn8O+DPDVx4Z0mebQ7GSWSzhd3aEEsxQEk1pf8ACDeFf+gBp/8A34WrXhf/AJFLRf8Arwg/9FrWtQBz/wDwg3hX/oAaf/34Wj/hBvCv/QA0/wD78LXQUUAc/wD8IN4V/wCgBp//AH4Wj/hBvCv/AEANP/78LXQVk33ibRtPJW41CLeOqId5/Jc4ppN7CbS3Kv8Awg3hX/oAaf8A9+Fo/wCEG8K/9ADT/wDvwtUX+IFk5Is9Pvbn3VAAf5n9KhPjPVZP9R4dkX0MkuP02itVQqPoQ6sO5qf8IN4V/wCgBp//AH4Wj/hBvCv/AEANP/78LWQfE3idjldGtgvoZBn/ANCo/wCEl8U/9Ae0/wC/g/8Aiqf1eYvbQNf/AIQbwr/0ANP/AO/C0f8ACDeFf+gBp/8A34WskeKvEUf+u0OJ/wDrnL/9c1Ivji6j/wCPrw/doO5jbcP5Ck8PU7B7aHc0v+EG8K/9ADT/APvwtH/CDeFf+gBp/wD34Wq9v4+0WRts/wBotW7iWL/4nNb9nqNlqCb7O6inHfY4JH1HaolCUd0WpxezMj/hBvCv/QA0/wD78LR/wg3hX/oAaf8A9+FroKKgo5//AIQbwr/0ANP/AO/C0f8ACDeFf+gBp/8A34WugooA+bvjRpWn6P4ssrfTrOG1haxV2SFAoLb3GceuAPyoq58ev+R0sP8AsHJ/6MkooA9v8L/8ilov/XhB/wCi1rWrJ8L/APIpaL/14Qf+i1rWoAKKKKAPO7u8vvFOoXcRu3ttNgkMYiiOGkx3P/1+Ks2ui6daAeXaoWH8Tjcf1rkozcw6hdz2k5ikE7gjswz3rVh8T3UOBeWO8f34j/SvWVNqKtsec53ep1AAAwBgUVixeKtMkHzvJEfR4z/TNW01vTJOl7CP95sfzpWY7l+iqw1CyYZF5bkeolX/ABpft9n/AM/cH/fwUAWKKqPqlgn3r23Ht5gqvJ4h0qPrdqf91Sf5CizAvywxTrtliSRfR1BrLn8O2pkE1k8llcLyskLEYP0/wxUEviyzGRbwTzN2wuB/j+lZ1xrWq3oKxhbSM9wct+f/AOqqUZMlySO08I61d3xu9O1BlkubMgeav8YOevvxXT1558O08vVNTXcWwicnvya9Drzq8VGo0jtoycoJsKKKKxNT56+PX/I6WH/YOT/0ZJRR8ev+R0sP+wcn/oySigD2/wAL/wDIpaL/ANeEH/ota1qyfC//ACKWi/8AXhB/6LWtagAooooA8aj/AOPm8/6+H/nUtRR/8fN5/wBfD/zqWvfh8KPGn8TEZFb7yg/UVGbWA9Yk/AVLRVWFcrmytj/yyH5mk+w23/PP/wAeNWaKLILsg+x24/5ZCniCFekSD/gNSUUWQXYAADAGKKKKYjoPh/8A8hjVP9xP5mvQK8/+H/8AyGNU/wBxP5mvQK8XFfxWerh/4aCiiiuc2Pnr49f8jpYf9g5P/RklFHx6/wCR0sP+wcn/AKMkooA9v8L/APIpaL/14Qf+i1rWrJ8L/wDIpaL/ANeEH/ota1qACiiigDxqP/j5vP8Ar4f+dS1FH/x83n/Xw/8AOqM2rg3z2NlA11cRgGXDBUiz/eb19gCa96Mkoq548k3J2NOisi81i402HzbzT22FgoeGTeoJOPmyAR9cU7+1bySedLfSpJY4pDH5hlVQxHXGaftI3sHI9zVorAsPEVzqlo1zZ6RLJEGK8zIDkexqS78Qm00aPVGspDC2N67wGQ5xgj60vawtcfs5XsbdFZSalqUkayJozlWAYf6QnQ1LBq0TaVJf3MbWyRFxIj8lSpIPT6U1OLJcGaFFZA1W/wDs4ujpEn2cjdhZQZdvrsxj8M5q/YXa39hBdqpVZkDhT1ANNTTdkDi1qdR8P/8AkMap/uJ/M16BXn/w/wD+Qxqn+4n8zXoFePiv4rPTw/8ADQUUUVzmx89fHr/kdLD/ALByf+jJKKPj1/yOlh/2Dk/9GSUUAe3+F/8AkUtF/wCvCD/0Wta1ZPhf/kUtF/68IP8A0Wta1ABRRRQB4nczm2h1SdRlonlcD6ZNYvgZP+JAbhjuluJneRj1Jzj+lb/lrLJfxuMo80isPUGuY0ac+FXm0vU9yWpkL210VOxgexPY/wD169naUZPax5e6kludVcQR3VvJBKu6ORdrCnbQqEAAdTxVEavbXHyWEiXUp6eWcqvuxHAH61bmmjt4GkmkVFA5Y8Ct009UZWa0Oc8Bf8i8/wD18P8AyFS+NlC+FLgKABvQ4A/2hVfwHKi6LJAzbZROzbG4OMDnFTeN5E/4R2aAMDM7JtQck/N6fhXMv92+Ru/4/wAyY6xcW2jCRNJvS0cAIJCY4Xr97OPwq7qWnDVdDnswyxtOgO4Djdwcn8RVe11/SVsIUku4+IlDKVPp0ximSaxLJo9zqFrC5hjlRYECENIoZQ3HvyAPatOaNrN30ItK+itqZdh4nudIkj07xDbvEyjalyoyrAdz6/UflXVWawJZxC1YNBtyhU5BHtWZqGoaJfaXIl3NE0bL/qn4kB9lPIb8KZ4Rs7mx8PQxXQZXLM4RuqKTwP6/jSptqXLe6CaTjzWszvfh/wD8hjVP9xP5mvQK8/8Ah/8A8hjVP9xP5mvQK83FfxWd+H/hoKKKK5zY+evj1/yOlh/2Dk/9GSUUfHr/AJHSw/7Byf8AoySigD2/wv8A8ilov/XhB/6LWtasnwv/AMilov8A14Qf+i1rWoAKKKKAPGo/+Pm8/wCvh/51KQCMEZqKP/j5vP8Ar4f+dS178PhR40/iYgAUYAAHoKWiirJCiiigAooooATapYMVG4dDjmloooA6D4f/APIY1T/cT+Zr0CvP/h//AMhjVP8AcT+Zr0CvFxX8Vnq4f+GgooornNj56+PX/I6WH/YOT/0ZJRR8ev8AkdLD/sHJ/wCjJKKAPb/C/wDyKWi/9eEH/ota1qyfC/8AyKWi/wDXhB/6LWtagAooooA8aj/4+bz/AK+H/nUtRR/8fN5/18P/ADqWvfh8KPGn8TCiiirJCiiigAooooAKKKKAOg+H/wDyGNU/3E/ma9Arz/4f/wDIY1T/AHE/ma9ArxcV/FZ6uH/hoKKKK5zY+evj1/yOlh/2Dk/9GSUUfHr/AJHSw/7Byf8AoySigD2/wv8A8ilov/XhB/6LWtasnwv/AMilov8A14Qf+i1rWoAKKKKAPGo/+Pm8/wCvh/51LXR694MvEvZr7RysiSsXktmOCCeu09K5aaWazk8u+tZ7Z/R0Ir26NaEoqzPKq0pRlqiaioVuoH6Sr+JxUoZW6MD9DW1zIWiiimIKKKYZY1+9Io+poAfRVd723T/lpn6DNXLLTdX1UgWNhIsZ/wCW0w2rj6nr+GaiU4xV2y4wlJ2SNz4f/wDIY1T/AHE/ma9ArC8M+HE0C2kLy+ddTkGWTHHHQD25NbteLXmp1G0epSi4wSYUUUVkaHz18ev+R0sP+wcn/oySij49f8jpYf8AYOT/ANGSUUAe3+F/+RS0X/rwg/8ARa1rVk+F/wDkUtF/68IP/Ra1rUAFFFFABTZI45UKSIrqeqsMinUUAZFx4X0O5JMmmW4J67F2f+g4rPl8A6DJnbDNH/uSnj88109FWqk1syXCL6HIH4c6QTkXN+B6CRf/AImj/hXWknrd6h/38T/4muvoqvbVO5Psodjkk+HejKfmlvJP96Qf0UVbh8DeH4uTZGQ+rysf64roqKTqzfUapwXQo2ujaZZHNtYW8bf3hGM/n1q9RRUNt7lJJbBRRRSGFFFFAHz18ev+R0sP+wcn/oySij49f8jpYf8AYOT/ANGSUUAYNp8WPGNjZQWkGoxrDBGsUam2jOFUYAzj0FTf8Li8bf8AQTi/8BY//iaKKAD/AIXF42/6CcX/AICx/wDxNH/C4vG3/QTi/wDAWP8A+JoooAP+FxeNv+gnF/4Cx/8AxNH/AAuLxt/0E4v/AAFj/wDiaKKAD/hcXjb/AKCcX/gLH/8AE0f8Li8bf9BOL/wFj/8AiaKKAD/hcXjb/oJxf+Asf/xNH/C4vG3/AEE4v/AWP/4miigA/wCFxeNv+gnF/wCAsf8A8TR/wuLxt/0E4v8AwFj/APiaKKAD/hcXjb/oJxf+Asf/AMTR/wALi8bf9BOL/wABY/8A4miigA/4XF42/wCgnF/4Cx//ABNH/C4vG3/QTi/8BY//AImiigA/4XF42/6CcX/gLH/8TR/wuLxt/wBBOL/wFj/+JoooA5rxD4m1XxTfR3urzrNPHEIlZY1TCgk4wAO5NFFFAH//2Q==")}),
        experiment(StartTime = 0, StopTime = 40000, Tolerance = 1e-06, Interval = 81.1359));
    end CTES_Loop;



    model Ambient_T
      //================ Library import ======================
      import SI = Modelica.SIunits;
      //=============== Parameter ambient temperature ========
      parameter SI.Temp_C T_amb = 25;
      //================ Connector ========================
      Interfaces.Amb_Temp Amb_Temp annotation(
        Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      Amb_Temp.T = T_amb;
//=============== Color and Shape====================
      annotation(
        Icon(graphics = {Text(origin = {-1, 76}, extent = {{-79, 24}, {81, -16}}, textString = "Ambient Temperature"), Bitmap(origin = {2, -12}, extent = {{-82, 72}, {78, -68}}, imageSource = "/9j/4AAQSkZJRgABAQEA3ADcAAD/4QBaRXhpZgAATU0AKgAAAAgABQMBAAUAAAABAAAASgMDAAEAAAABAAAAAFEQAAEAAAABAQAAAFERAAQAAAABAAAh1VESAAQAAAABAAAh1QAAAAAAAYagAACxj//bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIAK0ArQMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/ALHgHwD4W1XwNpV9faPBNczRFpJGZssdxHY10n/CsfBf/QAt/wDvp/8AGj4Y/wDJN9E/64n/ANDautoA5L/hWPgv/oAW/wD30/8AjR/wrHwX/wBAC3/76f8Axrq3kWNdzsAKpSX5ziNePU1w4zMsNhF+9lr26m1LD1Kvwowf+FY+C/8AoAW//fT/AONJ/wAKy8F/9AG2/wC+3/xrY8yed9oZiT2BxV6C1WPBb5m9+1ceDzWeNn+4pe6urdv8zWrho0V78teyOa/4Vj4L/wCgBb/99P8A40f8Kx8F/wDQAt/++n/xrraK9o5Dkv8AhWPgv/oAW/8A30/+NH/CsfBf/QAt/wDvp/8AGutooA5L/hWPgv8A6AFv/wB9P/jR/wAKx8F/9AC3/wC+n/xrraKAOS/4Vj4L/wCgBb/99P8A40f8Kx8F/wDQAt/++n/xrraKAOS/4Vj4L/6AFv8A99P/AI0f8Kx8F/8AQAt/++n/AMa62igDkv8AhWPgv/oAW/8A30/+NH/CsfBf/QAt/wDvp/8AGutooA5L/hWPgv8A6AFv/wB9P/jR/wAKx8F/9AC3/wC+n/xrraKAOS/4Vj4L/wCgBb/99P8A415F8ZfDej+Hb7SU0ixjtFmikMgQk7iCuOp96+iq8K/aA/5CWh/9cZf5rQB6R8Mf+Sb6J/1xP/obV1U0qwxl2/Aetcr8Mf8Akm+if9cT/wChtW3fOTME7KK83Nsa8HhXUjvsvU6MLR9rUUXsQSStK+5j+HpTKKntE33Cg9BzX51TjUxVdRbvKT39T3pONODa2RetoBDHyPnPU1PRRX6jQoQoU1SpqyR85ObnJyluFFFFbEBRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABXhX7QH/IS0P8A64y/zWvda8K/aA/5CWh/9cZf5rQB6R8Mf+Sb6J/1xP8A6G1bN6MXLH1ANY3wx/5Jvon/AFxP/obV0l3B5qblHzL+tePnuEnicG1DVxdzrwVVU6t3s9DMqzZHFyB6giq1ORijqw6g5r4HB1vYYiFV9Gme3Vhzwce5tUU1HEiB16GnV+qRlGcVKLumfNNNOzCiiiqEFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFeFftAf8hLQ/+uMv81r3WvCv2gP+Qlof/XGX+a0AekfDH/km+if9cT/6G1dbXJfDH/km+if9cT/6G1dbQBWntFlO5flb9DVCSGSI/MpHv2rYorw8fkOHxTc4+7Ly2+47aGNqU1Z6oyra5MDYPKHqK00dZF3Kcio2tYW6oPw4pEtUjOUZ1/Gpy7C47BfupNTh66r7/wAgxFWjW95XTJ6KKK944gooooAKKKKACiiigAooooAKKKKACiiigArwr9oD/kJaH/1xl/mte614V+0B/wAhLQ/+uMv81oA9I+GP/JN9E/64n/0Nq62uS+GP/JN9E/64n/0Nq62gAoorn9f8W2Ghq0WfPu8cQoen+8e1VGLk7ITkoq7OgqrLqVhA+yW9to29HlUH+dcMll4p8WMJbqc2FiwyFGVyP93qfxrQi+G+mKv726uZG7kED+laezhH4pfcZ88n8KOwiljmQPFIkinoyMCKfXnt34W1bw3J9u0G7kmROXhPUj6dGH610XhvxTba9F5bYivVGXiPf3X2pSp6c0XdDjPW0tGdBRRRWRoFFFFABRRRQAUUUUAFFFFABRRRQAV4V+0B/wAhLQ/+uMv81r3WvCv2gP8AkJaH/wBcZf5rQB6R8Mf+Sb6J/wBcT/6G1dbXJfDH/km+if8AXE/+htXW0Acl4q1vVYrxNI0q0k8+dciYDt32+nuT/wDXp/h7wZb6aRd6gRdXzHcS3KofbPU+5rqsDOcc0Vp7RqPLHQjkTldhRRRWZYVx3ifwo8s39raPmG+jO9kQ43n1Hv8AzrsaKqE3B3RMoqSszl/DHi2PVQLO9xDqCfKVIwJMenv6iuormfEfg+21ljdW7C2vhz5gHD/X396xF1LxpogEE1j9ujXgSbDJx9VP861cIz1g7eRClKGkj0Gua8WQ6qyQzWOrQWEMYPmebIU3Htzg5+lYo1DxzqnENktop4JKCPH/AH2c/lUkHgO8v7hbjXdUkmI6ojEn6bj0H0FOMFB3k1+YpSclZI5aXxTrsEzIusNKBxvTlT9MgV23gm51nUoJL7Ubt5Lf7kSFFG492yBn2/Ouf1PSLe98SReH9KthBDDgzy7cseMkknkgDp7mvSba2is7WK3gXbFEoVR6AVdaceVJLVkUoy5rt7EtFFFch0hRRRQAUUUUAFeFftAf8hLQ/wDrjL/Na91rwr9oD/kJaH/1xl/mtAHpHwx/5Jvon/XE/wDobV1tcl8Mf+Sb6J/1xP8A6G1dbQAUUUUAFFFFABRRRQAUVyM2jWXiP4qDTtU+0S2cWieekUd1LCBJ5+3d8jDPHFdH/wAKt8I/8+V7/wCDS6/+OUAW6Kqf8Kt8I/8APle/+DS6/wDjlH/CrfCP/Ple/wDg0uv/AI5QBZEaCRpAih2GCwHJp1VP+FW+Ef8Anyvf/Bpdf/HKP+FW+Ef+fK9/8Gl1/wDHKALdFVP+FW+Ef+fK9/8ABpdf/HKP+FW+Ef8Anyvf/Bpdf/HKALdFVP8AhVvhH/nyvf8AwaXX/wAco/4Vb4R/58r3/wAGl1/8coAt0VU/4Vb4R/58r3/waXX/AMcrD1rwnpHhjxB4Zn0iO6ge4vpIZd99PKHT7PK2CHcjqoPTtQB09eFftAf8hLQ/+uMv81r3WvCv2gP+Qlof/XGX+a0AekfDH/km+if9cT/6G1dbXJfDH/km+if9cT/6G1dbQAUUUUAFFFFABRRRQBg6T/yWaT/sXv8A24r0SvO9J/5LNJ/2L3/txXolABRRRQAUUUUAFFFFABRRRQAVxnjn/kMeEf8AsJyf+k01dnXGeOf+Qx4R/wCwnJ/6TTUAXa8K/aA/5CWh/wDXGX+a17rXhX7QH/IS0P8A64y/zWgD0j4Y/wDJN9E/64n/ANDautrkvhj/AMk30T/rif8A0Nq62gAooooAKKKKACiiigDB0n/ks0n/AGL3/txXoled6T/yWaT/ALF7/wBuK9EoAKKKKACiiigAooooAKKKKACuM8c/8hjwj/2E5P8A0mmrs64zxz/yGPCP/YTk/wDSaagC7XhX7QH/ACEtD/64y/zWvda8K/aA/wCQlof/AFxl/mtAHpHwx/5Jvon/AFxP/obV1tcl8Mf+Sb6J/wBcT/6G1dbQAUUUUAFFFFABRRRQBg6T/wAlmk/7F7/24r0SvO9J/wCSzSf9i9/7cV6JQAUUUUAFFFFABRRRQAUUUUAFcZ45/wCQx4R/7Ccn/pNNXZ1xnjn/AJDHhH/sJyf+k01AF2vCv2gP+Qlof/XGX+a17rXhX7QH/IS0P/rjL/NaAPSPhj/yTfRP+uJ/9Dautr518N/GW68O+HrPSE0aGdbVCgkacqW5J6Y961f+GgL3/oX7f/wJP/xNAHutFeFf8NAXv/Qv2/8A4En/AOJo/wCGgL3/AKF+3/8AAk//ABNAHutFeFf8NAXv/Qv2/wD4En/4mj/hoC9/6F+3/wDAk/8AxNAHutFeFf8ADQF7/wBC/b/+BJ/+Jo/4aAvf+hft/wDwJP8A8TQB6vpP/JZpP+xe/wDbivRK+VrX43Xdr4vbxANEgZzYfYvJ884x5m/dnH4Yrf8A+Glr/wD6Fq2/8Cm/+JoA+iqK+df+Glr/AP6Fq2/8Cm/+Jo/4aWv/APoWrb/wKb/4mgD6Kor51/4aWv8A/oWrb/wKb/4mj/hpa/8A+hatv/Apv/iaAPoqivnX/hpa/wD+hatv/Apv/iaP+Glr/wD6Fq2/8Cm/+JoA+iqK+df+Glr/AP6Fq2/8Cm/+Jo/4aWv/APoWrb/wKb/4mgD6KrjPHP8AyGPCP/YTk/8ASaavKP8Ahpa//wChatv/AAKb/wCJrI1r48Xms3elXD6DBEdPuWuFAuCd5Mbx4Py8ffz+FAHvdeFftAf8hLQ/+uMv81o/4aAvf+hft/8AwJP/AMTXE+O/Hc3ji4spprCO0NqjKAkhfduIPoPSgD//2Q==")}, coordinateSystem(initialScale = 0.1)));
    end Ambient_T;

    model Ambient_Table_T
      //=============== Parameter ambient temperature ========
      //================ Library import ======================
      import SI = Modelica.SIunits;
      //=============== Color and Shape====================
      Components.Realtophys realtophys1 annotation(
        Placement(visible = true, transformation(origin = {50, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.Amb_Temp Amb_Temp_out annotation(
        Placement(visible = true, transformation(origin = {98, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(fileName = "C:/Javier/Ambient/AdCM/AdCMTest4.csv", tableName = "tab1", tableOnFile = true) annotation(
        Placement(visible = true, transformation(origin = {-50, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(combiTimeTable.y[1], realtophys1.u) annotation(
        Line(points = {{-38, 10}, {38, 10}, {38, 10}, {40, 10}}, color = {0, 0, 127}));
      connect(realtophys1.amb_Temp, Amb_Temp_out) annotation(
        Line(points = {{60, 10}, {98, 10}, {98, 10}, {98, 10}}));
      annotation(
        Icon(graphics = {Text(origin = {-1, 76}, extent = {{-79, 24}, {81, -16}}, textString = "Ambient Temperature"), Bitmap(origin = {0, -10}, extent = {{-80, 70}, {80, -70}}, imageSource = "/9j/4AAQSkZJRgABAQEA3ADcAAD/4QBaRXhpZgAATU0AKgAAAAgABQMBAAUAAAABAAAASgMDAAEAAAABAAAAAFEQAAEAAAABAQAAAFERAAQAAAABAAAh1VESAAQAAAABAAAh1QAAAAAAAYagAACxj//bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIAK0ArQMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/ALHgHwD4W1XwNpV9faPBNczRFpJGZssdxHY10n/CsfBf/QAt/wDvp/8AGj4Y/wDJN9E/64n/ANDautoA5L/hWPgv/oAW/wD30/8AjR/wrHwX/wBAC3/76f8Axrq3kWNdzsAKpSX5ziNePU1w4zMsNhF+9lr26m1LD1Kvwowf+FY+C/8AoAW//fT/AONJ/wAKy8F/9AG2/wC+3/xrY8yed9oZiT2BxV6C1WPBb5m9+1ceDzWeNn+4pe6urdv8zWrho0V78teyOa/4Vj4L/wCgBb/99P8A40f8Kx8F/wDQAt/++n/xrraK9o5Dkv8AhWPgv/oAW/8A30/+NH/CsfBf/QAt/wDvp/8AGutooA5L/hWPgv8A6AFv/wB9P/jR/wAKx8F/9AC3/wC+n/xrraKAOS/4Vj4L/wCgBb/99P8A40f8Kx8F/wDQAt/++n/xrraKAOS/4Vj4L/6AFv8A99P/AI0f8Kx8F/8AQAt/++n/AMa62igDkv8AhWPgv/oAW/8A30/+NH/CsfBf/QAt/wDvp/8AGutooA5L/hWPgv8A6AFv/wB9P/jR/wAKx8F/9AC3/wC+n/xrraKAOS/4Vj4L/wCgBb/99P8A415F8ZfDej+Hb7SU0ixjtFmikMgQk7iCuOp96+iq8K/aA/5CWh/9cZf5rQB6R8Mf+Sb6J/1xP/obV1U0qwxl2/Aetcr8Mf8Akm+if9cT/wChtW3fOTME7KK83Nsa8HhXUjvsvU6MLR9rUUXsQSStK+5j+HpTKKntE33Cg9BzX51TjUxVdRbvKT39T3pONODa2RetoBDHyPnPU1PRRX6jQoQoU1SpqyR85ObnJyluFFFFbEBRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABXhX7QH/IS0P8A64y/zWvda8K/aA/5CWh/9cZf5rQB6R8Mf+Sb6J/1xP8A6G1bN6MXLH1ANY3wx/5Jvon/AFxP/obV0l3B5qblHzL+tePnuEnicG1DVxdzrwVVU6t3s9DMqzZHFyB6giq1ORijqw6g5r4HB1vYYiFV9Gme3Vhzwce5tUU1HEiB16GnV+qRlGcVKLumfNNNOzCiiiqEFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFeFftAf8hLQ/+uMv81r3WvCv2gP+Qlof/XGX+a0AekfDH/km+if9cT/6G1dbXJfDH/km+if9cT/6G1dbQBWntFlO5flb9DVCSGSI/MpHv2rYorw8fkOHxTc4+7Ly2+47aGNqU1Z6oyra5MDYPKHqK00dZF3Kcio2tYW6oPw4pEtUjOUZ1/Gpy7C47BfupNTh66r7/wAgxFWjW95XTJ6KKK944gooooAKKKKACiiigAooooAKKKKACiiigArwr9oD/kJaH/1xl/mte614V+0B/wAhLQ/+uMv81oA9I+GP/JN9E/64n/0Nq62uS+GP/JN9E/64n/0Nq62gAoorn9f8W2Ghq0WfPu8cQoen+8e1VGLk7ITkoq7OgqrLqVhA+yW9to29HlUH+dcMll4p8WMJbqc2FiwyFGVyP93qfxrQi+G+mKv726uZG7kED+laezhH4pfcZ88n8KOwiljmQPFIkinoyMCKfXnt34W1bw3J9u0G7kmROXhPUj6dGH610XhvxTba9F5bYivVGXiPf3X2pSp6c0XdDjPW0tGdBRRRWRoFFFFABRRRQAUUUUAFFFFABRRRQAV4V+0B/wAhLQ/+uMv81r3WvCv2gP8AkJaH/wBcZf5rQB6R8Mf+Sb6J/wBcT/6G1dbXJfDH/km+if8AXE/+htXW0Acl4q1vVYrxNI0q0k8+dciYDt32+nuT/wDXp/h7wZb6aRd6gRdXzHcS3KofbPU+5rqsDOcc0Vp7RqPLHQjkTldhRRRWZYVx3ifwo8s39raPmG+jO9kQ43n1Hv8AzrsaKqE3B3RMoqSszl/DHi2PVQLO9xDqCfKVIwJMenv6iuormfEfg+21ljdW7C2vhz5gHD/X396xF1LxpogEE1j9ujXgSbDJx9VP861cIz1g7eRClKGkj0Gua8WQ6qyQzWOrQWEMYPmebIU3Htzg5+lYo1DxzqnENktop4JKCPH/AH2c/lUkHgO8v7hbjXdUkmI6ojEn6bj0H0FOMFB3k1+YpSclZI5aXxTrsEzIusNKBxvTlT9MgV23gm51nUoJL7Ubt5Lf7kSFFG492yBn2/Ouf1PSLe98SReH9KthBDDgzy7cseMkknkgDp7mvSba2is7WK3gXbFEoVR6AVdaceVJLVkUoy5rt7EtFFFch0hRRRQAUUUUAFeFftAf8hLQ/wDrjL/Na91rwr9oD/kJaH/1xl/mtAHpHwx/5Jvon/XE/wDobV1tcl8Mf+Sb6J/1xP8A6G1dbQAUUUUAFFFFABRRRQAUVyM2jWXiP4qDTtU+0S2cWieekUd1LCBJ5+3d8jDPHFdH/wAKt8I/8+V7/wCDS6/+OUAW6Kqf8Kt8I/8APle/+DS6/wDjlH/CrfCP/Ple/wDg0uv/AI5QBZEaCRpAih2GCwHJp1VP+FW+Ef8Anyvf/Bpdf/HKP+FW+Ef+fK9/8Gl1/wDHKALdFVP+FW+Ef+fK9/8ABpdf/HKP+FW+Ef8Anyvf/Bpdf/HKALdFVP8AhVvhH/nyvf8AwaXX/wAco/4Vb4R/58r3/wAGl1/8coAt0VU/4Vb4R/58r3/waXX/AMcrD1rwnpHhjxB4Zn0iO6ge4vpIZd99PKHT7PK2CHcjqoPTtQB09eFftAf8hLQ/+uMv81r3WvCv2gP+Qlof/XGX+a0AekfDH/km+if9cT/6G1dbXJfDH/km+if9cT/6G1dbQAUUUUAFFFFABRRRQBg6T/yWaT/sXv8A24r0SvO9J/5LNJ/2L3/txXolABRRRQAUUUUAFFFFABRRRQAVxnjn/kMeEf8AsJyf+k01dnXGeOf+Qx4R/wCwnJ/6TTUAXa8K/aA/5CWh/wDXGX+a17rXhX7QH/IS0P8A64y/zWgD0j4Y/wDJN9E/64n/ANDautrkvhj/AMk30T/rif8A0Nq62gAooooAKKKKACiiigDB0n/ks0n/AGL3/txXoled6T/yWaT/ALF7/wBuK9EoAKKKKACiiigAooooAKKKKACuM8c/8hjwj/2E5P8A0mmrs64zxz/yGPCP/YTk/wDSaagC7XhX7QH/ACEtD/64y/zWvda8K/aA/wCQlof/AFxl/mtAHpHwx/5Jvon/AFxP/obV1tcl8Mf+Sb6J/wBcT/6G1dbQAUUUUAFFFFABRRRQBg6T/wAlmk/7F7/24r0SvO9J/wCSzSf9i9/7cV6JQAUUUUAFFFFABRRRQAUUUUAFcZ45/wCQx4R/7Ccn/pNNXZ1xnjn/AJDHhH/sJyf+k01AF2vCv2gP+Qlof/XGX+a17rXhX7QH/IS0P/rjL/NaAPSPhj/yTfRP+uJ/9Dautr518N/GW68O+HrPSE0aGdbVCgkacqW5J6Y961f+GgL3/oX7f/wJP/xNAHutFeFf8NAXv/Qv2/8A4En/AOJo/wCGgL3/AKF+3/8AAk//ABNAHutFeFf8NAXv/Qv2/wD4En/4mj/hoC9/6F+3/wDAk/8AxNAHutFeFf8ADQF7/wBC/b/+BJ/+Jo/4aAvf+hft/wDwJP8A8TQB6vpP/JZpP+xe/wDbivRK+VrX43Xdr4vbxANEgZzYfYvJ884x5m/dnH4Yrf8A+Glr/wD6Fq2/8Cm/+JoA+iqK+df+Glr/AP6Fq2/8Cm/+Jo/4aWv/APoWrb/wKb/4mgD6Kor51/4aWv8A/oWrb/wKb/4mj/hpa/8A+hatv/Apv/iaAPoqivnX/hpa/wD+hatv/Apv/iaP+Glr/wD6Fq2/8Cm/+JoA+iqK+df+Glr/AP6Fq2/8Cm/+Jo/4aWv/APoWrb/wKb/4mgD6KrjPHP8AyGPCP/YTk/8ASaavKP8Ahpa//wChatv/AAKb/wCJrI1r48Xms3elXD6DBEdPuWuFAuCd5Mbx4Py8ffz+FAHvdeFftAf8hLQ/+uMv81o/4aAvf+hft/8AwJP/AMTXE+O/Hc3ji4spprCO0NqjKAkhfduIPoPSgD//2Q==")}, coordinateSystem(initialScale = 0.1)));
    end Ambient_Table_T;

    model Realtophys
      import SI = Modelica.SIunits;
      Real T_amb_real;
      SI.Temp_C T_amb;
      Interfaces.RealInput u annotation(
        Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-98, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Interfaces.Amb_Temp amb_Temp annotation(
        Placement(visible = true, transformation(origin = {98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {98, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      T_amb_real = u;
      T_amb_real = T_amb;
      T_amb = amb_Temp.T;
    end Realtophys;

    model PowerBlock
      //================ Connector ========================
      //=============== Parameter ambient temperature ========
      parameter Units.Power_kW P_ele = 25;
      Interfaces.Power Power1 annotation(
        Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      Power1.P = P_ele;
//=============== Color and Shape====================
      annotation(
        Icon(graphics = {Text(origin = {-1, 76}, extent = {{-79, 24}, {81, -16}}, textString = "Power"), Bitmap(origin = {0, -10}, extent = {{-80, 70}, {80, -70}}, imageSource = "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")}, coordinateSystem(initialScale = 0.1)));
    end PowerBlock;

    model Power_Table_kW
      //=============== Parameter ambient temperature ========
      //================ Library import ======================
      import SI = Modelica.SIunits;
      //=============== Color and Shape====================
      Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(fileName = "C:/Javier/CHPTest2.csv", smoothness = Modelica.Blocks.Types.Smoothness.ConstantSegments, tableName = "tab1", tableOnFile = true) annotation(
        Placement(visible = true, transformation(origin = {-50, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.Realtophys_power Realtophys_power annotation(
        Placement(visible = true, transformation(origin = {30, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      KWKK_CCHP_V48.Interfaces.Power Power1 annotation(
        Placement(visible = true, transformation(origin = {100, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(Realtophys_power.Power1, Power1) annotation(
        Line(points = {{40, 10}, {92, 10}, {92, 10}, {100, 10}}));
      connect(combiTimeTable.y[1], Realtophys_power.u) annotation(
        Line(points = {{-38, 10}, {20, 10}, {20, 10}, {20, 10}}, color = {0, 0, 127}));
      annotation(
        Icon(graphics = {Text(origin = {-1, 76}, extent = {{-79, 24}, {81, -16}}, textString = "Power"), Bitmap(origin = {10, -4}, extent = {{-90, 70}, {70, -70}}, imageSource = "/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAAkGBwgHBgkIBwgKCgkLDRYPDQwMDRsUFRAWIB0iIiAdHx8kKDQsJCYxJx8fLT0tMTU3Ojo6Iys/RD84QzQ5Ojf/2wBDAQoKCg0MDRoPDxo3JR8lNzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzf/wAARCAGkAaQDASIAAhEBAxEB/8QAHAABAAMBAAMBAAAAAAAAAAAAAAYHCAUCAwQB/8QAQxAAAgECAwQDDgYCAQMFAQEAAAECAwQFBhEHITFBElWBExQVFhciQlFhcZOiwdEjMlKRobFigkMkksJUcrLh8DNT/8QAGwEBAAIDAQEAAAAAAAAAAAAAAAQFAgYHAwH/xAA0EQACAQIDBQYGAwADAQEAAAAAAQIDBAUREhQhMVGRBhMiQVNxYbHB0eHwMkKBUqHxFRb/2gAMAwEAAhEDEQA/ALQABx0tQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADxnKNOLlUlGMVvcm9EkRzEc+ZYw+bhXxajKa3ONLWo1+x70betWeVOLfsszFyS4sko3kRt9pWU69RQWKKDfOpTlFfvoSawvrTEKCr2NzSuKb9KlNSRlVtLigs6kGvdBSi+DPoABGMgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcfNGY8PyzhbvcQnx82lSj+erL1Jf2+R1LmvStbercXE4wpUoOc5vgopatmZM7ZluM0Y5VvKkpK3i3C3pv0Ia7u3my7wXC9vqtz/hHj9jxq1NC3HvzbnjF8z1pK4rSoWevmWtKTUUvb637yL8wz8OiUqVOlBQgskuRBbbebB0cGxnEMEu43WGXU6FWL1817n7GuDRz2fhnKMZJxks0fDR2z7Pltmq3dtcqNDE6S1nSX5aiXpR+qJmZJwzELnC76je2VR069GSlCS9Zp7KeO0Mx4FbYjR6KlNaVIfomuKNBx7CVaSVakvA/LkydRqalkzsAA1s9wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA2c3MWM2+AYNc4ldPzKMdYx/XJ7kl72elOnKpNQgs2z43ks2V3tszSre1jl6zqfi1tKl01yjxjHte/3e8pU+zFcQuMVxG4v7uXSr15ucn7z4zqWH2cbO3jSX+/FldOeqWZ+xi5S0W9+ovHZ3s2srSxpYjj9tG4vKyU4UKm+FKL4arnL+iFbI8r+HceV7dU9bGxanPVbpz9GP1NBsoO0OKTpNW1F5Pi2vl9z3oU0/EyKZqyHg+PYdOjStaFpdRX4NelBRafqenFeszpiVjcYZfV7K7h0K9CbhOPqaNbFSbbsr91pU8xWcPOp6U7pL1cIy+jInZ/FZxq7PWlmnwz8n+fmfa1NNakU1rvLB2QZq8C434OvJ6WV+1HVvdTqcIv3Pg+z1Fen6pNPVbmuBuFzbwuaMqU+DIsZOLTRsAEP2Y5n8ZMvU1XnrfWmlKvrxlot0u1cfaTB8DldzbztqsqU+KLKLTWaAAI5kAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACids+afCWLLBrSprbWT/ABWnulV5r/Xh7yztoWZY5Yy7WuKco9+VtaVtH/J+lp6kt5mqcpVJuc25Sk9XJ722bh2Zw/VJ3U1w3L6si15/1R4Hus7Ste3dG1toOdatJQhFc22ektvYllfutWeYLyn5lPWnaprjLnLs4G0X13C0t5VZeXD4sjQi5SSLKyfgFHLWAW2HUtHUiulWmvTm+L+i9h2xoDllarKtUdSb3veyySSWSB6ru2o3trVtbqnGpRrQcKkHwcWt6PaDCLcWmnvBlvOOX62WseucOq9Jwi+lRqNfnpvg/o/acM0Jtdyx4cwHv21p63tinNacZQ9JfUz2dPwq+V7bKb/ktz9/zxK+pDTLIkuQMyVMsZgo3esu9qn4dxH1wfPs4mmKVWnWpQrUpxlTmlKMlwafBmQi89iuaFf4ZLA7up/1NoulQb4yper/AFf8FR2lw/vKauYLfHj7fg9aE8npZZoANFJgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPGcowg5TekYrVt8EkeSK72x5o8EYMsKtZ6Xl8mpacYUub7eH7kuytZ3deNGPmYykorNlYbSczyzNmGpUpT1srfWnbrk0nvl2siQB1SjShRpxpwW5Fa2282dXLGC3GYcatsNtvzVpedLlCK/M37kahwywt8Mw+3srSHQt6FNQhH2Lm/a+ZA9jWV3hODyxa7hpd3yXQT4xpcv3e/9ixuWhofaLENor9zB+GPz8/sTKMNMc35gAGuEgAAANJrR8GZ02pZWeXcwzqW8NLG81qUdOEXr50OzX9jRZHs9Zcp5ny7WsmkriH4ltN8ppbux8GXOCYhsdwtT8Mtz+541oaomX2dLAcXucDxe2xKzelWhPpaPg1zXua3HxV6NS3rVKNaEoVacnGcXxTT3o9R0iUYzi4tZpkDga0wXE7fGsLtsRs3rRrwUl60+aftTPtKT2J5o70vZ4BeVNKFw3O3b9GpzXai7DmGKWLs7l0/LivYsKc9UcwACtPUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA+bE7+3wzD7i9u59ChQpuc5exfVmXcz43XzDjd1idxudaXmw5QivyxXuRY+23NPdKkMvWc/Ng1Uumn6Xox7OLKj5m/8AZ3D+4o9/NeKXD2/JBrzzelH4S3Zvll5mzBTo1YN2VvpUuHy6K4R7WRWEJVJqME5Sk9ElvbZpbZ5llZYy7St6qXftfSrcSX6mt0dfUluJuM4hsds9L8Uty+/+GNKGqRJ4RjTgowUYxitEluSSItnLPeH5Sube3vaFxVnXg5ruWm5a6b9WSrmUBttuu+M5dyUtY0KEI6epvVv+zTMEsqd5daKm9ZNslVZOMc0TLyz4J/6C9+T7jyz4J/6C9+T7lGA2/wD/AD1h/wAX1ZG7+fMvTy0YL1fffL9yf4LiMMXwq2xCnSnShcU1OMKmnSSfrMpWdCVzdUbeKblVqRgtPa9DWWH20bKwt7WH5aNKNNdi0Nfx/D7SzhBUVk2+fkj2ozlJvM+gAGrkkpHbVlfvO+jjtnT0oXL6FwlwjU5PtRVr4mssbwq3xrCrnDrxa0q8HFvmnya9qe8y7juE3OCYtc4beRarUJuL9TXJr2NbzoXZ7ENood1N+KP/AGv3cQa8MpZo+O3rVLetTr0ZuFSnJTjNcU09UzTuSMx08z5et75NK4X4dxBejNfR8UZeJvsrzT4u5gjRuZ6WN5pTq68IP0Z9n9EjG8P2u3bivFHevqjGjPTLeaJABzUsAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAuBxs349Ry5gFziVXRygujSh+ub/Kvr7jst7zP213NDx3HXY2tTWxsW4R04VKnpS+i/8Ast8GsHe3Ki14Vvf2/wBPKrPTHMg17d1r26q3VzNzrVpudST5tveegH2YTh9fFsQt7Gzj0q9eahBe86U3GMc3uSK/iT/YxljwljDxm7p62tk/wk+EqvJ/68ffoXsczLeC2+AYLbYbarzaMfOl+uT4t+9nTOZYtfO9uXNfxW5e37vLCnDTHIMzFtEu+/M64tWT1SruC/1Sj9DTlR9CEpepNmScSuXeYjc3T41q06j/ANm39S67KU851KnJJdf/AA8rh7kj5QAboRCV7McP8IZ3wym/y0qndpc1pFdL6GlilNguH9PFcSxGS3UKMaUf/dJ6/wBRLrXA0HtPW13ipr+qX/e/7E23WUMwADWyQCsNteV+/cOhj1nD/qLVdG4S9Onruf8Aq/49xZ54VqNOvSnRqwjOnUTjOL4NPiibYXc7OvGrHy4/FGE4qUcmZCBI895bqZYzBWs9Jd7z/Et5vnB8O1cCNnUqVSFWCnB5plc008maG2R5n8O4D3ndVNb2xShLXjKHov6E7MuZMzDWy1j9tiFPpOnF9CtTXp03xX1XtNPWtzRvLWldW041KFaCnTmuDi1qmaB2gw/ZrjvILwz+fn9ybRnqjkz2gA189wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAeFatToUqlWtNQp04uU5PclFLe2fYpyeSPhENqOZ/F3L04W89L68TpUdOMFp50uxcDOLbb1ZIc9ZjqZnzBWvvOVvH8O3g/RguHa+LI6dOwiwVlbKL/k97/fgQKs9Uj9Lo2I5W7jb1Mw3kPPrJ07RPlHXSUu17kVrkvL1XMuP29hT1VJvp15r0ILi/oadtbelZ21K3toRhRowUIQXBRS0SK3tHiHc0lbwfilx9vyZ0IZvUz2gA0ImnJzbdKxyxitz0tHTtKrj/AO7otL+TKho7a9d965Ev4p6SuJ06Ue2Sb/hMzlob72Wp5Wsp838kiDcPxJH4ADZTwNA7E8P71yb31NaSvLidRPm4x0iv5TLAOXlbD/BeXMNsNOjKjbQjNf5aay/nU6nM5ViNfv7qpU5t9PIsqayikAAQjMAAAhu1DLHjHl6creGt9Z61aOnGaS3x7Vw9pnHgbAM/7Xsr+Ascd/Zw0sb9uaSW6nU9KPbxX/0bl2ZxDjaTfxX1X1IlxD+yK/Ln2I5o7rbzy9dz86nrUtW+ceMo/Upg+vC8Qr4XiNvfWcuhXoTU4P3GyYhZxvLeVKX+fBnhCemSZrUaHNy3jNvmDBLbErZ+bWjrKP6Jrc0/czpI5bVpypTcJLJrcyxTzWaAAPM+gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD2lX7a80uysIYBZz/Hul0rlrjCnruj2v8Aj3lg47itvgmEXOI3b0p0IOWnOT5Je9mXcbxS4xnFLnELuTlVrzcn7FyS9iRs3ZzD++rd/NeGPD3/ABxI1eeS0o+AB8ScbKcreMOPxr3MNbCy0qVteE5ejHta3+w3e4rwt6Uqs+CIkU5PJFnbJsr+AMBV5cw0vb5Kc9eMYejH6k6YByy7uZ3NaVWfFllGKiskAARTIq/b3dungOG2ev8A/a5dT/tjp/5lHlp7e7tzxnDbTXdSt5T09TlLT+ooqw6ZgVPRh9P45vqyvrPObB1sp2DxPMmG2emqq3EOkv8AFPV/wjklg7E8P76ze7mS1jaUZT19UnuX9snXlbuLedTkmYQWcki/0tFouQAOSlmAAAAAADjZuwKjmPAbnDquilJdKlP9M1wZ2eY0PWjVlRmqkHvW9HxpNZMyNe2layu61rcwdOtRm4Ti+KaZ85b+23K3QlDMVnDzZ6U7pJcH6Mu3gyoTqdjdwu7eNWPnx+DK2cXGWRZWxjNPgzF3g13PS0vpLuTfCFbgv+7h79C9jIMJShNTi2pReqa4pmldnWZo5my7Sr1Wu/KGlK5X+SW59q3mr9psPyauoLjuf0f0JNCf9WSkAGnkoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADiCO58zHDLGXa94nF3U/w7aD5zfPT1Lie1ChOvUjSgt7MW0lmysttWaO/cQjgVpPWhaPpV2uEqmnDsT/AHKtPbWqzr1p1aspTqTblKT3tvm2es6pZ20LWhGlDgiunJylmz221Crc3FO3oQlOrVkoQguLk3okadyRl6llnL1vYR0dd/iV5r0pvj2LgistieV++buWYLuH4Vu3C2T5z5y7EXWal2lxDXJWsHuW9+/4JNCGS1MAA1IlAAAGddsF13znm8inrGjCnTXZFa/yyEnYzhdK9zRitzF6xqXVRr3dI451u0p93QhT5JFZJ5ybBdmwXDuhheI4jOG+tVVKEvZFav8AllJml9mWH+DclYbTcejOrTdafvk9f60KjtJW7uxcP+TS+p60FnPMlIAOdk4AAAANpLV7kjxpzhUgpwnGUZLWMk9U17GfcvM+HkAD4fT5sSsbfE8Pr2V3Dp0a9NwnF+p/VGXc0YJXy9jd1hlxvdKXmT/XF/lkvejVfLQrrbJljwrgqxW1p63dim56LfKlz/bibH2dxDZ6/czfhn8/L7HhWhqjmihCWbN8zPLWYaVWrNqzuNKVwuSi3+bsIkfpvlalCtTlTmtz3EJNp5o19CcakFOD1jJaprg0zyK72NZn8LYNLCrqet5YpdBvjKk+D7HufYWIzld7aztK8qUvL5FlGSks0AARDIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOSSbb0S3tszjtPzQ8x5gmqE27G11p0Vyb5y7WWhtfzR4FwLwfaz0vL9OK04wp8JPt4Iz6zduzOH6Yu6muO5fV/QiV5/wBUDpZewi4x3GLXDbRfiV59HpcornJ+xLec0vXYvlnwfhUsau6elxeR6NHXjClr/wCT3l9id8rK2lV8+C9/3eeNOGqWRP8ACMNtsIw23sLOHRo0IqEfW9OLftb3n2AHLpzlOTlLiywAAMD6OZ8+I1+9bC5uP/8AKlOf7RbPoXEju0O67yyXi1ZPSXcXGPvb0+p721Pva8Ic2kYyeSbMx16nda9So+M5OX7s8ADrZWH04dbTvb63tqcelOtUjCK9bb0NZ2tvC1taFtS/JRpxpx9yWiM5bKbDv/POHJrzaDlXk/V0U2v50NJGldqq2dSnS5LPr/4S7ZbmwNDxqVI04Oc3GMIpuUm9EkuLbIHmnanguD9Ohh78I3a3aU3+Gn7Zc+w1y2s69zLTSjmSJSUd7ZPJyjCLlJxSXFvciE5n2n4FgkZUrSfhG7W7udCXmJ/5T4ftqU7mbPOOZjk43l1KnbPhb0fNhp7fX2kZ1NssuzEI+K5ln8Fw6/YjTuPKJMMdz1mHNdxCzqXHcLetUUI21vrGL1aS136y7WaIw62jZWFta01pGjSjBL3LQzbs4sPCOc8LpaaxhW7rL3R3/Q00iJ2lVOl3dvTSSWbyRlQzecmwADVCSD8lGM4uMkpRktGnwaP0AGbNpOWXlnMNSlSX/R3OtW3f+Le+PYyImmtoeWY5ny7Vt6aXflDWrbS/yS3x19TW4zROEqc5RnFxlF6NPc0zpmDYhtlstT8Udz+5X1YaZHTyxjVfL2N22JW35qMvOjylF/mT96NQ4Zf2+J4fb31nPp0K9NTg/Y+T9qMklubEc0dzqVMvXdTzZ61LRt+lxlFf2Qu0WH9/R7+C8UePt+DKhPJ6WXIADQCcAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD0Xt3QsLOtd3VSNOhRg5zm+SSPeVFtuzQlCnl6znvelS6a9Xox+rJ+G2Ur24jSXDz+CMKktMcyts24/XzJjlziVfWKm+jSpv/jgvyr/APczi6n4eUU5NJLVvgkdRhCNOCjFZJbkVrebzZJtnuWpZmzFRtZKXetL8S4l/gnw7eBpalCFKEKVOPRhBKMYrgkuCIrs1ywss5dpxrw0vrrSrcetN8Idi/klvA55j2IbXc6YPwx3L6sn0YaY7wACiPYAAAciv9td33vk3uOukri4hFe5at/0WAuBUm3+60t8Js/1TnV/ZJfUt8Dp68Qpr459DyqvKDKZAB0sry2NhVtTpXGL4tcVI06dGlCipyklHzn0nvfq6MSTZn2r4PhfSoYVHwjcLd0ovo00/bLn2FFK8uY2bs1XqK2c3UdJSfRctEtdOxHzlPXwWjc3Tr13nyXluPVVXGOmJI8y50xzMk2sQunG311jbUfMprs5+96kc5g/C1p0oUoqMFkuSPNtt5sAAzPhaGwjD+7Y9e30lut6HRi/8pP7IvErjYXY975XubtrSVzcv/tilp/bLHOcY/W7y/nyWS/f9J9BZQQABSHsAAACids2V/BmLLGLSnpaXj/ESW6FXn+/EvY5mZMGt8fwW5w26Xm1o+bL9Elwa9zLTCL92Vypv+L3P2PKpDVHIyie+yuq1ldUbq2m6dajNThJcmnuPbi2H3GE4hcWN5Do16FRwmvavofGdNTjKOa3plfwNUZQx+jmTALbEqPRUpro1aa/45r8y+q9h2XwM+7Is0+A8d7wuqmllfNQlrwhP0ZfQ0EnvOa4xYOzuXFLwvevt/hYUp6o5gAFQeoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAByc043Qy9gdziVff3KOlOHOUn+VfuZdxG9r4hfVry7n069abnOXrbJ5tizR4YxlYXa1NbKwk1LR7qlXm+zgu0rs6NgGH7Lb65rxS3/55L6kCtPVLJAsTY5lfwvjfhS6hrZ2DUoprdOr6K7OP7EEw+yr4hfULO1h061eahCK9bZqHKuB0Mu4HbYbb7+5x1qT/AFzfF/uMfxDZLbRB+KW7/PP7CjDVLNnWABzkngAAAAADkUNt0uu65rt7dPVULWOvsbk3/WhfJmvaldd956xSUZaxpzjSX+sUn/OpsvZenqu3Lkn9CPcPwESP0cyWZa2f49mHoVaNr3vaS398XGsYtexcZdiN6q1qdGOupJJfEhpNvJET09ZI8tZJxzMc4uxtJRt3xuK3m00vfz7C4ssbLcDwboVr2PhG6W/p1o6QT9keH76k6jGNOCjCMYxW5Jbkkave9poRzjbRz+L4dCRC3f8AYrKw2X4NgGEXd9iz8IXNKjOaUvNpxaju0Xpb/X+xRzerftNObQ7hWuSsWnro3byjF+17l/ZmImdn7mvc0p1a0s3mY1oqLSR+AH24LZSxLFrKxh+a4rwpL/ZpF/J5LNngaWyJYeDcn4VbPc1QjOXvl5z1/c7x4wjGnBQgtIxWiS5I8jkdeq61WVR+bb6lmlkkgADxMgAAAAACp9tuVu728Mw2lP8AFpaU7pL0o+jLs4P2e4pc11eW1G9tatrcwjOjWg4Tg+Di1o0Zizll+tlrHriwqqTpp9KjN+nB8H9DfezeId9S2eb8UeHt+CFXhk9SOGpOLTW5rgzRmy3M6zDl6FO4nrfWmlOqucl6Mv2M4kkyHmSeWMw0L1uTt5fh3EFzg+L09a4ossXsFeWziv5Lev34mFKemRp0HhSqU61KNWjNTp1EpQlHemmtzR5nMWstzLAAA+AAAAAAAAAAAAAAAAAAAAAAAAAcCI7TMzrLWXajoT0vbrWlQ9abW+XYv5JZUnClCdWpKMYQTlKT4JLizNG0HMs8zZhq3MXLvWl+Hbx/wT49r3l7gOH7XcqU14Y739EeNaemO4jEm5Sbb1b3tgcTs5SwGvmPHLbDqHSSm9ak16EFxZ0Oc404OcnklvZASzeSLK2IZY6MKmYruG960rRP1elP6LtLdPRZWlGwtKNpa01To0YqEILgkluPecuxG9le3Eqr4eXwRZU46YpAAEAzAAAAAAHMoC1yFj2bMavMQnR7ztLm5qVe7V046qUm90eLL/BaWGJ1LGM+7SzllvfkeU6anlmQ3LGzfAMB0q1KPf10v+a4SaT9keC/kmQ1QIlxdVrieqrJtmaiorJAAEYyINtmue4ZGuIc61WnBf8Adq/4RngvDb3cdHAsOtudS5c+yMWv/Io/mdF7OU9Fgnzbf0IFd+ME02QWHf8Anqzk1rC1hOvLsWi/lohehb2wKw8/FcRa4KFCD9+rl/4k3Fq3c2VSXwy67jGks5pFxAA5aWIAAAAAAAAARBdrOV1j2AO7tqet9Ypzhot84elH6onQJVpcztq0asOKMZRUlkzH5+E42q5V8XcflXtoaWF7rUo6cIS9KPY+HsIQdTt68LilGrB7mVsouLyZeGxTNHfuHzwG7qa17VdK3b9KnzXZ/RaHtMn4HilxgmK22I2j0rUJqSXJrmn7GjUOCYpb43hVtiNo9aVeCklzT5p+5mkdo8P7it38F4Zcff8APEl2881pZ94ANZJIAAAAAAAAAAAAAAAAAAAAAAPjxfEqGEYZc392+jSoU3OXt9SXvZnGEqklGK3s+EA20Zp8HYSsDtJ6XN5HWs098aXq/wBuHuKKOlmHF7jHcXucRu23UrTbS/SuSXsSOadRwyxjZWypLjxfv+7iuqT1SzCNA7IMr+BsD8I3UNLy+Slv4wp8l28SsNl+V3mPMEHcQ1sLPSrXb10lv82Ha/41NHJaLRcCh7S4hpirWm+O9/RfU97eH9mAAaSSwAAAAAAAAAAAAAAAAACmdv1xreYRbL0KdSo+1pL/AOLKlLD243Pds5QpL/gtKcH725S/porw6jg8O7sKS+GfXeV1V5zY5mhtjVj3nkmhUa0ldVZ1Zfv0V/CM9Qi5zUYrVt6Je01dluyWG4Dh9mtyo28I6e1RWpWdqK2m1jT/AOT+X6jO3XibOiADQScAAAAAAAAAAAAR/PGXqeZsvXFk0u7xXdLeb9GaX14GY7ijUtq9ShWg4VKcnGcXxTXFGvCk9teV1aXkMfs6elG4fQuUuCqcn2r+TbezWIaJu1m9z3r3IteGa1IqotPYpmhWd/UwG8qaULp9K2be6NRcY/7L+feVaeyhWqUK1OtRnKFSm1KMluaae5m23lrC6oSpT4P5kaEnGWaNeMEeyLmOnmfL9G81irmH4dxBcprn7nxRIeRyuvRnQqOlPiixTTWaAAPEyAAAAAAAAAAAAAAAAAAHMpXbbmjvm7jl+0n+FQaqXLXOem6PYt5Zmdsw08s5fuL+WjradC3g/Sm+HYuLMxXNerdXFSvXm51qsnOc3xcm9WzbOzWH65u6mty3L3/BFrzyWlHqPZRpTrVYUqUHOpUajGK4tt7keotHYrlfv7EJY7eU9be1fRoJ8JVPX2I268uYWtCVafkRoxcpZIs3IWXIZZy7Qs2l3zU/FuJeub5e5LcSMaA5XXrzr1JVZ8WWKSSyQAB4mQAAAAAAAAAAAAAAAAABmralc99Z8xaa4QqRpr/WKj/aIodPNNz37mTFLlcKt3Vmvc5M5h123h3VGEOSS/6KuTzk2drJ1g8TzRhlppqqlxDpe5PV/wBGpigtiNh31m+VzL8tpbynv9b81f2X7yNK7U1tVzGnyXzJlsvC2AAauSAAAAAAAAAAAAAfHjGGW+MYZc4feR6VGvTcJetepr2p70fYDOE5QkpRe9Hwyfj2E3GB4tc4deLSrQm468pLk17Gt5zy89tOV+/8MjjlpT1uLVdGvpxlS9fYyjDqOG3sb23jVXHz9yvqQ0yyJpsuzQ8u5ghC4npY3mlKtrwi/Rl2P+DRiaa1W9PgzH6NCbI80eHMB7xuamt7YpQlrxnT9GXZwZQdpsOzirqC4bn9H9D2oT/qyeAA0olgAAAAAAAAAAAAAAAcOIXAgu1rM/gHL/ettPS9vtYQ0e+EPSl/OiJNpbTuq0aUOLMZSUVmysNquaPGHH3Qtp62NnrTpacJS9KXaQhMA6rb0IW9KNOHBFbJuTzZ9+CYVc41ilth1nHpVq9RRW7clzb9iW9mosDwq3wTCLbDbSOlOhBR15yfNv2t7yvdimWO87CePXdP8e6XQt01+Wnzf+39Fo+w0ftHiHfVu4g/DHj7/jgS6EMlqYABrJJAAAAAAAAAAAAAAABEtoGIYxgVjTxvCGqtK3826tai1hKL9LdvTT5ktR67m3pXVvVt7iEZ0asHCcXwcWtGiTa1o0aqnOOa81zRjJZrJEJy1tSy/jEYUryr4NunxhXl5jfsnw/fQmVa8o07Grd06sJ06dKVTpRkmmkteOpmPOGA1cuZgu8NqauEH0qU36UHvT+nvOdbYjfWkJ07W8uKMJpqcKdSUU0+KaXE3Cp2btq+VW3nknvy4rL5/MiqvJbpI+WpJznKT3tttv3niAbSRi7tguH9zwnEsRko/jVo0ovmlFav/wCSLAxbMGD4NT6eKYhb2/NRlPzn7ore+xGZbfH8XtLJWVriNxRtlJvudKo4rV8eB8UVWu7hRj06tarJJLfKUpN7l7Wa5dYBtV1KvVnkn5Ll7/g941tMUki/rHaHHMGNU8KyvYzrLXpVbu482FOCe9qK3v2atE8XEimzrKkMr4JCFWMXf3Gk7ifHR6boJ+pErNRxGVt3vd2y8MfPzfxJUNWWcgACuPQAAAAAAAAAAAA8KtOFalOlVhGUJpxlF8GnxTMz5/y3PLOYa1olJ21T8S3m+cHy7OBpsiG07LHjLl6fcIa31prVt/XLd50O1L99C+wHENkudM34Zbn9GeNaGqO4zdqdzJ+P1stY9bYjS6UoRelWCendIPiv/wBzOHJNPRrRoHQqkI1IOE1mnuZATyeaNdWl1QvrWldWtSNSjWipwmuaZ7ipNiOaO6U6mXrufnQ1qWrb5elH6ots5diNlKyuJUnw8vYsqctUcwACAZgAAAAAAAAAAAHpurilZ21W4uZxhRpQc5zfBRS1bMx5zzDWzNj9xiFTpKm30KFN/wDHTXBfV+0srbbmjuNvTy9aVPPq6VLprlHjGPbxKXN97N4f3NJ3M14pcPb8kKvPN6UfhI8i5cqZmzBQs0pKhH8S4n+mC4/vwI7oaO2W5Y8XcvQncQ6N/eaVa2vGKf5Yftx9pZYvfqytnJfye5fvwMKUNUiXW9Gnb0adGjCMKdOKjCK4JJbkewA5i25PNlgAAfAAAAAAAAAAAAAAAAAAAV7tiyz4XwFYnbQ1vMPTk9OM6T/Muziu0oE19KEakZQnHpRktGnwaZmfaHlyWWsx3FrCOlrVbq275dBvh2cDeOzN9rg7ab3revb8EO4hv1IjAANqIx+lvbGModKSzHiFPdHdZwl6+Dn9EQnZ/lWrmnG40HGSs6Ok7mouUfUvazSlvQpW1CnQt4KFGnFRhBcEktEjWe0WJ9zT2am/E+PwX5+RJoU83qZ7AAaGTAAAAAAAAAAAAAAAAAADP+1/K/gXG/CFrDSyvm5aLhTqekvqV+aozZgVHMWA3OG1uipVFrSm/QmuDMv39pWsLyvaXUHCvQqOE4vlJPRnR8BxDarfTN+KO5+3kyBWhplmjywy/uMMxC3vrOfQr0JqcJe1GostY1b5gwW2xO2fm1o+fDnTkvzRfuZlMsfY1mfwVjDwm6npaXzXQ14Qq8E+3g+wxx/D9pt+8gvFH/tef3FGemWTL5ABzongAAAAAAAADiczMeM2+AYLc4ndPzaMdYx/XJ7kl72dPgUxt4xuU7uywOlPzKUe71kuc3qop+5av/YssKs9suo03w4v2X7kedSWmOZWOLYhXxXELi+u5dKvXm5zfvPkQZ77K1rXt1RtbWm6letNQpwXFtvcdQSUY5cEiu4k32RZW8N46r+6p62Ni1OWq3TqejH6s0EuJxcoYDRy3gNth9LoupFdKrP9U3xZ2jmmMX+23Lkn4VuX78SwpQ0xyAAKg9QAAAAAAAAAAAAAAAAAAAAAiGbU8teMOXKlW3hre2etWl65RS86P7EzBJtbidtWjVhxRjKKksmY/PosLK4xC9o2dpTdSvWmoU4Lm2S7aplrxezHUqW8NLG91rUdOEHr50Oxv9mTrY3k92Fr4fxCnpc146W0JcacHxl73/R0e5xSjRs1dJ5prcvjy+5AjTbnpJnkzLVvlfBKVjS0lWfn3FZf8k3z9y4I7vIA5pWrTrVHUqPNviT0klkgADyMgAAAAAAAAAAAAAAAAAAVBtvyvp3PMVpDjpTu0v2jP6PsLfPnxCzoYjY17O6gp0a1NwnF+pon4beysrmNVcOD9jCpHVHIyOeUJShNSi9JJ6prkzqZowStl7G7nDa+90peZP8AXF8H2o5J1KE4zipxeaZWtZPJmltm+ZlmbLtOrWnre2+lK4XNtLdLtRKjO+yDGpYTm+jQnLShfLuE1y6T/K/33dpog5xjtkrS7aj/ABlvRPoz1R3gAFKewAAAAAAM1bUq87jPeKyn6NSMF7oxS+hpUzrthw+djne7m46U7qEK0H69Vo/5TNo7KyirqafHT9UR7n+KISWRsNw2jd5luLytHpOzo9KmnylJ6a/tqVvxJFkbM9XKmNK+jTdWhODp1qSejlF+p+vXebhiFKpWtalOnxa3ESDSkmzTwIhY7S8p3VFTlifcJPjTr0pRkv40/Zn0eUHKfXdv832OaSw68i2nSl0ZYd5HmScEY8oOU+u7f5vsPKDlPru3+b7HzYLv0pdGNceZJwRjyg5T67t/m+w8oOU+u7f5vsNgu/Sl0Y1x5knBGPKDlPru3+b7Dyg5T67t/m+w2C79KXRjXHmScEY8oOU+u7f5vsPKDlPru3+b7DYLv0pdGNceZJwRjyg5T67t/m+w8oOU+u7f5vsNgu/Sl0Y1x5knBGPKDlPru3+b7Dyg5T67t/m+w2C79KXRjXHmScEY8oOU+u7f5vsPKDlPru3+b7DYLv0pdGNceZJwRjyg5T67t/m+w8oOU+u7f5vsNgu/Sl0Y1x5knBGPKDlPru3+b7Dyg5T67t/m+w2C79KXRjXHmdLMGX8PzDQt6OJUenGhWjWhpueqe9e5rczpxjGEFGEVGMVoktySRG/KDlPru3+b7Dyg5U67t/m+x6O1vpQUHCWS4LJ+Z81QzzzJMCMeUHKfXdv832HlByn13b/N9jz2C79KXRn3XHmScEY8oOU+u7f5vsPKDlPru3+b7DYLv0pdGNceZJwRjyg5T67t/m+w8oOU+u7f5vsNgu/Sl0Y1x5knBGPKDlPru3+b7Dyg5T67t/m+w2C79KXRjXHmScEY8oOU+u7f5vsPKDlPru3+b7DYLv0pdGNceZJwRjyg5T67t/m+w8oOU+u7f5vsNgu/Sl0Y1x5knBGPKDlPru3+b7Dyg5T67t/m+w2C79KXRjXHmScEY8oOU+u7f5vsPKDlPru3+b7DYLv0pdGNceZJwRjyg5T67t/m+x41doeUqUHN41RaXKMJyf7JD/5936UujGuPMiW3jCqU8OscWgkqtOp3Cb9cWm1+zRSupP8AadnqnmmpQs8Op1IWFB9LWe6VWT56ckuRADomD0K1CzjTrcfkiDVac20fVhladtiVrXpPSdKtCcX7VJM1sZPy/ZTxHHLCzp/mr3EIe5OS1f7GsCg7VtZ0l57/AKHtbcGAAacSwAAAAAAuBA9rmVp4/gkb2zp9K+sdZRiuNSD/ADL3rTVE8BKs7qdrWjWhxRjKKksmY/BeOfdl1PFatXEsAcKN3J9KpbS82nUfNp+i/wCPcU/iuCYng9d0sRsa9Ca/XB6P2p8GjpdjiVveQUqct/mvNfvMr505Re85oAJpgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAfTaWd1eVo0bS3q1qknpGNODk2yy8l7Jru6qwvMyx73teKtU/xJ/8Au/Sv59xGuryhawc6ssvmZRhKTySPfsTyvUndTzBeU9KNNOFt0vSk90pL3LcXNqeu2t6Nrb07e2pxp0qaUYQitEkuSPYc2xK+lfXDqy4cEvgT6cFGOQABXnoAAAAAAAAADwr0aVem6denCpB8YzipJ9h5g+puLzR8OPXyrgFeXSqYNY6+yjGP9I9fidlzqWz+Ejudo7SSry5SyVR9WfNMeRw/E7LnUtn8JDxOy51LZ/CR3NBoNtufUl1Y0x5HD8TsudS2fwkPE7LfUtn8JHc0Gg2259SXVjTHkcPxOy51LZ/CQ8Tst9S2fwkdzQaDbbn1JdWNMeRw/E7LfUtn8JDxOy31LZ/CR3NBoNtufUl1Y0x5HD8TsudS2fwkPE7LnUtn8JHc0Gg2259SXVjTHkcPxOy51LZ/CQ8TsudS2fwkdzQaDbbn1JdWNMeRw/E7LnUtn8JDxOy51LZ/CR3NBoNtufUl1Y0x5HD8TsudS2fwkPE7LnUtn8JHc0Gg2259SXVjTHkcPxOy51LZ/CQ8TsudS2fwkdzQaDbbn1JdWNMeRw/E7LnUtn8JDxOy51LZ/CR3NBoNtufUl1Y0x5HD8TsudS2fwkPE7LfUtn8JHc0Gg2259SXVjTHkcPxOy31LZ/CQ8Tst9S2fwkdzQaDbbn1JdWNMeRw/E7LnUtn8JDxOy31LZ/CR3NBoNtufUl1Y0x5HD8TsudS2fwkPE7LnUtn8JHc0Gg2259SXVjTHkcPxOy51LZ/CQ8Tst9S2fwkdzQaDbbn1JdWNMeRw/E7LnUtn8JDxOy51LZ/CR3NBoNtufUl1Y0x5HD8Tst9S2fwkPE7LfUtn8JHc0Gg2259SXVjTHkcPxOy31LZ/CQ8Tst9S2fwkdzQaDbbn1JdWNMeRw/E7LnUtn8JH7DKGXYTUlgtnquGtJP8As7eg0G2XPqPqxpjyPRa2VpZxcbS1o0IviqVOMF/CPeAR5Sc3nJ7z6AAYn0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//9k=")}, coordinateSystem(initialScale = 0.1)));
    end Power_Table_kW;

    model Time_Switch
      //  parameter Boolean CHP_ON;
      //  parameter Boolean AdCM_ON;
      //  parameter Boolean RevHP_HP_ON;
      //  parameter Boolean RevHP_CC_ON;
      //  parameter Boolean HTES_V_HT;
      //  parameter Boolean Coil_ON;
      //================ Connector variables ==========
      Interfaces.RealOutput AdCM_Switch annotation(
        Placement(visible = true, transformation(origin = {-30, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-20, -98}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      Interfaces.RealOutput RevHP_HP_Switch annotation(
        Placement(visible = true, transformation(origin = {30, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {20, -98}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      Interfaces.RealOutput RevHP_CC_Switch annotation(
        Placement(visible = true, transformation(origin = {70, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {60, -98}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      Interfaces.RealOutput CHP_Switch annotation(
        Placement(visible = true, transformation(origin = {-70, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-60, -98}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealOutput v_HT annotation(
        Placement(visible = true, transformation(origin = {-100, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-100, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput Coil_Switch annotation(
        Placement(visible = true, transformation(origin = {-100, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-100, 40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
      Modelica.Blocks.Sources.CombiTimeTable CHP(fileName = "C:/Javier/Switch/Switch.csv", tableName = "tab1", tableOnFile = true) annotation(
        Placement(visible = true, transformation(origin = {-90, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Sources.CombiTimeTable AdCM(fileName = "C:/Javier/Switch/Switch.csv", tableName = "tab2", tableOnFile = true) annotation(
        Placement(visible = true, transformation(origin = {-30, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Sources.CombiTimeTable HP(fileName = "C:/Javier/Switch/Switch.csv", tableName = "tab3", tableOnFile = true) annotation(
        Placement(visible = true, transformation(origin = {10, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Sources.CombiTimeTable CCM(fileName = "C:/Javier/Switch/Switch.csv", tableName = "tab4", tableOnFile = true) annotation(
        Placement(visible = true, transformation(origin = {50, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Sources.CombiTimeTable Coil(fileName = "C:/Javier/Switch/Switch.csv", tableName = "tab5", tableOnFile = true) annotation(
        Placement(visible = true, transformation(origin = {-50, 10}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    equation
      connect(HP.y[1], v_HT) annotation(
        Line(points = {{22, -10}, {30, -10}, {30, 36}, {-78, 36}, {-78, 20}, {-100, 20}, {-100, 20}}, color = {0, 0, 127}));
      connect(Coil.y[1], Coil_Switch) annotation(
        Line(points = {{-60, 10}, {-70, 10}, {-70, -40}, {-100, -40}, {-100, -40}}, color = {0, 0, 127}));
      connect(CCM.y[1], RevHP_CC_Switch) annotation(
        Line(points = {{62, 10}, {70, 10}, {70, -90}, {70, -90}}, color = {0, 0, 127}));
      connect(HP.y[1], RevHP_HP_Switch) annotation(
        Line(points = {{22, -10}, {30, -10}, {30, -90}, {30, -90}}, color = {0, 0, 127}));
      connect(AdCM.y[1], AdCM_Switch) annotation(
        Line(points = {{-18, -30}, {-10, -30}, {-10, -60}, {-30, -60}, {-30, -90}, {-30, -90}}, color = {0, 0, 127}));
      connect(CHP.y[1], CHP_Switch) annotation(
        Line(points = {{-78, -70}, {-70, -70}, {-70, -90}, {-70, -90}}, color = {0, 0, 127}));
//================ CHP switch ===================
//  if CHP_ON == true then
//    CHP_Switch = 1;
//  else
//    CHP_Switch = 0;
//  end if;
////================ AdCM switch ==================
//  if AdCM_ON == true then
//    AdCM_Switch = 1;
//  else
//    AdCM_Switch = 0;
//  end if;
////================ RevHP_HP switch ==============
//  if RevHP_HP_ON == true then
//    RevHP_HP_Switch = 1;
//  else
//    RevHP_HP_Switch = 0;
//  end if;
////================ RevHP_CC switch ==============
//  if RevHP_CC_ON == true then
//    RevHP_CC_Switch = 1;
//  else
//    RevHP_CC_Switch = 0;
//  end if;
////================ Volume for HTES_HT ===========
//  if HTES_V_HT == true then
//    v_HT = 1;
//  else
//    v_HT = 0;
//  end if;
////================ Switch for the coil ==========
//  if Coil_ON == true then
//    Coil_Switch = 1;
//  else
//    Coil_Switch = 0;
//  end if;
//================ Color and shape ==============
      annotation(
        Icon(graphics = {Rectangle(origin = {-60, 0}, fillColor = {135, 135, 135}, fillPattern = FillPattern.Solid, extent = {{-8, 60}, {8, -60}}), Rectangle(origin = {-20, 0}, fillColor = {120, 120, 120}, fillPattern = FillPattern.Solid, extent = {{-8, 60}, {8, -60}}), Rectangle(origin = {20, 0}, fillColor = {126, 126, 126}, fillPattern = FillPattern.Solid, extent = {{-8, 60}, {8, -60}}), Rectangle(origin = {61, 0}, fillColor = {135, 135, 135}, fillPattern = FillPattern.Solid, extent = {{-9, 60}, {7, -60}}), Rectangle(origin = {-60, 40}, fillColor = {0, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-20, 8}, {20, -8}}), Rectangle(origin = {-20, -41}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-20, 9}, {20, -7}}), Rectangle(origin = {20, 41}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-20, 7}, {20, -9}}), Rectangle(origin = {60, -40}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-20, 8}, {20, -8}}), Text(origin = {1, 82}, extent = {{-65, 12}, {65, -12}}, textString = "On"), Text(origin = {0, -72}, extent = {{-40, 12}, {40, -12}}, textString = "Off")}));
    end Time_Switch;

    model LOAD_H_Block
      import SI = Modelica.SIunits;
      //================== Parameters =======================
      //parameter Units.Power_kW Pth_H "Thermal Power of the LOAD";
      //parameter SI.Temp_C delta_T_CC "Temperature difference between T_FL_CC and T_RL_CC";
      parameter SI.Temp_C T_CC_FL " Temeprature going to Climate Chamber";
      parameter Units.VolumeFlow v_dot_CC "Volume Flow going to the Climate Chamber [m3/h]";
      //==================Constants=====================
      constant SI.Density rho_water = 994.3025 "Water density [kg/m3]";
      constant Units.SpecificHeat cpw = 4.18 "Specific heat transfer coefficient of water" annotation(
        HideResult = false);
      //================== Variable =========================
      SI.Temp_C LOAD_HC_W_T_M__FL_ "Temp from tank to 3-MV";
      SI.Temp_C LOAD_HC_W_T_M__RL_ "Temp from 3-MV back to Tank, is the same as temp. coming back from climate chamber = T_CC_RL";
      SI.Temp_C T_CC_RL;
      SI.Temp_K LOAD_HC_W_T_M__FL__K annotation(
        HideResult = true);
      SI.Temp_K T_CC_RL_K annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_LOAD "Mass Flow going to the LOAD [kg/s]" annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_CC "Mass Flow going to the Climate Chamber[kg/s]" annotation(
        HideResult = true);
      Units.VolumeFlow LOAD_HC_W_VF_M___ "Volume Flow going to the LOAD [m3/h]";
      Units.Power_kW Pth_H "Thermal Power of the LOAD";
      //================== Connector =========================
      Interfaces.Temp_HT LOAD_In annotation(
        Placement(visible = true, transformation(origin = {-40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.MassFlow_out_HT LOAD_Out annotation(
        Placement(visible = true, transformation(origin = {40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.Power Power_H_in annotation(
        Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
//============ Mass flow kg/s to Volume Flow m3/h ==============
      m_dot_LOAD = LOAD_HC_W_VF_M___ * rho_water / 3600;
      m_dot_CC = v_dot_CC * rho_water / 3600;
//============== Connector equation ==================
      LOAD_HC_W_T_M__FL_ = LOAD_In.T;
      LOAD_HC_W_T_M__RL_ = LOAD_Out.T;
      m_dot_LOAD = LOAD_Out.m_dot;
      Pth_H = Power_H_in.P;
//================== Temperature equation from °C to K ==================
      LOAD_HC_W_T_M__FL__K = LOAD_HC_W_T_M__FL_ + 273.15;
      T_CC_RL_K = T_CC_RL + 273.15;
//================== Main equations =====================================
      LOAD_HC_W_T_M__RL_ = T_CC_RL "Temp coming back from CC is the one going back to the Tank";
////============== dT in Climate Chamber ==================
//  delta_T_CC = T_CC_FL - T_CC_RL;
//============== Energy Balance in Climate Chamber to calculate T_RL_CC ==================
      Pth_H = m_dot_CC * cpw * (T_CC_FL - T_CC_RL);
//============== Energy Balance Based on 3-MV Equations. Here the mass flow from Tank is calculated Check Documentation==================
      Pth_H = m_dot_LOAD * cpw * (LOAD_HC_W_T_M__FL__K - T_CC_RL_K);
//================== Color and shape =================
      annotation(
        Icon(coordinateSystem(initialScale = 0.1), graphics = {Bitmap(extent = {{-100, 100}, {100, -100}}, imageSource = "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")}));
    end LOAD_H_Block;

    model LOAD_C_Block
      import SI = Modelica.SIunits;
      //================== Parameters =======================
      //parameter Units.Power_kW Pth_CC "Thermal Power of the LOAD";
      //parameter SI.Temp_C delta_T_CC "Temperature difference between T_FL_CC and T_RL_CC";
      parameter SI.Temp_C T_CC_FL " Temeprature going to Climate Chamber";
      parameter Units.VolumeFlow v_dot_CC "Volume Flow going to the Climate Chamber [m3/h]";
      //================== Constants ========================
      constant SI.Density rho_water = 994.3025 "Water density [kg/m3]";
      constant Units.SpecificHeat cpw = 4.18 "Specific heat transfer coefficient of water" annotation(
        HideResult = false);
      //================== Variable =========================
      SI.Temp_C LOAD_HC_W_T_M__FL_ "Temp from tank to 3-MV";
      SI.Temp_C LOAD_HC_W_T_M__RL_ "Temp from 3-MV back to Tank, is the same as temp. coming back from climate chamber = T_CC_RL";
      SI.Temp_C T_CC_RL;
      SI.Temp_K LOAD_HC_W_T_M__FL__K annotation(
        HideResult = true);
      SI.Temp_K T_CC_RL_K annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_LOAD "Mass Flow going to the LOAD [kg/s]" annotation(
        HideResult = true);
      SI.MassFlowRate m_dot_CC "Mass Flow going to the Climate Chamber[kg/s]" annotation(
        HideResult = true);
      Units.VolumeFlow LOAD_HC_W_VF_M___ "Volume Flow going to the LOAD [m3/h]";
      Units.Power_kW Pth_CC "Thermal Power of the LOAD";
      //================== Connector =========================
      Interfaces.Temp_LT LOAD_In annotation(
        Placement(visible = true, transformation(origin = {40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.MassFlow_out_LT LOAD_Out annotation(
        Placement(visible = true, transformation(origin = {-40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.Power Power_C_In annotation(
        Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
//============== Connector equation ==================
      LOAD_HC_W_T_M__FL_ = LOAD_In.T;
      LOAD_HC_W_T_M__RL_ = LOAD_Out.T;
      m_dot_LOAD = LOAD_Out.m_dot;
      Pth_CC = Power_C_In.P;
//============ Mass flow kg/s to Volume Flow m3/h ==============
      m_dot_LOAD = LOAD_HC_W_VF_M___ * rho_water / 3600;
      m_dot_CC = v_dot_CC * rho_water / 3600;
//================== Temperature equation from °C to K ==================
      LOAD_HC_W_T_M__FL__K = LOAD_HC_W_T_M__FL_ + 273.15;
      T_CC_RL_K = T_CC_RL + 273.15;
//================== Main equations =====================================
      LOAD_HC_W_T_M__RL_ = T_CC_RL "Temp coming back from CC is the one going back to the Tank";
//============== dT in Climate Chamber ==================
//  delta_T_CC = T_CC_RL - T_CC_FL "Temperature are other way round since it is cooling";
//============== Energy Balance in Climate Chamber to calculate T_RL_CC==================
      Pth_CC = m_dot_CC * cpw * (T_CC_RL - T_CC_FL) "Temperature are other way round since it is cooling";
//============== Energy Balance Based on 3-MV Equations.Check Documentation==================
      Pth_CC = m_dot_LOAD * cpw * (T_CC_RL_K - LOAD_HC_W_T_M__FL__K) "Temperatures switched for cooling";
//================== Color and shape =================
      annotation(
        Icon(coordinateSystem(initialScale = 0.1), graphics = {Bitmap(extent = {{-100, 100}, {100, -100}}, imageSource = "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")}));
    end LOAD_C_Block;
  end Components;

  type Units
    type Power_kW = Real(unit = "kW");
    type SpecificHeat = Real(unit = "kJ/(kg.K)");
    type FuelEnergy = Real(unit = "kWh/kg");
    type unitless = Real(unit = "1");
    type Density = Real(unit = "kg/m3");
    type HeatConductivity = Real(unit = "kW/(m.K)");
    type Volume = Real(unit = "m3");
    type HeatTransfer = Real(unit = "kW/(K.m2)");
    type VolumeFlow = Real(unit = "m3/h");
    type HeatCapacityRate = Real(unit = "kW/K");
    type FuelFlow = Real(unit = "l/h");
    type Costs = Real(unit = "€");
    type FuelPrice = Real(unit = "€/l");
    type EnergyPrice = Real(unit = "€/kWh");
    type RPM = Real(unit = "RPM");
    type unitless_int = Integer(unit = "1");
  end Units;
  annotation(
    uses(Modelica(version = "3.2.2")));
end KWKK_CCHP_V49;
