-- -------------------------------------------------------------
-- 
-- File Name: C:\Users\paul.rogers\OldStuff\GradSchool\MATLAB\Both_Test\vf_hdl_prj\hdlsrc\VF_2\VF_2_pkg.vhd
-- Created: 2017-10-05 15:19:44
-- 
-- Generated by MATLAB 9.1 and HDL Coder 3.9
-- 
-- -------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

PACKAGE VF_2_pkg IS
  TYPE vector_of_signed51 IS ARRAY (NATURAL RANGE <>) OF signed(50 DOWNTO 0);
  TYPE vector_of_unsigned12 IS ARRAY (NATURAL RANGE <>) OF unsigned(11 DOWNTO 0);
  TYPE vector_of_signed32 IS ARRAY (NATURAL RANGE <>) OF signed(31 DOWNTO 0);
END VF_2_pkg;

