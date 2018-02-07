-- -------------------------------------------------------------
-- 
-- File Name: foc_hdl_prj_v3\hdlsrc\controller\controller.vhd
-- Created: 2017-11-28 19:11:02
-- 
-- Generated by MATLAB 9.1 and HDL Coder 3.9
-- 
-- 
-- -------------------------------------------------------------
-- Rate and Clocking Details
-- -------------------------------------------------------------
-- Model base rate: 2e-06
-- Target subsystem base rate: 2e-06
-- 
-- 
-- Clock Enable  Sample Time
-- -------------------------------------------------------------
-- ce_out        2e-06
-- -------------------------------------------------------------
-- 
-- 
-- Output Signal                 Clock Enable  Sample Time
-- -------------------------------------------------------------
-- Va                            ce_out        2e-06
-- Vb                            ce_out        2e-06
-- Vc                            ce_out        2e-06
-- -------------------------------------------------------------
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: controller
-- Source Path: controller
-- Hierarchy Level: 0
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY controller IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        clk_enable                        :   IN    std_logic;
        Current_Command                   :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En12
        i_a                               :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En12
        i_b                               :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En12
        Electrical_Position               :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En12
		  freq										:	IN		STD_LOGIC_VECTOR(15 DOWNTO 0);
        ce_out                            :   OUT   std_logic;
        Va                                :   OUT   std_logic_vector(83 DOWNTO 0);  -- sfix84_En66
        Vb                                :   OUT   std_logic_vector(83 DOWNTO 0);  -- sfix84_En66
        Vc                                :   OUT   std_logic_vector(83 DOWNTO 0)  -- sfix84_En66
        );
END controller;


