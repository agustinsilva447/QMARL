LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

PACKAGE QGT_fixpt_pkg IS
  TYPE vector_of_signed16 IS ARRAY (NATURAL RANGE <>) OF signed(15 DOWNTO 0);
  TYPE vector_of_signed35 IS ARRAY (NATURAL RANGE <>) OF signed(34 DOWNTO 0);
  TYPE vector_of_signed53 IS ARRAY (NATURAL RANGE <>) OF signed(52 DOWNTO 0);
  TYPE vector_of_signed72 IS ARRAY (NATURAL RANGE <>) OF signed(71 DOWNTO 0);
  TYPE vector_of_signed91 IS ARRAY (NATURAL RANGE <>) OF signed(90 DOWNTO 0);
  TYPE vector_of_signed64 IS ARRAY (NATURAL RANGE <>) OF signed(63 DOWNTO 0);
  TYPE vector_of_signed54 IS ARRAY (NATURAL RANGE <>) OF signed(53 DOWNTO 0);
  TYPE vector_of_signed51 IS ARRAY (NATURAL RANGE <>) OF signed(50 DOWNTO 0);
  TYPE vector_of_signed32 IS ARRAY (NATURAL RANGE <>) OF signed(31 DOWNTO 0);
  TYPE vector_of_signed88 IS ARRAY (NATURAL RANGE <>) OF signed(87 DOWNTO 0);
  TYPE vector_of_signed69 IS ARRAY (NATURAL RANGE <>) OF signed(68 DOWNTO 0);
  TYPE vector_of_unsigned16 IS ARRAY (NATURAL RANGE <>) OF unsigned(15 DOWNTO 0);
END QGT_fixpt_pkg;