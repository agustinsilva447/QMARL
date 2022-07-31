LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY complex_mult_fixpt IS
  PORT( a_re                              :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En13
        a_im                              :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En13
        b_re                              :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En13
        b_im                              :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En13
        result_re                         :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En13
        result_im                         :   OUT   std_logic_vector(15 DOWNTO 0)  -- sfix16_En13
        );
END complex_mult_fixpt;


ARCHITECTURE rtl OF complex_mult_fixpt IS

  -- Signals
  SIGNAL a_re_signed                      : signed(15 DOWNTO 0);  -- sfix16_En13
  SIGNAL a_im_signed                      : signed(15 DOWNTO 0);  -- sfix16_En13
  SIGNAL b_re_signed                      : signed(15 DOWNTO 0);  -- sfix16_En13
  SIGNAL b_im_signed                      : signed(15 DOWNTO 0);  -- sfix16_En13
  SIGNAL result_re_tmp                    : signed(15 DOWNTO 0);  -- sfix16_En13
  SIGNAL result_im_tmp                    : signed(15 DOWNTO 0);  -- sfix16_En13
  SIGNAL complex_mult_fixpt_mul_temp      : signed(31 DOWNTO 0);  -- sfix32_En26
  SIGNAL complex_mult_fixpt_sub_cast      : signed(32 DOWNTO 0);  -- sfix33_En26
  SIGNAL complex_mult_fixpt_mul_temp_1    : signed(31 DOWNTO 0);  -- sfix32_En26
  SIGNAL complex_mult_fixpt_sub_cast_1    : signed(32 DOWNTO 0);  -- sfix33_En26
  SIGNAL complex_mult_fixpt_sub_temp      : signed(32 DOWNTO 0);  -- sfix33_En26
  SIGNAL complex_mult_fixpt_mul_temp_2    : signed(31 DOWNTO 0);  -- sfix32_En26
  SIGNAL complex_mult_fixpt_add_cast      : signed(32 DOWNTO 0);  -- sfix33_En26
  SIGNAL complex_mult_fixpt_mul_temp_3    : signed(31 DOWNTO 0);  -- sfix32_En26
  SIGNAL complex_mult_fixpt_add_cast_1    : signed(32 DOWNTO 0);  -- sfix33_En26
  SIGNAL complex_mult_fixpt_add_temp      : signed(32 DOWNTO 0);  -- sfix33_En26

BEGIN
  a_re_signed <= signed(a_re);
  a_im_signed <= signed(a_im);
  b_re_signed <= signed(b_re);
  b_im_signed <= signed(b_im);

  complex_mult_fixpt_mul_temp   <= a_re_signed * b_re_signed;
  complex_mult_fixpt_sub_cast   <= resize(complex_mult_fixpt_mul_temp, 33);
  complex_mult_fixpt_mul_temp_1 <= a_im_signed * b_im_signed;
  complex_mult_fixpt_sub_cast_1 <= resize(complex_mult_fixpt_mul_temp_1, 33);
  complex_mult_fixpt_sub_temp   <= complex_mult_fixpt_sub_cast - complex_mult_fixpt_sub_cast_1;
  result_re_tmp                 <= complex_mult_fixpt_sub_temp(28 DOWNTO 13);
  
  complex_mult_fixpt_mul_temp_2 <= a_re_signed * b_im_signed;
  complex_mult_fixpt_add_cast   <= resize(complex_mult_fixpt_mul_temp_2, 33);
  complex_mult_fixpt_mul_temp_3 <= a_im_signed * b_re_signed;
  complex_mult_fixpt_add_cast_1 <= resize(complex_mult_fixpt_mul_temp_3, 33);
  complex_mult_fixpt_add_temp   <= complex_mult_fixpt_add_cast + complex_mult_fixpt_add_cast_1;
  result_im_tmp                 <= complex_mult_fixpt_add_temp(28 DOWNTO 13);
  
  result_re <= std_logic_vector(result_re_tmp);
  result_im <= std_logic_vector(result_im_tmp);

END rtl;