ARCHITECTURE rtl OF controller IS

  -- Component Declarations
  COMPONENT Clarke_Transform
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          Phase_Current_A                 :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En12
          Phase_Current_B                 :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En12
          Alpha                           :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En12
          Beta                            :   OUT   std_logic_vector(15 DOWNTO 0)  -- sfix16_En11
          );
  END COMPONENT;

  COMPONENT Sine_Cosine
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          P                               :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En12
          Sin                             :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En14
          Cos                             :   OUT   std_logic_vector(15 DOWNTO 0)  -- sfix16_En14
          );
  END COMPONENT;

  COMPONENT Park_Transform
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          Alpha                           :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En12
          Beta                            :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En11
          Sin_Coefficient                 :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En14
          Cos_Coefficient                 :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En14
          D                               :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En27
          Q                               :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En27
          );
  END COMPONENT;

  COMPONENT DQ_Current_Control
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          Q_Command                       :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En12
          D_Current                       :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En27
          Q_Current                       :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En27
          paramCurrentControlI            :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En3
          paramCurrentControlP            :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En8
          sampleTime                      :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En24
          D_Voltage                       :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En11
          Q_Voltage                       :   OUT   std_logic_vector(15 DOWNTO 0)  -- sfix16_En11
          );
  END COMPONENT;

  COMPONENT Inv_Park_Transform
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          D                               :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En11
          Q                               :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En11
          Sin_Coefficient                 :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En14
          Cos_Coefficient                 :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En14
          Alpha                           :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En10
          Beta                            :   OUT   std_logic_vector(15 DOWNTO 0)  -- sfix16_En10
          );
  END COMPONENT;

  COMPONENT Inv_Clarke_Transform
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          Alpha                           :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En10
          Beta                            :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En10
          Phase_Voltage_A                 :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En25
          Phase_Voltage_B                 :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En25
          Phase_Voltage_C                 :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En25
          );
  END COMPONENT;

  COMPONENT Space_Vector_Modulation
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          Phase_Voltage_A                 :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En25
          Phase_Voltage_B                 :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En25
          Phase_Voltage_C                 :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En25
          SVM_Phase_Voltage_A             :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En8
          SVM_Phase_Voltage_B             :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En8
          SVM_Phase_Voltage_C             :   OUT   std_logic_vector(15 DOWNTO 0)  -- sfix16_En8
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : Clarke_Transform
    USE ENTITY work.Clarke_Transform(rtl);

  FOR ALL : Sine_Cosine
    USE ENTITY work.Sine_Cosine(rtl);

  FOR ALL : Park_Transform
    USE ENTITY work.Park_Transform(rtl);

  FOR ALL : DQ_Current_Control
    USE ENTITY work.DQ_Current_Control(rtl);

  FOR ALL : Inv_Park_Transform
    USE ENTITY work.Inv_Park_Transform(rtl);

  FOR ALL : Inv_Clarke_Transform
    USE ENTITY work.Inv_Clarke_Transform(rtl);

  FOR ALL : Space_Vector_Modulation
    USE ENTITY work.Space_Vector_Modulation(rtl);

  -- Signals
  SIGNAL enb                              : std_logic;
  SIGNAL Current_Command_signed           : signed(15 DOWNTO 0);  -- sfix16_En12
  SIGNAL Delay_1_out1                     : signed(15 DOWNTO 0);  -- sfix16_En12
  SIGNAL i_a_signed                       : signed(15 DOWNTO 0);  -- sfix16_En12
  SIGNAL i_b_signed                       : signed(15 DOWNTO 0);  -- sfix16_En12
  SIGNAL Delay_2_out1                     : signed(15 DOWNTO 0);  -- sfix16_En12
  SIGNAL Delay_3_out1                     : signed(15 DOWNTO 0);  -- sfix16_En12
  SIGNAL Clarke_Transform_out1            : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL i_beta                           : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL Electrical_Position_signed       : signed(15 DOWNTO 0);  -- sfix16_En12
  SIGNAL Delay_4_out1                     : signed(15 DOWNTO 0);  -- sfix16_En12
  SIGNAL Sine_Cosine_out1                 : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL Sine_Cosine_out2                 : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL i_d                              : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL i_q                              : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL paramCurrentControlI_out1        : signed(15 DOWNTO 0);  -- sfix16_En3
  SIGNAL paramCurrentControlP_out1        : signed(15 DOWNTO 0);  -- sfix16_En8
  SIGNAL sampleTime1_out1                 : signed(15 DOWNTO 0);  -- sfix16_En24
  SIGNAL v_d                              : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL v_q                              : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL v_alpha                          : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL v_beta                           : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL v_a                              : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL v_b                              : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL v_c                              : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL v_a_1                            : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL v_b_1                            : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL v_c_1                            : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL v_a_signed                       : signed(15 DOWNTO 0);  -- sfix16_En8
  SIGNAL Delay_5_out1                     : signed(15 DOWNTO 0);  -- sfix16_En8
  SIGNAL Constant_out1                    : signed(82 DOWNTO 0);  -- sfix83_En66
  SIGNAL Add_add_cast                     : signed(83 DOWNTO 0);  -- sfix84_En66
  SIGNAL Add_add_cast_1                   : signed(83 DOWNTO 0);  -- sfix84_En66
  SIGNAL Add_out1                         : signed(83 DOWNTO 0);  -- sfix84_En66
  SIGNAL v_b_signed                       : signed(15 DOWNTO 0);  -- sfix16_En8
  SIGNAL Delay_6_out1                     : signed(15 DOWNTO 0);  -- sfix16_En8
  SIGNAL Add1_add_cast                    : signed(83 DOWNTO 0);  -- sfix84_En66
  SIGNAL Add1_add_cast_1                  : signed(83 DOWNTO 0);  -- sfix84_En66
  SIGNAL Add1_out1                        : signed(83 DOWNTO 0);  -- sfix84_En66
  SIGNAL v_c_signed                       : signed(15 DOWNTO 0);  -- sfix16_En8
  SIGNAL Delay_7_out1                     : signed(15 DOWNTO 0);  -- sfix16_En8
  SIGNAL Add2_add_cast                    : signed(83 DOWNTO 0);  -- sfix84_En66
  SIGNAL Add2_add_cast_1                  : signed(83 DOWNTO 0);  -- sfix84_En66
  SIGNAL Add2_out1                        : signed(83 DOWNTO 0);  -- sfix84_En66

BEGIN
  -- i_alpha
  -- 
  -- FOC Current Control
  -- 
  -- Copyright 2014 The MathWorks, Inc.

  -- <Root>/Clarke_Transform
  u_Clarke_Transform : Clarke_Transform
    PORT MAP( clk => clk,
              reset => reset,
              enb => clk_enable,
              Phase_Current_A => std_logic_vector(Delay_2_out1),  -- sfix16_En12
              Phase_Current_B => std_logic_vector(Delay_3_out1),  -- sfix16_En12
              Alpha => Clarke_Transform_out1,  -- sfix16_En12
              Beta => i_beta  -- sfix16_En11
              );

  -- <Root>/Sine_Cosine
  u_Sine_Cosine : Sine_Cosine
    PORT MAP( clk => clk,
              reset => reset,
              enb => clk_enable,
              P => std_logic_vector(Delay_4_out1),  -- sfix16_En12
              Sin => Sine_Cosine_out1,  -- sfix16_En14
              Cos => Sine_Cosine_out2  -- sfix16_En14
              );

  -- <Root>/Park_Transform
  u_Park_Transform : Park_Transform
    PORT MAP( clk => clk,
              reset => reset,
              enb => clk_enable,
              Alpha => Clarke_Transform_out1,  -- sfix16_En12
              Beta => i_beta,  -- sfix16_En11
              Sin_Coefficient => Sine_Cosine_out1,  -- sfix16_En14
              Cos_Coefficient => Sine_Cosine_out2,  -- sfix16_En14
              D => i_d,  -- sfix32_En27
              Q => i_q  -- sfix32_En27
              );

  -- <Root>/DQ_Current_Control
  u_DQ_Current_Control : DQ_Current_Control
    PORT MAP( clk => clk,
              reset => reset,
              enb => clk_enable,
              Q_Command => std_logic_vector(Delay_1_out1),  -- sfix16_En12
              D_Current => i_d,  -- sfix32_En27
              Q_Current => i_q,  -- sfix32_En27
              paramCurrentControlI => std_logic_vector(paramCurrentControlI_out1),  -- sfix16_En3
              paramCurrentControlP => std_logic_vector(paramCurrentControlP_out1),  -- sfix16_En8
              sampleTime => std_logic_vector(sampleTime1_out1),  -- sfix16_En24
              D_Voltage => v_d,  -- sfix16_En11
              Q_Voltage => v_q  -- sfix16_En11
              );

  -- <Root>/Inv_Park_Transform
  u_Inv_Park_Transform : Inv_Park_Transform
    PORT MAP( clk => clk,
              reset => reset,
              enb => clk_enable,
              D => v_d,  -- sfix16_En11
              Q => v_q,  -- sfix16_En11
              Sin_Coefficient => Sine_Cosine_out1,  -- sfix16_En14
              Cos_Coefficient => Sine_Cosine_out2,  -- sfix16_En14
              Alpha => v_alpha,  -- sfix16_En10
              Beta => v_beta  -- sfix16_En10
              );

  -- <Root>/Inv_Clarke_Transform
  u_Inv_Clarke_Transform : Inv_Clarke_Transform
    PORT MAP( clk => clk,
              reset => reset,
              enb => clk_enable,
              Alpha => v_alpha,  -- sfix16_En10
              Beta => v_beta,  -- sfix16_En10
              Phase_Voltage_A => v_a,  -- sfix32_En25
              Phase_Voltage_B => v_b,  -- sfix32_En25
              Phase_Voltage_C => v_c  -- sfix32_En25
              );

  -- <Root>/Space_Vector_Modulation
  u_Space_Vector_Modulation : Space_Vector_Modulation
    PORT MAP( clk => clk,
              reset => reset,
              enb => clk_enable,
              Phase_Voltage_A => v_a,  -- sfix32_En25
              Phase_Voltage_B => v_b,  -- sfix32_En25
              Phase_Voltage_C => v_c,  -- sfix32_En25
              SVM_Phase_Voltage_A => v_a_1,  -- sfix16_En8
              SVM_Phase_Voltage_B => v_b_1,  -- sfix16_En8
              SVM_Phase_Voltage_C => v_c_1  -- sfix16_En8
              );

  Current_Command_signed <= signed(Current_Command);

  enb <= clk_enable;

  -- <Root>/Delay_1
  Delay_1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '0' THEN
        Delay_1_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay_1_out1 <= Current_Command_signed;
      END IF;
    END IF;
  END PROCESS Delay_1_process;


  i_a_signed <= signed(i_a);

  i_b_signed <= signed(i_b);

  -- <Root>/Delay_2
  Delay_2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '0' THEN
        Delay_2_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay_2_out1 <= i_a_signed;
      END IF;
    END IF;
  END PROCESS Delay_2_process;


  -- <Root>/Delay_3
  Delay_3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '0' THEN
        Delay_3_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay_3_out1 <= i_b_signed;
      END IF;
    END IF;
  END PROCESS Delay_3_process;


  Electrical_Position_signed <= signed(Electrical_Position);

  -- <Root>/Delay_4
  Delay_4_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '0' THEN
        Delay_4_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay_4_out1 <= Electrical_Position_signed;
      END IF;
    END IF;
  END PROCESS Delay_4_process;


  -- <Root>/paramCurrentControlI
  paramCurrentControlI_out1 <= to_signed(16#07D0#, 16);

  -- <Root>/paramCurrentControlP
  paramCurrentControlP_out1 <= to_signed(16#0008#, 16);

  -- <Root>/sampleTime1
  sampleTime1_out1 <= to_signed(16#068E#, 16);

  v_a_signed <= signed(v_a_1);

  -- <Root>/Delay_5
  Delay_5_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '0' THEN
        Delay_5_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay_5_out1 <= v_a_signed;
      END IF;
    END IF;
  END PROCESS Delay_5_process;


  -- <Root>/Constant
  Constant_out1 <= signed'("00000000000011001000000000000000000000000000000000000000000000000000000000000000000");

  -- <Root>/Add
  Add_add_cast <= resize(Delay_5_out1 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 84);
  Add_add_cast_1 <= resize(Constant_out1, 84);
  Add_out1 <= Add_add_cast + Add_add_cast_1;

  Va <= std_logic_vector(Add_out1);

  v_b_signed <= signed(v_b_1);

  -- <Root>/Delay_6
  Delay_6_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '0' THEN
        Delay_6_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay_6_out1 <= v_b_signed;
      END IF;
    END IF;
  END PROCESS Delay_6_process;


  -- <Root>/Add1
  Add1_add_cast <= resize(Delay_6_out1 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 84);
  Add1_add_cast_1 <= resize(Constant_out1, 84);
  Add1_out1 <= Add1_add_cast + Add1_add_cast_1;

  Vb <= std_logic_vector(Add1_out1);

  v_c_signed <= signed(v_c_1);

  -- <Root>/Delay_7
  Delay_7_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '0' THEN
        Delay_7_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay_7_out1 <= v_c_signed;
      END IF;
    END IF;
  END PROCESS Delay_7_process;


  -- <Root>/Add2
  Add2_add_cast <= resize(Delay_7_out1 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 84);
  Add2_add_cast_1 <= resize(Constant_out1, 84);
  Add2_out1 <= Add2_add_cast + Add2_add_cast_1;

  Vc <= std_logic_vector(Add2_out1);

  ce_out <= clk_enable;

END rtl;

