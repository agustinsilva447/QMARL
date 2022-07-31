LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.QGT_state_fixpt_pkg.ALL;

ENTITY QGT_state_fixpt IS
  PORT( rotAx1                            :   IN    std_logic_vector(2 DOWNTO 0);  -- ufix3
        rotAy2                            :   IN    std_logic_vector(2 DOWNTO 0);  -- ufix3
        rotAx3                            :   IN    std_logic_vector(2 DOWNTO 0);  -- ufix3
        rotBx1                            :   IN    std_logic_vector(2 DOWNTO 0);  -- ufix3
        rotBy2                            :   IN    std_logic_vector(2 DOWNTO 0);  -- ufix3
        rotBx3                            :   IN    std_logic_vector(2 DOWNTO 0);  -- ufix3
        p00                               :   OUT   std_logic_vector(15 DOWNTO 0);  -- ufix16_En15
        p01                               :   OUT   std_logic_vector(15 DOWNTO 0);  -- ufix16_En15
        p10                               :   OUT   std_logic_vector(15 DOWNTO 0);  -- ufix16_En15
        p11                               :   OUT   std_logic_vector(15 DOWNTO 0)  -- ufix16_En15
        );
END QGT_state_fixpt;


ARCHITECTURE rtl OF QGT_state_fixpt IS

  -- Constants
  CONSTANT nc                             : vector_of_signed16(0 TO 7) := 
    (to_signed(16#4000#, 16), to_signed(16#3B20#, 16), to_signed(16#2D41#, 16), to_signed(16#187D#, 16),
     to_signed(16#0000#, 16), to_signed(-16#187E#, 16), to_signed(-16#2D42#, 16), to_signed(-16#3B21#, 16));  -- sfix16 [8]
  CONSTANT nc_0                           : vector_of_signed16(0 TO 7) := 
    (to_signed(16#0000#, 16), to_signed(16#187D#, 16), to_signed(16#2D41#, 16), to_signed(16#3B20#, 16),
     to_signed(16#4000#, 16), to_signed(16#3B20#, 16), to_signed(16#2D41#, 16), to_signed(16#187D#, 16));  -- sfix16 [8]

  -- Signals
  SIGNAL rotAx1_unsigned                  : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL rotAy2_unsigned                  : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL rotAx3_unsigned                  : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL rotBx1_unsigned                  : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL rotBy2_unsigned                  : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL rotBx3_unsigned                  : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL p00_tmp                          : unsigned(15 DOWNTO 0);  -- ufix16_En15
  SIGNAL p01_tmp                          : unsigned(15 DOWNTO 0);  -- ufix16_En15
  SIGNAL p10_tmp                          : unsigned(15 DOWNTO 0);  -- ufix16_En15
  SIGNAL p11_tmp                          : unsigned(15 DOWNTO 0);  -- ufix16_En15
  SIGNAL QGT_state_fixpt_auxAx1           : unsigned(3 DOWNTO 0);  -- ufix4
  SIGNAL QGT_state_fixpt_auxAy2           : unsigned(3 DOWNTO 0);  -- ufix4
  SIGNAL QGT_state_fixpt_auxAx3           : unsigned(3 DOWNTO 0);  -- ufix4
  SIGNAL QGT_state_fixpt_auxBx1           : unsigned(3 DOWNTO 0);  -- ufix4
  SIGNAL QGT_state_fixpt_auxBy2           : unsigned(3 DOWNTO 0);  -- ufix4
  SIGNAL QGT_state_fixpt_auxBx3           : unsigned(3 DOWNTO 0);  -- ufix4
  SIGNAL QGT_state_fixpt_c_re             : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_c_im             : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_c_re_1           : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_c_im_1           : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_c_re_2           : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_c_im_2           : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_c_re_3           : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_c_im_3           : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_sub_cast         : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp         : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_mul_temp_1       : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1       : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_2       : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_2       : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_3       : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast         : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_1       : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_3       : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_4       : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_mul_temp_5       : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_4       : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_6       : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_5       : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_7       : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_2       : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_3       : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_temp         : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_4       : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_6       : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_8       : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast             : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_mul_temp_9       : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_7       : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_10      : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_8       : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_11      : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_5       : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_6       : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_1       : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_7       : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_mul_temp_12      : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_1           : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_9       : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_13      : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_2           : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_3           : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_10      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_14      : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_11      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_15      : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_8       : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_2       : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_4           : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_16      : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_5           : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_12      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_17      : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_13      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_18      : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_14      : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_15      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_19      : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_6           : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_mul_temp_20      : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_7           : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_8           : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_16      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_21      : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_17      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_22      : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_9       : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_mul_temp_23      : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_9           : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_18      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_24      : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_10          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_11          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_19      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_25      : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_20      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_26      : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_10      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_temp_3       : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_21      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_22      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_27      : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_12          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_mul_temp_28      : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_23      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_29      : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_24      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_30      : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_sub_cast_25      : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_sub_cast_26      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_temp         : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_27      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_28      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_31      : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_mul_temp_32      : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_29      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_33      : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_30      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_34      : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_31      : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_32      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_temp_1       : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_13          : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_35      : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_14          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_cast_15          : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_16          : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_sub_cast_33      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_36      : signed(48 DOWNTO 0);  -- sfix49_En44
  SIGNAL QGT_state_fixpt_sub_cast_34      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_37      : signed(64 DOWNTO 0);  -- sfix65_En58
  SIGNAL QGT_state_fixpt_sub_cast_35      : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_temp_2       : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_36      : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_37      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_38      : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_17          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_mul_temp_39      : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_18          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_19          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_38      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_40      : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_39      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_41      : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_40      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_mul_temp_42      : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_20          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_41      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_43      : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_21          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_22          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_42      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_44      : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_43      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_45      : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_44      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_temp_3       : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_45      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_46      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_46      : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_23          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_mul_temp_47      : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_47      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_48      : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_48      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_49      : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_sub_cast_49      : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_sub_cast_50      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_temp_4       : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_11      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_51      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_50      : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_mul_temp_51      : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_52      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_52      : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_53      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_53      : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_12      : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_13      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_4       : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_24          : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_54      : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_25          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_cast_26          : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_27          : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_sub_cast_54      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_55      : signed(48 DOWNTO 0);  -- sfix49_En44
  SIGNAL QGT_state_fixpt_sub_cast_55      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_56      : signed(64 DOWNTO 0);  -- sfix65_En58
  SIGNAL QGT_state_fixpt_sub_cast_56      : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_temp_5       : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_57      : signed(67 DOWNTO 0);  -- sfix68_En58
  SIGNAL QGT_state_fixpt_sub_cast_58      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_57      : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_mul_temp_58      : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_59      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_59      : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_60      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_60      : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_61      : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_62      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_63      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_61      : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_mul_temp_62      : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_64      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_63      : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_65      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_64      : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_66      : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_67      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_temp_6       : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_14      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_68      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_65      : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_28          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_mul_temp_66      : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_69      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_67      : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_70      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_68      : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_15      : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_16      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_5       : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_71      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_mul_temp_69      : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_29          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_72      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_70      : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_30          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_31          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_73      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_71      : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_74      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_72      : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_75      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_temp_7       : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_32          : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_73      : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_33          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_76      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_74      : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_77      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_75      : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_78      : signed(67 DOWNTO 0);  -- sfix68_En58
  SIGNAL QGT_state_fixpt_sub_temp_8       : signed(67 DOWNTO 0);  -- sfix68_En58
  SIGNAL QGT_state_fixpt_add_cast_17      : signed(70 DOWNTO 0);  -- sfix71_En58
  SIGNAL QGT_state_fixpt_sub_cast_79      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_76      : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_34          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_mul_temp_77      : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_35          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_36          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_80      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_78      : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_81      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_79      : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_18      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_mul_temp_80      : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_37          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_82      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_81      : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_38          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_39          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_83      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_82      : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_84      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_83      : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_19      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_temp_6       : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_20      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_85      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_84      : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_40          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_mul_temp_85      : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_86      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_86      : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_87      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_87      : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_21      : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_22      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_7       : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_23      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_88      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_88      : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_mul_temp_89      : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_89      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_90      : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_90      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_91      : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_24      : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_25      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_8       : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_41          : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_cast_42          : signed(16 DOWNTO 0);  -- sfix17_En14
  SIGNAL QGT_state_fixpt_cast_43          : signed(17 DOWNTO 0);  -- sfix18_En14
  SIGNAL QGT_state_fixpt_cast_44          : signed(17 DOWNTO 0);  -- sfix18_En14
  SIGNAL QGT_state_fixpt_cast_45          : signed(16 DOWNTO 0);  -- sfix17_En14
  SIGNAL QGT_state_fixpt_sub_cast_91      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_92      : signed(32 DOWNTO 0);  -- sfix33_En28
  SIGNAL QGT_state_fixpt_sub_cast_92      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_93      : signed(48 DOWNTO 0);  -- sfix49_En42
  SIGNAL QGT_state_fixpt_sub_cast_93      : signed(50 DOWNTO 0);  -- sfix51_En42
  SIGNAL QGT_state_fixpt_sub_cast_94      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_94      : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_mul_temp_95      : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_95      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_96      : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_96      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_97      : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_26      : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_27      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_97      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_98      : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_mul_temp_99      : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_98      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_100     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_99      : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_101     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_28      : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_29      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_temp_9       : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_100     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_101     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_102     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_46          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_mul_temp_103     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_102     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_104     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_103     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_105     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_sub_cast_104     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_sub_cast_105     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_temp_9       : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_106     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_mul_temp_106     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_47          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_107     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_107     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_48          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_49          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_108     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_108     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_109     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_109     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_110     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_temp_10      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_50          : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_sub_cast_111     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_110     : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_sub_cast_112     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_111     : signed(47 DOWNTO 0);  -- sfix48_En42
  SIGNAL QGT_state_fixpt_sub_cast_113     : signed(49 DOWNTO 0);  -- sfix50_En42
  SIGNAL QGT_state_fixpt_sub_cast_114     : signed(50 DOWNTO 0);  -- sfix51_En42
  SIGNAL QGT_state_fixpt_sub_temp_11      : signed(50 DOWNTO 0);  -- sfix51_En42
  SIGNAL QGT_state_fixpt_sub_cast_115     : signed(51 DOWNTO 0);  -- sfix52_En42
  SIGNAL QGT_state_fixpt_sub_cast_116     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_112     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_mul_temp_113     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_117     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_114     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_118     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_115     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_119     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_120     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_121     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_116     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_mul_temp_117     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_122     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_118     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_123     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_119     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_124     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_125     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_temp_12      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_126     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_127     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_120     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_51          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_mul_temp_121     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_128     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_122     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_129     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_123     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_sub_cast_130     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_sub_cast_131     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_temp_13      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_30      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_mul_temp_124     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_52          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_132     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_125     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_53          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_54          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_133     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_126     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_134     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_127     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_31      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_10      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_55          : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_sub_cast_135     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_128     : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_sub_cast_136     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_129     : signed(47 DOWNTO 0);  -- sfix48_En42
  SIGNAL QGT_state_fixpt_sub_cast_137     : signed(49 DOWNTO 0);  -- sfix50_En42
  SIGNAL QGT_state_fixpt_sub_cast_138     : signed(51 DOWNTO 0);  -- sfix52_En42
  SIGNAL QGT_state_fixpt_sub_temp_14      : signed(51 DOWNTO 0);  -- sfix52_En42
  SIGNAL QGT_state_fixpt_add_cast_32      : signed(52 DOWNTO 0);  -- sfix53_En42
  SIGNAL QGT_state_fixpt_sub_cast_139     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_130     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_56          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_mul_temp_131     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_57          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_58          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_140     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_132     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_141     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_133     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_142     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_mul_temp_134     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_59          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_143     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_135     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_60          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_61          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_144     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_136     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_145     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_137     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_146     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_temp_15      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_33      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_147     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_138     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_62          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_mul_temp_139     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_148     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_140     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_149     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_141     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_34      : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_35      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_11      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_150     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_151     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_142     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_mul_temp_143     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_152     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_144     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_153     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_145     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_154     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_155     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_temp_16      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_63          : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_sub_cast_156     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_146     : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_sub_cast_157     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_147     : signed(47 DOWNTO 0);  -- sfix48_En42
  SIGNAL QGT_state_fixpt_add_cast_36      : signed(52 DOWNTO 0);  -- sfix53_En42
  SIGNAL QGT_state_fixpt_add_temp_12      : signed(52 DOWNTO 0);  -- sfix53_En42
  SIGNAL QGT_state_fixpt_mul_temp_148     : signed(69 DOWNTO 0);  -- sfix70_En58
  SIGNAL QGT_state_fixpt_cast_64          : signed(68 DOWNTO 0);  -- sfix69_En58
  SIGNAL QGT_state_fixpt_cast_65          : signed(69 DOWNTO 0);  -- sfix70_En58
  SIGNAL QGT_state_fixpt_cast_66          : signed(69 DOWNTO 0);  -- sfix70_En58
  SIGNAL QGT_state_fixpt_add_cast_37      : signed(70 DOWNTO 0);  -- sfix71_En58
  SIGNAL QGT_state_fixpt_add_temp_13      : signed(70 DOWNTO 0);  -- sfix71_En58
  SIGNAL QGT_state_fixpt_sub_cast_158     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_149     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_67          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_159     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_150     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_68          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_69          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_160     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_151     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_161     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_152     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_38      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_162     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_153     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_70          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_163     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_154     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_71          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_72          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_164     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_155     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_165     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_156     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_39      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_temp_14      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_40      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_166     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_157     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_73          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_167     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_158     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_168     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_159     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_169     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_160     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_41      : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_42      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_15      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_43      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_170     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_161     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_171     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_162     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_172     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_163     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_173     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_164     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_44      : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_45      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_16      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_74          : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_165     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_75          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_174     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_166     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_175     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_167     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_176     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_177     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_168     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_178     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_169     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_179     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_170     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_180     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_171     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_46      : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_47      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_181     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_172     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_182     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_173     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_183     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_174     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_184     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_175     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_48      : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_49      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_temp_17      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_185     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_186     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_176     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_76          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_187     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_177     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_188     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_178     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_189     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_179     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_sub_cast_190     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_sub_cast_191     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_temp_17      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_192     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_193     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_180     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_77          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_194     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_181     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_78          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_79          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_195     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_182     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_196     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_183     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_197     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_temp_18      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_80          : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_184     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_81          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_198     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_185     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_199     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_186     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_200     : signed(64 DOWNTO 0);  -- sfix65_En58
  SIGNAL QGT_state_fixpt_sub_cast_201     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_temp_19      : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_202     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_203     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_187     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_204     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_188     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_205     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_189     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_206     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_190     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_207     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_208     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_209     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_191     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_210     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_192     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_211     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_193     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_212     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_194     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_213     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_214     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_temp_20      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_215     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_216     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_195     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_82          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_217     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_196     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_218     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_197     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_219     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_198     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_sub_cast_220     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_sub_cast_221     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_temp_21      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_50      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_222     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_199     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_83          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_223     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_200     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_84          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_85          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_224     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_201     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_225     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_202     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_51      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_18      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_86          : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_203     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_87          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_226     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_204     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_227     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_205     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_228     : signed(64 DOWNTO 0);  -- sfix65_En58
  SIGNAL QGT_state_fixpt_sub_cast_229     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_temp_22      : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_230     : signed(67 DOWNTO 0);  -- sfix68_En58
  SIGNAL QGT_state_fixpt_sub_cast_231     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_206     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_88          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_232     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_207     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_89          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_90          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_233     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_208     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_234     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_209     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_235     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_236     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_210     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_91          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_237     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_211     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_92          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_93          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_238     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_212     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_239     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_213     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_240     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_temp_23      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_52      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_241     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_214     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_94          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_242     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_215     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_243     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_216     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_244     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_217     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_53      : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_54      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_19      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_245     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_246     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_218     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_247     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_219     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_248     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_220     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_249     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_221     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_250     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_251     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_temp_24      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_95          : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_222     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_96          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_252     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_223     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_253     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_224     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_254     : signed(67 DOWNTO 0);  -- sfix68_En58
  SIGNAL QGT_state_fixpt_sub_temp_25      : signed(67 DOWNTO 0);  -- sfix68_En58
  SIGNAL QGT_state_fixpt_add_cast_55      : signed(70 DOWNTO 0);  -- sfix71_En58
  SIGNAL QGT_state_fixpt_sub_cast_255     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_225     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_256     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_226     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_257     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_227     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_258     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_228     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_56      : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_57      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_259     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_229     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_260     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_230     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_261     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_231     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_262     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_232     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_58      : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_59      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_temp_20      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_60      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_263     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_233     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_97          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_264     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_234     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_265     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_235     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_266     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_236     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_61      : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_62      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_21      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_63      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_267     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_237     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_98          : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_268     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_238     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_99          : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_100         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_269     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_239     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_270     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_240     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_64      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_22      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_101         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_cast_102         : signed(16 DOWNTO 0);  -- sfix17_En14
  SIGNAL QGT_state_fixpt_cast_103         : signed(17 DOWNTO 0);  -- sfix18_En14
  SIGNAL QGT_state_fixpt_cast_104         : signed(17 DOWNTO 0);  -- sfix18_En14
  SIGNAL QGT_state_fixpt_cast_105         : signed(16 DOWNTO 0);  -- sfix17_En14
  SIGNAL QGT_state_fixpt_sub_cast_271     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_241     : signed(32 DOWNTO 0);  -- sfix33_En28
  SIGNAL QGT_state_fixpt_sub_cast_272     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_242     : signed(48 DOWNTO 0);  -- sfix49_En42
  SIGNAL QGT_state_fixpt_sub_cast_273     : signed(50 DOWNTO 0);  -- sfix51_En42
  SIGNAL QGT_state_fixpt_sub_cast_274     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_243     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_106         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_275     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_244     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_107         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_108         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_276     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_245     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_277     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_246     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_65      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_278     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_247     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_109         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_279     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_248     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_110         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_111         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_280     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_249     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_281     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_250     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_66      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_temp_23      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_282     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_283     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_251     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_112         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_284     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_252     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_285     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_253     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_286     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_254     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_sub_cast_287     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_sub_cast_288     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_temp_26      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_289     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_290     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_255     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_291     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_256     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_292     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_257     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_293     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_258     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_294     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_295     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_temp_27      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_113         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_cast_114         : signed(17 DOWNTO 0);  -- sfix18_En14
  SIGNAL QGT_state_fixpt_cast_115         : signed(17 DOWNTO 0);  -- sfix18_En14
  SIGNAL QGT_state_fixpt_sub_cast_296     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_259     : signed(33 DOWNTO 0);  -- sfix34_En28
  SIGNAL QGT_state_fixpt_sub_cast_297     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_260     : signed(49 DOWNTO 0);  -- sfix50_En42
  SIGNAL QGT_state_fixpt_sub_cast_298     : signed(50 DOWNTO 0);  -- sfix51_En42
  SIGNAL QGT_state_fixpt_sub_temp_28      : signed(50 DOWNTO 0);  -- sfix51_En42
  SIGNAL QGT_state_fixpt_sub_cast_299     : signed(51 DOWNTO 0);  -- sfix52_En42
  SIGNAL QGT_state_fixpt_sub_cast_300     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_261     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_116         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_301     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_262     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_117         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_118         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_302     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_263     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_303     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_264     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_304     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_305     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_265     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_119         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_306     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_266     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_120         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_121         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_307     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_267     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_308     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_268     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_309     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_temp_29      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_310     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_311     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_269     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_122         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_312     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_270     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_313     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_271     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_314     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_272     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_sub_cast_315     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_sub_cast_316     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_temp_30      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_67      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_317     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_273     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_318     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_274     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_319     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_275     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_320     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_276     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_68      : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_69      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_24      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_123         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_cast_124         : signed(17 DOWNTO 0);  -- sfix18_En14
  SIGNAL QGT_state_fixpt_cast_125         : signed(17 DOWNTO 0);  -- sfix18_En14
  SIGNAL QGT_state_fixpt_sub_cast_321     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_277     : signed(33 DOWNTO 0);  -- sfix34_En28
  SIGNAL QGT_state_fixpt_sub_cast_322     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_278     : signed(49 DOWNTO 0);  -- sfix50_En42
  SIGNAL QGT_state_fixpt_sub_cast_323     : signed(51 DOWNTO 0);  -- sfix52_En42
  SIGNAL QGT_state_fixpt_sub_temp_31      : signed(51 DOWNTO 0);  -- sfix52_En42
  SIGNAL QGT_state_fixpt_add_cast_70      : signed(52 DOWNTO 0);  -- sfix53_En42
  SIGNAL QGT_state_fixpt_sub_cast_324     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_279     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_325     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_280     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_326     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_281     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_327     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_282     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_328     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_329     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_330     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_283     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_331     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_284     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_332     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_285     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_333     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_286     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_334     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_335     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_temp_32      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_71      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_336     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_287     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_126         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_337     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_288     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_338     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_289     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_339     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_290     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_72      : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_73      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_25      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_340     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_341     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_291     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_127         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_342     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_292     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_128         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_129         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_343     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_293     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_344     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_294     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_345     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_temp_33      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_130         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_sub_cast_346     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_295     : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_sub_cast_347     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_296     : signed(47 DOWNTO 0);  -- sfix48_En42
  SIGNAL QGT_state_fixpt_add_cast_74      : signed(52 DOWNTO 0);  -- sfix53_En42
  SIGNAL QGT_state_fixpt_add_temp_26      : signed(52 DOWNTO 0);  -- sfix53_En42
  SIGNAL QGT_state_fixpt_mul_temp_297     : signed(69 DOWNTO 0);  -- sfix70_En58
  SIGNAL QGT_state_fixpt_add_cast_75      : signed(68 DOWNTO 0);  -- sfix69_En58
  SIGNAL QGT_state_fixpt_add_cast_76      : signed(70 DOWNTO 0);  -- sfix71_En58
  SIGNAL QGT_state_fixpt_add_temp_27      : signed(70 DOWNTO 0);  -- sfix71_En58
  SIGNAL QGT_state_fixpt_sub_cast_348     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_298     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_131         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_349     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_299     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_132         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_133         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_134         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_cast_135         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_136         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_137         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_sub_cast_350     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_300     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_351     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_301     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_352     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_353     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_302     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_138         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_354     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_303     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_139         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_140         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_355     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_304     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_356     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_305     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_357     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_temp_34      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_77      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_358     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_306     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_141         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_359     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_307     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_360     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_308     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_361     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_309     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_78      : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_79      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_28      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_cast_80      : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_cast_362     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_310     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_363     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_311     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_364     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_312     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_365     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_313     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_81      : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_82      : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_add_temp_29      : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_cast_142         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_314     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_cast_143         : signed(32 DOWNTO 0);  -- sfix33_En29
  SIGNAL QGT_state_fixpt_cast_144         : signed(32 DOWNTO 0);  -- sfix33_En29
  SIGNAL QGT_state_fixpt_sub_cast_366     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_315     : signed(48 DOWNTO 0);  -- sfix49_En43
  SIGNAL QGT_state_fixpt_sub_cast_367     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_316     : signed(64 DOWNTO 0);  -- sfix65_En57
  SIGNAL QGT_state_fixpt_add_cast_83      : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_368     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_317     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_369     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_318     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_370     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_319     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_371     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_320     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_84      : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_85      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_372     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_321     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_373     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_322     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_374     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_323     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_375     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_324     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_86      : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_87      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_temp_30      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_88      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_376     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_325     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_145         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_377     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_326     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_378     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_327     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_379     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_328     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_89      : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_90      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_31      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_91      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_380     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_329     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_146         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_381     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_330     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_147         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_148         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_382     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_331     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_383     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_332     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_92      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_32      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_149         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_333     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_150         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_384     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_334     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_385     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_335     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_add_cast_93      : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_add_temp_33      : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_386     : signed(67 DOWNTO 0);  -- sfix68_En58
  SIGNAL QGT_state_fixpt_sub_cast_387     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_336     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_388     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_337     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_cast_151         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_cast_152         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_153         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_154         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_sub_cast_389     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_338     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_390     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_339     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_94      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_391     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_340     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_392     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_341     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_393     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_342     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_394     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_343     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_95      : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_96      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_34      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_395     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_396     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_344     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_155         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_397     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_345     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_398     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_346     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_399     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_347     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_sub_cast_400     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_sub_cast_401     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_temp_35      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_cast_97      : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_cast_402     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_348     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_156         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_403     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_349     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_157         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_158         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_404     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_350     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_405     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_351     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_98      : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_add_temp_35      : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_cast_159         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_352     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_160         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_406     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_353     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_407     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_354     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_408     : signed(67 DOWNTO 0);  -- sfix68_En58
  SIGNAL QGT_state_fixpt_sub_temp_36      : signed(67 DOWNTO 0);  -- sfix68_En58
  SIGNAL QGT_state_fixpt_sub_cast_409     : signed(68 DOWNTO 0);  -- sfix69_En58
  SIGNAL QGT_state_fixpt_sub_cast_410     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_355     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_161         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_411     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_356     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_162         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_163         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_412     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_357     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_413     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_358     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_414     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_415     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_359     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_164         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_416     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_360     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_165         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_166         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_417     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_361     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_418     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_362     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_419     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_temp_37      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_420     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_421     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_363     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_167         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_422     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_364     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_423     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_365     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_424     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_366     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_sub_cast_425     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_sub_cast_426     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_temp_38      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_99      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_427     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_367     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_428     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_368     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_429     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_369     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_430     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_370     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_100     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_101     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_36      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_168         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_371     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_169         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_cast_170         : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_171         : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_sub_cast_431     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_372     : signed(48 DOWNTO 0);  -- sfix49_En44
  SIGNAL QGT_state_fixpt_sub_cast_432     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_373     : signed(64 DOWNTO 0);  -- sfix65_En58
  SIGNAL QGT_state_fixpt_sub_cast_433     : signed(68 DOWNTO 0);  -- sfix69_En58
  SIGNAL QGT_state_fixpt_sub_temp_39      : signed(68 DOWNTO 0);  -- sfix69_En58
  SIGNAL QGT_state_fixpt_add_cast_102     : signed(71 DOWNTO 0);  -- sfix72_En58
  SIGNAL QGT_state_fixpt_sub_cast_434     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_374     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_435     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_375     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_cast_172         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_cast_173         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_174         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_175         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_sub_cast_436     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_376     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_437     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_377     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_438     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_439     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_378     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_440     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_379     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_441     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_380     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_442     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_381     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_443     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_444     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_temp_40      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_103     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_445     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_382     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_176         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_446     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_383     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_447     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_384     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_448     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_385     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_104     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_105     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_37      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_cast_106     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_cast_449     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_386     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_177         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_450     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_387     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_178         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_179         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_451     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_388     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_452     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_389     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_107     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_add_temp_38      : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_cast_180         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_cast_181         : signed(16 DOWNTO 0);  -- sfix17_En14
  SIGNAL QGT_state_fixpt_cast_182         : signed(16 DOWNTO 0);  -- sfix17_En14
  SIGNAL QGT_state_fixpt_cast_183         : signed(17 DOWNTO 0);  -- sfix18_En14
  SIGNAL QGT_state_fixpt_sub_cast_453     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_390     : signed(33 DOWNTO 0);  -- sfix34_En28
  SIGNAL QGT_state_fixpt_sub_cast_454     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_391     : signed(49 DOWNTO 0);  -- sfix50_En42
  SIGNAL QGT_state_fixpt_sub_cast_455     : signed(50 DOWNTO 0);  -- sfix51_En42
  SIGNAL QGT_state_fixpt_sub_cast_456     : signed(51 DOWNTO 0);  -- sfix52_En42
  SIGNAL QGT_state_fixpt_sub_cast_457     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_392     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_184         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_458     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_393     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_185         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_186         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_459     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_394     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_460     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_395     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_108     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_461     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_396     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_187         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_462     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_397     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_188         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_189         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_463     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_398     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_464     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_399     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_109     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_temp_39      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_110     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_465     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_400     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_190         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_466     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_401     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_467     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_402     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_468     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_403     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_111     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_112     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_40      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_113     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_469     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_404     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_470     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_405     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_471     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_406     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_472     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_407     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_114     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_115     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_41      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_191         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_sub_cast_473     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_408     : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_sub_cast_474     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_409     : signed(47 DOWNTO 0);  -- sfix48_En42
  SIGNAL QGT_state_fixpt_sub_cast_475     : signed(51 DOWNTO 0);  -- sfix52_En42
  SIGNAL QGT_state_fixpt_sub_temp_41      : signed(51 DOWNTO 0);  -- sfix52_En42
  SIGNAL QGT_state_fixpt_add_cast_116     : signed(52 DOWNTO 0);  -- sfix53_En42
  SIGNAL QGT_state_fixpt_sub_cast_476     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_410     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_192         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_477     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_411     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_193         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_194         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_195         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_cast_196         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_197         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_198         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_sub_cast_478     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_412     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_479     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_413     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_117     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_480     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_414     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_199         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_481     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_415     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_200         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_201         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_482     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_416     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_483     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_417     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_118     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_42      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_484     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_485     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_418     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_202         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_486     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_419     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_487     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_420     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_488     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_421     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_sub_cast_489     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_sub_cast_490     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_temp_42      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_cast_119     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_cast_491     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_422     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_492     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_423     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_493     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_424     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_494     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_425     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_120     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_121     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_add_temp_43      : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_cast_203         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_sub_cast_495     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_426     : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_sub_cast_496     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_427     : signed(47 DOWNTO 0);  -- sfix48_En42
  SIGNAL QGT_state_fixpt_add_cast_122     : signed(52 DOWNTO 0);  -- sfix53_En42
  SIGNAL QGT_state_fixpt_add_temp_44      : signed(52 DOWNTO 0);  -- sfix53_En42
  SIGNAL QGT_state_fixpt_sub_cast_497     : signed(53 DOWNTO 0);  -- sfix54_En42
  SIGNAL QGT_state_fixpt_sub_cast_498     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_428     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_499     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_429     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_500     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_430     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_501     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_431     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_502     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_503     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_504     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_432     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_505     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_433     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_506     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_434     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_507     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_435     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_508     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_509     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_temp_43      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_510     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_511     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_436     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_204         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_512     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_437     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_513     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_438     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_514     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_439     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_sub_cast_515     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_sub_cast_516     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_temp_44      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_123     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_517     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_440     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_205         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_518     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_441     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_206         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_207         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_519     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_442     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_520     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_443     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_124     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_45      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_208         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_sub_cast_521     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_444     : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_sub_cast_522     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_445     : signed(47 DOWNTO 0);  -- sfix48_En42
  SIGNAL QGT_state_fixpt_sub_cast_523     : signed(49 DOWNTO 0);  -- sfix50_En42
  SIGNAL QGT_state_fixpt_sub_cast_524     : signed(53 DOWNTO 0);  -- sfix54_En42
  SIGNAL QGT_state_fixpt_sub_temp_45      : signed(53 DOWNTO 0);  -- sfix54_En42
  SIGNAL QGT_state_fixpt_mul_temp_446     : signed(70 DOWNTO 0);  -- sfix71_En58
  SIGNAL QGT_state_fixpt_cast_209         : signed(69 DOWNTO 0);  -- sfix70_En58
  SIGNAL QGT_state_fixpt_cast_210         : signed(70 DOWNTO 0);  -- sfix71_En58
  SIGNAL QGT_state_fixpt_cast_211         : signed(70 DOWNTO 0);  -- sfix71_En58
  SIGNAL QGT_state_fixpt_add_cast_125     : signed(71 DOWNTO 0);  -- sfix72_En58
  SIGNAL QGT_state_fixpt_add_temp_46      : signed(71 DOWNTO 0);  -- sfix72_En58
  SIGNAL QGT_state_fixpt_sub_cast_525     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_447     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_526     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_448     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_cast_212         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_cast_213         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_214         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_215         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_sub_cast_527     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_449     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_528     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_450     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_529     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_530     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_451     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_531     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_452     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_532     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_453     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_533     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_454     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_534     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_535     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_temp_46      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_126     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_536     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_455     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_216         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_537     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_456     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_538     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_457     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_539     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_458     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_127     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_128     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_47      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_cast_129     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_cast_540     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_459     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_217         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_541     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_460     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_218         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_219         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_542     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_461     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_543     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_462     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_130     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_add_temp_48      : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_cast_220         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_463     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_544     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_464     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_545     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_465     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_add_cast_131     : signed(64 DOWNTO 0);  -- sfix65_En57
  SIGNAL QGT_state_fixpt_add_cast_132     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_546     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_466     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_221         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_547     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_467     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_222         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_223         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_548     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_468     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_549     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_469     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_133     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_550     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_470     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_224         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_551     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_471     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_225         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_226         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_552     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_472     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_553     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_473     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_134     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_temp_49      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_135     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_554     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_474     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_227         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_555     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_475     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_556     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_476     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_557     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_477     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_136     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_137     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_50      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_138     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_558     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_478     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_559     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_479     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_560     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_480     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_561     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_481     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_139     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_140     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_51      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_228         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_482     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_229         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_562     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_483     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_563     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_484     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_add_cast_141     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_add_temp_52      : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_564     : signed(67 DOWNTO 0);  -- sfix68_En58
  SIGNAL QGT_state_fixpt_sub_cast_565     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_485     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_230         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_566     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_486     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_231         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_232         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_233         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_cast_234         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_235         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_236         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_sub_cast_567     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_487     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_568     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_488     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_142     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_569     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_489     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_237         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_570     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_490     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_238         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_239         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_571     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_491     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_572     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_492     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_143     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_53      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_573     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_574     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_493     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_240         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_575     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_494     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_576     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_495     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_577     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_496     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_sub_cast_578     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_sub_cast_579     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_temp_47      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_cast_144     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_cast_580     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_497     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_581     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_498     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_582     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_499     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_583     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_500     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_145     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_146     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_add_temp_54      : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_cast_241         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_501     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_242         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_584     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_502     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_585     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_503     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_586     : signed(67 DOWNTO 0);  -- sfix68_En58
  SIGNAL QGT_state_fixpt_sub_temp_48      : signed(67 DOWNTO 0);  -- sfix68_En58
  SIGNAL QGT_state_fixpt_sub_cast_587     : signed(68 DOWNTO 0);  -- sfix69_En58
  SIGNAL QGT_state_fixpt_sub_cast_588     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_504     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_589     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_505     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_590     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_506     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_591     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_507     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_592     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_593     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_594     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_508     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_595     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_509     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_596     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_510     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_597     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_511     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_598     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_599     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_temp_49      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_600     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_601     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_512     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_243         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_602     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_513     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_603     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_514     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_604     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_515     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_sub_cast_605     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_sub_cast_606     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_temp_50      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_147     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_607     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_516     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_244         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_608     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_517     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_245         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_246         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_609     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_518     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_610     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_519     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_148     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_55      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_247         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_520     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_248         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_611     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_521     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_612     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_522     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_613     : signed(64 DOWNTO 0);  -- sfix65_En58
  SIGNAL QGT_state_fixpt_sub_cast_614     : signed(68 DOWNTO 0);  -- sfix69_En58
  SIGNAL QGT_state_fixpt_sub_temp_51      : signed(68 DOWNTO 0);  -- sfix69_En58
  SIGNAL QGT_state_fixpt_add_cast_149     : signed(71 DOWNTO 0);  -- sfix72_En58
  SIGNAL QGT_state_fixpt_sub_cast_615     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_523     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_249         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_616     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_524     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_250         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_251         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_252         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_cast_253         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_254         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_255         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_sub_cast_617     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_525     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_618     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_526     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_619     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_620     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_527     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_256         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_621     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_528     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_257         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_258         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_622     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_529     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_623     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_530     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_624     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_temp_52      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_150     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_625     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_531     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_259         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_626     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_532     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_627     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_533     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_628     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_534     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_151     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_152     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_56      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_cast_153     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_cast_629     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_535     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_630     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_536     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_631     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_537     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_632     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_538     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_154     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_155     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_add_temp_57      : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_cast_260         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_cast_261         : signed(16 DOWNTO 0);  -- sfix17_En14
  SIGNAL QGT_state_fixpt_cast_262         : signed(16 DOWNTO 0);  -- sfix17_En14
  SIGNAL QGT_state_fixpt_cast_263         : signed(17 DOWNTO 0);  -- sfix18_En14
  SIGNAL QGT_state_fixpt_cast_264         : signed(18 DOWNTO 0);  -- sfix19_En14
  SIGNAL QGT_state_fixpt_cast_265         : signed(18 DOWNTO 0);  -- sfix19_En14
  SIGNAL QGT_state_fixpt_sub_cast_633     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_539     : signed(34 DOWNTO 0);  -- sfix35_En28
  SIGNAL QGT_state_fixpt_sub_cast_634     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_540     : signed(50 DOWNTO 0);  -- sfix51_En42
  SIGNAL QGT_state_fixpt_sub_cast_635     : signed(51 DOWNTO 0);  -- sfix52_En42
  SIGNAL QGT_state_fixpt_sub_cast_636     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_541     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_637     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_542     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_638     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_543     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_639     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_544     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_156     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_157     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_640     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_545     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_641     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_546     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_642     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_547     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_643     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_548     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_158     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_159     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_temp_58      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_160     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_644     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_549     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_266         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_645     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_550     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_646     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_551     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_647     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_552     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_161     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_162     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_59      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_163     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_648     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_553     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_267         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_649     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_554     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_268         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_269         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_650     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_555     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_651     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_556     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_164     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_60      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_270         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_sub_cast_652     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_557     : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_sub_cast_653     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_558     : signed(47 DOWNTO 0);  -- sfix48_En42
  SIGNAL QGT_state_fixpt_sub_cast_654     : signed(51 DOWNTO 0);  -- sfix52_En42
  SIGNAL QGT_state_fixpt_sub_temp_53      : signed(51 DOWNTO 0);  -- sfix52_En42
  SIGNAL QGT_state_fixpt_add_cast_165     : signed(52 DOWNTO 0);  -- sfix53_En42
  SIGNAL QGT_state_fixpt_sub_cast_655     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_559     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_656     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_560     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_cast_271         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_cast_272         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_273         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_274         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_sub_cast_657     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_561     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_658     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_562     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_166     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_659     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_563     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_660     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_564     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_661     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_565     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_662     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_566     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_167     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_168     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_61      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_663     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_664     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_567     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_275         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_665     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_568     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_666     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_569     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_667     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_570     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_sub_cast_668     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_sub_cast_669     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_temp_54      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_cast_169     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_cast_670     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_571     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_276         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_671     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_572     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_277         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_278         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_672     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_573     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_673     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_574     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_170     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_add_temp_62      : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_cast_279         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_sub_cast_674     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_575     : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_sub_cast_675     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_576     : signed(47 DOWNTO 0);  -- sfix48_En42
  SIGNAL QGT_state_fixpt_add_cast_171     : signed(52 DOWNTO 0);  -- sfix53_En42
  SIGNAL QGT_state_fixpt_add_temp_63      : signed(52 DOWNTO 0);  -- sfix53_En42
  SIGNAL QGT_state_fixpt_sub_cast_676     : signed(53 DOWNTO 0);  -- sfix54_En42
  SIGNAL QGT_state_fixpt_sub_cast_677     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_577     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_280         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_678     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_578     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_281         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_282         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_679     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_579     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_680     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_580     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_681     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_682     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_581     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_283         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_683     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_582     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_284         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_285         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_684     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_583     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_685     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_584     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_686     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_temp_55      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_687     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_688     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_585     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_286         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_689     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_586     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_690     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_587     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_691     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_588     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_sub_cast_692     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_sub_cast_693     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_temp_56      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_172     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_694     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_589     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_695     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_590     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_696     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_591     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_697     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_592     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_173     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_174     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_64      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_287         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_cast_288         : signed(17 DOWNTO 0);  -- sfix18_En14
  SIGNAL QGT_state_fixpt_cast_289         : signed(17 DOWNTO 0);  -- sfix18_En14
  SIGNAL QGT_state_fixpt_sub_cast_698     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_593     : signed(33 DOWNTO 0);  -- sfix34_En28
  SIGNAL QGT_state_fixpt_sub_cast_699     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_594     : signed(49 DOWNTO 0);  -- sfix50_En42
  SIGNAL QGT_state_fixpt_sub_cast_700     : signed(53 DOWNTO 0);  -- sfix54_En42
  SIGNAL QGT_state_fixpt_sub_temp_57      : signed(53 DOWNTO 0);  -- sfix54_En42
  SIGNAL QGT_state_fixpt_mul_temp_595     : signed(70 DOWNTO 0);  -- sfix71_En58
  SIGNAL QGT_state_fixpt_add_cast_175     : signed(69 DOWNTO 0);  -- sfix70_En58
  SIGNAL QGT_state_fixpt_add_cast_176     : signed(71 DOWNTO 0);  -- sfix72_En58
  SIGNAL QGT_state_fixpt_add_temp_65      : signed(71 DOWNTO 0);  -- sfix72_En58
  SIGNAL QGT_state_fixpt_sub_cast_701     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_596     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_290         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_702     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_597     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_291         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_292         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_293         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_cast_294         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_295         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_296         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_sub_cast_703     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_598     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_704     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_599     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_177     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_705     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_600     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_297         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_706     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_601     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_298         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_299         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_707     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_602     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_708     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_603     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_178     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_66      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_179     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_709     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_604     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_300         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_710     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_605     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_711     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_606     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_712     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_607     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_180     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_181     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_67      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_713     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_cast_714     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_608     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_715     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_609     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_716     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_610     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_717     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_611     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_718     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_719     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_temp_58      : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_cast_301         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_612     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_cast_302         : signed(32 DOWNTO 0);  -- sfix33_En29
  SIGNAL QGT_state_fixpt_cast_303         : signed(32 DOWNTO 0);  -- sfix33_En29
  SIGNAL QGT_state_fixpt_sub_cast_720     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_613     : signed(48 DOWNTO 0);  -- sfix49_En43
  SIGNAL QGT_state_fixpt_sub_cast_721     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_614     : signed(64 DOWNTO 0);  -- sfix65_En57
  SIGNAL QGT_state_fixpt_sub_cast_722     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_723     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_615     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_724     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_616     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_cast_304         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_cast_305         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_306         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_307         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_sub_cast_725     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_617     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_726     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_618     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_182     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_727     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_619     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_728     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_620     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_729     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_621     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_730     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_622     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_183     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_184     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_68      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_731     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_732     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_623     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_308         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_733     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_624     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_734     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_625     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_735     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_626     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_sub_cast_736     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_sub_cast_737     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_temp_59      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_cast_185     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_cast_738     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_627     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_309         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_739     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_628     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_310         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_311         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_740     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_629     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_741     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_630     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_186     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_add_temp_69      : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_cast_312         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_631     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_313         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_742     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_632     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_743     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_633     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_744     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_temp_60      : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_add_cast_187     : signed(67 DOWNTO 0);  -- sfix68_En58
  SIGNAL QGT_state_fixpt_sub_cast_745     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_634     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_746     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_635     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_747     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_636     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_748     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_637     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_188     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_189     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_749     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_638     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_750     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_639     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_751     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_640     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_752     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_641     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_190     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_191     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_temp_70      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_192     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_753     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_642     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_314         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_754     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_643     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_755     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_644     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_756     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_645     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_193     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_194     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_71      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_195     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_757     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_646     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_315         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_758     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_647     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_316         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_317         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_759     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_648     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_760     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_649     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_196     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_72      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_318         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_650     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_319         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_761     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_651     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_762     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_652     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_add_cast_197     : signed(67 DOWNTO 0);  -- sfix68_En58
  SIGNAL QGT_state_fixpt_add_temp_73      : signed(67 DOWNTO 0);  -- sfix68_En58
  SIGNAL QGT_state_fixpt_sub_cast_763     : signed(68 DOWNTO 0);  -- sfix69_En58
  SIGNAL QGT_state_fixpt_sub_cast_764     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_653     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_320         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_765     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_654     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_321         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_322         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_766     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_655     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_767     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_656     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_198     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_768     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_657     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_323         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_769     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_658     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_324         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_325         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_770     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_659     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_771     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_660     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_199     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_temp_74      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_772     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_773     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_661     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_326         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_774     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_662     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_775     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_663     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_776     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_664     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_sub_cast_777     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_sub_cast_778     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_temp_61      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_779     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_780     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_665     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_781     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_666     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_782     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_667     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_783     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_668     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_784     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_785     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_temp_62      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_327         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_669     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_328         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_cast_329         : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_330         : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_sub_cast_786     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_670     : signed(48 DOWNTO 0);  -- sfix49_En44
  SIGNAL QGT_state_fixpt_sub_cast_787     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_671     : signed(64 DOWNTO 0);  -- sfix65_En58
  SIGNAL QGT_state_fixpt_sub_cast_788     : signed(68 DOWNTO 0);  -- sfix69_En58
  SIGNAL QGT_state_fixpt_sub_temp_63      : signed(68 DOWNTO 0);  -- sfix69_En58
  SIGNAL QGT_state_fixpt_add_cast_200     : signed(71 DOWNTO 0);  -- sfix72_En58
  SIGNAL QGT_state_fixpt_sub_cast_789     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_672     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_790     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_673     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_cast_331         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_cast_332         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_333         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_334         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_sub_cast_791     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_674     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_792     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_675     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_201     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_793     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_676     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_794     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_677     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_795     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_678     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_796     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_679     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_202     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_203     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_75      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_204     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_797     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_680     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_335         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_798     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_681     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_799     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_682     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_800     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_683     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_205     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_206     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_76      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_801     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_cast_802     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_684     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_336         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_803     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_685     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_337         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_338         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_804     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_686     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_805     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_687     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_806     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_temp_64      : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_cast_339         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_cast_340         : signed(16 DOWNTO 0);  -- sfix17_En14
  SIGNAL QGT_state_fixpt_cast_341         : signed(16 DOWNTO 0);  -- sfix17_En14
  SIGNAL QGT_state_fixpt_cast_342         : signed(17 DOWNTO 0);  -- sfix18_En14
  SIGNAL QGT_state_fixpt_sub_cast_807     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_688     : signed(33 DOWNTO 0);  -- sfix34_En28
  SIGNAL QGT_state_fixpt_sub_cast_808     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_689     : signed(49 DOWNTO 0);  -- sfix50_En42
  SIGNAL QGT_state_fixpt_add_cast_207     : signed(50 DOWNTO 0);  -- sfix51_En42
  SIGNAL QGT_state_fixpt_add_cast_208     : signed(51 DOWNTO 0);  -- sfix52_En42
  SIGNAL QGT_state_fixpt_sub_cast_809     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_690     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_343         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_810     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_691     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_344         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_345         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_346         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_cast_347         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_348         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_349         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_sub_cast_811     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_692     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_812     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_693     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_209     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_813     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_694     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_350         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_814     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_695     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_351         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_352         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_815     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_696     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_816     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_697     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_210     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_77      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_817     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_818     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_698     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_353         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_819     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_699     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_820     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_700     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_821     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_701     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_sub_cast_822     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_sub_cast_823     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_temp_65      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_cast_211     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_cast_824     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_702     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_825     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_703     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_826     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_704     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_827     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_705     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_212     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_213     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_add_temp_78      : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_cast_354         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_sub_cast_828     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_706     : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_sub_cast_829     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_707     : signed(47 DOWNTO 0);  -- sfix48_En42
  SIGNAL QGT_state_fixpt_add_cast_214     : signed(51 DOWNTO 0);  -- sfix52_En42
  SIGNAL QGT_state_fixpt_add_temp_79      : signed(51 DOWNTO 0);  -- sfix52_En42
  SIGNAL QGT_state_fixpt_sub_cast_830     : signed(52 DOWNTO 0);  -- sfix53_En42
  SIGNAL QGT_state_fixpt_sub_cast_831     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_708     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_355         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_832     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_709     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_356         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_357         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_833     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_710     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_834     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_711     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_215     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_835     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_712     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_358         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_836     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_713     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_359         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_360         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_837     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_714     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_838     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_715     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_216     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_temp_80      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_217     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_839     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_716     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_361         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_840     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_717     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_841     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_718     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_842     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_719     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_218     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_219     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_81      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_220     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_843     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_720     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_844     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_721     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_845     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_722     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_846     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_723     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_221     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_222     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_82      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_362         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_sub_cast_847     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_724     : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_sub_cast_848     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_725     : signed(47 DOWNTO 0);  -- sfix48_En42
  SIGNAL QGT_state_fixpt_sub_cast_849     : signed(52 DOWNTO 0);  -- sfix53_En42
  SIGNAL QGT_state_fixpt_sub_temp_66      : signed(52 DOWNTO 0);  -- sfix53_En42
  SIGNAL QGT_state_fixpt_sub_cast_850     : signed(53 DOWNTO 0);  -- sfix54_En42
  SIGNAL QGT_state_fixpt_sub_cast_851     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_726     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_852     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_727     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_853     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_728     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_854     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_729     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_223     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_224     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_855     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_730     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_856     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_731     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_857     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_732     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_858     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_733     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_225     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_226     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_temp_83      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_859     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_860     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_734     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_363         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_861     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_735     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_862     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_736     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_863     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_737     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_sub_cast_864     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_sub_cast_865     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_temp_67      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_866     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_867     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_738     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_364         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_868     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_739     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_365         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_366         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_869     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_740     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_870     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_741     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_871     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_temp_68      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_367         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_sub_cast_872     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_742     : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_sub_cast_873     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_743     : signed(47 DOWNTO 0);  -- sfix48_En42
  SIGNAL QGT_state_fixpt_sub_cast_874     : signed(49 DOWNTO 0);  -- sfix50_En42
  SIGNAL QGT_state_fixpt_sub_cast_875     : signed(53 DOWNTO 0);  -- sfix54_En42
  SIGNAL QGT_state_fixpt_sub_temp_69      : signed(53 DOWNTO 0);  -- sfix54_En42
  SIGNAL QGT_state_fixpt_mul_temp_744     : signed(70 DOWNTO 0);  -- sfix71_En58
  SIGNAL QGT_state_fixpt_cast_368         : signed(69 DOWNTO 0);  -- sfix70_En58
  SIGNAL QGT_state_fixpt_cast_369         : signed(70 DOWNTO 0);  -- sfix71_En58
  SIGNAL QGT_state_fixpt_cast_370         : signed(70 DOWNTO 0);  -- sfix71_En58
  SIGNAL QGT_state_fixpt_add_cast_227     : signed(71 DOWNTO 0);  -- sfix72_En58
  SIGNAL QGT_state_fixpt_add_temp_84      : signed(71 DOWNTO 0);  -- sfix72_En58
  SIGNAL QGT_state_fixpt_sub_cast_876     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_745     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_877     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_746     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_cast_371         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_cast_372         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_373         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_374         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_sub_cast_878     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_747     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_879     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_748     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_228     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_880     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_749     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_881     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_750     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_882     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_751     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_883     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_752     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_229     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_230     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_85      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_231     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_884     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_753     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_375         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_885     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_754     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_886     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_755     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_887     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_756     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_232     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_233     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_86      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_888     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_cast_889     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_757     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_376         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_890     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_758     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_377         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_378         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_891     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_759     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_892     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_760     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_893     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_temp_70      : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_cast_379         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_761     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_894     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_762     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_895     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_763     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_896     : signed(64 DOWNTO 0);  -- sfix65_En57
  SIGNAL QGT_state_fixpt_sub_cast_897     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_898     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_764     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_380         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_899     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_765     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_381         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_382         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_383         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_cast_384         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_385         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_386         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_sub_cast_900     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_766     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_901     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_767     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_234     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_902     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_768     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_387         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_903     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_769     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_388         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_389         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_904     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_770     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_905     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_771     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_235     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_87      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_906     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_907     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_772     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_390         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_908     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_773     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_909     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_774     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_910     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_775     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_sub_cast_911     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_sub_cast_912     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_temp_71      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_cast_236     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_cast_913     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_776     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_914     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_777     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_915     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_778     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_916     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_779     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_237     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_238     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_add_temp_88      : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_cast_391         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_780     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_392         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_917     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_781     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_918     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_782     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_919     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_temp_72      : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_add_cast_239     : signed(67 DOWNTO 0);  -- sfix68_En58
  SIGNAL QGT_state_fixpt_sub_cast_920     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_783     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_393         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_921     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_784     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_394         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_395         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_922     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_785     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_923     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_786     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_240     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_924     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_787     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_396         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_925     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_788     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_397         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_398         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_926     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_789     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_927     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_790     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_241     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_temp_89      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_242     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_928     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_791     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_399         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_929     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_792     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_930     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_793     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_931     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_794     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_243     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_244     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_90      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_245     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_932     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_795     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_933     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_796     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_934     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_797     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_935     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_798     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_246     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_247     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_91      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_400         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_799     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_401         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_936     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_800     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_937     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_801     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_add_cast_248     : signed(67 DOWNTO 0);  -- sfix68_En58
  SIGNAL QGT_state_fixpt_add_temp_92      : signed(67 DOWNTO 0);  -- sfix68_En58
  SIGNAL QGT_state_fixpt_sub_cast_938     : signed(68 DOWNTO 0);  -- sfix69_En58
  SIGNAL QGT_state_fixpt_sub_cast_939     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_802     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_940     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_803     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_941     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_804     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_942     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_805     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_249     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_250     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_943     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_806     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_944     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_807     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_945     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_808     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_946     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_809     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_251     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_252     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_temp_93      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_947     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_948     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_810     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_402         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_949     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_811     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_950     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_812     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_951     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_813     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_sub_cast_952     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_sub_cast_953     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_temp_73      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_954     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_955     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_814     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_403         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_956     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_815     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_404         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_405         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_957     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_816     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_958     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_817     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_959     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_temp_74      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_406         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_818     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_407         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_960     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_819     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_961     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_820     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_962     : signed(64 DOWNTO 0);  -- sfix65_En58
  SIGNAL QGT_state_fixpt_sub_cast_963     : signed(68 DOWNTO 0);  -- sfix69_En58
  SIGNAL QGT_state_fixpt_sub_temp_75      : signed(68 DOWNTO 0);  -- sfix69_En58
  SIGNAL QGT_state_fixpt_add_cast_253     : signed(71 DOWNTO 0);  -- sfix72_En58
  SIGNAL QGT_state_fixpt_sub_cast_964     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_821     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_408         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_965     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_822     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_409         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_410         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_411         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_cast_412         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_413         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_414         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_sub_cast_966     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_823     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_967     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_824     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_254     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_968     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_825     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_415         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_969     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_826     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_416         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_417         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_970     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_827     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_971     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_828     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_255     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_94      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_256     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_972     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_829     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_418         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_973     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_830     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_974     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_831     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_975     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_832     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_257     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_258     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_95      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_976     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_cast_977     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_833     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_978     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_834     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_979     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_835     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_980     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_836     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_981     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_982     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_temp_76      : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_cast_419         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_cast_420         : signed(16 DOWNTO 0);  -- sfix17_En14
  SIGNAL QGT_state_fixpt_cast_421         : signed(16 DOWNTO 0);  -- sfix17_En14
  SIGNAL QGT_state_fixpt_cast_422         : signed(17 DOWNTO 0);  -- sfix18_En14
  SIGNAL QGT_state_fixpt_cast_423         : signed(18 DOWNTO 0);  -- sfix19_En14
  SIGNAL QGT_state_fixpt_cast_424         : signed(18 DOWNTO 0);  -- sfix19_En14
  SIGNAL QGT_state_fixpt_sub_cast_983     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_837     : signed(34 DOWNTO 0);  -- sfix35_En28
  SIGNAL QGT_state_fixpt_sub_cast_984     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_838     : signed(50 DOWNTO 0);  -- sfix51_En42
  SIGNAL QGT_state_fixpt_add_cast_259     : signed(51 DOWNTO 0);  -- sfix52_En42
  SIGNAL QGT_state_fixpt_sub_cast_985     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_839     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_986     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_840     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_cast_425         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_cast_426         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_427         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_428         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_sub_cast_987     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_841     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_988     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_842     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_260     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_989     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_843     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_990     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_844     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_991     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_845     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_992     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_846     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_261     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_262     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_96      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_993     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_994     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_847     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_429         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_995     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_848     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_996     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_849     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_997     : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_850     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_sub_cast_998     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_sub_cast_999     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_temp_77      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_cast_263     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_cast_1000    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_851     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_430         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1001    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_852     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_431         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_432         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_1002    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_853     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1003    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_854     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_264     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_add_temp_97      : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_cast_433         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_sub_cast_1004    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_855     : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_sub_cast_1005    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_856     : signed(47 DOWNTO 0);  -- sfix48_En42
  SIGNAL QGT_state_fixpt_add_cast_265     : signed(51 DOWNTO 0);  -- sfix52_En42
  SIGNAL QGT_state_fixpt_add_temp_98      : signed(51 DOWNTO 0);  -- sfix52_En42
  SIGNAL QGT_state_fixpt_sub_cast_1006    : signed(52 DOWNTO 0);  -- sfix53_En42
  SIGNAL QGT_state_fixpt_sub_cast_1007    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_857     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1008    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_858     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1009    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_859     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_1010    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_860     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_266     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_267     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_1011    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_861     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1012    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_862     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1013    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_863     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_1014    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_864     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_268     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_269     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_temp_99      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_270     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_1015    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_865     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_434         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1016    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_866     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_1017    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_867     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_1018    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_868     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_271     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_272     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_100     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_273     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_1019    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_869     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_435         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1020    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_870     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_436         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_437         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_1021    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_871     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1022    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_872     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_274     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_101     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_438         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_sub_cast_1023    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_873     : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_sub_cast_1024    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_874     : signed(47 DOWNTO 0);  -- sfix48_En42
  SIGNAL QGT_state_fixpt_sub_cast_1025    : signed(52 DOWNTO 0);  -- sfix53_En42
  SIGNAL QGT_state_fixpt_sub_temp_78      : signed(52 DOWNTO 0);  -- sfix53_En42
  SIGNAL QGT_state_fixpt_sub_cast_1026    : signed(53 DOWNTO 0);  -- sfix54_En42
  SIGNAL QGT_state_fixpt_sub_cast_1027    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_875     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_439         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1028    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_876     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_440         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_441         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_1029    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_877     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1030    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_878     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_275     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_1031    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_879     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_442         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1032    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_880     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_443         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_444         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_1033    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_881     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1034    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_882     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_276     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_temp_102     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_1035    : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_1036    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_883     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_445         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1037    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_884     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_1038    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_885     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_1039    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_886     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_sub_cast_1040    : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_sub_cast_1041    : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_temp_79      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_1042    : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_1043    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_887     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1044    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_888     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1045    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_889     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_1046    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_890     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_1047    : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_1048    : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_temp_80      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_446         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_cast_447         : signed(17 DOWNTO 0);  -- sfix18_En14
  SIGNAL QGT_state_fixpt_cast_448         : signed(17 DOWNTO 0);  -- sfix18_En14
  SIGNAL QGT_state_fixpt_sub_cast_1049    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_891     : signed(33 DOWNTO 0);  -- sfix34_En28
  SIGNAL QGT_state_fixpt_sub_cast_1050    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_892     : signed(49 DOWNTO 0);  -- sfix50_En42
  SIGNAL QGT_state_fixpt_sub_cast_1051    : signed(53 DOWNTO 0);  -- sfix54_En42
  SIGNAL QGT_state_fixpt_sub_temp_81      : signed(53 DOWNTO 0);  -- sfix54_En42
  SIGNAL QGT_state_fixpt_mul_temp_893     : signed(70 DOWNTO 0);  -- sfix71_En58
  SIGNAL QGT_state_fixpt_add_cast_277     : signed(69 DOWNTO 0);  -- sfix70_En58
  SIGNAL QGT_state_fixpt_add_cast_278     : signed(71 DOWNTO 0);  -- sfix72_En58
  SIGNAL QGT_state_fixpt_add_temp_103     : signed(71 DOWNTO 0);  -- sfix72_En58
  SIGNAL QGT_state_fixpt_sub_cast_1052    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_894     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1053    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_895     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1054    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_896     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_1055    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_897     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_1056    : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_1057    : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_1058    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_898     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1059    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_899     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1060    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_900     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_1061    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_901     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_1062    : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_1063    : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_temp_82      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_279     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_1064    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_902     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_449         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1065    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_903     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_1066    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_904     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_1067    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_905     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_280     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_281     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_104     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_1068    : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_1069    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_906     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_450         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1070    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_907     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_451         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_452         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_1071    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_908     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1072    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_909     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_1073    : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_temp_83      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_453         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_910     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1074    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_911     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1075    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_912     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_1076    : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1077    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_913     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_454         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1078    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_914     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_455         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_456         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_457         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_cast_458         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_459         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_460         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_sub_cast_1079    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_915     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_1080    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_916     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_282     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_1081    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_917     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_461         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1082    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_918     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_462         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_463         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_1083    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_919     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1084    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_920     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_283     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_105     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_284     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_1085    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_921     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_464         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1086    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_922     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_1087    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_923     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_1088    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_924     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_285     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_286     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_106     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_1089    : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_cast_1090    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_925     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1091    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_926     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1092    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_927     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_1093    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_928     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_1094    : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_1095    : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_temp_84      : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_cast_465         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_929     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_466         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_cast_467         : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_468         : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_sub_cast_1096    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_930     : signed(48 DOWNTO 0);  -- sfix49_En44
  SIGNAL QGT_state_fixpt_sub_cast_1097    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_931     : signed(64 DOWNTO 0);  -- sfix65_En58
  SIGNAL QGT_state_fixpt_sub_cast_1098    : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_temp_85      : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1099    : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_1100    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_932     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_469         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1101    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_933     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_470         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_471         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_472         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_cast_473         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_474         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_475         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_sub_cast_1102    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_934     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_1103    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_935     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_1104    : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_1105    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_936     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_476         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1106    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_937     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_477         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_478         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_1107    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_938     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1108    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_939     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_1109    : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_temp_86      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_287     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_1110    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_940     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_479         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1111    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_941     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_1112    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_942     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_1113    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_943     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_288     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_289     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_107     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_cast_290     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_cast_1114    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_944     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1115    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_945     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1116    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_946     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_1117    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_947     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_291     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_292     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_add_temp_108     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_cast_480         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_948     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_481         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_cast_482         : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_483         : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_sub_cast_1118    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_949     : signed(48 DOWNTO 0);  -- sfix49_En44
  SIGNAL QGT_state_fixpt_sub_cast_1119    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_950     : signed(64 DOWNTO 0);  -- sfix65_En58
  SIGNAL QGT_state_fixpt_sub_cast_1120    : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_temp_87      : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_add_cast_293     : signed(67 DOWNTO 0);  -- sfix68_En58
  SIGNAL QGT_state_fixpt_sub_cast_1121    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_951     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1122    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_952     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1123    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_953     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_1124    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_954     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_294     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_295     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_1125    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_955     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1126    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_956     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1127    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_957     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_1128    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_958     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_296     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_297     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_temp_109     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_298     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_1129    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_959     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_484         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1130    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_960     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_1131    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_961     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_1132    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_962     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_299     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_300     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_110     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_301     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_1133    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_963     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_485         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1134    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_964     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_486         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_487         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_1135    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_965     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1136    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_966     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_302     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_111     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_488         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_967     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_489         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1137    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_968     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_1138    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_969     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_add_cast_303     : signed(67 DOWNTO 0);  -- sfix68_En58
  SIGNAL QGT_state_fixpt_add_temp_112     : signed(67 DOWNTO 0);  -- sfix68_En58
  SIGNAL QGT_state_fixpt_add_cast_304     : signed(70 DOWNTO 0);  -- sfix71_En58
  SIGNAL QGT_state_fixpt_sub_cast_1139    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_970     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_490         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1140    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_971     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_491         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_492         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_1141    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_972     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1142    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_973     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_1143    : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_1144    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_974     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_493         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1145    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_975     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_494         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_495         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_1146    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_976     : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1147    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_977     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_1148    : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_temp_88      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_305     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_1149    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_978     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_496         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1150    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_979     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_1151    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_980     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_1152    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_981     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_306     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_307     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_113     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_1153    : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_1154    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_982     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1155    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_983     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1156    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_984     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_1157    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_985     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_1158    : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_1159    : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_temp_89      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_497         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_sub_cast_1160    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_986     : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_sub_cast_1161    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_987     : signed(47 DOWNTO 0);  -- sfix48_En42
  SIGNAL QGT_state_fixpt_sub_cast_1162    : signed(50 DOWNTO 0);  -- sfix51_En42
  SIGNAL QGT_state_fixpt_sub_cast_1163    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_988     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1164    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_989     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_cast_498         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_cast_499         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_500         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_501         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_sub_cast_1165    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_990     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_1166    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_991     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_308     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_1167    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_992     : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1168    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_993     : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1169    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_994     : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_1170    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_995     : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_309     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_310     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_114     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_311     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_1171    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_996     : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_502         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1172    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_997     : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_1173    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_998     : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_1174    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_999     : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_312     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_313     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_115     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_1175    : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_cast_1176    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1000    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_503         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1177    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1001    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_504         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_505         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_1178    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1002    : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1179    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1003    : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_1180    : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_temp_90      : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_cast_506         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_sub_cast_1181    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1004    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_sub_cast_1182    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1005    : signed(47 DOWNTO 0);  -- sfix48_En42
  SIGNAL QGT_state_fixpt_sub_cast_1183    : signed(49 DOWNTO 0);  -- sfix50_En42
  SIGNAL QGT_state_fixpt_sub_cast_1184    : signed(50 DOWNTO 0);  -- sfix51_En42
  SIGNAL QGT_state_fixpt_sub_temp_91      : signed(50 DOWNTO 0);  -- sfix51_En42
  SIGNAL QGT_state_fixpt_sub_cast_1185    : signed(51 DOWNTO 0);  -- sfix52_En42
  SIGNAL QGT_state_fixpt_sub_cast_1186    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1006    : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1187    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1007    : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_cast_507         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_cast_508         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_509         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_510         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_sub_cast_1188    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1008    : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_1189    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1009    : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_1190    : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_1191    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1010    : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1192    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1011    : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1193    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1012    : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_1194    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1013    : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_1195    : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_1196    : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_temp_92      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_314     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_1197    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1014    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_511         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1198    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1015    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_1199    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1016    : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_1200    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1017    : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_315     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_316     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_116     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_cast_317     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_cast_1201    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1018    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_512         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1202    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1019    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_513         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_514         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_1203    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1020    : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1204    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1021    : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_318     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_add_temp_117     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_cast_515         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_sub_cast_1205    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1022    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_sub_cast_1206    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1023    : signed(47 DOWNTO 0);  -- sfix48_En42
  SIGNAL QGT_state_fixpt_sub_cast_1207    : signed(49 DOWNTO 0);  -- sfix50_En42
  SIGNAL QGT_state_fixpt_sub_cast_1208    : signed(51 DOWNTO 0);  -- sfix52_En42
  SIGNAL QGT_state_fixpt_sub_temp_93      : signed(51 DOWNTO 0);  -- sfix52_En42
  SIGNAL QGT_state_fixpt_sub_cast_1209    : signed(52 DOWNTO 0);  -- sfix53_En42
  SIGNAL QGT_state_fixpt_sub_cast_1210    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1024    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_516         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1211    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1025    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_517         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_518         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_1212    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1026    : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1213    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1027    : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_319     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_1214    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1028    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_519         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1215    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1029    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_520         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_521         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_1216    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1030    : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1217    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1031    : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_320     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_temp_118     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_321     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_1218    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1032    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_522         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1219    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1033    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_1220    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1034    : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_1221    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1035    : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_322     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_323     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_119     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_324     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_1222    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1036    : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1223    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1037    : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1224    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1038    : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_1225    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1039    : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_325     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_326     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_120     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_523         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_sub_cast_1226    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1040    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_sub_cast_1227    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1041    : signed(47 DOWNTO 0);  -- sfix48_En42
  SIGNAL QGT_state_fixpt_sub_cast_1228    : signed(52 DOWNTO 0);  -- sfix53_En42
  SIGNAL QGT_state_fixpt_sub_temp_94      : signed(52 DOWNTO 0);  -- sfix53_En42
  SIGNAL QGT_state_fixpt_mul_temp_1042    : signed(69 DOWNTO 0);  -- sfix70_En58
  SIGNAL QGT_state_fixpt_cast_524         : signed(68 DOWNTO 0);  -- sfix69_En58
  SIGNAL QGT_state_fixpt_cast_525         : signed(69 DOWNTO 0);  -- sfix70_En58
  SIGNAL QGT_state_fixpt_cast_526         : signed(69 DOWNTO 0);  -- sfix70_En58
  SIGNAL QGT_state_fixpt_add_cast_327     : signed(70 DOWNTO 0);  -- sfix71_En58
  SIGNAL QGT_state_fixpt_add_temp_121     : signed(70 DOWNTO 0);  -- sfix71_En58
  SIGNAL QGT_state_fixpt_sub_cast_1229    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1043    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_527         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1230    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1044    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_528         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_529         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_1231    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1045    : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1232    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1046    : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_1233    : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_1234    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1047    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_530         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1235    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1048    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_531         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_532         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_1236    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1049    : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1237    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1050    : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_1238    : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_temp_95      : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_328     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_1239    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1051    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_533         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1240    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1052    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_1241    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1053    : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_1242    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1054    : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_329     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_330     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_122     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_1243    : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_1244    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1055    : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1245    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1056    : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1246    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1057    : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_1247    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1058    : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_1248    : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_1249    : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_temp_96      : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_534         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_1059    : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1250    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1060    : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1251    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1061    : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_1252    : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1253    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1062    : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1254    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1063    : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_cast_535         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_cast_536         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_537         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_538         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_sub_cast_1255    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1064    : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_1256    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1065    : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_331     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_1257    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1066    : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1258    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1067    : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1259    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1068    : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_1260    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1069    : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_332     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_333     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_123     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_334     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_1261    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1070    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_539         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1262    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1071    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_1263    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1072    : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_1264    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1073    : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_335     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_336     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_124     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_1265    : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_cast_1266    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1074    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_540         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1267    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1075    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_541         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_542         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_1268    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1076    : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1269    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1077    : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_1270    : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_temp_97      : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_cast_543         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_1078    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_544         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1271    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1079    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_1272    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1080    : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_1273    : signed(64 DOWNTO 0);  -- sfix65_En58
  SIGNAL QGT_state_fixpt_sub_cast_1274    : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_temp_98      : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1275    : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_1276    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1081    : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1277    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1082    : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_cast_545         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_cast_546         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_547         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_548         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_sub_cast_1278    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1083    : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_1279    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1084    : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_1280    : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_1281    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1085    : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1282    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1086    : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1283    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1087    : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_1284    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1088    : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_1285    : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_1286    : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_temp_99      : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_337     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_1287    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1089    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_549         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1288    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1090    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_1289    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1091    : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_1290    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1092    : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_338     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_339     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_125     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_cast_340     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_cast_1291    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1093    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_550         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1292    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1094    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_551         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_552         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_1293    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1095    : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1294    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1096    : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_341     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_add_temp_126     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_cast_553         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_1097    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_554         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1295    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1098    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_1296    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1099    : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_1297    : signed(64 DOWNTO 0);  -- sfix65_En58
  SIGNAL QGT_state_fixpt_sub_cast_1298    : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_temp_100     : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_add_cast_342     : signed(67 DOWNTO 0);  -- sfix68_En58
  SIGNAL QGT_state_fixpt_sub_cast_1299    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1100    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_555         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1300    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1101    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_556         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_557         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_1301    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1102    : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1302    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1103    : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_343     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_1303    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1104    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_558         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1304    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1105    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_559         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_560         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_1305    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1106    : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1306    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1107    : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_344     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_temp_127     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_345     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_1307    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1108    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_561         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1308    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1109    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_1309    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1110    : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_1310    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1111    : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_346     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_347     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_128     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_348     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_1311    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1112    : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1312    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1113    : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1313    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1114    : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_1314    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1115    : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_349     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_350     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_129     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_562         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_mul_temp_1116    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_563         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1315    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1117    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_1316    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1118    : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_add_cast_351     : signed(67 DOWNTO 0);  -- sfix68_En58
  SIGNAL QGT_state_fixpt_add_temp_130     : signed(67 DOWNTO 0);  -- sfix68_En58
  SIGNAL QGT_state_fixpt_add_cast_352     : signed(70 DOWNTO 0);  -- sfix71_En58
  SIGNAL QGT_state_fixpt_sub_cast_1317    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1119    : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1318    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1120    : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1319    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1121    : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_1320    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1122    : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_1321    : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_1322    : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_1323    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1123    : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1324    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1124    : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1325    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1125    : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_1326    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1126    : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_1327    : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_1328    : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_temp_101     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_353     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_1329    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1127    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_564         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1330    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1128    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_1331    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1129    : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_1332    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1130    : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_354     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_355     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_131     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_1333    : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_1334    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1131    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_565         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1335    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1132    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_566         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_567         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_1336    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1133    : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1337    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1134    : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_1338    : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_temp_102     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_568         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_sub_cast_1339    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1135    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_sub_cast_1340    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1136    : signed(47 DOWNTO 0);  -- sfix48_En42
  SIGNAL QGT_state_fixpt_sub_cast_1341    : signed(50 DOWNTO 0);  -- sfix51_En42
  SIGNAL QGT_state_fixpt_sub_cast_1342    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1137    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_569         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1343    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1138    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_570         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_571         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_572         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_cast_573         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_574         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_575         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_sub_cast_1344    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1139    : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_1345    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1140    : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_356     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_1346    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1141    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_576         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1347    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1142    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_577         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_578         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_1348    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1143    : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1349    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1144    : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_357     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_132     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_358     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_1350    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1145    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_579         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1351    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1146    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_1352    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1147    : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_1353    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1148    : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_359     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_360     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_133     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_1354    : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_cast_1355    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1149    : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1356    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1150    : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1357    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1151    : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_1358    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1152    : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_sub_cast_1359    : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_1360    : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_temp_103     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_cast_580         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_cast_581         : signed(17 DOWNTO 0);  -- sfix18_En14
  SIGNAL QGT_state_fixpt_cast_582         : signed(17 DOWNTO 0);  -- sfix18_En14
  SIGNAL QGT_state_fixpt_sub_cast_1361    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1153    : signed(33 DOWNTO 0);  -- sfix34_En28
  SIGNAL QGT_state_fixpt_sub_cast_1362    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1154    : signed(49 DOWNTO 0);  -- sfix50_En42
  SIGNAL QGT_state_fixpt_sub_cast_1363    : signed(50 DOWNTO 0);  -- sfix51_En42
  SIGNAL QGT_state_fixpt_sub_temp_104     : signed(50 DOWNTO 0);  -- sfix51_En42
  SIGNAL QGT_state_fixpt_sub_cast_1364    : signed(51 DOWNTO 0);  -- sfix52_En42
  SIGNAL QGT_state_fixpt_sub_cast_1365    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1155    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_583         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1366    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1156    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_584         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_585         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_586         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_cast_587         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_588         : signed(51 DOWNTO 0);  -- sfix52_En44
  SIGNAL QGT_state_fixpt_cast_589         : signed(50 DOWNTO 0);  -- sfix51_En44
  SIGNAL QGT_state_fixpt_sub_cast_1367    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1157    : signed(66 DOWNTO 0);  -- sfix67_En58
  SIGNAL QGT_state_fixpt_sub_cast_1368    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1158    : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_1369    : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_1370    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1159    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_590         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1371    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1160    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_591         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_592         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_1372    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1161    : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1373    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1162    : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_sub_cast_1374    : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_temp_105     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_361     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_1375    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1163    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_593         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1376    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1164    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_1377    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1165    : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_1378    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1166    : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_362     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_363     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_134     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_cast_364     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_sub_cast_1379    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1167    : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1380    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1168    : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1381    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1169    : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_1382    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1170    : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_365     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_366     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_add_temp_135     : signed(85 DOWNTO 0);  -- sfix86_En72
  SIGNAL QGT_state_fixpt_cast_594         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_cast_595         : signed(17 DOWNTO 0);  -- sfix18_En14
  SIGNAL QGT_state_fixpt_cast_596         : signed(17 DOWNTO 0);  -- sfix18_En14
  SIGNAL QGT_state_fixpt_sub_cast_1383    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1171    : signed(33 DOWNTO 0);  -- sfix34_En28
  SIGNAL QGT_state_fixpt_sub_cast_1384    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1172    : signed(49 DOWNTO 0);  -- sfix50_En42
  SIGNAL QGT_state_fixpt_sub_cast_1385    : signed(51 DOWNTO 0);  -- sfix52_En42
  SIGNAL QGT_state_fixpt_sub_temp_106     : signed(51 DOWNTO 0);  -- sfix52_En42
  SIGNAL QGT_state_fixpt_sub_cast_1386    : signed(52 DOWNTO 0);  -- sfix53_En42
  SIGNAL QGT_state_fixpt_sub_cast_1387    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1173    : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1388    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1174    : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1389    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1175    : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_1390    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1176    : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_367     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_368     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_sub_cast_1391    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1177    : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL QGT_state_fixpt_sub_cast_1392    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1178    : signed(47 DOWNTO 0);  -- sfix48_En43
  SIGNAL QGT_state_fixpt_sub_cast_1393    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1179    : signed(63 DOWNTO 0);  -- sfix64_En57
  SIGNAL QGT_state_fixpt_sub_cast_1394    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1180    : signed(79 DOWNTO 0);  -- sfix80_En71
  SIGNAL QGT_state_fixpt_add_cast_369     : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_370     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_temp_136     : signed(82 DOWNTO 0);  -- sfix83_En72
  SIGNAL QGT_state_fixpt_add_cast_371     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_sub_cast_1395    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1181    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_597         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1396    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1182    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_sub_cast_1397    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1183    : signed(63 DOWNTO 0);  -- sfix64_En58
  SIGNAL QGT_state_fixpt_sub_cast_1398    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1184    : signed(79 DOWNTO 0);  -- sfix80_En72
  SIGNAL QGT_state_fixpt_add_cast_372     : signed(80 DOWNTO 0);  -- sfix81_En72
  SIGNAL QGT_state_fixpt_add_cast_373     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_temp_137     : signed(83 DOWNTO 0);  -- sfix84_En72
  SIGNAL QGT_state_fixpt_add_cast_374     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_sub_cast_1399    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1185    : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL QGT_state_fixpt_cast_598         : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL QGT_state_fixpt_sub_cast_1400    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1186    : signed(47 DOWNTO 0);  -- sfix48_En44
  SIGNAL QGT_state_fixpt_cast_599         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_cast_600         : signed(49 DOWNTO 0);  -- sfix50_En44
  SIGNAL QGT_state_fixpt_sub_cast_1401    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1187    : signed(65 DOWNTO 0);  -- sfix66_En58
  SIGNAL QGT_state_fixpt_sub_cast_1402    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1188    : signed(81 DOWNTO 0);  -- sfix82_En72
  SIGNAL QGT_state_fixpt_add_cast_375     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_add_temp_138     : signed(84 DOWNTO 0);  -- sfix85_En72
  SIGNAL QGT_state_fixpt_cast_601         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL QGT_state_fixpt_sub_cast_1403    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1189    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_sub_cast_1404    : signed(31 DOWNTO 0);  -- int32
  SIGNAL QGT_state_fixpt_mul_temp_1190    : signed(47 DOWNTO 0);  -- sfix48_En42
  SIGNAL QGT_state_fixpt_sub_cast_1405    : signed(52 DOWNTO 0);  -- sfix53_En42
  SIGNAL QGT_state_fixpt_sub_temp_107     : signed(52 DOWNTO 0);  -- sfix53_En42
  SIGNAL QGT_state_fixpt_mul_temp_1191    : signed(69 DOWNTO 0);  -- sfix70_En58
  SIGNAL QGT_state_fixpt_add_cast_376     : signed(68 DOWNTO 0);  -- sfix69_En58
  SIGNAL QGT_state_fixpt_add_cast_377     : signed(70 DOWNTO 0);  -- sfix71_En58
  SIGNAL QGT_state_fixpt_add_temp_139     : signed(70 DOWNTO 0);  -- sfix71_En58
  SIGNAL QGT_state_fixpt_mul_temp_1192    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_add_cast_378     : signed(32 DOWNTO 0);  -- sfix33_En28
  SIGNAL QGT_state_fixpt_mul_temp_1193    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_add_cast_379     : signed(32 DOWNTO 0);  -- sfix33_En28
  SIGNAL QGT_state_fixpt_add_temp_140     : signed(32 DOWNTO 0);  -- sfix33_En28
  SIGNAL QGT_state_fixpt_mul_temp_1194    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_add_cast_380     : signed(32 DOWNTO 0);  -- sfix33_En28
  SIGNAL QGT_state_fixpt_mul_temp_1195    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_add_cast_381     : signed(32 DOWNTO 0);  -- sfix33_En28
  SIGNAL QGT_state_fixpt_add_temp_141     : signed(32 DOWNTO 0);  -- sfix33_En28
  SIGNAL QGT_state_fixpt_mul_temp_1196    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_add_cast_382     : signed(32 DOWNTO 0);  -- sfix33_En28
  SIGNAL QGT_state_fixpt_mul_temp_1197    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_add_cast_383     : signed(32 DOWNTO 0);  -- sfix33_En28
  SIGNAL QGT_state_fixpt_add_temp_142     : signed(32 DOWNTO 0);  -- sfix33_En28
  SIGNAL QGT_state_fixpt_mul_temp_1198    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_add_cast_384     : signed(32 DOWNTO 0);  -- sfix33_En28
  SIGNAL QGT_state_fixpt_mul_temp_1199    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL QGT_state_fixpt_add_cast_385     : signed(32 DOWNTO 0);  -- sfix33_En28
  SIGNAL QGT_state_fixpt_add_temp_143     : signed(32 DOWNTO 0);  -- sfix33_En28

BEGIN
  rotAx1_unsigned <= unsigned(rotAx1);
  rotAy2_unsigned <= unsigned(rotAy2);
  rotAx3_unsigned <= unsigned(rotAx3);
  rotBx1_unsigned <= unsigned(rotBx1);
  rotBy2_unsigned <= unsigned(rotBy2);
  rotBx3_unsigned <= unsigned(rotBx3);
  
  QGT_state_fixpt_auxAx1 <= resize(rotAx1_unsigned, 4) + to_unsigned(16#1#, 4);
  QGT_state_fixpt_auxAy2 <= resize(rotAy2_unsigned, 4) + to_unsigned(16#1#, 4);
  QGT_state_fixpt_auxAx3 <= resize(rotAx3_unsigned, 4) + to_unsigned(16#1#, 4);
  QGT_state_fixpt_auxBx1 <= resize(rotBx1_unsigned, 4) + to_unsigned(16#1#, 4);
  QGT_state_fixpt_auxBy2 <= resize(rotBy2_unsigned, 4) + to_unsigned(16#1#, 4);
  QGT_state_fixpt_auxBx3 <= resize(rotBx3_unsigned, 4) + to_unsigned(16#1#, 4);
  QGT_state_fixpt_sub_cast <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast - 1));
  QGT_state_fixpt_mul_temp_1 <= QGT_state_fixpt_mul_temp * nc_0(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_sub_cast_1 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_2 <= QGT_state_fixpt_mul_temp_1 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1 - 1));
  QGT_state_fixpt_sub_cast_2 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_3 <= QGT_state_fixpt_mul_temp_2 * nc_0(to_integer(QGT_state_fixpt_sub_cast_2 - 1));
  QGT_state_fixpt_add_cast <= resize(QGT_state_fixpt_mul_temp_3 & '0', 82);
  QGT_state_fixpt_add_cast_1 <= resize(QGT_state_fixpt_add_cast, 83);
  QGT_state_fixpt_sub_cast_3 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_4 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_3 - 1));
  QGT_state_fixpt_mul_temp_5 <= QGT_state_fixpt_mul_temp_4 * nc(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_sub_cast_4 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_6 <= QGT_state_fixpt_mul_temp_5 * nc_0(to_integer(QGT_state_fixpt_sub_cast_4 - 1));
  QGT_state_fixpt_sub_cast_5 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_7 <= QGT_state_fixpt_mul_temp_6 * nc(to_integer(QGT_state_fixpt_sub_cast_5 - 1));
  QGT_state_fixpt_add_cast_2 <= resize(QGT_state_fixpt_mul_temp_7 & '0', 82);
  QGT_state_fixpt_add_cast_3 <= resize(QGT_state_fixpt_add_cast_2, 83);
  QGT_state_fixpt_add_temp <= QGT_state_fixpt_add_cast_1 + QGT_state_fixpt_add_cast_3;
  QGT_state_fixpt_add_cast_4 <= resize(QGT_state_fixpt_add_temp, 84);
  QGT_state_fixpt_sub_cast_6 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_8 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_6 - 1));
  QGT_state_fixpt_cast <= QGT_state_fixpt_mul_temp_8(31 DOWNTO 0);
  QGT_state_fixpt_mul_temp_9 <= QGT_state_fixpt_cast * nc(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_sub_cast_7 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_10 <= QGT_state_fixpt_mul_temp_9 * nc(to_integer(QGT_state_fixpt_sub_cast_7 - 1));
  QGT_state_fixpt_sub_cast_8 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_11 <= QGT_state_fixpt_mul_temp_10 * nc(to_integer(QGT_state_fixpt_sub_cast_8 - 1));
  QGT_state_fixpt_add_cast_5 <= resize(QGT_state_fixpt_mul_temp_11, 81);
  QGT_state_fixpt_add_cast_6 <= resize(QGT_state_fixpt_add_cast_5, 84);
  QGT_state_fixpt_add_temp_1 <= QGT_state_fixpt_add_cast_4 + QGT_state_fixpt_add_cast_6;
  QGT_state_fixpt_add_cast_7 <= resize(QGT_state_fixpt_add_temp_1, 85);
  QGT_state_fixpt_mul_temp_12 <= to_signed(16#0B504#, 17) * nc_0(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_cast_1 <= QGT_state_fixpt_mul_temp_12(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_9 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_13 <= QGT_state_fixpt_cast_1 * nc(to_integer(QGT_state_fixpt_sub_cast_9 - 1));
  QGT_state_fixpt_cast_2 <= resize(QGT_state_fixpt_mul_temp_13, 50);
  QGT_state_fixpt_cast_3 <=  - (QGT_state_fixpt_cast_2);
  QGT_state_fixpt_sub_cast_10 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_14 <= QGT_state_fixpt_cast_3 * nc_0(to_integer(QGT_state_fixpt_sub_cast_10 - 1));
  QGT_state_fixpt_sub_cast_11 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_15 <= QGT_state_fixpt_mul_temp_14 * nc(to_integer(QGT_state_fixpt_sub_cast_11 - 1));
  QGT_state_fixpt_add_cast_8 <= resize(QGT_state_fixpt_mul_temp_15, 85);
  QGT_state_fixpt_add_temp_2 <= QGT_state_fixpt_add_cast_7 + QGT_state_fixpt_add_cast_8;
  QGT_state_fixpt_cast_4 <= QGT_state_fixpt_add_temp_2(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_16 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_4;
  QGT_state_fixpt_cast_5 <= QGT_state_fixpt_mul_temp_16(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_12 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_17 <= QGT_state_fixpt_cast_5 * nc(to_integer(QGT_state_fixpt_sub_cast_12 - 1));
  QGT_state_fixpt_sub_cast_13 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_18 <= QGT_state_fixpt_mul_temp_17 * nc(to_integer(QGT_state_fixpt_sub_cast_13 - 1));
  QGT_state_fixpt_sub_cast_14 <= resize(QGT_state_fixpt_mul_temp_18, 66);
  QGT_state_fixpt_sub_cast_15 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_19 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_15 - 1));
  QGT_state_fixpt_cast_6 <= QGT_state_fixpt_mul_temp_19(31 DOWNTO 0);
  QGT_state_fixpt_mul_temp_20 <= QGT_state_fixpt_cast_6 * nc(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_cast_7 <= resize(QGT_state_fixpt_mul_temp_20, 50);
  QGT_state_fixpt_cast_8 <=  - (QGT_state_fixpt_cast_7);
  QGT_state_fixpt_sub_cast_16 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_21 <= QGT_state_fixpt_cast_8 * nc_0(to_integer(QGT_state_fixpt_sub_cast_16 - 1));
  QGT_state_fixpt_sub_cast_17 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_22 <= QGT_state_fixpt_mul_temp_21 * nc(to_integer(QGT_state_fixpt_sub_cast_17 - 1));
  QGT_state_fixpt_add_cast_9 <= resize(QGT_state_fixpt_mul_temp_22, 83);
  QGT_state_fixpt_mul_temp_23 <= to_signed(16#0B504#, 17) * nc_0(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_cast_9 <= QGT_state_fixpt_mul_temp_23(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_18 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_24 <= QGT_state_fixpt_cast_9 * nc(to_integer(QGT_state_fixpt_sub_cast_18 - 1));
  QGT_state_fixpt_cast_10 <= resize(QGT_state_fixpt_mul_temp_24, 50);
  QGT_state_fixpt_cast_11 <=  - (QGT_state_fixpt_cast_10);
  QGT_state_fixpt_sub_cast_19 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_25 <= QGT_state_fixpt_cast_11 * nc(to_integer(QGT_state_fixpt_sub_cast_19 - 1));
  QGT_state_fixpt_sub_cast_20 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_26 <= QGT_state_fixpt_mul_temp_25 * nc(to_integer(QGT_state_fixpt_sub_cast_20 - 1));
  QGT_state_fixpt_add_cast_10 <= resize(QGT_state_fixpt_mul_temp_26, 83);
  QGT_state_fixpt_add_temp_3 <= QGT_state_fixpt_add_cast_9 + QGT_state_fixpt_add_cast_10;
  QGT_state_fixpt_sub_cast_21 <= resize(QGT_state_fixpt_add_temp_3, 84);
  QGT_state_fixpt_sub_cast_22 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_27 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_22 - 1));
  QGT_state_fixpt_cast_12 <= QGT_state_fixpt_mul_temp_27(31 DOWNTO 0);
  QGT_state_fixpt_mul_temp_28 <= QGT_state_fixpt_cast_12 * nc_0(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_sub_cast_23 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_29 <= QGT_state_fixpt_mul_temp_28 * nc_0(to_integer(QGT_state_fixpt_sub_cast_23 - 1));
  QGT_state_fixpt_sub_cast_24 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_30 <= QGT_state_fixpt_mul_temp_29 * nc(to_integer(QGT_state_fixpt_sub_cast_24 - 1));
  QGT_state_fixpt_sub_cast_25 <= resize(QGT_state_fixpt_mul_temp_30, 81);
  QGT_state_fixpt_sub_cast_26 <= resize(QGT_state_fixpt_sub_cast_25, 84);
  QGT_state_fixpt_sub_temp <= QGT_state_fixpt_sub_cast_21 - QGT_state_fixpt_sub_cast_26;
  QGT_state_fixpt_sub_cast_27 <= resize(QGT_state_fixpt_sub_temp, 85);
  QGT_state_fixpt_sub_cast_28 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_31 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_28 - 1));
  QGT_state_fixpt_mul_temp_32 <= QGT_state_fixpt_mul_temp_31 * nc(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_sub_cast_29 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_33 <= QGT_state_fixpt_mul_temp_32 * nc_0(to_integer(QGT_state_fixpt_sub_cast_29 - 1));
  QGT_state_fixpt_sub_cast_30 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_34 <= QGT_state_fixpt_mul_temp_33 * nc_0(to_integer(QGT_state_fixpt_sub_cast_30 - 1));
  QGT_state_fixpt_sub_cast_31 <= resize(QGT_state_fixpt_mul_temp_34 & '0', 82);
  QGT_state_fixpt_sub_cast_32 <= resize(QGT_state_fixpt_sub_cast_31, 85);
  QGT_state_fixpt_sub_temp_1 <= QGT_state_fixpt_sub_cast_27 - QGT_state_fixpt_sub_cast_32;
  QGT_state_fixpt_cast_13 <= QGT_state_fixpt_sub_temp_1(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_35 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_13;
  QGT_state_fixpt_cast_14 <= QGT_state_fixpt_mul_temp_35(31 DOWNTO 0);
  QGT_state_fixpt_cast_15 <= resize(QGT_state_fixpt_cast_14, 33);
  QGT_state_fixpt_cast_16 <=  - (QGT_state_fixpt_cast_15);
  QGT_state_fixpt_sub_cast_33 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_36 <= QGT_state_fixpt_cast_16 * nc_0(to_integer(QGT_state_fixpt_sub_cast_33 - 1));
  QGT_state_fixpt_sub_cast_34 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_37 <= QGT_state_fixpt_mul_temp_36 * nc(to_integer(QGT_state_fixpt_sub_cast_34 - 1));
  QGT_state_fixpt_sub_cast_35 <= resize(QGT_state_fixpt_mul_temp_37, 66);
  QGT_state_fixpt_sub_temp_2 <= QGT_state_fixpt_sub_cast_14 - QGT_state_fixpt_sub_cast_35;
  QGT_state_fixpt_sub_cast_36 <= resize(QGT_state_fixpt_sub_temp_2, 67);
  QGT_state_fixpt_sub_cast_37 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_38 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_37 - 1));
  QGT_state_fixpt_cast_17 <= QGT_state_fixpt_mul_temp_38(31 DOWNTO 0);
  QGT_state_fixpt_mul_temp_39 <= QGT_state_fixpt_cast_17 * nc(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_cast_18 <= resize(QGT_state_fixpt_mul_temp_39, 50);
  QGT_state_fixpt_cast_19 <=  - (QGT_state_fixpt_cast_18);
  QGT_state_fixpt_sub_cast_38 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_40 <= QGT_state_fixpt_cast_19 * nc_0(to_integer(QGT_state_fixpt_sub_cast_38 - 1));
  QGT_state_fixpt_sub_cast_39 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_41 <= QGT_state_fixpt_mul_temp_40 * nc(to_integer(QGT_state_fixpt_sub_cast_39 - 1));
  QGT_state_fixpt_sub_cast_40 <= resize(QGT_state_fixpt_mul_temp_41, 83);
  QGT_state_fixpt_mul_temp_42 <= to_signed(16#0B504#, 17) * nc_0(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_cast_20 <= QGT_state_fixpt_mul_temp_42(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_41 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_43 <= QGT_state_fixpt_cast_20 * nc(to_integer(QGT_state_fixpt_sub_cast_41 - 1));
  QGT_state_fixpt_cast_21 <= resize(QGT_state_fixpt_mul_temp_43, 50);
  QGT_state_fixpt_cast_22 <=  - (QGT_state_fixpt_cast_21);
  QGT_state_fixpt_sub_cast_42 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_44 <= QGT_state_fixpt_cast_22 * nc_0(to_integer(QGT_state_fixpt_sub_cast_42 - 1));
  QGT_state_fixpt_sub_cast_43 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_45 <= QGT_state_fixpt_mul_temp_44 * nc_0(to_integer(QGT_state_fixpt_sub_cast_43 - 1));
  QGT_state_fixpt_sub_cast_44 <= resize(QGT_state_fixpt_mul_temp_45, 83);
  QGT_state_fixpt_sub_temp_3 <= QGT_state_fixpt_sub_cast_40 - QGT_state_fixpt_sub_cast_44;
  QGT_state_fixpt_sub_cast_45 <= resize(QGT_state_fixpt_sub_temp_3, 84);
  QGT_state_fixpt_sub_cast_46 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_46 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_46 - 1));
  QGT_state_fixpt_cast_23 <= QGT_state_fixpt_mul_temp_46(31 DOWNTO 0);
  QGT_state_fixpt_mul_temp_47 <= QGT_state_fixpt_cast_23 * nc_0(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_sub_cast_47 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_48 <= QGT_state_fixpt_mul_temp_47 * nc_0(to_integer(QGT_state_fixpt_sub_cast_47 - 1));
  QGT_state_fixpt_sub_cast_48 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_49 <= QGT_state_fixpt_mul_temp_48 * nc(to_integer(QGT_state_fixpt_sub_cast_48 - 1));
  QGT_state_fixpt_sub_cast_49 <= resize(QGT_state_fixpt_mul_temp_49, 81);
  QGT_state_fixpt_sub_cast_50 <= resize(QGT_state_fixpt_sub_cast_49, 84);
  QGT_state_fixpt_sub_temp_4 <= QGT_state_fixpt_sub_cast_45 - QGT_state_fixpt_sub_cast_50;
  QGT_state_fixpt_add_cast_11 <= resize(QGT_state_fixpt_sub_temp_4, 85);
  QGT_state_fixpt_sub_cast_51 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_50 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_51 - 1));
  QGT_state_fixpt_mul_temp_51 <= QGT_state_fixpt_mul_temp_50 * nc(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_sub_cast_52 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_52 <= QGT_state_fixpt_mul_temp_51 * nc(to_integer(QGT_state_fixpt_sub_cast_52 - 1));
  QGT_state_fixpt_sub_cast_53 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_53 <= QGT_state_fixpt_mul_temp_52 * nc(to_integer(QGT_state_fixpt_sub_cast_53 - 1));
  QGT_state_fixpt_add_cast_12 <= resize(QGT_state_fixpt_mul_temp_53 & '0', 82);
  QGT_state_fixpt_add_cast_13 <= resize(QGT_state_fixpt_add_cast_12, 85);
  QGT_state_fixpt_add_temp_4 <= QGT_state_fixpt_add_cast_11 + QGT_state_fixpt_add_cast_13;
  QGT_state_fixpt_cast_24 <= QGT_state_fixpt_add_temp_4(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_54 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_24;
  QGT_state_fixpt_cast_25 <= QGT_state_fixpt_mul_temp_54(31 DOWNTO 0);
  QGT_state_fixpt_cast_26 <= resize(QGT_state_fixpt_cast_25, 33);
  QGT_state_fixpt_cast_27 <=  - (QGT_state_fixpt_cast_26);
  QGT_state_fixpt_sub_cast_54 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_55 <= QGT_state_fixpt_cast_27 * nc_0(to_integer(QGT_state_fixpt_sub_cast_54 - 1));
  QGT_state_fixpt_sub_cast_55 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_56 <= QGT_state_fixpt_mul_temp_55 * nc(to_integer(QGT_state_fixpt_sub_cast_55 - 1));
  QGT_state_fixpt_sub_cast_56 <= resize(QGT_state_fixpt_mul_temp_56, 67);
  QGT_state_fixpt_sub_temp_5 <= QGT_state_fixpt_sub_cast_36 - QGT_state_fixpt_sub_cast_56;
  QGT_state_fixpt_sub_cast_57 <= resize(QGT_state_fixpt_sub_temp_5, 68);
  QGT_state_fixpt_sub_cast_58 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_57 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_58 - 1));
  QGT_state_fixpt_mul_temp_58 <= QGT_state_fixpt_mul_temp_57 * nc_0(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_sub_cast_59 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_59 <= QGT_state_fixpt_mul_temp_58 * nc(to_integer(QGT_state_fixpt_sub_cast_59 - 1));
  QGT_state_fixpt_sub_cast_60 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_60 <= QGT_state_fixpt_mul_temp_59 * nc(to_integer(QGT_state_fixpt_sub_cast_60 - 1));
  QGT_state_fixpt_sub_cast_61 <= resize(QGT_state_fixpt_mul_temp_60 & '0', 82);
  QGT_state_fixpt_sub_cast_62 <= resize(QGT_state_fixpt_sub_cast_61, 83);
  QGT_state_fixpt_sub_cast_63 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_61 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_63 - 1));
  QGT_state_fixpt_mul_temp_62 <= QGT_state_fixpt_mul_temp_61 * nc(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_sub_cast_64 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_63 <= QGT_state_fixpt_mul_temp_62 * nc_0(to_integer(QGT_state_fixpt_sub_cast_64 - 1));
  QGT_state_fixpt_sub_cast_65 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_64 <= QGT_state_fixpt_mul_temp_63 * nc(to_integer(QGT_state_fixpt_sub_cast_65 - 1));
  QGT_state_fixpt_sub_cast_66 <= resize(QGT_state_fixpt_mul_temp_64 & '0', 82);
  QGT_state_fixpt_sub_cast_67 <= resize(QGT_state_fixpt_sub_cast_66, 83);
  QGT_state_fixpt_sub_temp_6 <= QGT_state_fixpt_sub_cast_62 - QGT_state_fixpt_sub_cast_67;
  QGT_state_fixpt_add_cast_14 <= resize(QGT_state_fixpt_sub_temp_6, 84);
  QGT_state_fixpt_sub_cast_68 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_65 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_68 - 1));
  QGT_state_fixpt_cast_28 <= QGT_state_fixpt_mul_temp_65(31 DOWNTO 0);
  QGT_state_fixpt_mul_temp_66 <= QGT_state_fixpt_cast_28 * nc(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_sub_cast_69 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_67 <= QGT_state_fixpt_mul_temp_66 * nc_0(to_integer(QGT_state_fixpt_sub_cast_69 - 1));
  QGT_state_fixpt_sub_cast_70 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_68 <= QGT_state_fixpt_mul_temp_67 * nc_0(to_integer(QGT_state_fixpt_sub_cast_70 - 1));
  QGT_state_fixpt_add_cast_15 <= resize(QGT_state_fixpt_mul_temp_68, 81);
  QGT_state_fixpt_add_cast_16 <= resize(QGT_state_fixpt_add_cast_15, 84);
  QGT_state_fixpt_add_temp_5 <= QGT_state_fixpt_add_cast_14 + QGT_state_fixpt_add_cast_16;
  QGT_state_fixpt_sub_cast_71 <= resize(QGT_state_fixpt_add_temp_5, 85);
  QGT_state_fixpt_mul_temp_69 <= to_signed(16#0B504#, 17) * nc_0(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_cast_29 <= QGT_state_fixpt_mul_temp_69(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_72 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_70 <= QGT_state_fixpt_cast_29 * nc(to_integer(QGT_state_fixpt_sub_cast_72 - 1));
  QGT_state_fixpt_cast_30 <= resize(QGT_state_fixpt_mul_temp_70, 50);
  QGT_state_fixpt_cast_31 <=  - (QGT_state_fixpt_cast_30);
  QGT_state_fixpt_sub_cast_73 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_71 <= QGT_state_fixpt_cast_31 * nc_0(to_integer(QGT_state_fixpt_sub_cast_73 - 1));
  QGT_state_fixpt_sub_cast_74 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_72 <= QGT_state_fixpt_mul_temp_71 * nc(to_integer(QGT_state_fixpt_sub_cast_74 - 1));
  QGT_state_fixpt_sub_cast_75 <= resize(QGT_state_fixpt_mul_temp_72, 85);
  QGT_state_fixpt_sub_temp_7 <= QGT_state_fixpt_sub_cast_71 - QGT_state_fixpt_sub_cast_75;
  QGT_state_fixpt_cast_32 <= QGT_state_fixpt_sub_temp_7(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_73 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_32;
  QGT_state_fixpt_cast_33 <= QGT_state_fixpt_mul_temp_73(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_76 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_74 <= QGT_state_fixpt_cast_33 * nc_0(to_integer(QGT_state_fixpt_sub_cast_76 - 1));
  QGT_state_fixpt_sub_cast_77 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_75 <= QGT_state_fixpt_mul_temp_74 * nc_0(to_integer(QGT_state_fixpt_sub_cast_77 - 1));
  QGT_state_fixpt_sub_cast_78 <= resize(QGT_state_fixpt_mul_temp_75, 68);
  QGT_state_fixpt_sub_temp_8 <= QGT_state_fixpt_sub_cast_57 - QGT_state_fixpt_sub_cast_78;
  QGT_state_fixpt_add_cast_17 <= resize(QGT_state_fixpt_sub_temp_8, 71);
  QGT_state_fixpt_sub_cast_79 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_76 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_79 - 1));
  QGT_state_fixpt_cast_34 <= QGT_state_fixpt_mul_temp_76(31 DOWNTO 0);
  QGT_state_fixpt_mul_temp_77 <= QGT_state_fixpt_cast_34 * nc(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_cast_35 <= resize(QGT_state_fixpt_mul_temp_77, 50);
  QGT_state_fixpt_cast_36 <=  - (QGT_state_fixpt_cast_35);
  QGT_state_fixpt_sub_cast_80 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_78 <= QGT_state_fixpt_cast_36 * nc_0(to_integer(QGT_state_fixpt_sub_cast_80 - 1));
  QGT_state_fixpt_sub_cast_81 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_79 <= QGT_state_fixpt_mul_temp_78 * nc_0(to_integer(QGT_state_fixpt_sub_cast_81 - 1));
  QGT_state_fixpt_add_cast_18 <= resize(QGT_state_fixpt_mul_temp_79, 83);
  QGT_state_fixpt_mul_temp_80 <= to_signed(16#0B504#, 17) * nc_0(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_cast_37 <= QGT_state_fixpt_mul_temp_80(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_82 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_81 <= QGT_state_fixpt_cast_37 * nc(to_integer(QGT_state_fixpt_sub_cast_82 - 1));
  QGT_state_fixpt_cast_38 <= resize(QGT_state_fixpt_mul_temp_81, 50);
  QGT_state_fixpt_cast_39 <=  - (QGT_state_fixpt_cast_38);
  QGT_state_fixpt_sub_cast_83 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_82 <= QGT_state_fixpt_cast_39 * nc_0(to_integer(QGT_state_fixpt_sub_cast_83 - 1));
  QGT_state_fixpt_sub_cast_84 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_83 <= QGT_state_fixpt_mul_temp_82 * nc(to_integer(QGT_state_fixpt_sub_cast_84 - 1));
  QGT_state_fixpt_add_cast_19 <= resize(QGT_state_fixpt_mul_temp_83, 83);
  QGT_state_fixpt_add_temp_6 <= QGT_state_fixpt_add_cast_18 + QGT_state_fixpt_add_cast_19;
  QGT_state_fixpt_add_cast_20 <= resize(QGT_state_fixpt_add_temp_6, 84);
  QGT_state_fixpt_sub_cast_85 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_84 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_85 - 1));
  QGT_state_fixpt_cast_40 <= QGT_state_fixpt_mul_temp_84(31 DOWNTO 0);
  QGT_state_fixpt_mul_temp_85 <= QGT_state_fixpt_cast_40 * nc_0(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_sub_cast_86 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_86 <= QGT_state_fixpt_mul_temp_85 * nc(to_integer(QGT_state_fixpt_sub_cast_86 - 1));
  QGT_state_fixpt_sub_cast_87 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_87 <= QGT_state_fixpt_mul_temp_86 * nc(to_integer(QGT_state_fixpt_sub_cast_87 - 1));
  QGT_state_fixpt_add_cast_21 <= resize(QGT_state_fixpt_mul_temp_87, 81);
  QGT_state_fixpt_add_cast_22 <= resize(QGT_state_fixpt_add_cast_21, 84);
  QGT_state_fixpt_add_temp_7 <= QGT_state_fixpt_add_cast_20 + QGT_state_fixpt_add_cast_22;
  QGT_state_fixpt_add_cast_23 <= resize(QGT_state_fixpt_add_temp_7, 85);
  QGT_state_fixpt_sub_cast_88 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_88 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_88 - 1));
  QGT_state_fixpt_mul_temp_89 <= QGT_state_fixpt_mul_temp_88 * nc(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_sub_cast_89 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_90 <= QGT_state_fixpt_mul_temp_89 * nc_0(to_integer(QGT_state_fixpt_sub_cast_89 - 1));
  QGT_state_fixpt_sub_cast_90 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_91 <= QGT_state_fixpt_mul_temp_90 * nc(to_integer(QGT_state_fixpt_sub_cast_90 - 1));
  QGT_state_fixpt_add_cast_24 <= resize(QGT_state_fixpt_mul_temp_91 & '0', 82);
  QGT_state_fixpt_add_cast_25 <= resize(QGT_state_fixpt_add_cast_24, 85);
  QGT_state_fixpt_add_temp_8 <= QGT_state_fixpt_add_cast_23 + QGT_state_fixpt_add_cast_25;
  QGT_state_fixpt_cast_41 <= QGT_state_fixpt_add_temp_8(73 DOWNTO 58);
  QGT_state_fixpt_cast_42 <= resize(QGT_state_fixpt_cast_41, 17);
  QGT_state_fixpt_cast_43 <= resize(QGT_state_fixpt_cast_42, 18);
  QGT_state_fixpt_cast_44 <=  - (QGT_state_fixpt_cast_43);
  QGT_state_fixpt_cast_45 <= QGT_state_fixpt_cast_44(16 DOWNTO 0);
  QGT_state_fixpt_sub_cast_91 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_92 <= QGT_state_fixpt_cast_45 * nc_0(to_integer(QGT_state_fixpt_sub_cast_91 - 1));
  QGT_state_fixpt_sub_cast_92 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_93 <= QGT_state_fixpt_mul_temp_92 * nc_0(to_integer(QGT_state_fixpt_sub_cast_92 - 1));
  QGT_state_fixpt_sub_cast_93 <= resize(QGT_state_fixpt_mul_temp_93, 51);
  QGT_state_fixpt_sub_cast_94 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_94 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_94 - 1));
  QGT_state_fixpt_mul_temp_95 <= QGT_state_fixpt_mul_temp_94 * nc_0(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_sub_cast_95 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_96 <= QGT_state_fixpt_mul_temp_95 * nc_0(to_integer(QGT_state_fixpt_sub_cast_95 - 1));
  QGT_state_fixpt_sub_cast_96 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_97 <= QGT_state_fixpt_mul_temp_96 * nc(to_integer(QGT_state_fixpt_sub_cast_96 - 1));
  QGT_state_fixpt_add_cast_26 <= resize(QGT_state_fixpt_mul_temp_97 & '0', 82);
  QGT_state_fixpt_add_cast_27 <= resize(QGT_state_fixpt_add_cast_26, 83);
  QGT_state_fixpt_sub_cast_97 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_98 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_97 - 1));
  QGT_state_fixpt_mul_temp_99 <= QGT_state_fixpt_mul_temp_98 * nc(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_sub_cast_98 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_100 <= QGT_state_fixpt_mul_temp_99 * nc(to_integer(QGT_state_fixpt_sub_cast_98 - 1));
  QGT_state_fixpt_sub_cast_99 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_101 <= QGT_state_fixpt_mul_temp_100 * nc(to_integer(QGT_state_fixpt_sub_cast_99 - 1));
  QGT_state_fixpt_add_cast_28 <= resize(QGT_state_fixpt_mul_temp_101 & '0', 82);
  QGT_state_fixpt_add_cast_29 <= resize(QGT_state_fixpt_add_cast_28, 83);
  QGT_state_fixpt_add_temp_9 <= QGT_state_fixpt_add_cast_27 + QGT_state_fixpt_add_cast_29;
  QGT_state_fixpt_sub_cast_100 <= resize(QGT_state_fixpt_add_temp_9, 84);
  QGT_state_fixpt_sub_cast_101 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_102 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_101 - 1));
  QGT_state_fixpt_cast_46 <= QGT_state_fixpt_mul_temp_102(31 DOWNTO 0);
  QGT_state_fixpt_mul_temp_103 <= QGT_state_fixpt_cast_46 * nc(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_sub_cast_102 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_104 <= QGT_state_fixpt_mul_temp_103 * nc_0(to_integer(QGT_state_fixpt_sub_cast_102 - 1));
  QGT_state_fixpt_sub_cast_103 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_105 <= QGT_state_fixpt_mul_temp_104 * nc(to_integer(QGT_state_fixpt_sub_cast_103 - 1));
  QGT_state_fixpt_sub_cast_104 <= resize(QGT_state_fixpt_mul_temp_105, 81);
  QGT_state_fixpt_sub_cast_105 <= resize(QGT_state_fixpt_sub_cast_104, 84);
  QGT_state_fixpt_sub_temp_9 <= QGT_state_fixpt_sub_cast_100 - QGT_state_fixpt_sub_cast_105;
  QGT_state_fixpt_sub_cast_106 <= resize(QGT_state_fixpt_sub_temp_9, 85);
  QGT_state_fixpt_mul_temp_106 <= to_signed(16#0B504#, 17) * nc_0(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_cast_47 <= QGT_state_fixpt_mul_temp_106(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_107 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_107 <= QGT_state_fixpt_cast_47 * nc(to_integer(QGT_state_fixpt_sub_cast_107 - 1));
  QGT_state_fixpt_cast_48 <= resize(QGT_state_fixpt_mul_temp_107, 50);
  QGT_state_fixpt_cast_49 <=  - (QGT_state_fixpt_cast_48);
  QGT_state_fixpt_sub_cast_108 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_108 <= QGT_state_fixpt_cast_49 * nc_0(to_integer(QGT_state_fixpt_sub_cast_108 - 1));
  QGT_state_fixpt_sub_cast_109 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_109 <= QGT_state_fixpt_mul_temp_108 * nc_0(to_integer(QGT_state_fixpt_sub_cast_109 - 1));
  QGT_state_fixpt_sub_cast_110 <= resize(QGT_state_fixpt_mul_temp_109, 85);
  QGT_state_fixpt_sub_temp_10 <= QGT_state_fixpt_sub_cast_106 - QGT_state_fixpt_sub_cast_110;
  QGT_state_fixpt_cast_50 <= QGT_state_fixpt_sub_temp_10(73 DOWNTO 58);
  QGT_state_fixpt_sub_cast_111 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_110 <= QGT_state_fixpt_cast_50 * nc_0(to_integer(QGT_state_fixpt_sub_cast_111 - 1));
  QGT_state_fixpt_sub_cast_112 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_111 <= QGT_state_fixpt_mul_temp_110 * nc(to_integer(QGT_state_fixpt_sub_cast_112 - 1));
  QGT_state_fixpt_sub_cast_113 <= resize(QGT_state_fixpt_mul_temp_111, 50);
  QGT_state_fixpt_sub_cast_114 <= resize(QGT_state_fixpt_sub_cast_113, 51);
  QGT_state_fixpt_sub_temp_11 <= QGT_state_fixpt_sub_cast_93 - QGT_state_fixpt_sub_cast_114;
  QGT_state_fixpt_sub_cast_115 <= resize(QGT_state_fixpt_sub_temp_11, 52);
  QGT_state_fixpt_sub_cast_116 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_112 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_116 - 1));
  QGT_state_fixpt_mul_temp_113 <= QGT_state_fixpt_mul_temp_112 * nc_0(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_sub_cast_117 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_114 <= QGT_state_fixpt_mul_temp_113 * nc_0(to_integer(QGT_state_fixpt_sub_cast_117 - 1));
  QGT_state_fixpt_sub_cast_118 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_115 <= QGT_state_fixpt_mul_temp_114 * nc(to_integer(QGT_state_fixpt_sub_cast_118 - 1));
  QGT_state_fixpt_sub_cast_119 <= resize(QGT_state_fixpt_mul_temp_115 & '0', 82);
  QGT_state_fixpt_sub_cast_120 <= resize(QGT_state_fixpt_sub_cast_119, 83);
  QGT_state_fixpt_sub_cast_121 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_116 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_121 - 1));
  QGT_state_fixpt_mul_temp_117 <= QGT_state_fixpt_mul_temp_116 * nc(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_sub_cast_122 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_118 <= QGT_state_fixpt_mul_temp_117 * nc_0(to_integer(QGT_state_fixpt_sub_cast_122 - 1));
  QGT_state_fixpt_sub_cast_123 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_119 <= QGT_state_fixpt_mul_temp_118 * nc_0(to_integer(QGT_state_fixpt_sub_cast_123 - 1));
  QGT_state_fixpt_sub_cast_124 <= resize(QGT_state_fixpt_mul_temp_119 & '0', 82);
  QGT_state_fixpt_sub_cast_125 <= resize(QGT_state_fixpt_sub_cast_124, 83);
  QGT_state_fixpt_sub_temp_12 <= QGT_state_fixpt_sub_cast_120 - QGT_state_fixpt_sub_cast_125;
  QGT_state_fixpt_sub_cast_126 <= resize(QGT_state_fixpt_sub_temp_12, 84);
  QGT_state_fixpt_sub_cast_127 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_120 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_127 - 1));
  QGT_state_fixpt_cast_51 <= QGT_state_fixpt_mul_temp_120(31 DOWNTO 0);
  QGT_state_fixpt_mul_temp_121 <= QGT_state_fixpt_cast_51 * nc(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_sub_cast_128 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_122 <= QGT_state_fixpt_mul_temp_121 * nc_0(to_integer(QGT_state_fixpt_sub_cast_128 - 1));
  QGT_state_fixpt_sub_cast_129 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_123 <= QGT_state_fixpt_mul_temp_122 * nc(to_integer(QGT_state_fixpt_sub_cast_129 - 1));
  QGT_state_fixpt_sub_cast_130 <= resize(QGT_state_fixpt_mul_temp_123, 81);
  QGT_state_fixpt_sub_cast_131 <= resize(QGT_state_fixpt_sub_cast_130, 84);
  QGT_state_fixpt_sub_temp_13 <= QGT_state_fixpt_sub_cast_126 - QGT_state_fixpt_sub_cast_131;
  QGT_state_fixpt_add_cast_30 <= resize(QGT_state_fixpt_sub_temp_13, 85);
  QGT_state_fixpt_mul_temp_124 <= to_signed(16#0B504#, 17) * nc_0(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_cast_52 <= QGT_state_fixpt_mul_temp_124(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_132 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_125 <= QGT_state_fixpt_cast_52 * nc(to_integer(QGT_state_fixpt_sub_cast_132 - 1));
  QGT_state_fixpt_cast_53 <= resize(QGT_state_fixpt_mul_temp_125, 50);
  QGT_state_fixpt_cast_54 <=  - (QGT_state_fixpt_cast_53);
  QGT_state_fixpt_sub_cast_133 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_126 <= QGT_state_fixpt_cast_54 * nc(to_integer(QGT_state_fixpt_sub_cast_133 - 1));
  QGT_state_fixpt_sub_cast_134 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_127 <= QGT_state_fixpt_mul_temp_126 * nc(to_integer(QGT_state_fixpt_sub_cast_134 - 1));
  QGT_state_fixpt_add_cast_31 <= resize(QGT_state_fixpt_mul_temp_127, 85);
  QGT_state_fixpt_add_temp_10 <= QGT_state_fixpt_add_cast_30 + QGT_state_fixpt_add_cast_31;
  QGT_state_fixpt_cast_55 <= QGT_state_fixpt_add_temp_10(73 DOWNTO 58);
  QGT_state_fixpt_sub_cast_135 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_128 <= QGT_state_fixpt_cast_55 * nc_0(to_integer(QGT_state_fixpt_sub_cast_135 - 1));
  QGT_state_fixpt_sub_cast_136 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_129 <= QGT_state_fixpt_mul_temp_128 * nc(to_integer(QGT_state_fixpt_sub_cast_136 - 1));
  QGT_state_fixpt_sub_cast_137 <= resize(QGT_state_fixpt_mul_temp_129, 50);
  QGT_state_fixpt_sub_cast_138 <= resize(QGT_state_fixpt_sub_cast_137, 52);
  QGT_state_fixpt_sub_temp_14 <= QGT_state_fixpt_sub_cast_115 - QGT_state_fixpt_sub_cast_138;
  QGT_state_fixpt_add_cast_32 <= resize(QGT_state_fixpt_sub_temp_14, 53);
  QGT_state_fixpt_sub_cast_139 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_130 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_139 - 1));
  QGT_state_fixpt_cast_56 <= QGT_state_fixpt_mul_temp_130(31 DOWNTO 0);
  QGT_state_fixpt_mul_temp_131 <= QGT_state_fixpt_cast_56 * nc(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_cast_57 <= resize(QGT_state_fixpt_mul_temp_131, 50);
  QGT_state_fixpt_cast_58 <=  - (QGT_state_fixpt_cast_57);
  QGT_state_fixpt_sub_cast_140 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_132 <= QGT_state_fixpt_cast_58 * nc(to_integer(QGT_state_fixpt_sub_cast_140 - 1));
  QGT_state_fixpt_sub_cast_141 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_133 <= QGT_state_fixpt_mul_temp_132 * nc(to_integer(QGT_state_fixpt_sub_cast_141 - 1));
  QGT_state_fixpt_sub_cast_142 <= resize(QGT_state_fixpt_mul_temp_133, 83);
  QGT_state_fixpt_mul_temp_134 <= to_signed(16#0B504#, 17) * nc_0(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_cast_59 <= QGT_state_fixpt_mul_temp_134(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_143 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_135 <= QGT_state_fixpt_cast_59 * nc(to_integer(QGT_state_fixpt_sub_cast_143 - 1));
  QGT_state_fixpt_cast_60 <= resize(QGT_state_fixpt_mul_temp_135, 50);
  QGT_state_fixpt_cast_61 <=  - (QGT_state_fixpt_cast_60);
  QGT_state_fixpt_sub_cast_144 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_136 <= QGT_state_fixpt_cast_61 * nc_0(to_integer(QGT_state_fixpt_sub_cast_144 - 1));
  QGT_state_fixpt_sub_cast_145 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_137 <= QGT_state_fixpt_mul_temp_136 * nc(to_integer(QGT_state_fixpt_sub_cast_145 - 1));
  QGT_state_fixpt_sub_cast_146 <= resize(QGT_state_fixpt_mul_temp_137, 83);
  QGT_state_fixpt_sub_temp_15 <= QGT_state_fixpt_sub_cast_142 - QGT_state_fixpt_sub_cast_146;
  QGT_state_fixpt_add_cast_33 <= resize(QGT_state_fixpt_sub_temp_15, 84);
  QGT_state_fixpt_sub_cast_147 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_138 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_147 - 1));
  QGT_state_fixpt_cast_62 <= QGT_state_fixpt_mul_temp_138(31 DOWNTO 0);
  QGT_state_fixpt_mul_temp_139 <= QGT_state_fixpt_cast_62 * nc_0(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_sub_cast_148 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_140 <= QGT_state_fixpt_mul_temp_139 * nc_0(to_integer(QGT_state_fixpt_sub_cast_148 - 1));
  QGT_state_fixpt_sub_cast_149 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_141 <= QGT_state_fixpt_mul_temp_140 * nc_0(to_integer(QGT_state_fixpt_sub_cast_149 - 1));
  QGT_state_fixpt_add_cast_34 <= resize(QGT_state_fixpt_mul_temp_141, 81);
  QGT_state_fixpt_add_cast_35 <= resize(QGT_state_fixpt_add_cast_34, 84);
  QGT_state_fixpt_add_temp_11 <= QGT_state_fixpt_add_cast_33 + QGT_state_fixpt_add_cast_35;
  QGT_state_fixpt_sub_cast_150 <= resize(QGT_state_fixpt_add_temp_11, 85);
  QGT_state_fixpt_sub_cast_151 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_142 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_151 - 1));
  QGT_state_fixpt_mul_temp_143 <= QGT_state_fixpt_mul_temp_142 * nc(to_integer(rotBx3_unsigned));
  QGT_state_fixpt_sub_cast_152 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_144 <= QGT_state_fixpt_mul_temp_143 * nc_0(to_integer(QGT_state_fixpt_sub_cast_152 - 1));
  QGT_state_fixpt_sub_cast_153 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_145 <= QGT_state_fixpt_mul_temp_144 * nc(to_integer(QGT_state_fixpt_sub_cast_153 - 1));
  QGT_state_fixpt_sub_cast_154 <= resize(QGT_state_fixpt_mul_temp_145 & '0', 82);
  QGT_state_fixpt_sub_cast_155 <= resize(QGT_state_fixpt_sub_cast_154, 85);
  QGT_state_fixpt_sub_temp_16 <= QGT_state_fixpt_sub_cast_150 - QGT_state_fixpt_sub_cast_155;
  QGT_state_fixpt_cast_63 <= QGT_state_fixpt_sub_temp_16(73 DOWNTO 58);
  QGT_state_fixpt_sub_cast_156 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_146 <= QGT_state_fixpt_cast_63 * nc(to_integer(QGT_state_fixpt_sub_cast_156 - 1));
  QGT_state_fixpt_sub_cast_157 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_147 <= QGT_state_fixpt_mul_temp_146 * nc(to_integer(QGT_state_fixpt_sub_cast_157 - 1));
  QGT_state_fixpt_add_cast_36 <= resize(QGT_state_fixpt_mul_temp_147, 53);
  QGT_state_fixpt_add_temp_12 <= QGT_state_fixpt_add_cast_32 + QGT_state_fixpt_add_cast_36;
  QGT_state_fixpt_mul_temp_148 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_add_temp_12;
  QGT_state_fixpt_cast_64 <= QGT_state_fixpt_mul_temp_148(68 DOWNTO 0);
  QGT_state_fixpt_cast_65 <= resize(QGT_state_fixpt_cast_64, 70);
  QGT_state_fixpt_cast_66 <=  - (QGT_state_fixpt_cast_65);
  QGT_state_fixpt_add_cast_37 <= resize(QGT_state_fixpt_cast_66, 71);
  QGT_state_fixpt_add_temp_13 <= QGT_state_fixpt_add_cast_17 + QGT_state_fixpt_add_cast_37;
  QGT_state_fixpt_c_re <= QGT_state_fixpt_add_temp_13(59 DOWNTO 44);
  QGT_state_fixpt_sub_cast_158 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_149 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_158 - 1));
  QGT_state_fixpt_cast_67 <= QGT_state_fixpt_mul_temp_149(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_159 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_150 <= QGT_state_fixpt_cast_67 * nc(to_integer(QGT_state_fixpt_sub_cast_159 - 1));
  QGT_state_fixpt_cast_68 <= resize(QGT_state_fixpt_mul_temp_150, 50);
  QGT_state_fixpt_cast_69 <=  - (QGT_state_fixpt_cast_68);
  QGT_state_fixpt_sub_cast_160 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_151 <= QGT_state_fixpt_cast_69 * nc_0(to_integer(QGT_state_fixpt_sub_cast_160 - 1));
  QGT_state_fixpt_sub_cast_161 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_152 <= QGT_state_fixpt_mul_temp_151 * nc_0(to_integer(QGT_state_fixpt_sub_cast_161 - 1));
  QGT_state_fixpt_add_cast_38 <= resize(QGT_state_fixpt_mul_temp_152, 83);
  QGT_state_fixpt_sub_cast_162 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_153 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_162 - 1));
  QGT_state_fixpt_cast_70 <= QGT_state_fixpt_mul_temp_153(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_163 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_154 <= QGT_state_fixpt_cast_70 * nc(to_integer(QGT_state_fixpt_sub_cast_163 - 1));
  QGT_state_fixpt_cast_71 <= resize(QGT_state_fixpt_mul_temp_154, 50);
  QGT_state_fixpt_cast_72 <=  - (QGT_state_fixpt_cast_71);
  QGT_state_fixpt_sub_cast_164 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_155 <= QGT_state_fixpt_cast_72 * nc_0(to_integer(QGT_state_fixpt_sub_cast_164 - 1));
  QGT_state_fixpt_sub_cast_165 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_156 <= QGT_state_fixpt_mul_temp_155 * nc(to_integer(QGT_state_fixpt_sub_cast_165 - 1));
  QGT_state_fixpt_add_cast_39 <= resize(QGT_state_fixpt_mul_temp_156, 83);
  QGT_state_fixpt_add_temp_14 <= QGT_state_fixpt_add_cast_38 + QGT_state_fixpt_add_cast_39;
  QGT_state_fixpt_add_cast_40 <= resize(QGT_state_fixpt_add_temp_14, 84);
  QGT_state_fixpt_sub_cast_166 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_157 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_166 - 1));
  QGT_state_fixpt_cast_73 <= QGT_state_fixpt_mul_temp_157(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_167 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_158 <= QGT_state_fixpt_cast_73 * nc_0(to_integer(QGT_state_fixpt_sub_cast_167 - 1));
  QGT_state_fixpt_sub_cast_168 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_159 <= QGT_state_fixpt_mul_temp_158 * nc(to_integer(QGT_state_fixpt_sub_cast_168 - 1));
  QGT_state_fixpt_sub_cast_169 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_160 <= QGT_state_fixpt_mul_temp_159 * nc(to_integer(QGT_state_fixpt_sub_cast_169 - 1));
  QGT_state_fixpt_add_cast_41 <= resize(QGT_state_fixpt_mul_temp_160, 81);
  QGT_state_fixpt_add_cast_42 <= resize(QGT_state_fixpt_add_cast_41, 84);
  QGT_state_fixpt_add_temp_15 <= QGT_state_fixpt_add_cast_40 + QGT_state_fixpt_add_cast_42;
  QGT_state_fixpt_add_cast_43 <= resize(QGT_state_fixpt_add_temp_15, 85);
  QGT_state_fixpt_sub_cast_170 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_161 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_170 - 1));
  QGT_state_fixpt_sub_cast_171 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_162 <= QGT_state_fixpt_mul_temp_161 * nc(to_integer(QGT_state_fixpt_sub_cast_171 - 1));
  QGT_state_fixpt_sub_cast_172 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_163 <= QGT_state_fixpt_mul_temp_162 * nc_0(to_integer(QGT_state_fixpt_sub_cast_172 - 1));
  QGT_state_fixpt_sub_cast_173 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_164 <= QGT_state_fixpt_mul_temp_163 * nc(to_integer(QGT_state_fixpt_sub_cast_173 - 1));
  QGT_state_fixpt_add_cast_44 <= resize(QGT_state_fixpt_mul_temp_164 & '0', 82);
  QGT_state_fixpt_add_cast_45 <= resize(QGT_state_fixpt_add_cast_44, 85);
  QGT_state_fixpt_add_temp_16 <= QGT_state_fixpt_add_cast_43 + QGT_state_fixpt_add_cast_45;
  QGT_state_fixpt_cast_74 <= QGT_state_fixpt_add_temp_16(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_165 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_74;
  QGT_state_fixpt_cast_75 <= QGT_state_fixpt_mul_temp_165(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_174 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_166 <= QGT_state_fixpt_cast_75 * nc(to_integer(QGT_state_fixpt_sub_cast_174 - 1));
  QGT_state_fixpt_sub_cast_175 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_167 <= QGT_state_fixpt_mul_temp_166 * nc(to_integer(QGT_state_fixpt_sub_cast_175 - 1));
  QGT_state_fixpt_sub_cast_176 <= resize(QGT_state_fixpt_mul_temp_167, 66);
  QGT_state_fixpt_sub_cast_177 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_168 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_177 - 1));
  QGT_state_fixpt_sub_cast_178 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_169 <= QGT_state_fixpt_mul_temp_168 * nc_0(to_integer(QGT_state_fixpt_sub_cast_178 - 1));
  QGT_state_fixpt_sub_cast_179 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_170 <= QGT_state_fixpt_mul_temp_169 * nc_0(to_integer(QGT_state_fixpt_sub_cast_179 - 1));
  QGT_state_fixpt_sub_cast_180 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_171 <= QGT_state_fixpt_mul_temp_170 * nc(to_integer(QGT_state_fixpt_sub_cast_180 - 1));
  QGT_state_fixpt_add_cast_46 <= resize(QGT_state_fixpt_mul_temp_171 & '0', 82);
  QGT_state_fixpt_add_cast_47 <= resize(QGT_state_fixpt_add_cast_46, 83);
  QGT_state_fixpt_sub_cast_181 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_172 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_181 - 1));
  QGT_state_fixpt_sub_cast_182 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_173 <= QGT_state_fixpt_mul_temp_172 * nc(to_integer(QGT_state_fixpt_sub_cast_182 - 1));
  QGT_state_fixpt_sub_cast_183 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_174 <= QGT_state_fixpt_mul_temp_173 * nc(to_integer(QGT_state_fixpt_sub_cast_183 - 1));
  QGT_state_fixpt_sub_cast_184 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_175 <= QGT_state_fixpt_mul_temp_174 * nc(to_integer(QGT_state_fixpt_sub_cast_184 - 1));
  QGT_state_fixpt_add_cast_48 <= resize(QGT_state_fixpt_mul_temp_175 & '0', 82);
  QGT_state_fixpt_add_cast_49 <= resize(QGT_state_fixpt_add_cast_48, 83);
  QGT_state_fixpt_add_temp_17 <= QGT_state_fixpt_add_cast_47 + QGT_state_fixpt_add_cast_49;
  QGT_state_fixpt_sub_cast_185 <= resize(QGT_state_fixpt_add_temp_17, 84);
  QGT_state_fixpt_sub_cast_186 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_176 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_186 - 1));
  QGT_state_fixpt_cast_76 <= QGT_state_fixpt_mul_temp_176(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_187 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_177 <= QGT_state_fixpt_cast_76 * nc(to_integer(QGT_state_fixpt_sub_cast_187 - 1));
  QGT_state_fixpt_sub_cast_188 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_178 <= QGT_state_fixpt_mul_temp_177 * nc_0(to_integer(QGT_state_fixpt_sub_cast_188 - 1));
  QGT_state_fixpt_sub_cast_189 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_179 <= QGT_state_fixpt_mul_temp_178 * nc(to_integer(QGT_state_fixpt_sub_cast_189 - 1));
  QGT_state_fixpt_sub_cast_190 <= resize(QGT_state_fixpt_mul_temp_179, 81);
  QGT_state_fixpt_sub_cast_191 <= resize(QGT_state_fixpt_sub_cast_190, 84);
  QGT_state_fixpt_sub_temp_17 <= QGT_state_fixpt_sub_cast_185 - QGT_state_fixpt_sub_cast_191;
  QGT_state_fixpt_sub_cast_192 <= resize(QGT_state_fixpt_sub_temp_17, 85);
  QGT_state_fixpt_sub_cast_193 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_180 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_193 - 1));
  QGT_state_fixpt_cast_77 <= QGT_state_fixpt_mul_temp_180(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_194 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_181 <= QGT_state_fixpt_cast_77 * nc(to_integer(QGT_state_fixpt_sub_cast_194 - 1));
  QGT_state_fixpt_cast_78 <= resize(QGT_state_fixpt_mul_temp_181, 50);
  QGT_state_fixpt_cast_79 <=  - (QGT_state_fixpt_cast_78);
  QGT_state_fixpt_sub_cast_195 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_182 <= QGT_state_fixpt_cast_79 * nc_0(to_integer(QGT_state_fixpt_sub_cast_195 - 1));
  QGT_state_fixpt_sub_cast_196 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_183 <= QGT_state_fixpt_mul_temp_182 * nc_0(to_integer(QGT_state_fixpt_sub_cast_196 - 1));
  QGT_state_fixpt_sub_cast_197 <= resize(QGT_state_fixpt_mul_temp_183, 85);
  QGT_state_fixpt_sub_temp_18 <= QGT_state_fixpt_sub_cast_192 - QGT_state_fixpt_sub_cast_197;
  QGT_state_fixpt_cast_80 <= QGT_state_fixpt_sub_temp_18(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_184 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_80;
  QGT_state_fixpt_cast_81 <= QGT_state_fixpt_mul_temp_184(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_198 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_185 <= QGT_state_fixpt_cast_81 * nc_0(to_integer(QGT_state_fixpt_sub_cast_198 - 1));
  QGT_state_fixpt_sub_cast_199 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_186 <= QGT_state_fixpt_mul_temp_185 * nc(to_integer(QGT_state_fixpt_sub_cast_199 - 1));
  QGT_state_fixpt_sub_cast_200 <= resize(QGT_state_fixpt_mul_temp_186, 65);
  QGT_state_fixpt_sub_cast_201 <= resize(QGT_state_fixpt_sub_cast_200, 66);
  QGT_state_fixpt_sub_temp_19 <= QGT_state_fixpt_sub_cast_176 - QGT_state_fixpt_sub_cast_201;
  QGT_state_fixpt_sub_cast_202 <= resize(QGT_state_fixpt_sub_temp_19, 67);
  QGT_state_fixpt_sub_cast_203 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_187 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_203 - 1));
  QGT_state_fixpt_sub_cast_204 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_188 <= QGT_state_fixpt_mul_temp_187 * nc_0(to_integer(QGT_state_fixpt_sub_cast_204 - 1));
  QGT_state_fixpt_sub_cast_205 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_189 <= QGT_state_fixpt_mul_temp_188 * nc_0(to_integer(QGT_state_fixpt_sub_cast_205 - 1));
  QGT_state_fixpt_sub_cast_206 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_190 <= QGT_state_fixpt_mul_temp_189 * nc(to_integer(QGT_state_fixpt_sub_cast_206 - 1));
  QGT_state_fixpt_sub_cast_207 <= resize(QGT_state_fixpt_mul_temp_190 & '0', 82);
  QGT_state_fixpt_sub_cast_208 <= resize(QGT_state_fixpt_sub_cast_207, 83);
  QGT_state_fixpt_sub_cast_209 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_191 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_209 - 1));
  QGT_state_fixpt_sub_cast_210 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_192 <= QGT_state_fixpt_mul_temp_191 * nc(to_integer(QGT_state_fixpt_sub_cast_210 - 1));
  QGT_state_fixpt_sub_cast_211 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_193 <= QGT_state_fixpt_mul_temp_192 * nc_0(to_integer(QGT_state_fixpt_sub_cast_211 - 1));
  QGT_state_fixpt_sub_cast_212 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_194 <= QGT_state_fixpt_mul_temp_193 * nc_0(to_integer(QGT_state_fixpt_sub_cast_212 - 1));
  QGT_state_fixpt_sub_cast_213 <= resize(QGT_state_fixpt_mul_temp_194 & '0', 82);
  QGT_state_fixpt_sub_cast_214 <= resize(QGT_state_fixpt_sub_cast_213, 83);
  QGT_state_fixpt_sub_temp_20 <= QGT_state_fixpt_sub_cast_208 - QGT_state_fixpt_sub_cast_214;
  QGT_state_fixpt_sub_cast_215 <= resize(QGT_state_fixpt_sub_temp_20, 84);
  QGT_state_fixpt_sub_cast_216 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_195 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_216 - 1));
  QGT_state_fixpt_cast_82 <= QGT_state_fixpt_mul_temp_195(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_217 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_196 <= QGT_state_fixpt_cast_82 * nc(to_integer(QGT_state_fixpt_sub_cast_217 - 1));
  QGT_state_fixpt_sub_cast_218 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_197 <= QGT_state_fixpt_mul_temp_196 * nc_0(to_integer(QGT_state_fixpt_sub_cast_218 - 1));
  QGT_state_fixpt_sub_cast_219 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_198 <= QGT_state_fixpt_mul_temp_197 * nc(to_integer(QGT_state_fixpt_sub_cast_219 - 1));
  QGT_state_fixpt_sub_cast_220 <= resize(QGT_state_fixpt_mul_temp_198, 81);
  QGT_state_fixpt_sub_cast_221 <= resize(QGT_state_fixpt_sub_cast_220, 84);
  QGT_state_fixpt_sub_temp_21 <= QGT_state_fixpt_sub_cast_215 - QGT_state_fixpt_sub_cast_221;
  QGT_state_fixpt_add_cast_50 <= resize(QGT_state_fixpt_sub_temp_21, 85);
  QGT_state_fixpt_sub_cast_222 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_199 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_222 - 1));
  QGT_state_fixpt_cast_83 <= QGT_state_fixpt_mul_temp_199(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_223 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_200 <= QGT_state_fixpt_cast_83 * nc(to_integer(QGT_state_fixpt_sub_cast_223 - 1));
  QGT_state_fixpt_cast_84 <= resize(QGT_state_fixpt_mul_temp_200, 50);
  QGT_state_fixpt_cast_85 <=  - (QGT_state_fixpt_cast_84);
  QGT_state_fixpt_sub_cast_224 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_201 <= QGT_state_fixpt_cast_85 * nc(to_integer(QGT_state_fixpt_sub_cast_224 - 1));
  QGT_state_fixpt_sub_cast_225 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_202 <= QGT_state_fixpt_mul_temp_201 * nc(to_integer(QGT_state_fixpt_sub_cast_225 - 1));
  QGT_state_fixpt_add_cast_51 <= resize(QGT_state_fixpt_mul_temp_202, 85);
  QGT_state_fixpt_add_temp_18 <= QGT_state_fixpt_add_cast_50 + QGT_state_fixpt_add_cast_51;
  QGT_state_fixpt_cast_86 <= QGT_state_fixpt_add_temp_18(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_203 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_86;
  QGT_state_fixpt_cast_87 <= QGT_state_fixpt_mul_temp_203(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_226 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_204 <= QGT_state_fixpt_cast_87 * nc_0(to_integer(QGT_state_fixpt_sub_cast_226 - 1));
  QGT_state_fixpt_sub_cast_227 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_205 <= QGT_state_fixpt_mul_temp_204 * nc(to_integer(QGT_state_fixpt_sub_cast_227 - 1));
  QGT_state_fixpt_sub_cast_228 <= resize(QGT_state_fixpt_mul_temp_205, 65);
  QGT_state_fixpt_sub_cast_229 <= resize(QGT_state_fixpt_sub_cast_228, 67);
  QGT_state_fixpt_sub_temp_22 <= QGT_state_fixpt_sub_cast_202 - QGT_state_fixpt_sub_cast_229;
  QGT_state_fixpt_sub_cast_230 <= resize(QGT_state_fixpt_sub_temp_22, 68);
  QGT_state_fixpt_sub_cast_231 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_206 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_231 - 1));
  QGT_state_fixpt_cast_88 <= QGT_state_fixpt_mul_temp_206(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_232 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_207 <= QGT_state_fixpt_cast_88 * nc(to_integer(QGT_state_fixpt_sub_cast_232 - 1));
  QGT_state_fixpt_cast_89 <= resize(QGT_state_fixpt_mul_temp_207, 50);
  QGT_state_fixpt_cast_90 <=  - (QGT_state_fixpt_cast_89);
  QGT_state_fixpt_sub_cast_233 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_208 <= QGT_state_fixpt_cast_90 * nc(to_integer(QGT_state_fixpt_sub_cast_233 - 1));
  QGT_state_fixpt_sub_cast_234 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_209 <= QGT_state_fixpt_mul_temp_208 * nc(to_integer(QGT_state_fixpt_sub_cast_234 - 1));
  QGT_state_fixpt_sub_cast_235 <= resize(QGT_state_fixpt_mul_temp_209, 83);
  QGT_state_fixpt_sub_cast_236 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_210 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_236 - 1));
  QGT_state_fixpt_cast_91 <= QGT_state_fixpt_mul_temp_210(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_237 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_211 <= QGT_state_fixpt_cast_91 * nc(to_integer(QGT_state_fixpt_sub_cast_237 - 1));
  QGT_state_fixpt_cast_92 <= resize(QGT_state_fixpt_mul_temp_211, 50);
  QGT_state_fixpt_cast_93 <=  - (QGT_state_fixpt_cast_92);
  QGT_state_fixpt_sub_cast_238 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_212 <= QGT_state_fixpt_cast_93 * nc_0(to_integer(QGT_state_fixpt_sub_cast_238 - 1));
  QGT_state_fixpt_sub_cast_239 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_213 <= QGT_state_fixpt_mul_temp_212 * nc(to_integer(QGT_state_fixpt_sub_cast_239 - 1));
  QGT_state_fixpt_sub_cast_240 <= resize(QGT_state_fixpt_mul_temp_213, 83);
  QGT_state_fixpt_sub_temp_23 <= QGT_state_fixpt_sub_cast_235 - QGT_state_fixpt_sub_cast_240;
  QGT_state_fixpt_add_cast_52 <= resize(QGT_state_fixpt_sub_temp_23, 84);
  QGT_state_fixpt_sub_cast_241 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_214 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_241 - 1));
  QGT_state_fixpt_cast_94 <= QGT_state_fixpt_mul_temp_214(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_242 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_215 <= QGT_state_fixpt_cast_94 * nc_0(to_integer(QGT_state_fixpt_sub_cast_242 - 1));
  QGT_state_fixpt_sub_cast_243 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_216 <= QGT_state_fixpt_mul_temp_215 * nc_0(to_integer(QGT_state_fixpt_sub_cast_243 - 1));
  QGT_state_fixpt_sub_cast_244 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_217 <= QGT_state_fixpt_mul_temp_216 * nc_0(to_integer(QGT_state_fixpt_sub_cast_244 - 1));
  QGT_state_fixpt_add_cast_53 <= resize(QGT_state_fixpt_mul_temp_217, 81);
  QGT_state_fixpt_add_cast_54 <= resize(QGT_state_fixpt_add_cast_53, 84);
  QGT_state_fixpt_add_temp_19 <= QGT_state_fixpt_add_cast_52 + QGT_state_fixpt_add_cast_54;
  QGT_state_fixpt_sub_cast_245 <= resize(QGT_state_fixpt_add_temp_19, 85);
  QGT_state_fixpt_sub_cast_246 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_218 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_246 - 1));
  QGT_state_fixpt_sub_cast_247 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_219 <= QGT_state_fixpt_mul_temp_218 * nc(to_integer(QGT_state_fixpt_sub_cast_247 - 1));
  QGT_state_fixpt_sub_cast_248 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_220 <= QGT_state_fixpt_mul_temp_219 * nc_0(to_integer(QGT_state_fixpt_sub_cast_248 - 1));
  QGT_state_fixpt_sub_cast_249 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_221 <= QGT_state_fixpt_mul_temp_220 * nc(to_integer(QGT_state_fixpt_sub_cast_249 - 1));
  QGT_state_fixpt_sub_cast_250 <= resize(QGT_state_fixpt_mul_temp_221 & '0', 82);
  QGT_state_fixpt_sub_cast_251 <= resize(QGT_state_fixpt_sub_cast_250, 85);
  QGT_state_fixpt_sub_temp_24 <= QGT_state_fixpt_sub_cast_245 - QGT_state_fixpt_sub_cast_251;
  QGT_state_fixpt_cast_95 <= QGT_state_fixpt_sub_temp_24(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_222 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_95;
  QGT_state_fixpt_cast_96 <= QGT_state_fixpt_mul_temp_222(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_252 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_223 <= QGT_state_fixpt_cast_96 * nc_0(to_integer(QGT_state_fixpt_sub_cast_252 - 1));
  QGT_state_fixpt_sub_cast_253 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_224 <= QGT_state_fixpt_mul_temp_223 * nc_0(to_integer(QGT_state_fixpt_sub_cast_253 - 1));
  QGT_state_fixpt_sub_cast_254 <= resize(QGT_state_fixpt_mul_temp_224, 68);
  QGT_state_fixpt_sub_temp_25 <= QGT_state_fixpt_sub_cast_230 - QGT_state_fixpt_sub_cast_254;
  QGT_state_fixpt_add_cast_55 <= resize(QGT_state_fixpt_sub_temp_25, 71);
  QGT_state_fixpt_sub_cast_255 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_225 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_255 - 1));
  QGT_state_fixpt_sub_cast_256 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_226 <= QGT_state_fixpt_mul_temp_225 * nc_0(to_integer(QGT_state_fixpt_sub_cast_256 - 1));
  QGT_state_fixpt_sub_cast_257 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_227 <= QGT_state_fixpt_mul_temp_226 * nc_0(to_integer(QGT_state_fixpt_sub_cast_257 - 1));
  QGT_state_fixpt_sub_cast_258 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_228 <= QGT_state_fixpt_mul_temp_227 * nc_0(to_integer(QGT_state_fixpt_sub_cast_258 - 1));
  QGT_state_fixpt_add_cast_56 <= resize(QGT_state_fixpt_mul_temp_228 & '0', 82);
  QGT_state_fixpt_add_cast_57 <= resize(QGT_state_fixpt_add_cast_56, 83);
  QGT_state_fixpt_sub_cast_259 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_229 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_259 - 1));
  QGT_state_fixpt_sub_cast_260 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_230 <= QGT_state_fixpt_mul_temp_229 * nc(to_integer(QGT_state_fixpt_sub_cast_260 - 1));
  QGT_state_fixpt_sub_cast_261 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_231 <= QGT_state_fixpt_mul_temp_230 * nc_0(to_integer(QGT_state_fixpt_sub_cast_261 - 1));
  QGT_state_fixpt_sub_cast_262 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_232 <= QGT_state_fixpt_mul_temp_231 * nc(to_integer(QGT_state_fixpt_sub_cast_262 - 1));
  QGT_state_fixpt_add_cast_58 <= resize(QGT_state_fixpt_mul_temp_232 & '0', 82);
  QGT_state_fixpt_add_cast_59 <= resize(QGT_state_fixpt_add_cast_58, 83);
  QGT_state_fixpt_add_temp_20 <= QGT_state_fixpt_add_cast_57 + QGT_state_fixpt_add_cast_59;
  QGT_state_fixpt_add_cast_60 <= resize(QGT_state_fixpt_add_temp_20, 84);
  QGT_state_fixpt_sub_cast_263 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_233 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_263 - 1));
  QGT_state_fixpt_cast_97 <= QGT_state_fixpt_mul_temp_233(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_264 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_234 <= QGT_state_fixpt_cast_97 * nc(to_integer(QGT_state_fixpt_sub_cast_264 - 1));
  QGT_state_fixpt_sub_cast_265 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_235 <= QGT_state_fixpt_mul_temp_234 * nc(to_integer(QGT_state_fixpt_sub_cast_265 - 1));
  QGT_state_fixpt_sub_cast_266 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_236 <= QGT_state_fixpt_mul_temp_235 * nc(to_integer(QGT_state_fixpt_sub_cast_266 - 1));
  QGT_state_fixpt_add_cast_61 <= resize(QGT_state_fixpt_mul_temp_236, 81);
  QGT_state_fixpt_add_cast_62 <= resize(QGT_state_fixpt_add_cast_61, 84);
  QGT_state_fixpt_add_temp_21 <= QGT_state_fixpt_add_cast_60 + QGT_state_fixpt_add_cast_62;
  QGT_state_fixpt_add_cast_63 <= resize(QGT_state_fixpt_add_temp_21, 85);
  QGT_state_fixpt_sub_cast_267 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_237 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_267 - 1));
  QGT_state_fixpt_cast_98 <= QGT_state_fixpt_mul_temp_237(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_268 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_238 <= QGT_state_fixpt_cast_98 * nc(to_integer(QGT_state_fixpt_sub_cast_268 - 1));
  QGT_state_fixpt_cast_99 <= resize(QGT_state_fixpt_mul_temp_238, 50);
  QGT_state_fixpt_cast_100 <=  - (QGT_state_fixpt_cast_99);
  QGT_state_fixpt_sub_cast_269 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_239 <= QGT_state_fixpt_cast_100 * nc_0(to_integer(QGT_state_fixpt_sub_cast_269 - 1));
  QGT_state_fixpt_sub_cast_270 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_240 <= QGT_state_fixpt_mul_temp_239 * nc(to_integer(QGT_state_fixpt_sub_cast_270 - 1));
  QGT_state_fixpt_add_cast_64 <= resize(QGT_state_fixpt_mul_temp_240, 85);
  QGT_state_fixpt_add_temp_22 <= QGT_state_fixpt_add_cast_63 + QGT_state_fixpt_add_cast_64;
  QGT_state_fixpt_cast_101 <= QGT_state_fixpt_add_temp_22(73 DOWNTO 58);
  QGT_state_fixpt_cast_102 <= resize(QGT_state_fixpt_cast_101, 17);
  QGT_state_fixpt_cast_103 <= resize(QGT_state_fixpt_cast_102, 18);
  QGT_state_fixpt_cast_104 <=  - (QGT_state_fixpt_cast_103);
  QGT_state_fixpt_cast_105 <= QGT_state_fixpt_cast_104(16 DOWNTO 0);
  QGT_state_fixpt_sub_cast_271 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_241 <= QGT_state_fixpt_cast_105 * nc_0(to_integer(QGT_state_fixpt_sub_cast_271 - 1));
  QGT_state_fixpt_sub_cast_272 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_242 <= QGT_state_fixpt_mul_temp_241 * nc_0(to_integer(QGT_state_fixpt_sub_cast_272 - 1));
  QGT_state_fixpt_sub_cast_273 <= resize(QGT_state_fixpt_mul_temp_242, 51);
  QGT_state_fixpt_sub_cast_274 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_243 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_274 - 1));
  QGT_state_fixpt_cast_106 <= QGT_state_fixpt_mul_temp_243(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_275 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_244 <= QGT_state_fixpt_cast_106 * nc(to_integer(QGT_state_fixpt_sub_cast_275 - 1));
  QGT_state_fixpt_cast_107 <= resize(QGT_state_fixpt_mul_temp_244, 50);
  QGT_state_fixpt_cast_108 <=  - (QGT_state_fixpt_cast_107);
  QGT_state_fixpt_sub_cast_276 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_245 <= QGT_state_fixpt_cast_108 * nc_0(to_integer(QGT_state_fixpt_sub_cast_276 - 1));
  QGT_state_fixpt_sub_cast_277 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_246 <= QGT_state_fixpt_mul_temp_245 * nc(to_integer(QGT_state_fixpt_sub_cast_277 - 1));
  QGT_state_fixpt_add_cast_65 <= resize(QGT_state_fixpt_mul_temp_246, 83);
  QGT_state_fixpt_sub_cast_278 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_247 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_278 - 1));
  QGT_state_fixpt_cast_109 <= QGT_state_fixpt_mul_temp_247(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_279 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_248 <= QGT_state_fixpt_cast_109 * nc(to_integer(QGT_state_fixpt_sub_cast_279 - 1));
  QGT_state_fixpt_cast_110 <= resize(QGT_state_fixpt_mul_temp_248, 50);
  QGT_state_fixpt_cast_111 <=  - (QGT_state_fixpt_cast_110);
  QGT_state_fixpt_sub_cast_280 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_249 <= QGT_state_fixpt_cast_111 * nc(to_integer(QGT_state_fixpt_sub_cast_280 - 1));
  QGT_state_fixpt_sub_cast_281 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_250 <= QGT_state_fixpt_mul_temp_249 * nc(to_integer(QGT_state_fixpt_sub_cast_281 - 1));
  QGT_state_fixpt_add_cast_66 <= resize(QGT_state_fixpt_mul_temp_250, 83);
  QGT_state_fixpt_add_temp_23 <= QGT_state_fixpt_add_cast_65 + QGT_state_fixpt_add_cast_66;
  QGT_state_fixpt_sub_cast_282 <= resize(QGT_state_fixpt_add_temp_23, 84);
  QGT_state_fixpt_sub_cast_283 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_251 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_283 - 1));
  QGT_state_fixpt_cast_112 <= QGT_state_fixpt_mul_temp_251(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_284 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_252 <= QGT_state_fixpt_cast_112 * nc_0(to_integer(QGT_state_fixpt_sub_cast_284 - 1));
  QGT_state_fixpt_sub_cast_285 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_253 <= QGT_state_fixpt_mul_temp_252 * nc_0(to_integer(QGT_state_fixpt_sub_cast_285 - 1));
  QGT_state_fixpt_sub_cast_286 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_254 <= QGT_state_fixpt_mul_temp_253 * nc(to_integer(QGT_state_fixpt_sub_cast_286 - 1));
  QGT_state_fixpt_sub_cast_287 <= resize(QGT_state_fixpt_mul_temp_254, 81);
  QGT_state_fixpt_sub_cast_288 <= resize(QGT_state_fixpt_sub_cast_287, 84);
  QGT_state_fixpt_sub_temp_26 <= QGT_state_fixpt_sub_cast_282 - QGT_state_fixpt_sub_cast_288;
  QGT_state_fixpt_sub_cast_289 <= resize(QGT_state_fixpt_sub_temp_26, 85);
  QGT_state_fixpt_sub_cast_290 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_255 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_290 - 1));
  QGT_state_fixpt_sub_cast_291 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_256 <= QGT_state_fixpt_mul_temp_255 * nc(to_integer(QGT_state_fixpt_sub_cast_291 - 1));
  QGT_state_fixpt_sub_cast_292 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_257 <= QGT_state_fixpt_mul_temp_256 * nc_0(to_integer(QGT_state_fixpt_sub_cast_292 - 1));
  QGT_state_fixpt_sub_cast_293 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_258 <= QGT_state_fixpt_mul_temp_257 * nc_0(to_integer(QGT_state_fixpt_sub_cast_293 - 1));
  QGT_state_fixpt_sub_cast_294 <= resize(QGT_state_fixpt_mul_temp_258 & '0', 82);
  QGT_state_fixpt_sub_cast_295 <= resize(QGT_state_fixpt_sub_cast_294, 85);
  QGT_state_fixpt_sub_temp_27 <= QGT_state_fixpt_sub_cast_289 - QGT_state_fixpt_sub_cast_295;
  QGT_state_fixpt_cast_113 <= QGT_state_fixpt_sub_temp_27(73 DOWNTO 58);
  QGT_state_fixpt_cast_114 <= resize(QGT_state_fixpt_cast_113, 18);
  QGT_state_fixpt_cast_115 <=  - (QGT_state_fixpt_cast_114);
  QGT_state_fixpt_sub_cast_296 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_259 <= QGT_state_fixpt_cast_115 * nc_0(to_integer(QGT_state_fixpt_sub_cast_296 - 1));
  QGT_state_fixpt_sub_cast_297 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_260 <= QGT_state_fixpt_mul_temp_259 * nc(to_integer(QGT_state_fixpt_sub_cast_297 - 1));
  QGT_state_fixpt_sub_cast_298 <= resize(QGT_state_fixpt_mul_temp_260, 51);
  QGT_state_fixpt_sub_temp_28 <= QGT_state_fixpt_sub_cast_273 - QGT_state_fixpt_sub_cast_298;
  QGT_state_fixpt_sub_cast_299 <= resize(QGT_state_fixpt_sub_temp_28, 52);
  QGT_state_fixpt_sub_cast_300 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_261 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_300 - 1));
  QGT_state_fixpt_cast_116 <= QGT_state_fixpt_mul_temp_261(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_301 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_262 <= QGT_state_fixpt_cast_116 * nc(to_integer(QGT_state_fixpt_sub_cast_301 - 1));
  QGT_state_fixpt_cast_117 <= resize(QGT_state_fixpt_mul_temp_262, 50);
  QGT_state_fixpt_cast_118 <=  - (QGT_state_fixpt_cast_117);
  QGT_state_fixpt_sub_cast_302 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_263 <= QGT_state_fixpt_cast_118 * nc_0(to_integer(QGT_state_fixpt_sub_cast_302 - 1));
  QGT_state_fixpt_sub_cast_303 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_264 <= QGT_state_fixpt_mul_temp_263 * nc(to_integer(QGT_state_fixpt_sub_cast_303 - 1));
  QGT_state_fixpt_sub_cast_304 <= resize(QGT_state_fixpt_mul_temp_264, 83);
  QGT_state_fixpt_sub_cast_305 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_265 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_305 - 1));
  QGT_state_fixpt_cast_119 <= QGT_state_fixpt_mul_temp_265(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_306 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_266 <= QGT_state_fixpt_cast_119 * nc(to_integer(QGT_state_fixpt_sub_cast_306 - 1));
  QGT_state_fixpt_cast_120 <= resize(QGT_state_fixpt_mul_temp_266, 50);
  QGT_state_fixpt_cast_121 <=  - (QGT_state_fixpt_cast_120);
  QGT_state_fixpt_sub_cast_307 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_267 <= QGT_state_fixpt_cast_121 * nc_0(to_integer(QGT_state_fixpt_sub_cast_307 - 1));
  QGT_state_fixpt_sub_cast_308 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_268 <= QGT_state_fixpt_mul_temp_267 * nc_0(to_integer(QGT_state_fixpt_sub_cast_308 - 1));
  QGT_state_fixpt_sub_cast_309 <= resize(QGT_state_fixpt_mul_temp_268, 83);
  QGT_state_fixpt_sub_temp_29 <= QGT_state_fixpt_sub_cast_304 - QGT_state_fixpt_sub_cast_309;
  QGT_state_fixpt_sub_cast_310 <= resize(QGT_state_fixpt_sub_temp_29, 84);
  QGT_state_fixpt_sub_cast_311 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_269 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_311 - 1));
  QGT_state_fixpt_cast_122 <= QGT_state_fixpt_mul_temp_269(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_312 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_270 <= QGT_state_fixpt_cast_122 * nc_0(to_integer(QGT_state_fixpt_sub_cast_312 - 1));
  QGT_state_fixpt_sub_cast_313 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_271 <= QGT_state_fixpt_mul_temp_270 * nc_0(to_integer(QGT_state_fixpt_sub_cast_313 - 1));
  QGT_state_fixpt_sub_cast_314 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_272 <= QGT_state_fixpt_mul_temp_271 * nc(to_integer(QGT_state_fixpt_sub_cast_314 - 1));
  QGT_state_fixpt_sub_cast_315 <= resize(QGT_state_fixpt_mul_temp_272, 81);
  QGT_state_fixpt_sub_cast_316 <= resize(QGT_state_fixpt_sub_cast_315, 84);
  QGT_state_fixpt_sub_temp_30 <= QGT_state_fixpt_sub_cast_310 - QGT_state_fixpt_sub_cast_316;
  QGT_state_fixpt_add_cast_67 <= resize(QGT_state_fixpt_sub_temp_30, 85);
  QGT_state_fixpt_sub_cast_317 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_273 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_317 - 1));
  QGT_state_fixpt_sub_cast_318 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_274 <= QGT_state_fixpt_mul_temp_273 * nc(to_integer(QGT_state_fixpt_sub_cast_318 - 1));
  QGT_state_fixpt_sub_cast_319 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_275 <= QGT_state_fixpt_mul_temp_274 * nc(to_integer(QGT_state_fixpt_sub_cast_319 - 1));
  QGT_state_fixpt_sub_cast_320 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_276 <= QGT_state_fixpt_mul_temp_275 * nc(to_integer(QGT_state_fixpt_sub_cast_320 - 1));
  QGT_state_fixpt_add_cast_68 <= resize(QGT_state_fixpt_mul_temp_276 & '0', 82);
  QGT_state_fixpt_add_cast_69 <= resize(QGT_state_fixpt_add_cast_68, 85);
  QGT_state_fixpt_add_temp_24 <= QGT_state_fixpt_add_cast_67 + QGT_state_fixpt_add_cast_69;
  QGT_state_fixpt_cast_123 <= QGT_state_fixpt_add_temp_24(73 DOWNTO 58);
  QGT_state_fixpt_cast_124 <= resize(QGT_state_fixpt_cast_123, 18);
  QGT_state_fixpt_cast_125 <=  - (QGT_state_fixpt_cast_124);
  QGT_state_fixpt_sub_cast_321 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_277 <= QGT_state_fixpt_cast_125 * nc_0(to_integer(QGT_state_fixpt_sub_cast_321 - 1));
  QGT_state_fixpt_sub_cast_322 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_278 <= QGT_state_fixpt_mul_temp_277 * nc(to_integer(QGT_state_fixpt_sub_cast_322 - 1));
  QGT_state_fixpt_sub_cast_323 <= resize(QGT_state_fixpt_mul_temp_278, 52);
  QGT_state_fixpt_sub_temp_31 <= QGT_state_fixpt_sub_cast_299 - QGT_state_fixpt_sub_cast_323;
  QGT_state_fixpt_add_cast_70 <= resize(QGT_state_fixpt_sub_temp_31, 53);
  QGT_state_fixpt_sub_cast_324 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_279 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_324 - 1));
  QGT_state_fixpt_sub_cast_325 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_280 <= QGT_state_fixpt_mul_temp_279 * nc_0(to_integer(QGT_state_fixpt_sub_cast_325 - 1));
  QGT_state_fixpt_sub_cast_326 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_281 <= QGT_state_fixpt_mul_temp_280 * nc(to_integer(QGT_state_fixpt_sub_cast_326 - 1));
  QGT_state_fixpt_sub_cast_327 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_282 <= QGT_state_fixpt_mul_temp_281 * nc(to_integer(QGT_state_fixpt_sub_cast_327 - 1));
  QGT_state_fixpt_sub_cast_328 <= resize(QGT_state_fixpt_mul_temp_282 & '0', 82);
  QGT_state_fixpt_sub_cast_329 <= resize(QGT_state_fixpt_sub_cast_328, 83);
  QGT_state_fixpt_sub_cast_330 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_283 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_330 - 1));
  QGT_state_fixpt_sub_cast_331 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_284 <= QGT_state_fixpt_mul_temp_283 * nc(to_integer(QGT_state_fixpt_sub_cast_331 - 1));
  QGT_state_fixpt_sub_cast_332 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_285 <= QGT_state_fixpt_mul_temp_284 * nc_0(to_integer(QGT_state_fixpt_sub_cast_332 - 1));
  QGT_state_fixpt_sub_cast_333 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_286 <= QGT_state_fixpt_mul_temp_285 * nc(to_integer(QGT_state_fixpt_sub_cast_333 - 1));
  QGT_state_fixpt_sub_cast_334 <= resize(QGT_state_fixpt_mul_temp_286 & '0', 82);
  QGT_state_fixpt_sub_cast_335 <= resize(QGT_state_fixpt_sub_cast_334, 83);
  QGT_state_fixpt_sub_temp_32 <= QGT_state_fixpt_sub_cast_329 - QGT_state_fixpt_sub_cast_335;
  QGT_state_fixpt_add_cast_71 <= resize(QGT_state_fixpt_sub_temp_32, 84);
  QGT_state_fixpt_sub_cast_336 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_287 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_336 - 1));
  QGT_state_fixpt_cast_126 <= QGT_state_fixpt_mul_temp_287(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_337 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_288 <= QGT_state_fixpt_cast_126 * nc(to_integer(QGT_state_fixpt_sub_cast_337 - 1));
  QGT_state_fixpt_sub_cast_338 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_289 <= QGT_state_fixpt_mul_temp_288 * nc_0(to_integer(QGT_state_fixpt_sub_cast_338 - 1));
  QGT_state_fixpt_sub_cast_339 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_290 <= QGT_state_fixpt_mul_temp_289 * nc_0(to_integer(QGT_state_fixpt_sub_cast_339 - 1));
  QGT_state_fixpt_add_cast_72 <= resize(QGT_state_fixpt_mul_temp_290, 81);
  QGT_state_fixpt_add_cast_73 <= resize(QGT_state_fixpt_add_cast_72, 84);
  QGT_state_fixpt_add_temp_25 <= QGT_state_fixpt_add_cast_71 + QGT_state_fixpt_add_cast_73;
  QGT_state_fixpt_sub_cast_340 <= resize(QGT_state_fixpt_add_temp_25, 85);
  QGT_state_fixpt_sub_cast_341 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_291 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_341 - 1));
  QGT_state_fixpt_cast_127 <= QGT_state_fixpt_mul_temp_291(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_342 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_292 <= QGT_state_fixpt_cast_127 * nc(to_integer(QGT_state_fixpt_sub_cast_342 - 1));
  QGT_state_fixpt_cast_128 <= resize(QGT_state_fixpt_mul_temp_292, 50);
  QGT_state_fixpt_cast_129 <=  - (QGT_state_fixpt_cast_128);
  QGT_state_fixpt_sub_cast_343 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_293 <= QGT_state_fixpt_cast_129 * nc_0(to_integer(QGT_state_fixpt_sub_cast_343 - 1));
  QGT_state_fixpt_sub_cast_344 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_294 <= QGT_state_fixpt_mul_temp_293 * nc(to_integer(QGT_state_fixpt_sub_cast_344 - 1));
  QGT_state_fixpt_sub_cast_345 <= resize(QGT_state_fixpt_mul_temp_294, 85);
  QGT_state_fixpt_sub_temp_33 <= QGT_state_fixpt_sub_cast_340 - QGT_state_fixpt_sub_cast_345;
  QGT_state_fixpt_cast_130 <= QGT_state_fixpt_sub_temp_33(73 DOWNTO 58);
  QGT_state_fixpt_sub_cast_346 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_295 <= QGT_state_fixpt_cast_130 * nc(to_integer(QGT_state_fixpt_sub_cast_346 - 1));
  QGT_state_fixpt_sub_cast_347 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_296 <= QGT_state_fixpt_mul_temp_295 * nc(to_integer(QGT_state_fixpt_sub_cast_347 - 1));
  QGT_state_fixpt_add_cast_74 <= resize(QGT_state_fixpt_mul_temp_296, 53);
  QGT_state_fixpt_add_temp_26 <= QGT_state_fixpt_add_cast_70 + QGT_state_fixpt_add_cast_74;
  QGT_state_fixpt_mul_temp_297 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_add_temp_26;
  QGT_state_fixpt_add_cast_75 <= QGT_state_fixpt_mul_temp_297(68 DOWNTO 0);
  QGT_state_fixpt_add_cast_76 <= resize(QGT_state_fixpt_add_cast_75, 71);
  QGT_state_fixpt_add_temp_27 <= QGT_state_fixpt_add_cast_55 + QGT_state_fixpt_add_cast_76;
  QGT_state_fixpt_c_im <= QGT_state_fixpt_add_temp_27(59 DOWNTO 44);
  QGT_state_fixpt_sub_cast_348 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_298 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_348 - 1));
  QGT_state_fixpt_cast_131 <= QGT_state_fixpt_mul_temp_298(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_349 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_299 <= QGT_state_fixpt_cast_131 * nc(to_integer(QGT_state_fixpt_sub_cast_349 - 1));
  QGT_state_fixpt_cast_132 <= resize(QGT_state_fixpt_mul_temp_299, 50);
  QGT_state_fixpt_cast_133 <=  - (QGT_state_fixpt_cast_132);
  QGT_state_fixpt_cast_134 <= resize(QGT_state_fixpt_cast_133, 51);
  QGT_state_fixpt_cast_135 <= resize(QGT_state_fixpt_cast_134, 52);
  QGT_state_fixpt_cast_136 <=  - (QGT_state_fixpt_cast_135);
  QGT_state_fixpt_cast_137 <= QGT_state_fixpt_cast_136(50 DOWNTO 0);
  QGT_state_fixpt_sub_cast_350 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_300 <= QGT_state_fixpt_cast_137 * nc_0(to_integer(QGT_state_fixpt_sub_cast_350 - 1));
  QGT_state_fixpt_sub_cast_351 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_301 <= QGT_state_fixpt_mul_temp_300 * nc_0(to_integer(QGT_state_fixpt_sub_cast_351 - 1));
  QGT_state_fixpt_sub_cast_352 <= resize(QGT_state_fixpt_mul_temp_301, 84);
  QGT_state_fixpt_sub_cast_353 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_302 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_353 - 1));
  QGT_state_fixpt_cast_138 <= QGT_state_fixpt_mul_temp_302(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_354 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_303 <= QGT_state_fixpt_cast_138 * nc(to_integer(QGT_state_fixpt_sub_cast_354 - 1));
  QGT_state_fixpt_cast_139 <= resize(QGT_state_fixpt_mul_temp_303, 50);
  QGT_state_fixpt_cast_140 <=  - (QGT_state_fixpt_cast_139);
  QGT_state_fixpt_sub_cast_355 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_304 <= QGT_state_fixpt_cast_140 * nc_0(to_integer(QGT_state_fixpt_sub_cast_355 - 1));
  QGT_state_fixpt_sub_cast_356 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_305 <= QGT_state_fixpt_mul_temp_304 * nc(to_integer(QGT_state_fixpt_sub_cast_356 - 1));
  QGT_state_fixpt_sub_cast_357 <= resize(QGT_state_fixpt_mul_temp_305, 84);
  QGT_state_fixpt_sub_temp_34 <= QGT_state_fixpt_sub_cast_352 - QGT_state_fixpt_sub_cast_357;
  QGT_state_fixpt_add_cast_77 <= resize(QGT_state_fixpt_sub_temp_34, 85);
  QGT_state_fixpt_sub_cast_358 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_306 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_358 - 1));
  QGT_state_fixpt_cast_141 <= QGT_state_fixpt_mul_temp_306(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_359 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_307 <= QGT_state_fixpt_cast_141 * nc_0(to_integer(QGT_state_fixpt_sub_cast_359 - 1));
  QGT_state_fixpt_sub_cast_360 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_308 <= QGT_state_fixpt_mul_temp_307 * nc(to_integer(QGT_state_fixpt_sub_cast_360 - 1));
  QGT_state_fixpt_sub_cast_361 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_309 <= QGT_state_fixpt_mul_temp_308 * nc(to_integer(QGT_state_fixpt_sub_cast_361 - 1));
  QGT_state_fixpt_add_cast_78 <= resize(QGT_state_fixpt_mul_temp_309, 81);
  QGT_state_fixpt_add_cast_79 <= resize(QGT_state_fixpt_add_cast_78, 85);
  QGT_state_fixpt_add_temp_28 <= QGT_state_fixpt_add_cast_77 + QGT_state_fixpt_add_cast_79;
  QGT_state_fixpt_add_cast_80 <= resize(QGT_state_fixpt_add_temp_28, 86);
  QGT_state_fixpt_sub_cast_362 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_310 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_362 - 1));
  QGT_state_fixpt_sub_cast_363 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_311 <= QGT_state_fixpt_mul_temp_310 * nc(to_integer(QGT_state_fixpt_sub_cast_363 - 1));
  QGT_state_fixpt_sub_cast_364 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_312 <= QGT_state_fixpt_mul_temp_311 * nc_0(to_integer(QGT_state_fixpt_sub_cast_364 - 1));
  QGT_state_fixpt_sub_cast_365 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_313 <= QGT_state_fixpt_mul_temp_312 * nc(to_integer(QGT_state_fixpt_sub_cast_365 - 1));
  QGT_state_fixpt_add_cast_81 <= resize(QGT_state_fixpt_mul_temp_313 & '0', 82);
  QGT_state_fixpt_add_cast_82 <= resize(QGT_state_fixpt_add_cast_81, 86);
  QGT_state_fixpt_add_temp_29 <= QGT_state_fixpt_add_cast_80 + QGT_state_fixpt_add_cast_82;
  QGT_state_fixpt_cast_142 <= QGT_state_fixpt_add_temp_29(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_314 <= to_signed(-16#5A83#, 16) * QGT_state_fixpt_cast_142;
  QGT_state_fixpt_cast_143 <= resize(QGT_state_fixpt_mul_temp_314, 33);
  QGT_state_fixpt_cast_144 <=  - (QGT_state_fixpt_cast_143);
  QGT_state_fixpt_sub_cast_366 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_315 <= QGT_state_fixpt_cast_144 * nc_0(to_integer(QGT_state_fixpt_sub_cast_366 - 1));
  QGT_state_fixpt_sub_cast_367 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_316 <= QGT_state_fixpt_mul_temp_315 * nc(to_integer(QGT_state_fixpt_sub_cast_367 - 1));
  QGT_state_fixpt_add_cast_83 <= resize(QGT_state_fixpt_mul_temp_316 & '0', 67);
  QGT_state_fixpt_sub_cast_368 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_317 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_368 - 1));
  QGT_state_fixpt_sub_cast_369 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_318 <= QGT_state_fixpt_mul_temp_317 * nc_0(to_integer(QGT_state_fixpt_sub_cast_369 - 1));
  QGT_state_fixpt_sub_cast_370 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_319 <= QGT_state_fixpt_mul_temp_318 * nc_0(to_integer(QGT_state_fixpt_sub_cast_370 - 1));
  QGT_state_fixpt_sub_cast_371 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_320 <= QGT_state_fixpt_mul_temp_319 * nc(to_integer(QGT_state_fixpt_sub_cast_371 - 1));
  QGT_state_fixpt_add_cast_84 <= resize(QGT_state_fixpt_mul_temp_320 & '0', 82);
  QGT_state_fixpt_add_cast_85 <= resize(QGT_state_fixpt_add_cast_84, 83);
  QGT_state_fixpt_sub_cast_372 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_321 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_372 - 1));
  QGT_state_fixpt_sub_cast_373 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_322 <= QGT_state_fixpt_mul_temp_321 * nc(to_integer(QGT_state_fixpt_sub_cast_373 - 1));
  QGT_state_fixpt_sub_cast_374 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_323 <= QGT_state_fixpt_mul_temp_322 * nc(to_integer(QGT_state_fixpt_sub_cast_374 - 1));
  QGT_state_fixpt_sub_cast_375 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_324 <= QGT_state_fixpt_mul_temp_323 * nc(to_integer(QGT_state_fixpt_sub_cast_375 - 1));
  QGT_state_fixpt_add_cast_86 <= resize(QGT_state_fixpt_mul_temp_324 & '0', 82);
  QGT_state_fixpt_add_cast_87 <= resize(QGT_state_fixpt_add_cast_86, 83);
  QGT_state_fixpt_add_temp_30 <= QGT_state_fixpt_add_cast_85 + QGT_state_fixpt_add_cast_87;
  QGT_state_fixpt_add_cast_88 <= resize(QGT_state_fixpt_add_temp_30, 84);
  QGT_state_fixpt_sub_cast_376 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_325 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_376 - 1));
  QGT_state_fixpt_cast_145 <= QGT_state_fixpt_mul_temp_325(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_377 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_326 <= QGT_state_fixpt_cast_145 * nc(to_integer(QGT_state_fixpt_sub_cast_377 - 1));
  QGT_state_fixpt_sub_cast_378 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_327 <= QGT_state_fixpt_mul_temp_326 * nc_0(to_integer(QGT_state_fixpt_sub_cast_378 - 1));
  QGT_state_fixpt_sub_cast_379 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_328 <= QGT_state_fixpt_mul_temp_327 * nc(to_integer(QGT_state_fixpt_sub_cast_379 - 1));
  QGT_state_fixpt_add_cast_89 <= resize(QGT_state_fixpt_mul_temp_328, 81);
  QGT_state_fixpt_add_cast_90 <= resize(QGT_state_fixpt_add_cast_89, 84);
  QGT_state_fixpt_add_temp_31 <= QGT_state_fixpt_add_cast_88 + QGT_state_fixpt_add_cast_90;
  QGT_state_fixpt_add_cast_91 <= resize(QGT_state_fixpt_add_temp_31, 85);
  QGT_state_fixpt_sub_cast_380 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_329 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_380 - 1));
  QGT_state_fixpt_cast_146 <= QGT_state_fixpt_mul_temp_329(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_381 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_330 <= QGT_state_fixpt_cast_146 * nc(to_integer(QGT_state_fixpt_sub_cast_381 - 1));
  QGT_state_fixpt_cast_147 <= resize(QGT_state_fixpt_mul_temp_330, 50);
  QGT_state_fixpt_cast_148 <=  - (QGT_state_fixpt_cast_147);
  QGT_state_fixpt_sub_cast_382 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_331 <= QGT_state_fixpt_cast_148 * nc_0(to_integer(QGT_state_fixpt_sub_cast_382 - 1));
  QGT_state_fixpt_sub_cast_383 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_332 <= QGT_state_fixpt_mul_temp_331 * nc_0(to_integer(QGT_state_fixpt_sub_cast_383 - 1));
  QGT_state_fixpt_add_cast_92 <= resize(QGT_state_fixpt_mul_temp_332, 85);
  QGT_state_fixpt_add_temp_32 <= QGT_state_fixpt_add_cast_91 + QGT_state_fixpt_add_cast_92;
  QGT_state_fixpt_cast_149 <= QGT_state_fixpt_add_temp_32(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_333 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_149;
  QGT_state_fixpt_cast_150 <= QGT_state_fixpt_mul_temp_333(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_384 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_334 <= QGT_state_fixpt_cast_150 * nc(to_integer(QGT_state_fixpt_sub_cast_384 - 1));
  QGT_state_fixpt_sub_cast_385 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_335 <= QGT_state_fixpt_mul_temp_334 * nc(to_integer(QGT_state_fixpt_sub_cast_385 - 1));
  QGT_state_fixpt_add_cast_93 <= resize(QGT_state_fixpt_mul_temp_335, 67);
  QGT_state_fixpt_add_temp_33 <= QGT_state_fixpt_add_cast_83 + QGT_state_fixpt_add_cast_93;
  QGT_state_fixpt_sub_cast_386 <= resize(QGT_state_fixpt_add_temp_33, 68);
  QGT_state_fixpt_sub_cast_387 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_336 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_387 - 1));
  QGT_state_fixpt_sub_cast_388 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_337 <= QGT_state_fixpt_mul_temp_336 * nc_0(to_integer(QGT_state_fixpt_sub_cast_388 - 1));
  QGT_state_fixpt_cast_151 <= resize(QGT_state_fixpt_mul_temp_337 & '0', 51);
  QGT_state_fixpt_cast_152 <= resize(QGT_state_fixpt_cast_151, 52);
  QGT_state_fixpt_cast_153 <=  - (QGT_state_fixpt_cast_152);
  QGT_state_fixpt_cast_154 <= QGT_state_fixpt_cast_153(50 DOWNTO 0);
  QGT_state_fixpt_sub_cast_389 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_338 <= QGT_state_fixpt_cast_154 * nc_0(to_integer(QGT_state_fixpt_sub_cast_389 - 1));
  QGT_state_fixpt_sub_cast_390 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_339 <= QGT_state_fixpt_mul_temp_338 * nc(to_integer(QGT_state_fixpt_sub_cast_390 - 1));
  QGT_state_fixpt_add_cast_94 <= resize(QGT_state_fixpt_mul_temp_339, 84);
  QGT_state_fixpt_sub_cast_391 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_340 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_391 - 1));
  QGT_state_fixpt_sub_cast_392 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_341 <= QGT_state_fixpt_mul_temp_340 * nc(to_integer(QGT_state_fixpt_sub_cast_392 - 1));
  QGT_state_fixpt_sub_cast_393 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_342 <= QGT_state_fixpt_mul_temp_341 * nc_0(to_integer(QGT_state_fixpt_sub_cast_393 - 1));
  QGT_state_fixpt_sub_cast_394 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_343 <= QGT_state_fixpt_mul_temp_342 * nc_0(to_integer(QGT_state_fixpt_sub_cast_394 - 1));
  QGT_state_fixpt_add_cast_95 <= resize(QGT_state_fixpt_mul_temp_343 & '0', 82);
  QGT_state_fixpt_add_cast_96 <= resize(QGT_state_fixpt_add_cast_95, 84);
  QGT_state_fixpt_add_temp_34 <= QGT_state_fixpt_add_cast_94 + QGT_state_fixpt_add_cast_96;
  QGT_state_fixpt_sub_cast_395 <= resize(QGT_state_fixpt_add_temp_34, 85);
  QGT_state_fixpt_sub_cast_396 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_344 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_396 - 1));
  QGT_state_fixpt_cast_155 <= QGT_state_fixpt_mul_temp_344(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_397 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_345 <= QGT_state_fixpt_cast_155 * nc(to_integer(QGT_state_fixpt_sub_cast_397 - 1));
  QGT_state_fixpt_sub_cast_398 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_346 <= QGT_state_fixpt_mul_temp_345 * nc_0(to_integer(QGT_state_fixpt_sub_cast_398 - 1));
  QGT_state_fixpt_sub_cast_399 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_347 <= QGT_state_fixpt_mul_temp_346 * nc(to_integer(QGT_state_fixpt_sub_cast_399 - 1));
  QGT_state_fixpt_sub_cast_400 <= resize(QGT_state_fixpt_mul_temp_347, 81);
  QGT_state_fixpt_sub_cast_401 <= resize(QGT_state_fixpt_sub_cast_400, 85);
  QGT_state_fixpt_sub_temp_35 <= QGT_state_fixpt_sub_cast_395 - QGT_state_fixpt_sub_cast_401;
  QGT_state_fixpt_add_cast_97 <= resize(QGT_state_fixpt_sub_temp_35, 86);
  QGT_state_fixpt_sub_cast_402 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_348 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_402 - 1));
  QGT_state_fixpt_cast_156 <= QGT_state_fixpt_mul_temp_348(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_403 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_349 <= QGT_state_fixpt_cast_156 * nc(to_integer(QGT_state_fixpt_sub_cast_403 - 1));
  QGT_state_fixpt_cast_157 <= resize(QGT_state_fixpt_mul_temp_349, 50);
  QGT_state_fixpt_cast_158 <=  - (QGT_state_fixpt_cast_157);
  QGT_state_fixpt_sub_cast_404 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_350 <= QGT_state_fixpt_cast_158 * nc(to_integer(QGT_state_fixpt_sub_cast_404 - 1));
  QGT_state_fixpt_sub_cast_405 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_351 <= QGT_state_fixpt_mul_temp_350 * nc(to_integer(QGT_state_fixpt_sub_cast_405 - 1));
  QGT_state_fixpt_add_cast_98 <= resize(QGT_state_fixpt_mul_temp_351, 86);
  QGT_state_fixpt_add_temp_35 <= QGT_state_fixpt_add_cast_97 + QGT_state_fixpt_add_cast_98;
  QGT_state_fixpt_cast_159 <= QGT_state_fixpt_add_temp_35(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_352 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_159;
  QGT_state_fixpt_cast_160 <= QGT_state_fixpt_mul_temp_352(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_406 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_353 <= QGT_state_fixpt_cast_160 * nc_0(to_integer(QGT_state_fixpt_sub_cast_406 - 1));
  QGT_state_fixpt_sub_cast_407 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_354 <= QGT_state_fixpt_mul_temp_353 * nc_0(to_integer(QGT_state_fixpt_sub_cast_407 - 1));
  QGT_state_fixpt_sub_cast_408 <= resize(QGT_state_fixpt_mul_temp_354, 68);
  QGT_state_fixpt_sub_temp_36 <= QGT_state_fixpt_sub_cast_386 - QGT_state_fixpt_sub_cast_408;
  QGT_state_fixpt_sub_cast_409 <= resize(QGT_state_fixpt_sub_temp_36, 69);
  QGT_state_fixpt_sub_cast_410 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_355 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_410 - 1));
  QGT_state_fixpt_cast_161 <= QGT_state_fixpt_mul_temp_355(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_411 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_356 <= QGT_state_fixpt_cast_161 * nc(to_integer(QGT_state_fixpt_sub_cast_411 - 1));
  QGT_state_fixpt_cast_162 <= resize(QGT_state_fixpt_mul_temp_356, 50);
  QGT_state_fixpt_cast_163 <=  - (QGT_state_fixpt_cast_162);
  QGT_state_fixpt_sub_cast_412 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_357 <= QGT_state_fixpt_cast_163 * nc(to_integer(QGT_state_fixpt_sub_cast_412 - 1));
  QGT_state_fixpt_sub_cast_413 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_358 <= QGT_state_fixpt_mul_temp_357 * nc(to_integer(QGT_state_fixpt_sub_cast_413 - 1));
  QGT_state_fixpt_sub_cast_414 <= resize(QGT_state_fixpt_mul_temp_358, 83);
  QGT_state_fixpt_sub_cast_415 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_359 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_415 - 1));
  QGT_state_fixpt_cast_164 <= QGT_state_fixpt_mul_temp_359(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_416 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_360 <= QGT_state_fixpt_cast_164 * nc(to_integer(QGT_state_fixpt_sub_cast_416 - 1));
  QGT_state_fixpt_cast_165 <= resize(QGT_state_fixpt_mul_temp_360, 50);
  QGT_state_fixpt_cast_166 <=  - (QGT_state_fixpt_cast_165);
  QGT_state_fixpt_sub_cast_417 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_361 <= QGT_state_fixpt_cast_166 * nc_0(to_integer(QGT_state_fixpt_sub_cast_417 - 1));
  QGT_state_fixpt_sub_cast_418 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_362 <= QGT_state_fixpt_mul_temp_361 * nc(to_integer(QGT_state_fixpt_sub_cast_418 - 1));
  QGT_state_fixpt_sub_cast_419 <= resize(QGT_state_fixpt_mul_temp_362, 83);
  QGT_state_fixpt_sub_temp_37 <= QGT_state_fixpt_sub_cast_414 - QGT_state_fixpt_sub_cast_419;
  QGT_state_fixpt_sub_cast_420 <= resize(QGT_state_fixpt_sub_temp_37, 84);
  QGT_state_fixpt_sub_cast_421 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_363 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_421 - 1));
  QGT_state_fixpt_cast_167 <= QGT_state_fixpt_mul_temp_363(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_422 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_364 <= QGT_state_fixpt_cast_167 * nc_0(to_integer(QGT_state_fixpt_sub_cast_422 - 1));
  QGT_state_fixpt_sub_cast_423 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_365 <= QGT_state_fixpt_mul_temp_364 * nc_0(to_integer(QGT_state_fixpt_sub_cast_423 - 1));
  QGT_state_fixpt_sub_cast_424 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_366 <= QGT_state_fixpt_mul_temp_365 * nc_0(to_integer(QGT_state_fixpt_sub_cast_424 - 1));
  QGT_state_fixpt_sub_cast_425 <= resize(QGT_state_fixpt_mul_temp_366, 81);
  QGT_state_fixpt_sub_cast_426 <= resize(QGT_state_fixpt_sub_cast_425, 84);
  QGT_state_fixpt_sub_temp_38 <= QGT_state_fixpt_sub_cast_420 - QGT_state_fixpt_sub_cast_426;
  QGT_state_fixpt_add_cast_99 <= resize(QGT_state_fixpt_sub_temp_38, 85);
  QGT_state_fixpt_sub_cast_427 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_367 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_427 - 1));
  QGT_state_fixpt_sub_cast_428 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_368 <= QGT_state_fixpt_mul_temp_367 * nc(to_integer(QGT_state_fixpt_sub_cast_428 - 1));
  QGT_state_fixpt_sub_cast_429 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_369 <= QGT_state_fixpt_mul_temp_368 * nc_0(to_integer(QGT_state_fixpt_sub_cast_429 - 1));
  QGT_state_fixpt_sub_cast_430 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_370 <= QGT_state_fixpt_mul_temp_369 * nc(to_integer(QGT_state_fixpt_sub_cast_430 - 1));
  QGT_state_fixpt_add_cast_100 <= resize(QGT_state_fixpt_mul_temp_370 & '0', 82);
  QGT_state_fixpt_add_cast_101 <= resize(QGT_state_fixpt_add_cast_100, 85);
  QGT_state_fixpt_add_temp_36 <= QGT_state_fixpt_add_cast_99 + QGT_state_fixpt_add_cast_101;
  QGT_state_fixpt_cast_168 <= QGT_state_fixpt_add_temp_36(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_371 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_168;
  QGT_state_fixpt_cast_169 <= QGT_state_fixpt_mul_temp_371(31 DOWNTO 0);
  QGT_state_fixpt_cast_170 <= resize(QGT_state_fixpt_cast_169, 33);
  QGT_state_fixpt_cast_171 <=  - (QGT_state_fixpt_cast_170);
  QGT_state_fixpt_sub_cast_431 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_372 <= QGT_state_fixpt_cast_171 * nc_0(to_integer(QGT_state_fixpt_sub_cast_431 - 1));
  QGT_state_fixpt_sub_cast_432 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_373 <= QGT_state_fixpt_mul_temp_372 * nc(to_integer(QGT_state_fixpt_sub_cast_432 - 1));
  QGT_state_fixpt_sub_cast_433 <= resize(QGT_state_fixpt_mul_temp_373, 69);
  QGT_state_fixpt_sub_temp_39 <= QGT_state_fixpt_sub_cast_409 - QGT_state_fixpt_sub_cast_433;
  QGT_state_fixpt_add_cast_102 <= resize(QGT_state_fixpt_sub_temp_39, 72);
  QGT_state_fixpt_sub_cast_434 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_374 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_434 - 1));
  QGT_state_fixpt_sub_cast_435 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_375 <= QGT_state_fixpt_mul_temp_374 * nc_0(to_integer(QGT_state_fixpt_sub_cast_435 - 1));
  QGT_state_fixpt_cast_172 <= resize(QGT_state_fixpt_mul_temp_375 & '0', 51);
  QGT_state_fixpt_cast_173 <= resize(QGT_state_fixpt_cast_172, 52);
  QGT_state_fixpt_cast_174 <=  - (QGT_state_fixpt_cast_173);
  QGT_state_fixpt_cast_175 <= QGT_state_fixpt_cast_174(50 DOWNTO 0);
  QGT_state_fixpt_sub_cast_436 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_376 <= QGT_state_fixpt_cast_175 * nc_0(to_integer(QGT_state_fixpt_sub_cast_436 - 1));
  QGT_state_fixpt_sub_cast_437 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_377 <= QGT_state_fixpt_mul_temp_376 * nc_0(to_integer(QGT_state_fixpt_sub_cast_437 - 1));
  QGT_state_fixpt_sub_cast_438 <= resize(QGT_state_fixpt_mul_temp_377, 84);
  QGT_state_fixpt_sub_cast_439 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_378 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_439 - 1));
  QGT_state_fixpt_sub_cast_440 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_379 <= QGT_state_fixpt_mul_temp_378 * nc(to_integer(QGT_state_fixpt_sub_cast_440 - 1));
  QGT_state_fixpt_sub_cast_441 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_380 <= QGT_state_fixpt_mul_temp_379 * nc_0(to_integer(QGT_state_fixpt_sub_cast_441 - 1));
  QGT_state_fixpt_sub_cast_442 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_381 <= QGT_state_fixpt_mul_temp_380 * nc(to_integer(QGT_state_fixpt_sub_cast_442 - 1));
  QGT_state_fixpt_sub_cast_443 <= resize(QGT_state_fixpt_mul_temp_381 & '0', 82);
  QGT_state_fixpt_sub_cast_444 <= resize(QGT_state_fixpt_sub_cast_443, 84);
  QGT_state_fixpt_sub_temp_40 <= QGT_state_fixpt_sub_cast_438 - QGT_state_fixpt_sub_cast_444;
  QGT_state_fixpt_add_cast_103 <= resize(QGT_state_fixpt_sub_temp_40, 85);
  QGT_state_fixpt_sub_cast_445 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_382 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_445 - 1));
  QGT_state_fixpt_cast_176 <= QGT_state_fixpt_mul_temp_382(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_446 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_383 <= QGT_state_fixpt_cast_176 * nc(to_integer(QGT_state_fixpt_sub_cast_446 - 1));
  QGT_state_fixpt_sub_cast_447 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_384 <= QGT_state_fixpt_mul_temp_383 * nc(to_integer(QGT_state_fixpt_sub_cast_447 - 1));
  QGT_state_fixpt_sub_cast_448 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_385 <= QGT_state_fixpt_mul_temp_384 * nc(to_integer(QGT_state_fixpt_sub_cast_448 - 1));
  QGT_state_fixpt_add_cast_104 <= resize(QGT_state_fixpt_mul_temp_385, 81);
  QGT_state_fixpt_add_cast_105 <= resize(QGT_state_fixpt_add_cast_104, 85);
  QGT_state_fixpt_add_temp_37 <= QGT_state_fixpt_add_cast_103 + QGT_state_fixpt_add_cast_105;
  QGT_state_fixpt_add_cast_106 <= resize(QGT_state_fixpt_add_temp_37, 86);
  QGT_state_fixpt_sub_cast_449 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_386 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_449 - 1));
  QGT_state_fixpt_cast_177 <= QGT_state_fixpt_mul_temp_386(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_450 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_387 <= QGT_state_fixpt_cast_177 * nc(to_integer(QGT_state_fixpt_sub_cast_450 - 1));
  QGT_state_fixpt_cast_178 <= resize(QGT_state_fixpt_mul_temp_387, 50);
  QGT_state_fixpt_cast_179 <=  - (QGT_state_fixpt_cast_178);
  QGT_state_fixpt_sub_cast_451 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_388 <= QGT_state_fixpt_cast_179 * nc_0(to_integer(QGT_state_fixpt_sub_cast_451 - 1));
  QGT_state_fixpt_sub_cast_452 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_389 <= QGT_state_fixpt_mul_temp_388 * nc(to_integer(QGT_state_fixpt_sub_cast_452 - 1));
  QGT_state_fixpt_add_cast_107 <= resize(QGT_state_fixpt_mul_temp_389, 86);
  QGT_state_fixpt_add_temp_38 <= QGT_state_fixpt_add_cast_106 + QGT_state_fixpt_add_cast_107;
  QGT_state_fixpt_cast_180 <= QGT_state_fixpt_add_temp_38(73 DOWNTO 58);
  QGT_state_fixpt_cast_181 <= resize(QGT_state_fixpt_cast_180, 17);
  QGT_state_fixpt_cast_182 <=  - (QGT_state_fixpt_cast_181);
  QGT_state_fixpt_cast_183 <= resize(QGT_state_fixpt_cast_182, 18);
  QGT_state_fixpt_sub_cast_453 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_390 <= QGT_state_fixpt_cast_183 * nc_0(to_integer(QGT_state_fixpt_sub_cast_453 - 1));
  QGT_state_fixpt_sub_cast_454 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_391 <= QGT_state_fixpt_mul_temp_390 * nc(to_integer(QGT_state_fixpt_sub_cast_454 - 1));
  QGT_state_fixpt_sub_cast_455 <= resize(QGT_state_fixpt_mul_temp_391, 51);
  QGT_state_fixpt_sub_cast_456 <= resize(QGT_state_fixpt_sub_cast_455, 52);
  QGT_state_fixpt_sub_cast_457 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_392 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_457 - 1));
  QGT_state_fixpt_cast_184 <= QGT_state_fixpt_mul_temp_392(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_458 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_393 <= QGT_state_fixpt_cast_184 * nc(to_integer(QGT_state_fixpt_sub_cast_458 - 1));
  QGT_state_fixpt_cast_185 <= resize(QGT_state_fixpt_mul_temp_393, 50);
  QGT_state_fixpt_cast_186 <=  - (QGT_state_fixpt_cast_185);
  QGT_state_fixpt_sub_cast_459 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_394 <= QGT_state_fixpt_cast_186 * nc_0(to_integer(QGT_state_fixpt_sub_cast_459 - 1));
  QGT_state_fixpt_sub_cast_460 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_395 <= QGT_state_fixpt_mul_temp_394 * nc(to_integer(QGT_state_fixpt_sub_cast_460 - 1));
  QGT_state_fixpt_add_cast_108 <= resize(QGT_state_fixpt_mul_temp_395, 83);
  QGT_state_fixpt_sub_cast_461 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_396 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_461 - 1));
  QGT_state_fixpt_cast_187 <= QGT_state_fixpt_mul_temp_396(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_462 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_397 <= QGT_state_fixpt_cast_187 * nc(to_integer(QGT_state_fixpt_sub_cast_462 - 1));
  QGT_state_fixpt_cast_188 <= resize(QGT_state_fixpt_mul_temp_397, 50);
  QGT_state_fixpt_cast_189 <=  - (QGT_state_fixpt_cast_188);
  QGT_state_fixpt_sub_cast_463 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_398 <= QGT_state_fixpt_cast_189 * nc(to_integer(QGT_state_fixpt_sub_cast_463 - 1));
  QGT_state_fixpt_sub_cast_464 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_399 <= QGT_state_fixpt_mul_temp_398 * nc(to_integer(QGT_state_fixpt_sub_cast_464 - 1));
  QGT_state_fixpt_add_cast_109 <= resize(QGT_state_fixpt_mul_temp_399, 83);
  QGT_state_fixpt_add_temp_39 <= QGT_state_fixpt_add_cast_108 + QGT_state_fixpt_add_cast_109;
  QGT_state_fixpt_add_cast_110 <= resize(QGT_state_fixpt_add_temp_39, 84);
  QGT_state_fixpt_sub_cast_465 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_400 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_465 - 1));
  QGT_state_fixpt_cast_190 <= QGT_state_fixpt_mul_temp_400(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_466 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_401 <= QGT_state_fixpt_cast_190 * nc_0(to_integer(QGT_state_fixpt_sub_cast_466 - 1));
  QGT_state_fixpt_sub_cast_467 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_402 <= QGT_state_fixpt_mul_temp_401 * nc_0(to_integer(QGT_state_fixpt_sub_cast_467 - 1));
  QGT_state_fixpt_sub_cast_468 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_403 <= QGT_state_fixpt_mul_temp_402 * nc(to_integer(QGT_state_fixpt_sub_cast_468 - 1));
  QGT_state_fixpt_add_cast_111 <= resize(QGT_state_fixpt_mul_temp_403, 81);
  QGT_state_fixpt_add_cast_112 <= resize(QGT_state_fixpt_add_cast_111, 84);
  QGT_state_fixpt_add_temp_40 <= QGT_state_fixpt_add_cast_110 + QGT_state_fixpt_add_cast_112;
  QGT_state_fixpt_add_cast_113 <= resize(QGT_state_fixpt_add_temp_40, 85);
  QGT_state_fixpt_sub_cast_469 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_404 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_469 - 1));
  QGT_state_fixpt_sub_cast_470 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_405 <= QGT_state_fixpt_mul_temp_404 * nc(to_integer(QGT_state_fixpt_sub_cast_470 - 1));
  QGT_state_fixpt_sub_cast_471 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_406 <= QGT_state_fixpt_mul_temp_405 * nc_0(to_integer(QGT_state_fixpt_sub_cast_471 - 1));
  QGT_state_fixpt_sub_cast_472 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_407 <= QGT_state_fixpt_mul_temp_406 * nc_0(to_integer(QGT_state_fixpt_sub_cast_472 - 1));
  QGT_state_fixpt_add_cast_114 <= resize(QGT_state_fixpt_mul_temp_407 & '0', 82);
  QGT_state_fixpt_add_cast_115 <= resize(QGT_state_fixpt_add_cast_114, 85);
  QGT_state_fixpt_add_temp_41 <= QGT_state_fixpt_add_cast_113 + QGT_state_fixpt_add_cast_115;
  QGT_state_fixpt_cast_191 <= QGT_state_fixpt_add_temp_41(73 DOWNTO 58);
  QGT_state_fixpt_sub_cast_473 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_408 <= QGT_state_fixpt_cast_191 * nc_0(to_integer(QGT_state_fixpt_sub_cast_473 - 1));
  QGT_state_fixpt_sub_cast_474 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_409 <= QGT_state_fixpt_mul_temp_408 * nc_0(to_integer(QGT_state_fixpt_sub_cast_474 - 1));
  QGT_state_fixpt_sub_cast_475 <= resize(QGT_state_fixpt_mul_temp_409, 52);
  QGT_state_fixpt_sub_temp_41 <= QGT_state_fixpt_sub_cast_456 - QGT_state_fixpt_sub_cast_475;
  QGT_state_fixpt_add_cast_116 <= resize(QGT_state_fixpt_sub_temp_41, 53);
  QGT_state_fixpt_sub_cast_476 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_410 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_476 - 1));
  QGT_state_fixpt_cast_192 <= QGT_state_fixpt_mul_temp_410(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_477 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_411 <= QGT_state_fixpt_cast_192 * nc(to_integer(QGT_state_fixpt_sub_cast_477 - 1));
  QGT_state_fixpt_cast_193 <= resize(QGT_state_fixpt_mul_temp_411, 50);
  QGT_state_fixpt_cast_194 <=  - (QGT_state_fixpt_cast_193);
  QGT_state_fixpt_cast_195 <= resize(QGT_state_fixpt_cast_194, 51);
  QGT_state_fixpt_cast_196 <= resize(QGT_state_fixpt_cast_195, 52);
  QGT_state_fixpt_cast_197 <=  - (QGT_state_fixpt_cast_196);
  QGT_state_fixpt_cast_198 <= QGT_state_fixpt_cast_197(50 DOWNTO 0);
  QGT_state_fixpt_sub_cast_478 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_412 <= QGT_state_fixpt_cast_198 * nc_0(to_integer(QGT_state_fixpt_sub_cast_478 - 1));
  QGT_state_fixpt_sub_cast_479 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_413 <= QGT_state_fixpt_mul_temp_412 * nc(to_integer(QGT_state_fixpt_sub_cast_479 - 1));
  QGT_state_fixpt_add_cast_117 <= resize(QGT_state_fixpt_mul_temp_413, 84);
  QGT_state_fixpt_sub_cast_480 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_414 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_480 - 1));
  QGT_state_fixpt_cast_199 <= QGT_state_fixpt_mul_temp_414(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_481 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_415 <= QGT_state_fixpt_cast_199 * nc(to_integer(QGT_state_fixpt_sub_cast_481 - 1));
  QGT_state_fixpt_cast_200 <= resize(QGT_state_fixpt_mul_temp_415, 50);
  QGT_state_fixpt_cast_201 <=  - (QGT_state_fixpt_cast_200);
  QGT_state_fixpt_sub_cast_482 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_416 <= QGT_state_fixpt_cast_201 * nc_0(to_integer(QGT_state_fixpt_sub_cast_482 - 1));
  QGT_state_fixpt_sub_cast_483 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_417 <= QGT_state_fixpt_mul_temp_416 * nc_0(to_integer(QGT_state_fixpt_sub_cast_483 - 1));
  QGT_state_fixpt_add_cast_118 <= resize(QGT_state_fixpt_mul_temp_417, 84);
  QGT_state_fixpt_add_temp_42 <= QGT_state_fixpt_add_cast_117 + QGT_state_fixpt_add_cast_118;
  QGT_state_fixpt_sub_cast_484 <= resize(QGT_state_fixpt_add_temp_42, 85);
  QGT_state_fixpt_sub_cast_485 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_418 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_485 - 1));
  QGT_state_fixpt_cast_202 <= QGT_state_fixpt_mul_temp_418(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_486 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_419 <= QGT_state_fixpt_cast_202 * nc_0(to_integer(QGT_state_fixpt_sub_cast_486 - 1));
  QGT_state_fixpt_sub_cast_487 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_420 <= QGT_state_fixpt_mul_temp_419 * nc_0(to_integer(QGT_state_fixpt_sub_cast_487 - 1));
  QGT_state_fixpt_sub_cast_488 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_421 <= QGT_state_fixpt_mul_temp_420 * nc(to_integer(QGT_state_fixpt_sub_cast_488 - 1));
  QGT_state_fixpt_sub_cast_489 <= resize(QGT_state_fixpt_mul_temp_421, 81);
  QGT_state_fixpt_sub_cast_490 <= resize(QGT_state_fixpt_sub_cast_489, 85);
  QGT_state_fixpt_sub_temp_42 <= QGT_state_fixpt_sub_cast_484 - QGT_state_fixpt_sub_cast_490;
  QGT_state_fixpt_add_cast_119 <= resize(QGT_state_fixpt_sub_temp_42, 86);
  QGT_state_fixpt_sub_cast_491 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_422 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_491 - 1));
  QGT_state_fixpt_sub_cast_492 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_423 <= QGT_state_fixpt_mul_temp_422 * nc(to_integer(QGT_state_fixpt_sub_cast_492 - 1));
  QGT_state_fixpt_sub_cast_493 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_424 <= QGT_state_fixpt_mul_temp_423 * nc(to_integer(QGT_state_fixpt_sub_cast_493 - 1));
  QGT_state_fixpt_sub_cast_494 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_425 <= QGT_state_fixpt_mul_temp_424 * nc(to_integer(QGT_state_fixpt_sub_cast_494 - 1));
  QGT_state_fixpt_add_cast_120 <= resize(QGT_state_fixpt_mul_temp_425 & '0', 82);
  QGT_state_fixpt_add_cast_121 <= resize(QGT_state_fixpt_add_cast_120, 86);
  QGT_state_fixpt_add_temp_43 <= QGT_state_fixpt_add_cast_119 + QGT_state_fixpt_add_cast_121;
  QGT_state_fixpt_cast_203 <= QGT_state_fixpt_add_temp_43(73 DOWNTO 58);
  QGT_state_fixpt_sub_cast_495 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_426 <= QGT_state_fixpt_cast_203 * nc(to_integer(QGT_state_fixpt_sub_cast_495 - 1));
  QGT_state_fixpt_sub_cast_496 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_427 <= QGT_state_fixpt_mul_temp_426 * nc(to_integer(QGT_state_fixpt_sub_cast_496 - 1));
  QGT_state_fixpt_add_cast_122 <= resize(QGT_state_fixpt_mul_temp_427, 53);
  QGT_state_fixpt_add_temp_44 <= QGT_state_fixpt_add_cast_116 + QGT_state_fixpt_add_cast_122;
  QGT_state_fixpt_sub_cast_497 <= resize(QGT_state_fixpt_add_temp_44, 54);
  QGT_state_fixpt_sub_cast_498 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_428 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_498 - 1));
  QGT_state_fixpt_sub_cast_499 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_429 <= QGT_state_fixpt_mul_temp_428 * nc_0(to_integer(QGT_state_fixpt_sub_cast_499 - 1));
  QGT_state_fixpt_sub_cast_500 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_430 <= QGT_state_fixpt_mul_temp_429 * nc(to_integer(QGT_state_fixpt_sub_cast_500 - 1));
  QGT_state_fixpt_sub_cast_501 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_431 <= QGT_state_fixpt_mul_temp_430 * nc(to_integer(QGT_state_fixpt_sub_cast_501 - 1));
  QGT_state_fixpt_sub_cast_502 <= resize(QGT_state_fixpt_mul_temp_431 & '0', 82);
  QGT_state_fixpt_sub_cast_503 <= resize(QGT_state_fixpt_sub_cast_502, 83);
  QGT_state_fixpt_sub_cast_504 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_432 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_504 - 1));
  QGT_state_fixpt_sub_cast_505 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_433 <= QGT_state_fixpt_mul_temp_432 * nc(to_integer(QGT_state_fixpt_sub_cast_505 - 1));
  QGT_state_fixpt_sub_cast_506 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_434 <= QGT_state_fixpt_mul_temp_433 * nc_0(to_integer(QGT_state_fixpt_sub_cast_506 - 1));
  QGT_state_fixpt_sub_cast_507 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_435 <= QGT_state_fixpt_mul_temp_434 * nc(to_integer(QGT_state_fixpt_sub_cast_507 - 1));
  QGT_state_fixpt_sub_cast_508 <= resize(QGT_state_fixpt_mul_temp_435 & '0', 82);
  QGT_state_fixpt_sub_cast_509 <= resize(QGT_state_fixpt_sub_cast_508, 83);
  QGT_state_fixpt_sub_temp_43 <= QGT_state_fixpt_sub_cast_503 - QGT_state_fixpt_sub_cast_509;
  QGT_state_fixpt_sub_cast_510 <= resize(QGT_state_fixpt_sub_temp_43, 84);
  QGT_state_fixpt_sub_cast_511 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_436 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_511 - 1));
  QGT_state_fixpt_cast_204 <= QGT_state_fixpt_mul_temp_436(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_512 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_437 <= QGT_state_fixpt_cast_204 * nc(to_integer(QGT_state_fixpt_sub_cast_512 - 1));
  QGT_state_fixpt_sub_cast_513 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_438 <= QGT_state_fixpt_mul_temp_437 * nc_0(to_integer(QGT_state_fixpt_sub_cast_513 - 1));
  QGT_state_fixpt_sub_cast_514 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_439 <= QGT_state_fixpt_mul_temp_438 * nc_0(to_integer(QGT_state_fixpt_sub_cast_514 - 1));
  QGT_state_fixpt_sub_cast_515 <= resize(QGT_state_fixpt_mul_temp_439, 81);
  QGT_state_fixpt_sub_cast_516 <= resize(QGT_state_fixpt_sub_cast_515, 84);
  QGT_state_fixpt_sub_temp_44 <= QGT_state_fixpt_sub_cast_510 - QGT_state_fixpt_sub_cast_516;
  QGT_state_fixpt_add_cast_123 <= resize(QGT_state_fixpt_sub_temp_44, 85);
  QGT_state_fixpt_sub_cast_517 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_440 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_517 - 1));
  QGT_state_fixpt_cast_205 <= QGT_state_fixpt_mul_temp_440(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_518 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_441 <= QGT_state_fixpt_cast_205 * nc(to_integer(QGT_state_fixpt_sub_cast_518 - 1));
  QGT_state_fixpt_cast_206 <= resize(QGT_state_fixpt_mul_temp_441, 50);
  QGT_state_fixpt_cast_207 <=  - (QGT_state_fixpt_cast_206);
  QGT_state_fixpt_sub_cast_519 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_442 <= QGT_state_fixpt_cast_207 * nc_0(to_integer(QGT_state_fixpt_sub_cast_519 - 1));
  QGT_state_fixpt_sub_cast_520 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_443 <= QGT_state_fixpt_mul_temp_442 * nc(to_integer(QGT_state_fixpt_sub_cast_520 - 1));
  QGT_state_fixpt_add_cast_124 <= resize(QGT_state_fixpt_mul_temp_443, 85);
  QGT_state_fixpt_add_temp_45 <= QGT_state_fixpt_add_cast_123 + QGT_state_fixpt_add_cast_124;
  QGT_state_fixpt_cast_208 <= QGT_state_fixpt_add_temp_45(73 DOWNTO 58);
  QGT_state_fixpt_sub_cast_521 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_444 <= QGT_state_fixpt_cast_208 * nc_0(to_integer(QGT_state_fixpt_sub_cast_521 - 1));
  QGT_state_fixpt_sub_cast_522 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_445 <= QGT_state_fixpt_mul_temp_444 * nc(to_integer(QGT_state_fixpt_sub_cast_522 - 1));
  QGT_state_fixpt_sub_cast_523 <= resize(QGT_state_fixpt_mul_temp_445, 50);
  QGT_state_fixpt_sub_cast_524 <= resize(QGT_state_fixpt_sub_cast_523, 54);
  QGT_state_fixpt_sub_temp_45 <= QGT_state_fixpt_sub_cast_497 - QGT_state_fixpt_sub_cast_524;
  QGT_state_fixpt_mul_temp_446 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_sub_temp_45;
  QGT_state_fixpt_cast_209 <= QGT_state_fixpt_mul_temp_446(69 DOWNTO 0);
  QGT_state_fixpt_cast_210 <= resize(QGT_state_fixpt_cast_209, 71);
  QGT_state_fixpt_cast_211 <=  - (QGT_state_fixpt_cast_210);
  QGT_state_fixpt_add_cast_125 <= resize(QGT_state_fixpt_cast_211, 72);
  QGT_state_fixpt_add_temp_46 <= QGT_state_fixpt_add_cast_102 + QGT_state_fixpt_add_cast_125;
  QGT_state_fixpt_c_re_1 <= QGT_state_fixpt_add_temp_46(59 DOWNTO 44);
  QGT_state_fixpt_sub_cast_525 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_447 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_525 - 1));
  QGT_state_fixpt_sub_cast_526 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_448 <= QGT_state_fixpt_mul_temp_447 * nc_0(to_integer(QGT_state_fixpt_sub_cast_526 - 1));
  QGT_state_fixpt_cast_212 <= resize(QGT_state_fixpt_mul_temp_448 & '0', 51);
  QGT_state_fixpt_cast_213 <= resize(QGT_state_fixpt_cast_212, 52);
  QGT_state_fixpt_cast_214 <=  - (QGT_state_fixpt_cast_213);
  QGT_state_fixpt_cast_215 <= QGT_state_fixpt_cast_214(50 DOWNTO 0);
  QGT_state_fixpt_sub_cast_527 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_449 <= QGT_state_fixpt_cast_215 * nc_0(to_integer(QGT_state_fixpt_sub_cast_527 - 1));
  QGT_state_fixpt_sub_cast_528 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_450 <= QGT_state_fixpt_mul_temp_449 * nc_0(to_integer(QGT_state_fixpt_sub_cast_528 - 1));
  QGT_state_fixpt_sub_cast_529 <= resize(QGT_state_fixpt_mul_temp_450, 84);
  QGT_state_fixpt_sub_cast_530 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_451 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_530 - 1));
  QGT_state_fixpt_sub_cast_531 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_452 <= QGT_state_fixpt_mul_temp_451 * nc(to_integer(QGT_state_fixpt_sub_cast_531 - 1));
  QGT_state_fixpt_sub_cast_532 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_453 <= QGT_state_fixpt_mul_temp_452 * nc_0(to_integer(QGT_state_fixpt_sub_cast_532 - 1));
  QGT_state_fixpt_sub_cast_533 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_454 <= QGT_state_fixpt_mul_temp_453 * nc(to_integer(QGT_state_fixpt_sub_cast_533 - 1));
  QGT_state_fixpt_sub_cast_534 <= resize(QGT_state_fixpt_mul_temp_454 & '0', 82);
  QGT_state_fixpt_sub_cast_535 <= resize(QGT_state_fixpt_sub_cast_534, 84);
  QGT_state_fixpt_sub_temp_46 <= QGT_state_fixpt_sub_cast_529 - QGT_state_fixpt_sub_cast_535;
  QGT_state_fixpt_add_cast_126 <= resize(QGT_state_fixpt_sub_temp_46, 85);
  QGT_state_fixpt_sub_cast_536 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_455 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_536 - 1));
  QGT_state_fixpt_cast_216 <= QGT_state_fixpt_mul_temp_455(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_537 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_456 <= QGT_state_fixpt_cast_216 * nc(to_integer(QGT_state_fixpt_sub_cast_537 - 1));
  QGT_state_fixpt_sub_cast_538 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_457 <= QGT_state_fixpt_mul_temp_456 * nc(to_integer(QGT_state_fixpt_sub_cast_538 - 1));
  QGT_state_fixpt_sub_cast_539 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_458 <= QGT_state_fixpt_mul_temp_457 * nc(to_integer(QGT_state_fixpt_sub_cast_539 - 1));
  QGT_state_fixpt_add_cast_127 <= resize(QGT_state_fixpt_mul_temp_458, 81);
  QGT_state_fixpt_add_cast_128 <= resize(QGT_state_fixpt_add_cast_127, 85);
  QGT_state_fixpt_add_temp_47 <= QGT_state_fixpt_add_cast_126 + QGT_state_fixpt_add_cast_128;
  QGT_state_fixpt_add_cast_129 <= resize(QGT_state_fixpt_add_temp_47, 86);
  QGT_state_fixpt_sub_cast_540 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_459 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_540 - 1));
  QGT_state_fixpt_cast_217 <= QGT_state_fixpt_mul_temp_459(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_541 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_460 <= QGT_state_fixpt_cast_217 * nc(to_integer(QGT_state_fixpt_sub_cast_541 - 1));
  QGT_state_fixpt_cast_218 <= resize(QGT_state_fixpt_mul_temp_460, 50);
  QGT_state_fixpt_cast_219 <=  - (QGT_state_fixpt_cast_218);
  QGT_state_fixpt_sub_cast_542 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_461 <= QGT_state_fixpt_cast_219 * nc_0(to_integer(QGT_state_fixpt_sub_cast_542 - 1));
  QGT_state_fixpt_sub_cast_543 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_462 <= QGT_state_fixpt_mul_temp_461 * nc(to_integer(QGT_state_fixpt_sub_cast_543 - 1));
  QGT_state_fixpt_add_cast_130 <= resize(QGT_state_fixpt_mul_temp_462, 86);
  QGT_state_fixpt_add_temp_48 <= QGT_state_fixpt_add_cast_129 + QGT_state_fixpt_add_cast_130;
  QGT_state_fixpt_cast_220 <= QGT_state_fixpt_add_temp_48(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_463 <= to_signed(-16#5A83#, 16) * QGT_state_fixpt_cast_220;
  QGT_state_fixpt_sub_cast_544 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_464 <= QGT_state_fixpt_mul_temp_463 * nc_0(to_integer(QGT_state_fixpt_sub_cast_544 - 1));
  QGT_state_fixpt_sub_cast_545 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_465 <= QGT_state_fixpt_mul_temp_464 * nc(to_integer(QGT_state_fixpt_sub_cast_545 - 1));
  QGT_state_fixpt_add_cast_131 <= resize(QGT_state_fixpt_mul_temp_465, 65);
  QGT_state_fixpt_add_cast_132 <= resize(QGT_state_fixpt_add_cast_131 & '0', 67);
  QGT_state_fixpt_sub_cast_546 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_466 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_546 - 1));
  QGT_state_fixpt_cast_221 <= QGT_state_fixpt_mul_temp_466(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_547 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_467 <= QGT_state_fixpt_cast_221 * nc(to_integer(QGT_state_fixpt_sub_cast_547 - 1));
  QGT_state_fixpt_cast_222 <= resize(QGT_state_fixpt_mul_temp_467, 50);
  QGT_state_fixpt_cast_223 <=  - (QGT_state_fixpt_cast_222);
  QGT_state_fixpt_sub_cast_548 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_468 <= QGT_state_fixpt_cast_223 * nc_0(to_integer(QGT_state_fixpt_sub_cast_548 - 1));
  QGT_state_fixpt_sub_cast_549 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_469 <= QGT_state_fixpt_mul_temp_468 * nc(to_integer(QGT_state_fixpt_sub_cast_549 - 1));
  QGT_state_fixpt_add_cast_133 <= resize(QGT_state_fixpt_mul_temp_469, 83);
  QGT_state_fixpt_sub_cast_550 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_470 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_550 - 1));
  QGT_state_fixpt_cast_224 <= QGT_state_fixpt_mul_temp_470(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_551 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_471 <= QGT_state_fixpt_cast_224 * nc(to_integer(QGT_state_fixpt_sub_cast_551 - 1));
  QGT_state_fixpt_cast_225 <= resize(QGT_state_fixpt_mul_temp_471, 50);
  QGT_state_fixpt_cast_226 <=  - (QGT_state_fixpt_cast_225);
  QGT_state_fixpt_sub_cast_552 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_472 <= QGT_state_fixpt_cast_226 * nc(to_integer(QGT_state_fixpt_sub_cast_552 - 1));
  QGT_state_fixpt_sub_cast_553 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_473 <= QGT_state_fixpt_mul_temp_472 * nc(to_integer(QGT_state_fixpt_sub_cast_553 - 1));
  QGT_state_fixpt_add_cast_134 <= resize(QGT_state_fixpt_mul_temp_473, 83);
  QGT_state_fixpt_add_temp_49 <= QGT_state_fixpt_add_cast_133 + QGT_state_fixpt_add_cast_134;
  QGT_state_fixpt_add_cast_135 <= resize(QGT_state_fixpt_add_temp_49, 84);
  QGT_state_fixpt_sub_cast_554 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_474 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_554 - 1));
  QGT_state_fixpt_cast_227 <= QGT_state_fixpt_mul_temp_474(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_555 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_475 <= QGT_state_fixpt_cast_227 * nc_0(to_integer(QGT_state_fixpt_sub_cast_555 - 1));
  QGT_state_fixpt_sub_cast_556 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_476 <= QGT_state_fixpt_mul_temp_475 * nc_0(to_integer(QGT_state_fixpt_sub_cast_556 - 1));
  QGT_state_fixpt_sub_cast_557 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_477 <= QGT_state_fixpt_mul_temp_476 * nc(to_integer(QGT_state_fixpt_sub_cast_557 - 1));
  QGT_state_fixpt_add_cast_136 <= resize(QGT_state_fixpt_mul_temp_477, 81);
  QGT_state_fixpt_add_cast_137 <= resize(QGT_state_fixpt_add_cast_136, 84);
  QGT_state_fixpt_add_temp_50 <= QGT_state_fixpt_add_cast_135 + QGT_state_fixpt_add_cast_137;
  QGT_state_fixpt_add_cast_138 <= resize(QGT_state_fixpt_add_temp_50, 85);
  QGT_state_fixpt_sub_cast_558 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_478 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_558 - 1));
  QGT_state_fixpt_sub_cast_559 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_479 <= QGT_state_fixpt_mul_temp_478 * nc(to_integer(QGT_state_fixpt_sub_cast_559 - 1));
  QGT_state_fixpt_sub_cast_560 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_480 <= QGT_state_fixpt_mul_temp_479 * nc_0(to_integer(QGT_state_fixpt_sub_cast_560 - 1));
  QGT_state_fixpt_sub_cast_561 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_481 <= QGT_state_fixpt_mul_temp_480 * nc_0(to_integer(QGT_state_fixpt_sub_cast_561 - 1));
  QGT_state_fixpt_add_cast_139 <= resize(QGT_state_fixpt_mul_temp_481 & '0', 82);
  QGT_state_fixpt_add_cast_140 <= resize(QGT_state_fixpt_add_cast_139, 85);
  QGT_state_fixpt_add_temp_51 <= QGT_state_fixpt_add_cast_138 + QGT_state_fixpt_add_cast_140;
  QGT_state_fixpt_cast_228 <= QGT_state_fixpt_add_temp_51(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_482 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_228;
  QGT_state_fixpt_cast_229 <= QGT_state_fixpt_mul_temp_482(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_562 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_483 <= QGT_state_fixpt_cast_229 * nc(to_integer(QGT_state_fixpt_sub_cast_562 - 1));
  QGT_state_fixpt_sub_cast_563 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_484 <= QGT_state_fixpt_mul_temp_483 * nc(to_integer(QGT_state_fixpt_sub_cast_563 - 1));
  QGT_state_fixpt_add_cast_141 <= resize(QGT_state_fixpt_mul_temp_484, 67);
  QGT_state_fixpt_add_temp_52 <= QGT_state_fixpt_add_cast_132 + QGT_state_fixpt_add_cast_141;
  QGT_state_fixpt_sub_cast_564 <= resize(QGT_state_fixpt_add_temp_52, 68);
  QGT_state_fixpt_sub_cast_565 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_485 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_565 - 1));
  QGT_state_fixpt_cast_230 <= QGT_state_fixpt_mul_temp_485(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_566 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_486 <= QGT_state_fixpt_cast_230 * nc(to_integer(QGT_state_fixpt_sub_cast_566 - 1));
  QGT_state_fixpt_cast_231 <= resize(QGT_state_fixpt_mul_temp_486, 50);
  QGT_state_fixpt_cast_232 <=  - (QGT_state_fixpt_cast_231);
  QGT_state_fixpt_cast_233 <= resize(QGT_state_fixpt_cast_232, 51);
  QGT_state_fixpt_cast_234 <= resize(QGT_state_fixpt_cast_233, 52);
  QGT_state_fixpt_cast_235 <=  - (QGT_state_fixpt_cast_234);
  QGT_state_fixpt_cast_236 <= QGT_state_fixpt_cast_235(50 DOWNTO 0);
  QGT_state_fixpt_sub_cast_567 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_487 <= QGT_state_fixpt_cast_236 * nc_0(to_integer(QGT_state_fixpt_sub_cast_567 - 1));
  QGT_state_fixpt_sub_cast_568 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_488 <= QGT_state_fixpt_mul_temp_487 * nc(to_integer(QGT_state_fixpt_sub_cast_568 - 1));
  QGT_state_fixpt_add_cast_142 <= resize(QGT_state_fixpt_mul_temp_488, 84);
  QGT_state_fixpt_sub_cast_569 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_489 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_569 - 1));
  QGT_state_fixpt_cast_237 <= QGT_state_fixpt_mul_temp_489(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_570 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_490 <= QGT_state_fixpt_cast_237 * nc(to_integer(QGT_state_fixpt_sub_cast_570 - 1));
  QGT_state_fixpt_cast_238 <= resize(QGT_state_fixpt_mul_temp_490, 50);
  QGT_state_fixpt_cast_239 <=  - (QGT_state_fixpt_cast_238);
  QGT_state_fixpt_sub_cast_571 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_491 <= QGT_state_fixpt_cast_239 * nc_0(to_integer(QGT_state_fixpt_sub_cast_571 - 1));
  QGT_state_fixpt_sub_cast_572 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_492 <= QGT_state_fixpt_mul_temp_491 * nc_0(to_integer(QGT_state_fixpt_sub_cast_572 - 1));
  QGT_state_fixpt_add_cast_143 <= resize(QGT_state_fixpt_mul_temp_492, 84);
  QGT_state_fixpt_add_temp_53 <= QGT_state_fixpt_add_cast_142 + QGT_state_fixpt_add_cast_143;
  QGT_state_fixpt_sub_cast_573 <= resize(QGT_state_fixpt_add_temp_53, 85);
  QGT_state_fixpt_sub_cast_574 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_493 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_574 - 1));
  QGT_state_fixpt_cast_240 <= QGT_state_fixpt_mul_temp_493(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_575 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_494 <= QGT_state_fixpt_cast_240 * nc_0(to_integer(QGT_state_fixpt_sub_cast_575 - 1));
  QGT_state_fixpt_sub_cast_576 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_495 <= QGT_state_fixpt_mul_temp_494 * nc_0(to_integer(QGT_state_fixpt_sub_cast_576 - 1));
  QGT_state_fixpt_sub_cast_577 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_496 <= QGT_state_fixpt_mul_temp_495 * nc(to_integer(QGT_state_fixpt_sub_cast_577 - 1));
  QGT_state_fixpt_sub_cast_578 <= resize(QGT_state_fixpt_mul_temp_496, 81);
  QGT_state_fixpt_sub_cast_579 <= resize(QGT_state_fixpt_sub_cast_578, 85);
  QGT_state_fixpt_sub_temp_47 <= QGT_state_fixpt_sub_cast_573 - QGT_state_fixpt_sub_cast_579;
  QGT_state_fixpt_add_cast_144 <= resize(QGT_state_fixpt_sub_temp_47, 86);
  QGT_state_fixpt_sub_cast_580 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_497 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_580 - 1));
  QGT_state_fixpt_sub_cast_581 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_498 <= QGT_state_fixpt_mul_temp_497 * nc(to_integer(QGT_state_fixpt_sub_cast_581 - 1));
  QGT_state_fixpt_sub_cast_582 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_499 <= QGT_state_fixpt_mul_temp_498 * nc(to_integer(QGT_state_fixpt_sub_cast_582 - 1));
  QGT_state_fixpt_sub_cast_583 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_500 <= QGT_state_fixpt_mul_temp_499 * nc(to_integer(QGT_state_fixpt_sub_cast_583 - 1));
  QGT_state_fixpt_add_cast_145 <= resize(QGT_state_fixpt_mul_temp_500 & '0', 82);
  QGT_state_fixpt_add_cast_146 <= resize(QGT_state_fixpt_add_cast_145, 86);
  QGT_state_fixpt_add_temp_54 <= QGT_state_fixpt_add_cast_144 + QGT_state_fixpt_add_cast_146;
  QGT_state_fixpt_cast_241 <= QGT_state_fixpt_add_temp_54(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_501 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_241;
  QGT_state_fixpt_cast_242 <= QGT_state_fixpt_mul_temp_501(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_584 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_502 <= QGT_state_fixpt_cast_242 * nc_0(to_integer(QGT_state_fixpt_sub_cast_584 - 1));
  QGT_state_fixpt_sub_cast_585 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_503 <= QGT_state_fixpt_mul_temp_502 * nc_0(to_integer(QGT_state_fixpt_sub_cast_585 - 1));
  QGT_state_fixpt_sub_cast_586 <= resize(QGT_state_fixpt_mul_temp_503, 68);
  QGT_state_fixpt_sub_temp_48 <= QGT_state_fixpt_sub_cast_564 - QGT_state_fixpt_sub_cast_586;
  QGT_state_fixpt_sub_cast_587 <= resize(QGT_state_fixpt_sub_temp_48, 69);
  QGT_state_fixpt_sub_cast_588 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_504 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_588 - 1));
  QGT_state_fixpt_sub_cast_589 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_505 <= QGT_state_fixpt_mul_temp_504 * nc_0(to_integer(QGT_state_fixpt_sub_cast_589 - 1));
  QGT_state_fixpt_sub_cast_590 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_506 <= QGT_state_fixpt_mul_temp_505 * nc(to_integer(QGT_state_fixpt_sub_cast_590 - 1));
  QGT_state_fixpt_sub_cast_591 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_507 <= QGT_state_fixpt_mul_temp_506 * nc(to_integer(QGT_state_fixpt_sub_cast_591 - 1));
  QGT_state_fixpt_sub_cast_592 <= resize(QGT_state_fixpt_mul_temp_507 & '0', 82);
  QGT_state_fixpt_sub_cast_593 <= resize(QGT_state_fixpt_sub_cast_592, 83);
  QGT_state_fixpt_sub_cast_594 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_508 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_594 - 1));
  QGT_state_fixpt_sub_cast_595 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_509 <= QGT_state_fixpt_mul_temp_508 * nc(to_integer(QGT_state_fixpt_sub_cast_595 - 1));
  QGT_state_fixpt_sub_cast_596 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_510 <= QGT_state_fixpt_mul_temp_509 * nc_0(to_integer(QGT_state_fixpt_sub_cast_596 - 1));
  QGT_state_fixpt_sub_cast_597 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_511 <= QGT_state_fixpt_mul_temp_510 * nc(to_integer(QGT_state_fixpt_sub_cast_597 - 1));
  QGT_state_fixpt_sub_cast_598 <= resize(QGT_state_fixpt_mul_temp_511 & '0', 82);
  QGT_state_fixpt_sub_cast_599 <= resize(QGT_state_fixpt_sub_cast_598, 83);
  QGT_state_fixpt_sub_temp_49 <= QGT_state_fixpt_sub_cast_593 - QGT_state_fixpt_sub_cast_599;
  QGT_state_fixpt_sub_cast_600 <= resize(QGT_state_fixpt_sub_temp_49, 84);
  QGT_state_fixpt_sub_cast_601 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_512 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_601 - 1));
  QGT_state_fixpt_cast_243 <= QGT_state_fixpt_mul_temp_512(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_602 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_513 <= QGT_state_fixpt_cast_243 * nc(to_integer(QGT_state_fixpt_sub_cast_602 - 1));
  QGT_state_fixpt_sub_cast_603 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_514 <= QGT_state_fixpt_mul_temp_513 * nc_0(to_integer(QGT_state_fixpt_sub_cast_603 - 1));
  QGT_state_fixpt_sub_cast_604 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_515 <= QGT_state_fixpt_mul_temp_514 * nc_0(to_integer(QGT_state_fixpt_sub_cast_604 - 1));
  QGT_state_fixpt_sub_cast_605 <= resize(QGT_state_fixpt_mul_temp_515, 81);
  QGT_state_fixpt_sub_cast_606 <= resize(QGT_state_fixpt_sub_cast_605, 84);
  QGT_state_fixpt_sub_temp_50 <= QGT_state_fixpt_sub_cast_600 - QGT_state_fixpt_sub_cast_606;
  QGT_state_fixpt_add_cast_147 <= resize(QGT_state_fixpt_sub_temp_50, 85);
  QGT_state_fixpt_sub_cast_607 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_516 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_607 - 1));
  QGT_state_fixpt_cast_244 <= QGT_state_fixpt_mul_temp_516(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_608 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_517 <= QGT_state_fixpt_cast_244 * nc(to_integer(QGT_state_fixpt_sub_cast_608 - 1));
  QGT_state_fixpt_cast_245 <= resize(QGT_state_fixpt_mul_temp_517, 50);
  QGT_state_fixpt_cast_246 <=  - (QGT_state_fixpt_cast_245);
  QGT_state_fixpt_sub_cast_609 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_518 <= QGT_state_fixpt_cast_246 * nc_0(to_integer(QGT_state_fixpt_sub_cast_609 - 1));
  QGT_state_fixpt_sub_cast_610 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_519 <= QGT_state_fixpt_mul_temp_518 * nc(to_integer(QGT_state_fixpt_sub_cast_610 - 1));
  QGT_state_fixpt_add_cast_148 <= resize(QGT_state_fixpt_mul_temp_519, 85);
  QGT_state_fixpt_add_temp_55 <= QGT_state_fixpt_add_cast_147 + QGT_state_fixpt_add_cast_148;
  QGT_state_fixpt_cast_247 <= QGT_state_fixpt_add_temp_55(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_520 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_247;
  QGT_state_fixpt_cast_248 <= QGT_state_fixpt_mul_temp_520(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_611 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_521 <= QGT_state_fixpt_cast_248 * nc_0(to_integer(QGT_state_fixpt_sub_cast_611 - 1));
  QGT_state_fixpt_sub_cast_612 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_522 <= QGT_state_fixpt_mul_temp_521 * nc(to_integer(QGT_state_fixpt_sub_cast_612 - 1));
  QGT_state_fixpt_sub_cast_613 <= resize(QGT_state_fixpt_mul_temp_522, 65);
  QGT_state_fixpt_sub_cast_614 <= resize(QGT_state_fixpt_sub_cast_613, 69);
  QGT_state_fixpt_sub_temp_51 <= QGT_state_fixpt_sub_cast_587 - QGT_state_fixpt_sub_cast_614;
  QGT_state_fixpt_add_cast_149 <= resize(QGT_state_fixpt_sub_temp_51, 72);
  QGT_state_fixpt_sub_cast_615 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_523 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_615 - 1));
  QGT_state_fixpt_cast_249 <= QGT_state_fixpt_mul_temp_523(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_616 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_524 <= QGT_state_fixpt_cast_249 * nc(to_integer(QGT_state_fixpt_sub_cast_616 - 1));
  QGT_state_fixpt_cast_250 <= resize(QGT_state_fixpt_mul_temp_524, 50);
  QGT_state_fixpt_cast_251 <=  - (QGT_state_fixpt_cast_250);
  QGT_state_fixpt_cast_252 <= resize(QGT_state_fixpt_cast_251, 51);
  QGT_state_fixpt_cast_253 <= resize(QGT_state_fixpt_cast_252, 52);
  QGT_state_fixpt_cast_254 <=  - (QGT_state_fixpt_cast_253);
  QGT_state_fixpt_cast_255 <= QGT_state_fixpt_cast_254(50 DOWNTO 0);
  QGT_state_fixpt_sub_cast_617 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_525 <= QGT_state_fixpt_cast_255 * nc_0(to_integer(QGT_state_fixpt_sub_cast_617 - 1));
  QGT_state_fixpt_sub_cast_618 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_526 <= QGT_state_fixpt_mul_temp_525 * nc_0(to_integer(QGT_state_fixpt_sub_cast_618 - 1));
  QGT_state_fixpt_sub_cast_619 <= resize(QGT_state_fixpt_mul_temp_526, 84);
  QGT_state_fixpt_sub_cast_620 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_527 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_620 - 1));
  QGT_state_fixpt_cast_256 <= QGT_state_fixpt_mul_temp_527(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_621 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_528 <= QGT_state_fixpt_cast_256 * nc(to_integer(QGT_state_fixpt_sub_cast_621 - 1));
  QGT_state_fixpt_cast_257 <= resize(QGT_state_fixpt_mul_temp_528, 50);
  QGT_state_fixpt_cast_258 <=  - (QGT_state_fixpt_cast_257);
  QGT_state_fixpt_sub_cast_622 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_529 <= QGT_state_fixpt_cast_258 * nc_0(to_integer(QGT_state_fixpt_sub_cast_622 - 1));
  QGT_state_fixpt_sub_cast_623 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_530 <= QGT_state_fixpt_mul_temp_529 * nc(to_integer(QGT_state_fixpt_sub_cast_623 - 1));
  QGT_state_fixpt_sub_cast_624 <= resize(QGT_state_fixpt_mul_temp_530, 84);
  QGT_state_fixpt_sub_temp_52 <= QGT_state_fixpt_sub_cast_619 - QGT_state_fixpt_sub_cast_624;
  QGT_state_fixpt_add_cast_150 <= resize(QGT_state_fixpt_sub_temp_52, 85);
  QGT_state_fixpt_sub_cast_625 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_531 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_625 - 1));
  QGT_state_fixpt_cast_259 <= QGT_state_fixpt_mul_temp_531(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_626 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_532 <= QGT_state_fixpt_cast_259 * nc_0(to_integer(QGT_state_fixpt_sub_cast_626 - 1));
  QGT_state_fixpt_sub_cast_627 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_533 <= QGT_state_fixpt_mul_temp_532 * nc(to_integer(QGT_state_fixpt_sub_cast_627 - 1));
  QGT_state_fixpt_sub_cast_628 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_534 <= QGT_state_fixpt_mul_temp_533 * nc(to_integer(QGT_state_fixpt_sub_cast_628 - 1));
  QGT_state_fixpt_add_cast_151 <= resize(QGT_state_fixpt_mul_temp_534, 81);
  QGT_state_fixpt_add_cast_152 <= resize(QGT_state_fixpt_add_cast_151, 85);
  QGT_state_fixpt_add_temp_56 <= QGT_state_fixpt_add_cast_150 + QGT_state_fixpt_add_cast_152;
  QGT_state_fixpt_add_cast_153 <= resize(QGT_state_fixpt_add_temp_56, 86);
  QGT_state_fixpt_sub_cast_629 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_535 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_629 - 1));
  QGT_state_fixpt_sub_cast_630 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_536 <= QGT_state_fixpt_mul_temp_535 * nc(to_integer(QGT_state_fixpt_sub_cast_630 - 1));
  QGT_state_fixpt_sub_cast_631 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_537 <= QGT_state_fixpt_mul_temp_536 * nc_0(to_integer(QGT_state_fixpt_sub_cast_631 - 1));
  QGT_state_fixpt_sub_cast_632 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_538 <= QGT_state_fixpt_mul_temp_537 * nc(to_integer(QGT_state_fixpt_sub_cast_632 - 1));
  QGT_state_fixpt_add_cast_154 <= resize(QGT_state_fixpt_mul_temp_538 & '0', 82);
  QGT_state_fixpt_add_cast_155 <= resize(QGT_state_fixpt_add_cast_154, 86);
  QGT_state_fixpt_add_temp_57 <= QGT_state_fixpt_add_cast_153 + QGT_state_fixpt_add_cast_155;
  QGT_state_fixpt_cast_260 <= QGT_state_fixpt_add_temp_57(73 DOWNTO 58);
  QGT_state_fixpt_cast_261 <= resize(QGT_state_fixpt_cast_260, 17);
  QGT_state_fixpt_cast_262 <=  - (QGT_state_fixpt_cast_261);
  QGT_state_fixpt_cast_263 <= resize(QGT_state_fixpt_cast_262, 18);
  QGT_state_fixpt_cast_264 <= resize(QGT_state_fixpt_cast_263, 19);
  QGT_state_fixpt_cast_265 <=  - (QGT_state_fixpt_cast_264);
  QGT_state_fixpt_sub_cast_633 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_539 <= QGT_state_fixpt_cast_265 * nc_0(to_integer(QGT_state_fixpt_sub_cast_633 - 1));
  QGT_state_fixpt_sub_cast_634 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_540 <= QGT_state_fixpt_mul_temp_539 * nc(to_integer(QGT_state_fixpt_sub_cast_634 - 1));
  QGT_state_fixpt_sub_cast_635 <= resize(QGT_state_fixpt_mul_temp_540, 52);
  QGT_state_fixpt_sub_cast_636 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_541 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_636 - 1));
  QGT_state_fixpt_sub_cast_637 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_542 <= QGT_state_fixpt_mul_temp_541 * nc_0(to_integer(QGT_state_fixpt_sub_cast_637 - 1));
  QGT_state_fixpt_sub_cast_638 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_543 <= QGT_state_fixpt_mul_temp_542 * nc_0(to_integer(QGT_state_fixpt_sub_cast_638 - 1));
  QGT_state_fixpt_sub_cast_639 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_544 <= QGT_state_fixpt_mul_temp_543 * nc(to_integer(QGT_state_fixpt_sub_cast_639 - 1));
  QGT_state_fixpt_add_cast_156 <= resize(QGT_state_fixpt_mul_temp_544 & '0', 82);
  QGT_state_fixpt_add_cast_157 <= resize(QGT_state_fixpt_add_cast_156, 83);
  QGT_state_fixpt_sub_cast_640 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_545 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_640 - 1));
  QGT_state_fixpt_sub_cast_641 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_546 <= QGT_state_fixpt_mul_temp_545 * nc(to_integer(QGT_state_fixpt_sub_cast_641 - 1));
  QGT_state_fixpt_sub_cast_642 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_547 <= QGT_state_fixpt_mul_temp_546 * nc(to_integer(QGT_state_fixpt_sub_cast_642 - 1));
  QGT_state_fixpt_sub_cast_643 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_548 <= QGT_state_fixpt_mul_temp_547 * nc(to_integer(QGT_state_fixpt_sub_cast_643 - 1));
  QGT_state_fixpt_add_cast_158 <= resize(QGT_state_fixpt_mul_temp_548 & '0', 82);
  QGT_state_fixpt_add_cast_159 <= resize(QGT_state_fixpt_add_cast_158, 83);
  QGT_state_fixpt_add_temp_58 <= QGT_state_fixpt_add_cast_157 + QGT_state_fixpt_add_cast_159;
  QGT_state_fixpt_add_cast_160 <= resize(QGT_state_fixpt_add_temp_58, 84);
  QGT_state_fixpt_sub_cast_644 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_549 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_644 - 1));
  QGT_state_fixpt_cast_266 <= QGT_state_fixpt_mul_temp_549(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_645 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_550 <= QGT_state_fixpt_cast_266 * nc(to_integer(QGT_state_fixpt_sub_cast_645 - 1));
  QGT_state_fixpt_sub_cast_646 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_551 <= QGT_state_fixpt_mul_temp_550 * nc_0(to_integer(QGT_state_fixpt_sub_cast_646 - 1));
  QGT_state_fixpt_sub_cast_647 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_552 <= QGT_state_fixpt_mul_temp_551 * nc(to_integer(QGT_state_fixpt_sub_cast_647 - 1));
  QGT_state_fixpt_add_cast_161 <= resize(QGT_state_fixpt_mul_temp_552, 81);
  QGT_state_fixpt_add_cast_162 <= resize(QGT_state_fixpt_add_cast_161, 84);
  QGT_state_fixpt_add_temp_59 <= QGT_state_fixpt_add_cast_160 + QGT_state_fixpt_add_cast_162;
  QGT_state_fixpt_add_cast_163 <= resize(QGT_state_fixpt_add_temp_59, 85);
  QGT_state_fixpt_sub_cast_648 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_553 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_648 - 1));
  QGT_state_fixpt_cast_267 <= QGT_state_fixpt_mul_temp_553(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_649 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_554 <= QGT_state_fixpt_cast_267 * nc(to_integer(QGT_state_fixpt_sub_cast_649 - 1));
  QGT_state_fixpt_cast_268 <= resize(QGT_state_fixpt_mul_temp_554, 50);
  QGT_state_fixpt_cast_269 <=  - (QGT_state_fixpt_cast_268);
  QGT_state_fixpt_sub_cast_650 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_555 <= QGT_state_fixpt_cast_269 * nc_0(to_integer(QGT_state_fixpt_sub_cast_650 - 1));
  QGT_state_fixpt_sub_cast_651 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_556 <= QGT_state_fixpt_mul_temp_555 * nc_0(to_integer(QGT_state_fixpt_sub_cast_651 - 1));
  QGT_state_fixpt_add_cast_164 <= resize(QGT_state_fixpt_mul_temp_556, 85);
  QGT_state_fixpt_add_temp_60 <= QGT_state_fixpt_add_cast_163 + QGT_state_fixpt_add_cast_164;
  QGT_state_fixpt_cast_270 <= QGT_state_fixpt_add_temp_60(73 DOWNTO 58);
  QGT_state_fixpt_sub_cast_652 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_557 <= QGT_state_fixpt_cast_270 * nc_0(to_integer(QGT_state_fixpt_sub_cast_652 - 1));
  QGT_state_fixpt_sub_cast_653 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_558 <= QGT_state_fixpt_mul_temp_557 * nc_0(to_integer(QGT_state_fixpt_sub_cast_653 - 1));
  QGT_state_fixpt_sub_cast_654 <= resize(QGT_state_fixpt_mul_temp_558, 52);
  QGT_state_fixpt_sub_temp_53 <= QGT_state_fixpt_sub_cast_635 - QGT_state_fixpt_sub_cast_654;
  QGT_state_fixpt_add_cast_165 <= resize(QGT_state_fixpt_sub_temp_53, 53);
  QGT_state_fixpt_sub_cast_655 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_559 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_655 - 1));
  QGT_state_fixpt_sub_cast_656 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_560 <= QGT_state_fixpt_mul_temp_559 * nc_0(to_integer(QGT_state_fixpt_sub_cast_656 - 1));
  QGT_state_fixpt_cast_271 <= resize(QGT_state_fixpt_mul_temp_560 & '0', 51);
  QGT_state_fixpt_cast_272 <= resize(QGT_state_fixpt_cast_271, 52);
  QGT_state_fixpt_cast_273 <=  - (QGT_state_fixpt_cast_272);
  QGT_state_fixpt_cast_274 <= QGT_state_fixpt_cast_273(50 DOWNTO 0);
  QGT_state_fixpt_sub_cast_657 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_561 <= QGT_state_fixpt_cast_274 * nc_0(to_integer(QGT_state_fixpt_sub_cast_657 - 1));
  QGT_state_fixpt_sub_cast_658 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_562 <= QGT_state_fixpt_mul_temp_561 * nc(to_integer(QGT_state_fixpt_sub_cast_658 - 1));
  QGT_state_fixpt_add_cast_166 <= resize(QGT_state_fixpt_mul_temp_562, 84);
  QGT_state_fixpt_sub_cast_659 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_563 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_659 - 1));
  QGT_state_fixpt_sub_cast_660 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_564 <= QGT_state_fixpt_mul_temp_563 * nc(to_integer(QGT_state_fixpt_sub_cast_660 - 1));
  QGT_state_fixpt_sub_cast_661 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_565 <= QGT_state_fixpt_mul_temp_564 * nc_0(to_integer(QGT_state_fixpt_sub_cast_661 - 1));
  QGT_state_fixpt_sub_cast_662 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_566 <= QGT_state_fixpt_mul_temp_565 * nc_0(to_integer(QGT_state_fixpt_sub_cast_662 - 1));
  QGT_state_fixpt_add_cast_167 <= resize(QGT_state_fixpt_mul_temp_566 & '0', 82);
  QGT_state_fixpt_add_cast_168 <= resize(QGT_state_fixpt_add_cast_167, 84);
  QGT_state_fixpt_add_temp_61 <= QGT_state_fixpt_add_cast_166 + QGT_state_fixpt_add_cast_168;
  QGT_state_fixpt_sub_cast_663 <= resize(QGT_state_fixpt_add_temp_61, 85);
  QGT_state_fixpt_sub_cast_664 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_567 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_664 - 1));
  QGT_state_fixpt_cast_275 <= QGT_state_fixpt_mul_temp_567(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_665 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_568 <= QGT_state_fixpt_cast_275 * nc(to_integer(QGT_state_fixpt_sub_cast_665 - 1));
  QGT_state_fixpt_sub_cast_666 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_569 <= QGT_state_fixpt_mul_temp_568 * nc_0(to_integer(QGT_state_fixpt_sub_cast_666 - 1));
  QGT_state_fixpt_sub_cast_667 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_570 <= QGT_state_fixpt_mul_temp_569 * nc(to_integer(QGT_state_fixpt_sub_cast_667 - 1));
  QGT_state_fixpt_sub_cast_668 <= resize(QGT_state_fixpt_mul_temp_570, 81);
  QGT_state_fixpt_sub_cast_669 <= resize(QGT_state_fixpt_sub_cast_668, 85);
  QGT_state_fixpt_sub_temp_54 <= QGT_state_fixpt_sub_cast_663 - QGT_state_fixpt_sub_cast_669;
  QGT_state_fixpt_add_cast_169 <= resize(QGT_state_fixpt_sub_temp_54, 86);
  QGT_state_fixpt_sub_cast_670 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_571 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_670 - 1));
  QGT_state_fixpt_cast_276 <= QGT_state_fixpt_mul_temp_571(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_671 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_572 <= QGT_state_fixpt_cast_276 * nc(to_integer(QGT_state_fixpt_sub_cast_671 - 1));
  QGT_state_fixpt_cast_277 <= resize(QGT_state_fixpt_mul_temp_572, 50);
  QGT_state_fixpt_cast_278 <=  - (QGT_state_fixpt_cast_277);
  QGT_state_fixpt_sub_cast_672 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_573 <= QGT_state_fixpt_cast_278 * nc(to_integer(QGT_state_fixpt_sub_cast_672 - 1));
  QGT_state_fixpt_sub_cast_673 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_574 <= QGT_state_fixpt_mul_temp_573 * nc(to_integer(QGT_state_fixpt_sub_cast_673 - 1));
  QGT_state_fixpt_add_cast_170 <= resize(QGT_state_fixpt_mul_temp_574, 86);
  QGT_state_fixpt_add_temp_62 <= QGT_state_fixpt_add_cast_169 + QGT_state_fixpt_add_cast_170;
  QGT_state_fixpt_cast_279 <= QGT_state_fixpt_add_temp_62(73 DOWNTO 58);
  QGT_state_fixpt_sub_cast_674 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_575 <= QGT_state_fixpt_cast_279 * nc(to_integer(QGT_state_fixpt_sub_cast_674 - 1));
  QGT_state_fixpt_sub_cast_675 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_576 <= QGT_state_fixpt_mul_temp_575 * nc(to_integer(QGT_state_fixpt_sub_cast_675 - 1));
  QGT_state_fixpt_add_cast_171 <= resize(QGT_state_fixpt_mul_temp_576, 53);
  QGT_state_fixpt_add_temp_63 <= QGT_state_fixpt_add_cast_165 + QGT_state_fixpt_add_cast_171;
  QGT_state_fixpt_sub_cast_676 <= resize(QGT_state_fixpt_add_temp_63, 54);
  QGT_state_fixpt_sub_cast_677 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_577 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_677 - 1));
  QGT_state_fixpt_cast_280 <= QGT_state_fixpt_mul_temp_577(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_678 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_578 <= QGT_state_fixpt_cast_280 * nc(to_integer(QGT_state_fixpt_sub_cast_678 - 1));
  QGT_state_fixpt_cast_281 <= resize(QGT_state_fixpt_mul_temp_578, 50);
  QGT_state_fixpt_cast_282 <=  - (QGT_state_fixpt_cast_281);
  QGT_state_fixpt_sub_cast_679 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_579 <= QGT_state_fixpt_cast_282 * nc(to_integer(QGT_state_fixpt_sub_cast_679 - 1));
  QGT_state_fixpt_sub_cast_680 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_580 <= QGT_state_fixpt_mul_temp_579 * nc(to_integer(QGT_state_fixpt_sub_cast_680 - 1));
  QGT_state_fixpt_sub_cast_681 <= resize(QGT_state_fixpt_mul_temp_580, 83);
  QGT_state_fixpt_sub_cast_682 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_581 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_682 - 1));
  QGT_state_fixpt_cast_283 <= QGT_state_fixpt_mul_temp_581(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_683 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_582 <= QGT_state_fixpt_cast_283 * nc(to_integer(QGT_state_fixpt_sub_cast_683 - 1));
  QGT_state_fixpt_cast_284 <= resize(QGT_state_fixpt_mul_temp_582, 50);
  QGT_state_fixpt_cast_285 <=  - (QGT_state_fixpt_cast_284);
  QGT_state_fixpt_sub_cast_684 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_583 <= QGT_state_fixpt_cast_285 * nc_0(to_integer(QGT_state_fixpt_sub_cast_684 - 1));
  QGT_state_fixpt_sub_cast_685 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_584 <= QGT_state_fixpt_mul_temp_583 * nc(to_integer(QGT_state_fixpt_sub_cast_685 - 1));
  QGT_state_fixpt_sub_cast_686 <= resize(QGT_state_fixpt_mul_temp_584, 83);
  QGT_state_fixpt_sub_temp_55 <= QGT_state_fixpt_sub_cast_681 - QGT_state_fixpt_sub_cast_686;
  QGT_state_fixpt_sub_cast_687 <= resize(QGT_state_fixpt_sub_temp_55, 84);
  QGT_state_fixpt_sub_cast_688 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_585 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_688 - 1));
  QGT_state_fixpt_cast_286 <= QGT_state_fixpt_mul_temp_585(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_689 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_586 <= QGT_state_fixpt_cast_286 * nc_0(to_integer(QGT_state_fixpt_sub_cast_689 - 1));
  QGT_state_fixpt_sub_cast_690 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_587 <= QGT_state_fixpt_mul_temp_586 * nc_0(to_integer(QGT_state_fixpt_sub_cast_690 - 1));
  QGT_state_fixpt_sub_cast_691 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_588 <= QGT_state_fixpt_mul_temp_587 * nc_0(to_integer(QGT_state_fixpt_sub_cast_691 - 1));
  QGT_state_fixpt_sub_cast_692 <= resize(QGT_state_fixpt_mul_temp_588, 81);
  QGT_state_fixpt_sub_cast_693 <= resize(QGT_state_fixpt_sub_cast_692, 84);
  QGT_state_fixpt_sub_temp_56 <= QGT_state_fixpt_sub_cast_687 - QGT_state_fixpt_sub_cast_693;
  QGT_state_fixpt_add_cast_172 <= resize(QGT_state_fixpt_sub_temp_56, 85);
  QGT_state_fixpt_sub_cast_694 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_589 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_694 - 1));
  QGT_state_fixpt_sub_cast_695 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_590 <= QGT_state_fixpt_mul_temp_589 * nc(to_integer(QGT_state_fixpt_sub_cast_695 - 1));
  QGT_state_fixpt_sub_cast_696 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_591 <= QGT_state_fixpt_mul_temp_590 * nc_0(to_integer(QGT_state_fixpt_sub_cast_696 - 1));
  QGT_state_fixpt_sub_cast_697 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_592 <= QGT_state_fixpt_mul_temp_591 * nc(to_integer(QGT_state_fixpt_sub_cast_697 - 1));
  QGT_state_fixpt_add_cast_173 <= resize(QGT_state_fixpt_mul_temp_592 & '0', 82);
  QGT_state_fixpt_add_cast_174 <= resize(QGT_state_fixpt_add_cast_173, 85);
  QGT_state_fixpt_add_temp_64 <= QGT_state_fixpt_add_cast_172 + QGT_state_fixpt_add_cast_174;
  QGT_state_fixpt_cast_287 <= QGT_state_fixpt_add_temp_64(73 DOWNTO 58);
  QGT_state_fixpt_cast_288 <= resize(QGT_state_fixpt_cast_287, 18);
  QGT_state_fixpt_cast_289 <=  - (QGT_state_fixpt_cast_288);
  QGT_state_fixpt_sub_cast_698 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_593 <= QGT_state_fixpt_cast_289 * nc_0(to_integer(QGT_state_fixpt_sub_cast_698 - 1));
  QGT_state_fixpt_sub_cast_699 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_594 <= QGT_state_fixpt_mul_temp_593 * nc(to_integer(QGT_state_fixpt_sub_cast_699 - 1));
  QGT_state_fixpt_sub_cast_700 <= resize(QGT_state_fixpt_mul_temp_594, 54);
  QGT_state_fixpt_sub_temp_57 <= QGT_state_fixpt_sub_cast_676 - QGT_state_fixpt_sub_cast_700;
  QGT_state_fixpt_mul_temp_595 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_sub_temp_57;
  QGT_state_fixpt_add_cast_175 <= QGT_state_fixpt_mul_temp_595(69 DOWNTO 0);
  QGT_state_fixpt_add_cast_176 <= resize(QGT_state_fixpt_add_cast_175, 72);
  QGT_state_fixpt_add_temp_65 <= QGT_state_fixpt_add_cast_149 + QGT_state_fixpt_add_cast_176;
  QGT_state_fixpt_c_im_1 <= QGT_state_fixpt_add_temp_65(59 DOWNTO 44);
  QGT_state_fixpt_sub_cast_701 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_596 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_701 - 1));
  QGT_state_fixpt_cast_290 <= QGT_state_fixpt_mul_temp_596(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_702 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_597 <= QGT_state_fixpt_cast_290 * nc(to_integer(QGT_state_fixpt_sub_cast_702 - 1));
  QGT_state_fixpt_cast_291 <= resize(QGT_state_fixpt_mul_temp_597, 50);
  QGT_state_fixpt_cast_292 <=  - (QGT_state_fixpt_cast_291);
  QGT_state_fixpt_cast_293 <= resize(QGT_state_fixpt_cast_292, 51);
  QGT_state_fixpt_cast_294 <= resize(QGT_state_fixpt_cast_293, 52);
  QGT_state_fixpt_cast_295 <=  - (QGT_state_fixpt_cast_294);
  QGT_state_fixpt_cast_296 <= QGT_state_fixpt_cast_295(50 DOWNTO 0);
  QGT_state_fixpt_sub_cast_703 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_598 <= QGT_state_fixpt_cast_296 * nc_0(to_integer(QGT_state_fixpt_sub_cast_703 - 1));
  QGT_state_fixpt_sub_cast_704 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_599 <= QGT_state_fixpt_mul_temp_598 * nc_0(to_integer(QGT_state_fixpt_sub_cast_704 - 1));
  QGT_state_fixpt_add_cast_177 <= resize(QGT_state_fixpt_mul_temp_599, 84);
  QGT_state_fixpt_sub_cast_705 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_600 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_705 - 1));
  QGT_state_fixpt_cast_297 <= QGT_state_fixpt_mul_temp_600(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_706 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_601 <= QGT_state_fixpt_cast_297 * nc(to_integer(QGT_state_fixpt_sub_cast_706 - 1));
  QGT_state_fixpt_cast_298 <= resize(QGT_state_fixpt_mul_temp_601, 50);
  QGT_state_fixpt_cast_299 <=  - (QGT_state_fixpt_cast_298);
  QGT_state_fixpt_sub_cast_707 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_602 <= QGT_state_fixpt_cast_299 * nc_0(to_integer(QGT_state_fixpt_sub_cast_707 - 1));
  QGT_state_fixpt_sub_cast_708 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_603 <= QGT_state_fixpt_mul_temp_602 * nc(to_integer(QGT_state_fixpt_sub_cast_708 - 1));
  QGT_state_fixpt_add_cast_178 <= resize(QGT_state_fixpt_mul_temp_603, 84);
  QGT_state_fixpt_add_temp_66 <= QGT_state_fixpt_add_cast_177 + QGT_state_fixpt_add_cast_178;
  QGT_state_fixpt_add_cast_179 <= resize(QGT_state_fixpt_add_temp_66, 85);
  QGT_state_fixpt_sub_cast_709 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_604 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_709 - 1));
  QGT_state_fixpt_cast_300 <= QGT_state_fixpt_mul_temp_604(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_710 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_605 <= QGT_state_fixpt_cast_300 * nc_0(to_integer(QGT_state_fixpt_sub_cast_710 - 1));
  QGT_state_fixpt_sub_cast_711 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_606 <= QGT_state_fixpt_mul_temp_605 * nc(to_integer(QGT_state_fixpt_sub_cast_711 - 1));
  QGT_state_fixpt_sub_cast_712 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_607 <= QGT_state_fixpt_mul_temp_606 * nc(to_integer(QGT_state_fixpt_sub_cast_712 - 1));
  QGT_state_fixpt_add_cast_180 <= resize(QGT_state_fixpt_mul_temp_607, 81);
  QGT_state_fixpt_add_cast_181 <= resize(QGT_state_fixpt_add_cast_180, 85);
  QGT_state_fixpt_add_temp_67 <= QGT_state_fixpt_add_cast_179 + QGT_state_fixpt_add_cast_181;
  QGT_state_fixpt_sub_cast_713 <= resize(QGT_state_fixpt_add_temp_67, 86);
  QGT_state_fixpt_sub_cast_714 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_608 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_714 - 1));
  QGT_state_fixpt_sub_cast_715 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_609 <= QGT_state_fixpt_mul_temp_608 * nc(to_integer(QGT_state_fixpt_sub_cast_715 - 1));
  QGT_state_fixpt_sub_cast_716 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_610 <= QGT_state_fixpt_mul_temp_609 * nc_0(to_integer(QGT_state_fixpt_sub_cast_716 - 1));
  QGT_state_fixpt_sub_cast_717 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_611 <= QGT_state_fixpt_mul_temp_610 * nc(to_integer(QGT_state_fixpt_sub_cast_717 - 1));
  QGT_state_fixpt_sub_cast_718 <= resize(QGT_state_fixpt_mul_temp_611 & '0', 82);
  QGT_state_fixpt_sub_cast_719 <= resize(QGT_state_fixpt_sub_cast_718, 86);
  QGT_state_fixpt_sub_temp_58 <= QGT_state_fixpt_sub_cast_713 - QGT_state_fixpt_sub_cast_719;
  QGT_state_fixpt_cast_301 <= QGT_state_fixpt_sub_temp_58(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_612 <= to_signed(-16#5A83#, 16) * QGT_state_fixpt_cast_301;
  QGT_state_fixpt_cast_302 <= resize(QGT_state_fixpt_mul_temp_612, 33);
  QGT_state_fixpt_cast_303 <=  - (QGT_state_fixpt_cast_302);
  QGT_state_fixpt_sub_cast_720 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_613 <= QGT_state_fixpt_cast_303 * nc_0(to_integer(QGT_state_fixpt_sub_cast_720 - 1));
  QGT_state_fixpt_sub_cast_721 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_614 <= QGT_state_fixpt_mul_temp_613 * nc(to_integer(QGT_state_fixpt_sub_cast_721 - 1));
  QGT_state_fixpt_sub_cast_722 <= resize(QGT_state_fixpt_mul_temp_614 & '0', 67);
  QGT_state_fixpt_sub_cast_723 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_615 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_723 - 1));
  QGT_state_fixpt_sub_cast_724 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_616 <= QGT_state_fixpt_mul_temp_615 * nc_0(to_integer(QGT_state_fixpt_sub_cast_724 - 1));
  QGT_state_fixpt_cast_304 <= resize(QGT_state_fixpt_mul_temp_616 & '0', 51);
  QGT_state_fixpt_cast_305 <= resize(QGT_state_fixpt_cast_304, 52);
  QGT_state_fixpt_cast_306 <=  - (QGT_state_fixpt_cast_305);
  QGT_state_fixpt_cast_307 <= QGT_state_fixpt_cast_306(50 DOWNTO 0);
  QGT_state_fixpt_sub_cast_725 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_617 <= QGT_state_fixpt_cast_307 * nc_0(to_integer(QGT_state_fixpt_sub_cast_725 - 1));
  QGT_state_fixpt_sub_cast_726 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_618 <= QGT_state_fixpt_mul_temp_617 * nc(to_integer(QGT_state_fixpt_sub_cast_726 - 1));
  QGT_state_fixpt_add_cast_182 <= resize(QGT_state_fixpt_mul_temp_618, 84);
  QGT_state_fixpt_sub_cast_727 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_619 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_727 - 1));
  QGT_state_fixpt_sub_cast_728 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_620 <= QGT_state_fixpt_mul_temp_619 * nc(to_integer(QGT_state_fixpt_sub_cast_728 - 1));
  QGT_state_fixpt_sub_cast_729 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_621 <= QGT_state_fixpt_mul_temp_620 * nc(to_integer(QGT_state_fixpt_sub_cast_729 - 1));
  QGT_state_fixpt_sub_cast_730 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_622 <= QGT_state_fixpt_mul_temp_621 * nc(to_integer(QGT_state_fixpt_sub_cast_730 - 1));
  QGT_state_fixpt_add_cast_183 <= resize(QGT_state_fixpt_mul_temp_622 & '0', 82);
  QGT_state_fixpt_add_cast_184 <= resize(QGT_state_fixpt_add_cast_183, 84);
  QGT_state_fixpt_add_temp_68 <= QGT_state_fixpt_add_cast_182 + QGT_state_fixpt_add_cast_184;
  QGT_state_fixpt_sub_cast_731 <= resize(QGT_state_fixpt_add_temp_68, 85);
  QGT_state_fixpt_sub_cast_732 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_623 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_732 - 1));
  QGT_state_fixpt_cast_308 <= QGT_state_fixpt_mul_temp_623(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_733 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_624 <= QGT_state_fixpt_cast_308 * nc(to_integer(QGT_state_fixpt_sub_cast_733 - 1));
  QGT_state_fixpt_sub_cast_734 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_625 <= QGT_state_fixpt_mul_temp_624 * nc_0(to_integer(QGT_state_fixpt_sub_cast_734 - 1));
  QGT_state_fixpt_sub_cast_735 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_626 <= QGT_state_fixpt_mul_temp_625 * nc(to_integer(QGT_state_fixpt_sub_cast_735 - 1));
  QGT_state_fixpt_sub_cast_736 <= resize(QGT_state_fixpt_mul_temp_626, 81);
  QGT_state_fixpt_sub_cast_737 <= resize(QGT_state_fixpt_sub_cast_736, 85);
  QGT_state_fixpt_sub_temp_59 <= QGT_state_fixpt_sub_cast_731 - QGT_state_fixpt_sub_cast_737;
  QGT_state_fixpt_add_cast_185 <= resize(QGT_state_fixpt_sub_temp_59, 86);
  QGT_state_fixpt_sub_cast_738 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_627 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_738 - 1));
  QGT_state_fixpt_cast_309 <= QGT_state_fixpt_mul_temp_627(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_739 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_628 <= QGT_state_fixpt_cast_309 * nc(to_integer(QGT_state_fixpt_sub_cast_739 - 1));
  QGT_state_fixpt_cast_310 <= resize(QGT_state_fixpt_mul_temp_628, 50);
  QGT_state_fixpt_cast_311 <=  - (QGT_state_fixpt_cast_310);
  QGT_state_fixpt_sub_cast_740 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_629 <= QGT_state_fixpt_cast_311 * nc_0(to_integer(QGT_state_fixpt_sub_cast_740 - 1));
  QGT_state_fixpt_sub_cast_741 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_630 <= QGT_state_fixpt_mul_temp_629 * nc_0(to_integer(QGT_state_fixpt_sub_cast_741 - 1));
  QGT_state_fixpt_add_cast_186 <= resize(QGT_state_fixpt_mul_temp_630, 86);
  QGT_state_fixpt_add_temp_69 <= QGT_state_fixpt_add_cast_185 + QGT_state_fixpt_add_cast_186;
  QGT_state_fixpt_cast_312 <= QGT_state_fixpt_add_temp_69(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_631 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_312;
  QGT_state_fixpt_cast_313 <= QGT_state_fixpt_mul_temp_631(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_742 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_632 <= QGT_state_fixpt_cast_313 * nc_0(to_integer(QGT_state_fixpt_sub_cast_742 - 1));
  QGT_state_fixpt_sub_cast_743 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_633 <= QGT_state_fixpt_mul_temp_632 * nc_0(to_integer(QGT_state_fixpt_sub_cast_743 - 1));
  QGT_state_fixpt_sub_cast_744 <= resize(QGT_state_fixpt_mul_temp_633, 67);
  QGT_state_fixpt_sub_temp_60 <= QGT_state_fixpt_sub_cast_722 - QGT_state_fixpt_sub_cast_744;
  QGT_state_fixpt_add_cast_187 <= resize(QGT_state_fixpt_sub_temp_60, 68);
  QGT_state_fixpt_sub_cast_745 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_634 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_745 - 1));
  QGT_state_fixpt_sub_cast_746 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_635 <= QGT_state_fixpt_mul_temp_634 * nc_0(to_integer(QGT_state_fixpt_sub_cast_746 - 1));
  QGT_state_fixpt_sub_cast_747 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_636 <= QGT_state_fixpt_mul_temp_635 * nc_0(to_integer(QGT_state_fixpt_sub_cast_747 - 1));
  QGT_state_fixpt_sub_cast_748 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_637 <= QGT_state_fixpt_mul_temp_636 * nc(to_integer(QGT_state_fixpt_sub_cast_748 - 1));
  QGT_state_fixpt_add_cast_188 <= resize(QGT_state_fixpt_mul_temp_637 & '0', 82);
  QGT_state_fixpt_add_cast_189 <= resize(QGT_state_fixpt_add_cast_188, 83);
  QGT_state_fixpt_sub_cast_749 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_638 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_749 - 1));
  QGT_state_fixpt_sub_cast_750 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_639 <= QGT_state_fixpt_mul_temp_638 * nc(to_integer(QGT_state_fixpt_sub_cast_750 - 1));
  QGT_state_fixpt_sub_cast_751 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_640 <= QGT_state_fixpt_mul_temp_639 * nc_0(to_integer(QGT_state_fixpt_sub_cast_751 - 1));
  QGT_state_fixpt_sub_cast_752 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_641 <= QGT_state_fixpt_mul_temp_640 * nc_0(to_integer(QGT_state_fixpt_sub_cast_752 - 1));
  QGT_state_fixpt_add_cast_190 <= resize(QGT_state_fixpt_mul_temp_641 & '0', 82);
  QGT_state_fixpt_add_cast_191 <= resize(QGT_state_fixpt_add_cast_190, 83);
  QGT_state_fixpt_add_temp_70 <= QGT_state_fixpt_add_cast_189 + QGT_state_fixpt_add_cast_191;
  QGT_state_fixpt_add_cast_192 <= resize(QGT_state_fixpt_add_temp_70, 84);
  QGT_state_fixpt_sub_cast_753 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_642 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_753 - 1));
  QGT_state_fixpt_cast_314 <= QGT_state_fixpt_mul_temp_642(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_754 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_643 <= QGT_state_fixpt_cast_314 * nc(to_integer(QGT_state_fixpt_sub_cast_754 - 1));
  QGT_state_fixpt_sub_cast_755 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_644 <= QGT_state_fixpt_mul_temp_643 * nc_0(to_integer(QGT_state_fixpt_sub_cast_755 - 1));
  QGT_state_fixpt_sub_cast_756 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_645 <= QGT_state_fixpt_mul_temp_644 * nc(to_integer(QGT_state_fixpt_sub_cast_756 - 1));
  QGT_state_fixpt_add_cast_193 <= resize(QGT_state_fixpt_mul_temp_645, 81);
  QGT_state_fixpt_add_cast_194 <= resize(QGT_state_fixpt_add_cast_193, 84);
  QGT_state_fixpt_add_temp_71 <= QGT_state_fixpt_add_cast_192 + QGT_state_fixpt_add_cast_194;
  QGT_state_fixpt_add_cast_195 <= resize(QGT_state_fixpt_add_temp_71, 85);
  QGT_state_fixpt_sub_cast_757 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_646 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_757 - 1));
  QGT_state_fixpt_cast_315 <= QGT_state_fixpt_mul_temp_646(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_758 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_647 <= QGT_state_fixpt_cast_315 * nc(to_integer(QGT_state_fixpt_sub_cast_758 - 1));
  QGT_state_fixpt_cast_316 <= resize(QGT_state_fixpt_mul_temp_647, 50);
  QGT_state_fixpt_cast_317 <=  - (QGT_state_fixpt_cast_316);
  QGT_state_fixpt_sub_cast_759 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_648 <= QGT_state_fixpt_cast_317 * nc(to_integer(QGT_state_fixpt_sub_cast_759 - 1));
  QGT_state_fixpt_sub_cast_760 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_649 <= QGT_state_fixpt_mul_temp_648 * nc(to_integer(QGT_state_fixpt_sub_cast_760 - 1));
  QGT_state_fixpt_add_cast_196 <= resize(QGT_state_fixpt_mul_temp_649, 85);
  QGT_state_fixpt_add_temp_72 <= QGT_state_fixpt_add_cast_195 + QGT_state_fixpt_add_cast_196;
  QGT_state_fixpt_cast_318 <= QGT_state_fixpt_add_temp_72(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_650 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_318;
  QGT_state_fixpt_cast_319 <= QGT_state_fixpt_mul_temp_650(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_761 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_651 <= QGT_state_fixpt_cast_319 * nc(to_integer(QGT_state_fixpt_sub_cast_761 - 1));
  QGT_state_fixpt_sub_cast_762 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_652 <= QGT_state_fixpt_mul_temp_651 * nc(to_integer(QGT_state_fixpt_sub_cast_762 - 1));
  QGT_state_fixpt_add_cast_197 <= resize(QGT_state_fixpt_mul_temp_652, 68);
  QGT_state_fixpt_add_temp_73 <= QGT_state_fixpt_add_cast_187 + QGT_state_fixpt_add_cast_197;
  QGT_state_fixpt_sub_cast_763 <= resize(QGT_state_fixpt_add_temp_73, 69);
  QGT_state_fixpt_sub_cast_764 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_653 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_764 - 1));
  QGT_state_fixpt_cast_320 <= QGT_state_fixpt_mul_temp_653(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_765 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_654 <= QGT_state_fixpt_cast_320 * nc(to_integer(QGT_state_fixpt_sub_cast_765 - 1));
  QGT_state_fixpt_cast_321 <= resize(QGT_state_fixpt_mul_temp_654, 50);
  QGT_state_fixpt_cast_322 <=  - (QGT_state_fixpt_cast_321);
  QGT_state_fixpt_sub_cast_766 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_655 <= QGT_state_fixpt_cast_322 * nc(to_integer(QGT_state_fixpt_sub_cast_766 - 1));
  QGT_state_fixpt_sub_cast_767 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_656 <= QGT_state_fixpt_mul_temp_655 * nc(to_integer(QGT_state_fixpt_sub_cast_767 - 1));
  QGT_state_fixpt_add_cast_198 <= resize(QGT_state_fixpt_mul_temp_656, 83);
  QGT_state_fixpt_sub_cast_768 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_657 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_768 - 1));
  QGT_state_fixpt_cast_323 <= QGT_state_fixpt_mul_temp_657(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_769 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_658 <= QGT_state_fixpt_cast_323 * nc(to_integer(QGT_state_fixpt_sub_cast_769 - 1));
  QGT_state_fixpt_cast_324 <= resize(QGT_state_fixpt_mul_temp_658, 50);
  QGT_state_fixpt_cast_325 <=  - (QGT_state_fixpt_cast_324);
  QGT_state_fixpt_sub_cast_770 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_659 <= QGT_state_fixpt_cast_325 * nc_0(to_integer(QGT_state_fixpt_sub_cast_770 - 1));
  QGT_state_fixpt_sub_cast_771 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_660 <= QGT_state_fixpt_mul_temp_659 * nc(to_integer(QGT_state_fixpt_sub_cast_771 - 1));
  QGT_state_fixpt_add_cast_199 <= resize(QGT_state_fixpt_mul_temp_660, 83);
  QGT_state_fixpt_add_temp_74 <= QGT_state_fixpt_add_cast_198 + QGT_state_fixpt_add_cast_199;
  QGT_state_fixpt_sub_cast_772 <= resize(QGT_state_fixpt_add_temp_74, 84);
  QGT_state_fixpt_sub_cast_773 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_661 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_773 - 1));
  QGT_state_fixpt_cast_326 <= QGT_state_fixpt_mul_temp_661(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_774 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_662 <= QGT_state_fixpt_cast_326 * nc_0(to_integer(QGT_state_fixpt_sub_cast_774 - 1));
  QGT_state_fixpt_sub_cast_775 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_663 <= QGT_state_fixpt_mul_temp_662 * nc_0(to_integer(QGT_state_fixpt_sub_cast_775 - 1));
  QGT_state_fixpt_sub_cast_776 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_664 <= QGT_state_fixpt_mul_temp_663 * nc_0(to_integer(QGT_state_fixpt_sub_cast_776 - 1));
  QGT_state_fixpt_sub_cast_777 <= resize(QGT_state_fixpt_mul_temp_664, 81);
  QGT_state_fixpt_sub_cast_778 <= resize(QGT_state_fixpt_sub_cast_777, 84);
  QGT_state_fixpt_sub_temp_61 <= QGT_state_fixpt_sub_cast_772 - QGT_state_fixpt_sub_cast_778;
  QGT_state_fixpt_sub_cast_779 <= resize(QGT_state_fixpt_sub_temp_61, 85);
  QGT_state_fixpt_sub_cast_780 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_665 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_780 - 1));
  QGT_state_fixpt_sub_cast_781 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_666 <= QGT_state_fixpt_mul_temp_665 * nc(to_integer(QGT_state_fixpt_sub_cast_781 - 1));
  QGT_state_fixpt_sub_cast_782 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_667 <= QGT_state_fixpt_mul_temp_666 * nc_0(to_integer(QGT_state_fixpt_sub_cast_782 - 1));
  QGT_state_fixpt_sub_cast_783 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_668 <= QGT_state_fixpt_mul_temp_667 * nc(to_integer(QGT_state_fixpt_sub_cast_783 - 1));
  QGT_state_fixpt_sub_cast_784 <= resize(QGT_state_fixpt_mul_temp_668 & '0', 82);
  QGT_state_fixpt_sub_cast_785 <= resize(QGT_state_fixpt_sub_cast_784, 85);
  QGT_state_fixpt_sub_temp_62 <= QGT_state_fixpt_sub_cast_779 - QGT_state_fixpt_sub_cast_785;
  QGT_state_fixpt_cast_327 <= QGT_state_fixpt_sub_temp_62(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_669 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_327;
  QGT_state_fixpt_cast_328 <= QGT_state_fixpt_mul_temp_669(31 DOWNTO 0);
  QGT_state_fixpt_cast_329 <= resize(QGT_state_fixpt_cast_328, 33);
  QGT_state_fixpt_cast_330 <=  - (QGT_state_fixpt_cast_329);
  QGT_state_fixpt_sub_cast_786 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_670 <= QGT_state_fixpt_cast_330 * nc_0(to_integer(QGT_state_fixpt_sub_cast_786 - 1));
  QGT_state_fixpt_sub_cast_787 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_671 <= QGT_state_fixpt_mul_temp_670 * nc(to_integer(QGT_state_fixpt_sub_cast_787 - 1));
  QGT_state_fixpt_sub_cast_788 <= resize(QGT_state_fixpt_mul_temp_671, 69);
  QGT_state_fixpt_sub_temp_63 <= QGT_state_fixpt_sub_cast_763 - QGT_state_fixpt_sub_cast_788;
  QGT_state_fixpt_add_cast_200 <= resize(QGT_state_fixpt_sub_temp_63, 72);
  QGT_state_fixpt_sub_cast_789 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_672 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_789 - 1));
  QGT_state_fixpt_sub_cast_790 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_673 <= QGT_state_fixpt_mul_temp_672 * nc_0(to_integer(QGT_state_fixpt_sub_cast_790 - 1));
  QGT_state_fixpt_cast_331 <= resize(QGT_state_fixpt_mul_temp_673 & '0', 51);
  QGT_state_fixpt_cast_332 <= resize(QGT_state_fixpt_cast_331, 52);
  QGT_state_fixpt_cast_333 <=  - (QGT_state_fixpt_cast_332);
  QGT_state_fixpt_cast_334 <= QGT_state_fixpt_cast_333(50 DOWNTO 0);
  QGT_state_fixpt_sub_cast_791 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_674 <= QGT_state_fixpt_cast_334 * nc_0(to_integer(QGT_state_fixpt_sub_cast_791 - 1));
  QGT_state_fixpt_sub_cast_792 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_675 <= QGT_state_fixpt_mul_temp_674 * nc_0(to_integer(QGT_state_fixpt_sub_cast_792 - 1));
  QGT_state_fixpt_add_cast_201 <= resize(QGT_state_fixpt_mul_temp_675, 84);
  QGT_state_fixpt_sub_cast_793 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_676 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_793 - 1));
  QGT_state_fixpt_sub_cast_794 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_677 <= QGT_state_fixpt_mul_temp_676 * nc(to_integer(QGT_state_fixpt_sub_cast_794 - 1));
  QGT_state_fixpt_sub_cast_795 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_678 <= QGT_state_fixpt_mul_temp_677 * nc_0(to_integer(QGT_state_fixpt_sub_cast_795 - 1));
  QGT_state_fixpt_sub_cast_796 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_679 <= QGT_state_fixpt_mul_temp_678 * nc(to_integer(QGT_state_fixpt_sub_cast_796 - 1));
  QGT_state_fixpt_add_cast_202 <= resize(QGT_state_fixpt_mul_temp_679 & '0', 82);
  QGT_state_fixpt_add_cast_203 <= resize(QGT_state_fixpt_add_cast_202, 84);
  QGT_state_fixpt_add_temp_75 <= QGT_state_fixpt_add_cast_201 + QGT_state_fixpt_add_cast_203;
  QGT_state_fixpt_add_cast_204 <= resize(QGT_state_fixpt_add_temp_75, 85);
  QGT_state_fixpt_sub_cast_797 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_680 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_797 - 1));
  QGT_state_fixpt_cast_335 <= QGT_state_fixpt_mul_temp_680(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_798 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_681 <= QGT_state_fixpt_cast_335 * nc(to_integer(QGT_state_fixpt_sub_cast_798 - 1));
  QGT_state_fixpt_sub_cast_799 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_682 <= QGT_state_fixpt_mul_temp_681 * nc(to_integer(QGT_state_fixpt_sub_cast_799 - 1));
  QGT_state_fixpt_sub_cast_800 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_683 <= QGT_state_fixpt_mul_temp_682 * nc(to_integer(QGT_state_fixpt_sub_cast_800 - 1));
  QGT_state_fixpt_add_cast_205 <= resize(QGT_state_fixpt_mul_temp_683, 81);
  QGT_state_fixpt_add_cast_206 <= resize(QGT_state_fixpt_add_cast_205, 85);
  QGT_state_fixpt_add_temp_76 <= QGT_state_fixpt_add_cast_204 + QGT_state_fixpt_add_cast_206;
  QGT_state_fixpt_sub_cast_801 <= resize(QGT_state_fixpt_add_temp_76, 86);
  QGT_state_fixpt_sub_cast_802 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_684 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_802 - 1));
  QGT_state_fixpt_cast_336 <= QGT_state_fixpt_mul_temp_684(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_803 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_685 <= QGT_state_fixpt_cast_336 * nc(to_integer(QGT_state_fixpt_sub_cast_803 - 1));
  QGT_state_fixpt_cast_337 <= resize(QGT_state_fixpt_mul_temp_685, 50);
  QGT_state_fixpt_cast_338 <=  - (QGT_state_fixpt_cast_337);
  QGT_state_fixpt_sub_cast_804 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_686 <= QGT_state_fixpt_cast_338 * nc_0(to_integer(QGT_state_fixpt_sub_cast_804 - 1));
  QGT_state_fixpt_sub_cast_805 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_687 <= QGT_state_fixpt_mul_temp_686 * nc(to_integer(QGT_state_fixpt_sub_cast_805 - 1));
  QGT_state_fixpt_sub_cast_806 <= resize(QGT_state_fixpt_mul_temp_687, 86);
  QGT_state_fixpt_sub_temp_64 <= QGT_state_fixpt_sub_cast_801 - QGT_state_fixpt_sub_cast_806;
  QGT_state_fixpt_cast_339 <= QGT_state_fixpt_sub_temp_64(73 DOWNTO 58);
  QGT_state_fixpt_cast_340 <= resize(QGT_state_fixpt_cast_339, 17);
  QGT_state_fixpt_cast_341 <=  - (QGT_state_fixpt_cast_340);
  QGT_state_fixpt_cast_342 <= resize(QGT_state_fixpt_cast_341, 18);
  QGT_state_fixpt_sub_cast_807 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_688 <= QGT_state_fixpt_cast_342 * nc_0(to_integer(QGT_state_fixpt_sub_cast_807 - 1));
  QGT_state_fixpt_sub_cast_808 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_689 <= QGT_state_fixpt_mul_temp_688 * nc(to_integer(QGT_state_fixpt_sub_cast_808 - 1));
  QGT_state_fixpt_add_cast_207 <= resize(QGT_state_fixpt_mul_temp_689, 51);
  QGT_state_fixpt_add_cast_208 <= resize(QGT_state_fixpt_add_cast_207, 52);
  QGT_state_fixpt_sub_cast_809 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_690 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_809 - 1));
  QGT_state_fixpt_cast_343 <= QGT_state_fixpt_mul_temp_690(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_810 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_691 <= QGT_state_fixpt_cast_343 * nc(to_integer(QGT_state_fixpt_sub_cast_810 - 1));
  QGT_state_fixpt_cast_344 <= resize(QGT_state_fixpt_mul_temp_691, 50);
  QGT_state_fixpt_cast_345 <=  - (QGT_state_fixpt_cast_344);
  QGT_state_fixpt_cast_346 <= resize(QGT_state_fixpt_cast_345, 51);
  QGT_state_fixpt_cast_347 <= resize(QGT_state_fixpt_cast_346, 52);
  QGT_state_fixpt_cast_348 <=  - (QGT_state_fixpt_cast_347);
  QGT_state_fixpt_cast_349 <= QGT_state_fixpt_cast_348(50 DOWNTO 0);
  QGT_state_fixpt_sub_cast_811 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_692 <= QGT_state_fixpt_cast_349 * nc_0(to_integer(QGT_state_fixpt_sub_cast_811 - 1));
  QGT_state_fixpt_sub_cast_812 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_693 <= QGT_state_fixpt_mul_temp_692 * nc(to_integer(QGT_state_fixpt_sub_cast_812 - 1));
  QGT_state_fixpt_add_cast_209 <= resize(QGT_state_fixpt_mul_temp_693, 84);
  QGT_state_fixpt_sub_cast_813 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_694 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_813 - 1));
  QGT_state_fixpt_cast_350 <= QGT_state_fixpt_mul_temp_694(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_814 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_695 <= QGT_state_fixpt_cast_350 * nc(to_integer(QGT_state_fixpt_sub_cast_814 - 1));
  QGT_state_fixpt_cast_351 <= resize(QGT_state_fixpt_mul_temp_695, 50);
  QGT_state_fixpt_cast_352 <=  - (QGT_state_fixpt_cast_351);
  QGT_state_fixpt_sub_cast_815 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_696 <= QGT_state_fixpt_cast_352 * nc(to_integer(QGT_state_fixpt_sub_cast_815 - 1));
  QGT_state_fixpt_sub_cast_816 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_697 <= QGT_state_fixpt_mul_temp_696 * nc(to_integer(QGT_state_fixpt_sub_cast_816 - 1));
  QGT_state_fixpt_add_cast_210 <= resize(QGT_state_fixpt_mul_temp_697, 84);
  QGT_state_fixpt_add_temp_77 <= QGT_state_fixpt_add_cast_209 + QGT_state_fixpt_add_cast_210;
  QGT_state_fixpt_sub_cast_817 <= resize(QGT_state_fixpt_add_temp_77, 85);
  QGT_state_fixpt_sub_cast_818 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_698 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_818 - 1));
  QGT_state_fixpt_cast_353 <= QGT_state_fixpt_mul_temp_698(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_819 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_699 <= QGT_state_fixpt_cast_353 * nc_0(to_integer(QGT_state_fixpt_sub_cast_819 - 1));
  QGT_state_fixpt_sub_cast_820 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_700 <= QGT_state_fixpt_mul_temp_699 * nc_0(to_integer(QGT_state_fixpt_sub_cast_820 - 1));
  QGT_state_fixpt_sub_cast_821 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_701 <= QGT_state_fixpt_mul_temp_700 * nc(to_integer(QGT_state_fixpt_sub_cast_821 - 1));
  QGT_state_fixpt_sub_cast_822 <= resize(QGT_state_fixpt_mul_temp_701, 81);
  QGT_state_fixpt_sub_cast_823 <= resize(QGT_state_fixpt_sub_cast_822, 85);
  QGT_state_fixpt_sub_temp_65 <= QGT_state_fixpt_sub_cast_817 - QGT_state_fixpt_sub_cast_823;
  QGT_state_fixpt_add_cast_211 <= resize(QGT_state_fixpt_sub_temp_65, 86);
  QGT_state_fixpt_sub_cast_824 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_702 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_824 - 1));
  QGT_state_fixpt_sub_cast_825 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_703 <= QGT_state_fixpt_mul_temp_702 * nc(to_integer(QGT_state_fixpt_sub_cast_825 - 1));
  QGT_state_fixpt_sub_cast_826 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_704 <= QGT_state_fixpt_mul_temp_703 * nc_0(to_integer(QGT_state_fixpt_sub_cast_826 - 1));
  QGT_state_fixpt_sub_cast_827 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_705 <= QGT_state_fixpt_mul_temp_704 * nc_0(to_integer(QGT_state_fixpt_sub_cast_827 - 1));
  QGT_state_fixpt_add_cast_212 <= resize(QGT_state_fixpt_mul_temp_705 & '0', 82);
  QGT_state_fixpt_add_cast_213 <= resize(QGT_state_fixpt_add_cast_212, 86);
  QGT_state_fixpt_add_temp_78 <= QGT_state_fixpt_add_cast_211 + QGT_state_fixpt_add_cast_213;
  QGT_state_fixpt_cast_354 <= QGT_state_fixpt_add_temp_78(73 DOWNTO 58);
  QGT_state_fixpt_sub_cast_828 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_706 <= QGT_state_fixpt_cast_354 * nc(to_integer(QGT_state_fixpt_sub_cast_828 - 1));
  QGT_state_fixpt_sub_cast_829 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_707 <= QGT_state_fixpt_mul_temp_706 * nc(to_integer(QGT_state_fixpt_sub_cast_829 - 1));
  QGT_state_fixpt_add_cast_214 <= resize(QGT_state_fixpt_mul_temp_707, 52);
  QGT_state_fixpt_add_temp_79 <= QGT_state_fixpt_add_cast_208 + QGT_state_fixpt_add_cast_214;
  QGT_state_fixpt_sub_cast_830 <= resize(QGT_state_fixpt_add_temp_79, 53);
  QGT_state_fixpt_sub_cast_831 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_708 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_831 - 1));
  QGT_state_fixpt_cast_355 <= QGT_state_fixpt_mul_temp_708(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_832 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_709 <= QGT_state_fixpt_cast_355 * nc(to_integer(QGT_state_fixpt_sub_cast_832 - 1));
  QGT_state_fixpt_cast_356 <= resize(QGT_state_fixpt_mul_temp_709, 50);
  QGT_state_fixpt_cast_357 <=  - (QGT_state_fixpt_cast_356);
  QGT_state_fixpt_sub_cast_833 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_710 <= QGT_state_fixpt_cast_357 * nc_0(to_integer(QGT_state_fixpt_sub_cast_833 - 1));
  QGT_state_fixpt_sub_cast_834 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_711 <= QGT_state_fixpt_mul_temp_710 * nc(to_integer(QGT_state_fixpt_sub_cast_834 - 1));
  QGT_state_fixpt_add_cast_215 <= resize(QGT_state_fixpt_mul_temp_711, 83);
  QGT_state_fixpt_sub_cast_835 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_712 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_835 - 1));
  QGT_state_fixpt_cast_358 <= QGT_state_fixpt_mul_temp_712(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_836 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_713 <= QGT_state_fixpt_cast_358 * nc(to_integer(QGT_state_fixpt_sub_cast_836 - 1));
  QGT_state_fixpt_cast_359 <= resize(QGT_state_fixpt_mul_temp_713, 50);
  QGT_state_fixpt_cast_360 <=  - (QGT_state_fixpt_cast_359);
  QGT_state_fixpt_sub_cast_837 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_714 <= QGT_state_fixpt_cast_360 * nc_0(to_integer(QGT_state_fixpt_sub_cast_837 - 1));
  QGT_state_fixpt_sub_cast_838 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_715 <= QGT_state_fixpt_mul_temp_714 * nc_0(to_integer(QGT_state_fixpt_sub_cast_838 - 1));
  QGT_state_fixpt_add_cast_216 <= resize(QGT_state_fixpt_mul_temp_715, 83);
  QGT_state_fixpt_add_temp_80 <= QGT_state_fixpt_add_cast_215 + QGT_state_fixpt_add_cast_216;
  QGT_state_fixpt_add_cast_217 <= resize(QGT_state_fixpt_add_temp_80, 84);
  QGT_state_fixpt_sub_cast_839 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_716 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_839 - 1));
  QGT_state_fixpt_cast_361 <= QGT_state_fixpt_mul_temp_716(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_840 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_717 <= QGT_state_fixpt_cast_361 * nc_0(to_integer(QGT_state_fixpt_sub_cast_840 - 1));
  QGT_state_fixpt_sub_cast_841 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_718 <= QGT_state_fixpt_mul_temp_717 * nc_0(to_integer(QGT_state_fixpt_sub_cast_841 - 1));
  QGT_state_fixpt_sub_cast_842 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_719 <= QGT_state_fixpt_mul_temp_718 * nc(to_integer(QGT_state_fixpt_sub_cast_842 - 1));
  QGT_state_fixpt_add_cast_218 <= resize(QGT_state_fixpt_mul_temp_719, 81);
  QGT_state_fixpt_add_cast_219 <= resize(QGT_state_fixpt_add_cast_218, 84);
  QGT_state_fixpt_add_temp_81 <= QGT_state_fixpt_add_cast_217 + QGT_state_fixpt_add_cast_219;
  QGT_state_fixpt_add_cast_220 <= resize(QGT_state_fixpt_add_temp_81, 85);
  QGT_state_fixpt_sub_cast_843 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_720 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_843 - 1));
  QGT_state_fixpt_sub_cast_844 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_721 <= QGT_state_fixpt_mul_temp_720 * nc(to_integer(QGT_state_fixpt_sub_cast_844 - 1));
  QGT_state_fixpt_sub_cast_845 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_722 <= QGT_state_fixpt_mul_temp_721 * nc(to_integer(QGT_state_fixpt_sub_cast_845 - 1));
  QGT_state_fixpt_sub_cast_846 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_723 <= QGT_state_fixpt_mul_temp_722 * nc(to_integer(QGT_state_fixpt_sub_cast_846 - 1));
  QGT_state_fixpt_add_cast_221 <= resize(QGT_state_fixpt_mul_temp_723 & '0', 82);
  QGT_state_fixpt_add_cast_222 <= resize(QGT_state_fixpt_add_cast_221, 85);
  QGT_state_fixpt_add_temp_82 <= QGT_state_fixpt_add_cast_220 + QGT_state_fixpt_add_cast_222;
  QGT_state_fixpt_cast_362 <= QGT_state_fixpt_add_temp_82(73 DOWNTO 58);
  QGT_state_fixpt_sub_cast_847 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_724 <= QGT_state_fixpt_cast_362 * nc_0(to_integer(QGT_state_fixpt_sub_cast_847 - 1));
  QGT_state_fixpt_sub_cast_848 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_725 <= QGT_state_fixpt_mul_temp_724 * nc_0(to_integer(QGT_state_fixpt_sub_cast_848 - 1));
  QGT_state_fixpt_sub_cast_849 <= resize(QGT_state_fixpt_mul_temp_725, 53);
  QGT_state_fixpt_sub_temp_66 <= QGT_state_fixpt_sub_cast_830 - QGT_state_fixpt_sub_cast_849;
  QGT_state_fixpt_sub_cast_850 <= resize(QGT_state_fixpt_sub_temp_66, 54);
  QGT_state_fixpt_sub_cast_851 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_726 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_851 - 1));
  QGT_state_fixpt_sub_cast_852 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_727 <= QGT_state_fixpt_mul_temp_726 * nc_0(to_integer(QGT_state_fixpt_sub_cast_852 - 1));
  QGT_state_fixpt_sub_cast_853 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_728 <= QGT_state_fixpt_mul_temp_727 * nc(to_integer(QGT_state_fixpt_sub_cast_853 - 1));
  QGT_state_fixpt_sub_cast_854 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_729 <= QGT_state_fixpt_mul_temp_728 * nc(to_integer(QGT_state_fixpt_sub_cast_854 - 1));
  QGT_state_fixpt_add_cast_223 <= resize(QGT_state_fixpt_mul_temp_729 & '0', 82);
  QGT_state_fixpt_add_cast_224 <= resize(QGT_state_fixpt_add_cast_223, 83);
  QGT_state_fixpt_sub_cast_855 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_730 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_855 - 1));
  QGT_state_fixpt_sub_cast_856 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_731 <= QGT_state_fixpt_mul_temp_730 * nc(to_integer(QGT_state_fixpt_sub_cast_856 - 1));
  QGT_state_fixpt_sub_cast_857 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_732 <= QGT_state_fixpt_mul_temp_731 * nc_0(to_integer(QGT_state_fixpt_sub_cast_857 - 1));
  QGT_state_fixpt_sub_cast_858 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_733 <= QGT_state_fixpt_mul_temp_732 * nc(to_integer(QGT_state_fixpt_sub_cast_858 - 1));
  QGT_state_fixpt_add_cast_225 <= resize(QGT_state_fixpt_mul_temp_733 & '0', 82);
  QGT_state_fixpt_add_cast_226 <= resize(QGT_state_fixpt_add_cast_225, 83);
  QGT_state_fixpt_add_temp_83 <= QGT_state_fixpt_add_cast_224 + QGT_state_fixpt_add_cast_226;
  QGT_state_fixpt_sub_cast_859 <= resize(QGT_state_fixpt_add_temp_83, 84);
  QGT_state_fixpt_sub_cast_860 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_734 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_860 - 1));
  QGT_state_fixpt_cast_363 <= QGT_state_fixpt_mul_temp_734(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_861 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_735 <= QGT_state_fixpt_cast_363 * nc(to_integer(QGT_state_fixpt_sub_cast_861 - 1));
  QGT_state_fixpt_sub_cast_862 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_736 <= QGT_state_fixpt_mul_temp_735 * nc_0(to_integer(QGT_state_fixpt_sub_cast_862 - 1));
  QGT_state_fixpt_sub_cast_863 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_737 <= QGT_state_fixpt_mul_temp_736 * nc_0(to_integer(QGT_state_fixpt_sub_cast_863 - 1));
  QGT_state_fixpt_sub_cast_864 <= resize(QGT_state_fixpt_mul_temp_737, 81);
  QGT_state_fixpt_sub_cast_865 <= resize(QGT_state_fixpt_sub_cast_864, 84);
  QGT_state_fixpt_sub_temp_67 <= QGT_state_fixpt_sub_cast_859 - QGT_state_fixpt_sub_cast_865;
  QGT_state_fixpt_sub_cast_866 <= resize(QGT_state_fixpt_sub_temp_67, 85);
  QGT_state_fixpt_sub_cast_867 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_738 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_867 - 1));
  QGT_state_fixpt_cast_364 <= QGT_state_fixpt_mul_temp_738(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_868 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_739 <= QGT_state_fixpt_cast_364 * nc(to_integer(QGT_state_fixpt_sub_cast_868 - 1));
  QGT_state_fixpt_cast_365 <= resize(QGT_state_fixpt_mul_temp_739, 50);
  QGT_state_fixpt_cast_366 <=  - (QGT_state_fixpt_cast_365);
  QGT_state_fixpt_sub_cast_869 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_740 <= QGT_state_fixpt_cast_366 * nc_0(to_integer(QGT_state_fixpt_sub_cast_869 - 1));
  QGT_state_fixpt_sub_cast_870 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_741 <= QGT_state_fixpt_mul_temp_740 * nc(to_integer(QGT_state_fixpt_sub_cast_870 - 1));
  QGT_state_fixpt_sub_cast_871 <= resize(QGT_state_fixpt_mul_temp_741, 85);
  QGT_state_fixpt_sub_temp_68 <= QGT_state_fixpt_sub_cast_866 - QGT_state_fixpt_sub_cast_871;
  QGT_state_fixpt_cast_367 <= QGT_state_fixpt_sub_temp_68(73 DOWNTO 58);
  QGT_state_fixpt_sub_cast_872 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_742 <= QGT_state_fixpt_cast_367 * nc_0(to_integer(QGT_state_fixpt_sub_cast_872 - 1));
  QGT_state_fixpt_sub_cast_873 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_743 <= QGT_state_fixpt_mul_temp_742 * nc(to_integer(QGT_state_fixpt_sub_cast_873 - 1));
  QGT_state_fixpt_sub_cast_874 <= resize(QGT_state_fixpt_mul_temp_743, 50);
  QGT_state_fixpt_sub_cast_875 <= resize(QGT_state_fixpt_sub_cast_874, 54);
  QGT_state_fixpt_sub_temp_69 <= QGT_state_fixpt_sub_cast_850 - QGT_state_fixpt_sub_cast_875;
  QGT_state_fixpt_mul_temp_744 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_sub_temp_69;
  QGT_state_fixpt_cast_368 <= QGT_state_fixpt_mul_temp_744(69 DOWNTO 0);
  QGT_state_fixpt_cast_369 <= resize(QGT_state_fixpt_cast_368, 71);
  QGT_state_fixpt_cast_370 <=  - (QGT_state_fixpt_cast_369);
  QGT_state_fixpt_add_cast_227 <= resize(QGT_state_fixpt_cast_370, 72);
  QGT_state_fixpt_add_temp_84 <= QGT_state_fixpt_add_cast_200 + QGT_state_fixpt_add_cast_227;
  QGT_state_fixpt_c_re_2 <= QGT_state_fixpt_add_temp_84(59 DOWNTO 44);
  QGT_state_fixpt_sub_cast_876 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_745 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_876 - 1));
  QGT_state_fixpt_sub_cast_877 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_746 <= QGT_state_fixpt_mul_temp_745 * nc_0(to_integer(QGT_state_fixpt_sub_cast_877 - 1));
  QGT_state_fixpt_cast_371 <= resize(QGT_state_fixpt_mul_temp_746 & '0', 51);
  QGT_state_fixpt_cast_372 <= resize(QGT_state_fixpt_cast_371, 52);
  QGT_state_fixpt_cast_373 <=  - (QGT_state_fixpt_cast_372);
  QGT_state_fixpt_cast_374 <= QGT_state_fixpt_cast_373(50 DOWNTO 0);
  QGT_state_fixpt_sub_cast_878 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_747 <= QGT_state_fixpt_cast_374 * nc_0(to_integer(QGT_state_fixpt_sub_cast_878 - 1));
  QGT_state_fixpt_sub_cast_879 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_748 <= QGT_state_fixpt_mul_temp_747 * nc_0(to_integer(QGT_state_fixpt_sub_cast_879 - 1));
  QGT_state_fixpt_add_cast_228 <= resize(QGT_state_fixpt_mul_temp_748, 84);
  QGT_state_fixpt_sub_cast_880 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_749 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_880 - 1));
  QGT_state_fixpt_sub_cast_881 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_750 <= QGT_state_fixpt_mul_temp_749 * nc(to_integer(QGT_state_fixpt_sub_cast_881 - 1));
  QGT_state_fixpt_sub_cast_882 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_751 <= QGT_state_fixpt_mul_temp_750 * nc_0(to_integer(QGT_state_fixpt_sub_cast_882 - 1));
  QGT_state_fixpt_sub_cast_883 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_752 <= QGT_state_fixpt_mul_temp_751 * nc(to_integer(QGT_state_fixpt_sub_cast_883 - 1));
  QGT_state_fixpt_add_cast_229 <= resize(QGT_state_fixpt_mul_temp_752 & '0', 82);
  QGT_state_fixpt_add_cast_230 <= resize(QGT_state_fixpt_add_cast_229, 84);
  QGT_state_fixpt_add_temp_85 <= QGT_state_fixpt_add_cast_228 + QGT_state_fixpt_add_cast_230;
  QGT_state_fixpt_add_cast_231 <= resize(QGT_state_fixpt_add_temp_85, 85);
  QGT_state_fixpt_sub_cast_884 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_753 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_884 - 1));
  QGT_state_fixpt_cast_375 <= QGT_state_fixpt_mul_temp_753(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_885 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_754 <= QGT_state_fixpt_cast_375 * nc(to_integer(QGT_state_fixpt_sub_cast_885 - 1));
  QGT_state_fixpt_sub_cast_886 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_755 <= QGT_state_fixpt_mul_temp_754 * nc(to_integer(QGT_state_fixpt_sub_cast_886 - 1));
  QGT_state_fixpt_sub_cast_887 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_756 <= QGT_state_fixpt_mul_temp_755 * nc(to_integer(QGT_state_fixpt_sub_cast_887 - 1));
  QGT_state_fixpt_add_cast_232 <= resize(QGT_state_fixpt_mul_temp_756, 81);
  QGT_state_fixpt_add_cast_233 <= resize(QGT_state_fixpt_add_cast_232, 85);
  QGT_state_fixpt_add_temp_86 <= QGT_state_fixpt_add_cast_231 + QGT_state_fixpt_add_cast_233;
  QGT_state_fixpt_sub_cast_888 <= resize(QGT_state_fixpt_add_temp_86, 86);
  QGT_state_fixpt_sub_cast_889 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_757 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_889 - 1));
  QGT_state_fixpt_cast_376 <= QGT_state_fixpt_mul_temp_757(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_890 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_758 <= QGT_state_fixpt_cast_376 * nc(to_integer(QGT_state_fixpt_sub_cast_890 - 1));
  QGT_state_fixpt_cast_377 <= resize(QGT_state_fixpt_mul_temp_758, 50);
  QGT_state_fixpt_cast_378 <=  - (QGT_state_fixpt_cast_377);
  QGT_state_fixpt_sub_cast_891 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_759 <= QGT_state_fixpt_cast_378 * nc_0(to_integer(QGT_state_fixpt_sub_cast_891 - 1));
  QGT_state_fixpt_sub_cast_892 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_760 <= QGT_state_fixpt_mul_temp_759 * nc(to_integer(QGT_state_fixpt_sub_cast_892 - 1));
  QGT_state_fixpt_sub_cast_893 <= resize(QGT_state_fixpt_mul_temp_760, 86);
  QGT_state_fixpt_sub_temp_70 <= QGT_state_fixpt_sub_cast_888 - QGT_state_fixpt_sub_cast_893;
  QGT_state_fixpt_cast_379 <= QGT_state_fixpt_sub_temp_70(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_761 <= to_signed(-16#5A83#, 16) * QGT_state_fixpt_cast_379;
  QGT_state_fixpt_sub_cast_894 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_762 <= QGT_state_fixpt_mul_temp_761 * nc_0(to_integer(QGT_state_fixpt_sub_cast_894 - 1));
  QGT_state_fixpt_sub_cast_895 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_763 <= QGT_state_fixpt_mul_temp_762 * nc(to_integer(QGT_state_fixpt_sub_cast_895 - 1));
  QGT_state_fixpt_sub_cast_896 <= resize(QGT_state_fixpt_mul_temp_763, 65);
  QGT_state_fixpt_sub_cast_897 <= resize(QGT_state_fixpt_sub_cast_896 & '0', 67);
  QGT_state_fixpt_sub_cast_898 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_764 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_898 - 1));
  QGT_state_fixpt_cast_380 <= QGT_state_fixpt_mul_temp_764(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_899 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_765 <= QGT_state_fixpt_cast_380 * nc(to_integer(QGT_state_fixpt_sub_cast_899 - 1));
  QGT_state_fixpt_cast_381 <= resize(QGT_state_fixpt_mul_temp_765, 50);
  QGT_state_fixpt_cast_382 <=  - (QGT_state_fixpt_cast_381);
  QGT_state_fixpt_cast_383 <= resize(QGT_state_fixpt_cast_382, 51);
  QGT_state_fixpt_cast_384 <= resize(QGT_state_fixpt_cast_383, 52);
  QGT_state_fixpt_cast_385 <=  - (QGT_state_fixpt_cast_384);
  QGT_state_fixpt_cast_386 <= QGT_state_fixpt_cast_385(50 DOWNTO 0);
  QGT_state_fixpt_sub_cast_900 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_766 <= QGT_state_fixpt_cast_386 * nc_0(to_integer(QGT_state_fixpt_sub_cast_900 - 1));
  QGT_state_fixpt_sub_cast_901 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_767 <= QGT_state_fixpt_mul_temp_766 * nc(to_integer(QGT_state_fixpt_sub_cast_901 - 1));
  QGT_state_fixpt_add_cast_234 <= resize(QGT_state_fixpt_mul_temp_767, 84);
  QGT_state_fixpt_sub_cast_902 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_768 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_902 - 1));
  QGT_state_fixpt_cast_387 <= QGT_state_fixpt_mul_temp_768(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_903 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_769 <= QGT_state_fixpt_cast_387 * nc(to_integer(QGT_state_fixpt_sub_cast_903 - 1));
  QGT_state_fixpt_cast_388 <= resize(QGT_state_fixpt_mul_temp_769, 50);
  QGT_state_fixpt_cast_389 <=  - (QGT_state_fixpt_cast_388);
  QGT_state_fixpt_sub_cast_904 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_770 <= QGT_state_fixpt_cast_389 * nc(to_integer(QGT_state_fixpt_sub_cast_904 - 1));
  QGT_state_fixpt_sub_cast_905 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_771 <= QGT_state_fixpt_mul_temp_770 * nc(to_integer(QGT_state_fixpt_sub_cast_905 - 1));
  QGT_state_fixpt_add_cast_235 <= resize(QGT_state_fixpt_mul_temp_771, 84);
  QGT_state_fixpt_add_temp_87 <= QGT_state_fixpt_add_cast_234 + QGT_state_fixpt_add_cast_235;
  QGT_state_fixpt_sub_cast_906 <= resize(QGT_state_fixpt_add_temp_87, 85);
  QGT_state_fixpt_sub_cast_907 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_772 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_907 - 1));
  QGT_state_fixpt_cast_390 <= QGT_state_fixpt_mul_temp_772(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_908 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_773 <= QGT_state_fixpt_cast_390 * nc_0(to_integer(QGT_state_fixpt_sub_cast_908 - 1));
  QGT_state_fixpt_sub_cast_909 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_774 <= QGT_state_fixpt_mul_temp_773 * nc_0(to_integer(QGT_state_fixpt_sub_cast_909 - 1));
  QGT_state_fixpt_sub_cast_910 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_775 <= QGT_state_fixpt_mul_temp_774 * nc(to_integer(QGT_state_fixpt_sub_cast_910 - 1));
  QGT_state_fixpt_sub_cast_911 <= resize(QGT_state_fixpt_mul_temp_775, 81);
  QGT_state_fixpt_sub_cast_912 <= resize(QGT_state_fixpt_sub_cast_911, 85);
  QGT_state_fixpt_sub_temp_71 <= QGT_state_fixpt_sub_cast_906 - QGT_state_fixpt_sub_cast_912;
  QGT_state_fixpt_add_cast_236 <= resize(QGT_state_fixpt_sub_temp_71, 86);
  QGT_state_fixpt_sub_cast_913 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_776 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_913 - 1));
  QGT_state_fixpt_sub_cast_914 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_777 <= QGT_state_fixpt_mul_temp_776 * nc(to_integer(QGT_state_fixpt_sub_cast_914 - 1));
  QGT_state_fixpt_sub_cast_915 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_778 <= QGT_state_fixpt_mul_temp_777 * nc_0(to_integer(QGT_state_fixpt_sub_cast_915 - 1));
  QGT_state_fixpt_sub_cast_916 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_779 <= QGT_state_fixpt_mul_temp_778 * nc_0(to_integer(QGT_state_fixpt_sub_cast_916 - 1));
  QGT_state_fixpt_add_cast_237 <= resize(QGT_state_fixpt_mul_temp_779 & '0', 82);
  QGT_state_fixpt_add_cast_238 <= resize(QGT_state_fixpt_add_cast_237, 86);
  QGT_state_fixpt_add_temp_88 <= QGT_state_fixpt_add_cast_236 + QGT_state_fixpt_add_cast_238;
  QGT_state_fixpt_cast_391 <= QGT_state_fixpt_add_temp_88(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_780 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_391;
  QGT_state_fixpt_cast_392 <= QGT_state_fixpt_mul_temp_780(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_917 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_781 <= QGT_state_fixpt_cast_392 * nc_0(to_integer(QGT_state_fixpt_sub_cast_917 - 1));
  QGT_state_fixpt_sub_cast_918 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_782 <= QGT_state_fixpt_mul_temp_781 * nc_0(to_integer(QGT_state_fixpt_sub_cast_918 - 1));
  QGT_state_fixpt_sub_cast_919 <= resize(QGT_state_fixpt_mul_temp_782, 67);
  QGT_state_fixpt_sub_temp_72 <= QGT_state_fixpt_sub_cast_897 - QGT_state_fixpt_sub_cast_919;
  QGT_state_fixpt_add_cast_239 <= resize(QGT_state_fixpt_sub_temp_72, 68);
  QGT_state_fixpt_sub_cast_920 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_783 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_920 - 1));
  QGT_state_fixpt_cast_393 <= QGT_state_fixpt_mul_temp_783(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_921 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_784 <= QGT_state_fixpt_cast_393 * nc(to_integer(QGT_state_fixpt_sub_cast_921 - 1));
  QGT_state_fixpt_cast_394 <= resize(QGT_state_fixpt_mul_temp_784, 50);
  QGT_state_fixpt_cast_395 <=  - (QGT_state_fixpt_cast_394);
  QGT_state_fixpt_sub_cast_922 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_785 <= QGT_state_fixpt_cast_395 * nc_0(to_integer(QGT_state_fixpt_sub_cast_922 - 1));
  QGT_state_fixpt_sub_cast_923 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_786 <= QGT_state_fixpt_mul_temp_785 * nc(to_integer(QGT_state_fixpt_sub_cast_923 - 1));
  QGT_state_fixpt_add_cast_240 <= resize(QGT_state_fixpt_mul_temp_786, 83);
  QGT_state_fixpt_sub_cast_924 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_787 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_924 - 1));
  QGT_state_fixpt_cast_396 <= QGT_state_fixpt_mul_temp_787(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_925 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_788 <= QGT_state_fixpt_cast_396 * nc(to_integer(QGT_state_fixpt_sub_cast_925 - 1));
  QGT_state_fixpt_cast_397 <= resize(QGT_state_fixpt_mul_temp_788, 50);
  QGT_state_fixpt_cast_398 <=  - (QGT_state_fixpt_cast_397);
  QGT_state_fixpt_sub_cast_926 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_789 <= QGT_state_fixpt_cast_398 * nc_0(to_integer(QGT_state_fixpt_sub_cast_926 - 1));
  QGT_state_fixpt_sub_cast_927 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_790 <= QGT_state_fixpt_mul_temp_789 * nc_0(to_integer(QGT_state_fixpt_sub_cast_927 - 1));
  QGT_state_fixpt_add_cast_241 <= resize(QGT_state_fixpt_mul_temp_790, 83);
  QGT_state_fixpt_add_temp_89 <= QGT_state_fixpt_add_cast_240 + QGT_state_fixpt_add_cast_241;
  QGT_state_fixpt_add_cast_242 <= resize(QGT_state_fixpt_add_temp_89, 84);
  QGT_state_fixpt_sub_cast_928 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_791 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_928 - 1));
  QGT_state_fixpt_cast_399 <= QGT_state_fixpt_mul_temp_791(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_929 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_792 <= QGT_state_fixpt_cast_399 * nc_0(to_integer(QGT_state_fixpt_sub_cast_929 - 1));
  QGT_state_fixpt_sub_cast_930 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_793 <= QGT_state_fixpt_mul_temp_792 * nc_0(to_integer(QGT_state_fixpt_sub_cast_930 - 1));
  QGT_state_fixpt_sub_cast_931 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_794 <= QGT_state_fixpt_mul_temp_793 * nc(to_integer(QGT_state_fixpt_sub_cast_931 - 1));
  QGT_state_fixpt_add_cast_243 <= resize(QGT_state_fixpt_mul_temp_794, 81);
  QGT_state_fixpt_add_cast_244 <= resize(QGT_state_fixpt_add_cast_243, 84);
  QGT_state_fixpt_add_temp_90 <= QGT_state_fixpt_add_cast_242 + QGT_state_fixpt_add_cast_244;
  QGT_state_fixpt_add_cast_245 <= resize(QGT_state_fixpt_add_temp_90, 85);
  QGT_state_fixpt_sub_cast_932 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_795 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_932 - 1));
  QGT_state_fixpt_sub_cast_933 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_796 <= QGT_state_fixpt_mul_temp_795 * nc(to_integer(QGT_state_fixpt_sub_cast_933 - 1));
  QGT_state_fixpt_sub_cast_934 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_797 <= QGT_state_fixpt_mul_temp_796 * nc(to_integer(QGT_state_fixpt_sub_cast_934 - 1));
  QGT_state_fixpt_sub_cast_935 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_798 <= QGT_state_fixpt_mul_temp_797 * nc(to_integer(QGT_state_fixpt_sub_cast_935 - 1));
  QGT_state_fixpt_add_cast_246 <= resize(QGT_state_fixpt_mul_temp_798 & '0', 82);
  QGT_state_fixpt_add_cast_247 <= resize(QGT_state_fixpt_add_cast_246, 85);
  QGT_state_fixpt_add_temp_91 <= QGT_state_fixpt_add_cast_245 + QGT_state_fixpt_add_cast_247;
  QGT_state_fixpt_cast_400 <= QGT_state_fixpt_add_temp_91(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_799 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_400;
  QGT_state_fixpt_cast_401 <= QGT_state_fixpt_mul_temp_799(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_936 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_800 <= QGT_state_fixpt_cast_401 * nc(to_integer(QGT_state_fixpt_sub_cast_936 - 1));
  QGT_state_fixpt_sub_cast_937 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_801 <= QGT_state_fixpt_mul_temp_800 * nc(to_integer(QGT_state_fixpt_sub_cast_937 - 1));
  QGT_state_fixpt_add_cast_248 <= resize(QGT_state_fixpt_mul_temp_801, 68);
  QGT_state_fixpt_add_temp_92 <= QGT_state_fixpt_add_cast_239 + QGT_state_fixpt_add_cast_248;
  QGT_state_fixpt_sub_cast_938 <= resize(QGT_state_fixpt_add_temp_92, 69);
  QGT_state_fixpt_sub_cast_939 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_802 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_939 - 1));
  QGT_state_fixpt_sub_cast_940 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_803 <= QGT_state_fixpt_mul_temp_802 * nc_0(to_integer(QGT_state_fixpt_sub_cast_940 - 1));
  QGT_state_fixpt_sub_cast_941 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_804 <= QGT_state_fixpt_mul_temp_803 * nc(to_integer(QGT_state_fixpt_sub_cast_941 - 1));
  QGT_state_fixpt_sub_cast_942 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_805 <= QGT_state_fixpt_mul_temp_804 * nc(to_integer(QGT_state_fixpt_sub_cast_942 - 1));
  QGT_state_fixpt_add_cast_249 <= resize(QGT_state_fixpt_mul_temp_805 & '0', 82);
  QGT_state_fixpt_add_cast_250 <= resize(QGT_state_fixpt_add_cast_249, 83);
  QGT_state_fixpt_sub_cast_943 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_806 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_943 - 1));
  QGT_state_fixpt_sub_cast_944 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_807 <= QGT_state_fixpt_mul_temp_806 * nc(to_integer(QGT_state_fixpt_sub_cast_944 - 1));
  QGT_state_fixpt_sub_cast_945 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_808 <= QGT_state_fixpt_mul_temp_807 * nc_0(to_integer(QGT_state_fixpt_sub_cast_945 - 1));
  QGT_state_fixpt_sub_cast_946 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_809 <= QGT_state_fixpt_mul_temp_808 * nc(to_integer(QGT_state_fixpt_sub_cast_946 - 1));
  QGT_state_fixpt_add_cast_251 <= resize(QGT_state_fixpt_mul_temp_809 & '0', 82);
  QGT_state_fixpt_add_cast_252 <= resize(QGT_state_fixpt_add_cast_251, 83);
  QGT_state_fixpt_add_temp_93 <= QGT_state_fixpt_add_cast_250 + QGT_state_fixpt_add_cast_252;
  QGT_state_fixpt_sub_cast_947 <= resize(QGT_state_fixpt_add_temp_93, 84);
  QGT_state_fixpt_sub_cast_948 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_810 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_948 - 1));
  QGT_state_fixpt_cast_402 <= QGT_state_fixpt_mul_temp_810(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_949 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_811 <= QGT_state_fixpt_cast_402 * nc(to_integer(QGT_state_fixpt_sub_cast_949 - 1));
  QGT_state_fixpt_sub_cast_950 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_812 <= QGT_state_fixpt_mul_temp_811 * nc_0(to_integer(QGT_state_fixpt_sub_cast_950 - 1));
  QGT_state_fixpt_sub_cast_951 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_813 <= QGT_state_fixpt_mul_temp_812 * nc_0(to_integer(QGT_state_fixpt_sub_cast_951 - 1));
  QGT_state_fixpt_sub_cast_952 <= resize(QGT_state_fixpt_mul_temp_813, 81);
  QGT_state_fixpt_sub_cast_953 <= resize(QGT_state_fixpt_sub_cast_952, 84);
  QGT_state_fixpt_sub_temp_73 <= QGT_state_fixpt_sub_cast_947 - QGT_state_fixpt_sub_cast_953;
  QGT_state_fixpt_sub_cast_954 <= resize(QGT_state_fixpt_sub_temp_73, 85);
  QGT_state_fixpt_sub_cast_955 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_814 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_955 - 1));
  QGT_state_fixpt_cast_403 <= QGT_state_fixpt_mul_temp_814(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_956 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_815 <= QGT_state_fixpt_cast_403 * nc(to_integer(QGT_state_fixpt_sub_cast_956 - 1));
  QGT_state_fixpt_cast_404 <= resize(QGT_state_fixpt_mul_temp_815, 50);
  QGT_state_fixpt_cast_405 <=  - (QGT_state_fixpt_cast_404);
  QGT_state_fixpt_sub_cast_957 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_816 <= QGT_state_fixpt_cast_405 * nc_0(to_integer(QGT_state_fixpt_sub_cast_957 - 1));
  QGT_state_fixpt_sub_cast_958 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_817 <= QGT_state_fixpt_mul_temp_816 * nc(to_integer(QGT_state_fixpt_sub_cast_958 - 1));
  QGT_state_fixpt_sub_cast_959 <= resize(QGT_state_fixpt_mul_temp_817, 85);
  QGT_state_fixpt_sub_temp_74 <= QGT_state_fixpt_sub_cast_954 - QGT_state_fixpt_sub_cast_959;
  QGT_state_fixpt_cast_406 <= QGT_state_fixpt_sub_temp_74(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_818 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_406;
  QGT_state_fixpt_cast_407 <= QGT_state_fixpt_mul_temp_818(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_960 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_819 <= QGT_state_fixpt_cast_407 * nc_0(to_integer(QGT_state_fixpt_sub_cast_960 - 1));
  QGT_state_fixpt_sub_cast_961 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_820 <= QGT_state_fixpt_mul_temp_819 * nc(to_integer(QGT_state_fixpt_sub_cast_961 - 1));
  QGT_state_fixpt_sub_cast_962 <= resize(QGT_state_fixpt_mul_temp_820, 65);
  QGT_state_fixpt_sub_cast_963 <= resize(QGT_state_fixpt_sub_cast_962, 69);
  QGT_state_fixpt_sub_temp_75 <= QGT_state_fixpt_sub_cast_938 - QGT_state_fixpt_sub_cast_963;
  QGT_state_fixpt_add_cast_253 <= resize(QGT_state_fixpt_sub_temp_75, 72);
  QGT_state_fixpt_sub_cast_964 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_821 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_964 - 1));
  QGT_state_fixpt_cast_408 <= QGT_state_fixpt_mul_temp_821(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_965 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_822 <= QGT_state_fixpt_cast_408 * nc(to_integer(QGT_state_fixpt_sub_cast_965 - 1));
  QGT_state_fixpt_cast_409 <= resize(QGT_state_fixpt_mul_temp_822, 50);
  QGT_state_fixpt_cast_410 <=  - (QGT_state_fixpt_cast_409);
  QGT_state_fixpt_cast_411 <= resize(QGT_state_fixpt_cast_410, 51);
  QGT_state_fixpt_cast_412 <= resize(QGT_state_fixpt_cast_411, 52);
  QGT_state_fixpt_cast_413 <=  - (QGT_state_fixpt_cast_412);
  QGT_state_fixpt_cast_414 <= QGT_state_fixpt_cast_413(50 DOWNTO 0);
  QGT_state_fixpt_sub_cast_966 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_823 <= QGT_state_fixpt_cast_414 * nc_0(to_integer(QGT_state_fixpt_sub_cast_966 - 1));
  QGT_state_fixpt_sub_cast_967 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_824 <= QGT_state_fixpt_mul_temp_823 * nc_0(to_integer(QGT_state_fixpt_sub_cast_967 - 1));
  QGT_state_fixpt_add_cast_254 <= resize(QGT_state_fixpt_mul_temp_824, 84);
  QGT_state_fixpt_sub_cast_968 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_825 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_968 - 1));
  QGT_state_fixpt_cast_415 <= QGT_state_fixpt_mul_temp_825(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_969 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_826 <= QGT_state_fixpt_cast_415 * nc(to_integer(QGT_state_fixpt_sub_cast_969 - 1));
  QGT_state_fixpt_cast_416 <= resize(QGT_state_fixpt_mul_temp_826, 50);
  QGT_state_fixpt_cast_417 <=  - (QGT_state_fixpt_cast_416);
  QGT_state_fixpt_sub_cast_970 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_827 <= QGT_state_fixpt_cast_417 * nc_0(to_integer(QGT_state_fixpt_sub_cast_970 - 1));
  QGT_state_fixpt_sub_cast_971 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_828 <= QGT_state_fixpt_mul_temp_827 * nc(to_integer(QGT_state_fixpt_sub_cast_971 - 1));
  QGT_state_fixpt_add_cast_255 <= resize(QGT_state_fixpt_mul_temp_828, 84);
  QGT_state_fixpt_add_temp_94 <= QGT_state_fixpt_add_cast_254 + QGT_state_fixpt_add_cast_255;
  QGT_state_fixpt_add_cast_256 <= resize(QGT_state_fixpt_add_temp_94, 85);
  QGT_state_fixpt_sub_cast_972 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_829 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_972 - 1));
  QGT_state_fixpt_cast_418 <= QGT_state_fixpt_mul_temp_829(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_973 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_830 <= QGT_state_fixpt_cast_418 * nc_0(to_integer(QGT_state_fixpt_sub_cast_973 - 1));
  QGT_state_fixpt_sub_cast_974 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_831 <= QGT_state_fixpt_mul_temp_830 * nc(to_integer(QGT_state_fixpt_sub_cast_974 - 1));
  QGT_state_fixpt_sub_cast_975 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_832 <= QGT_state_fixpt_mul_temp_831 * nc(to_integer(QGT_state_fixpt_sub_cast_975 - 1));
  QGT_state_fixpt_add_cast_257 <= resize(QGT_state_fixpt_mul_temp_832, 81);
  QGT_state_fixpt_add_cast_258 <= resize(QGT_state_fixpt_add_cast_257, 85);
  QGT_state_fixpt_add_temp_95 <= QGT_state_fixpt_add_cast_256 + QGT_state_fixpt_add_cast_258;
  QGT_state_fixpt_sub_cast_976 <= resize(QGT_state_fixpt_add_temp_95, 86);
  QGT_state_fixpt_sub_cast_977 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_833 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_977 - 1));
  QGT_state_fixpt_sub_cast_978 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_834 <= QGT_state_fixpt_mul_temp_833 * nc(to_integer(QGT_state_fixpt_sub_cast_978 - 1));
  QGT_state_fixpt_sub_cast_979 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_835 <= QGT_state_fixpt_mul_temp_834 * nc_0(to_integer(QGT_state_fixpt_sub_cast_979 - 1));
  QGT_state_fixpt_sub_cast_980 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_836 <= QGT_state_fixpt_mul_temp_835 * nc(to_integer(QGT_state_fixpt_sub_cast_980 - 1));
  QGT_state_fixpt_sub_cast_981 <= resize(QGT_state_fixpt_mul_temp_836 & '0', 82);
  QGT_state_fixpt_sub_cast_982 <= resize(QGT_state_fixpt_sub_cast_981, 86);
  QGT_state_fixpt_sub_temp_76 <= QGT_state_fixpt_sub_cast_976 - QGT_state_fixpt_sub_cast_982;
  QGT_state_fixpt_cast_419 <= QGT_state_fixpt_sub_temp_76(73 DOWNTO 58);
  QGT_state_fixpt_cast_420 <= resize(QGT_state_fixpt_cast_419, 17);
  QGT_state_fixpt_cast_421 <=  - (QGT_state_fixpt_cast_420);
  QGT_state_fixpt_cast_422 <= resize(QGT_state_fixpt_cast_421, 18);
  QGT_state_fixpt_cast_423 <= resize(QGT_state_fixpt_cast_422, 19);
  QGT_state_fixpt_cast_424 <=  - (QGT_state_fixpt_cast_423);
  QGT_state_fixpt_sub_cast_983 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_837 <= QGT_state_fixpt_cast_424 * nc_0(to_integer(QGT_state_fixpt_sub_cast_983 - 1));
  QGT_state_fixpt_sub_cast_984 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_838 <= QGT_state_fixpt_mul_temp_837 * nc(to_integer(QGT_state_fixpt_sub_cast_984 - 1));
  QGT_state_fixpt_add_cast_259 <= resize(QGT_state_fixpt_mul_temp_838, 52);
  QGT_state_fixpt_sub_cast_985 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_839 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_985 - 1));
  QGT_state_fixpt_sub_cast_986 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_840 <= QGT_state_fixpt_mul_temp_839 * nc_0(to_integer(QGT_state_fixpt_sub_cast_986 - 1));
  QGT_state_fixpt_cast_425 <= resize(QGT_state_fixpt_mul_temp_840 & '0', 51);
  QGT_state_fixpt_cast_426 <= resize(QGT_state_fixpt_cast_425, 52);
  QGT_state_fixpt_cast_427 <=  - (QGT_state_fixpt_cast_426);
  QGT_state_fixpt_cast_428 <= QGT_state_fixpt_cast_427(50 DOWNTO 0);
  QGT_state_fixpt_sub_cast_987 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_841 <= QGT_state_fixpt_cast_428 * nc_0(to_integer(QGT_state_fixpt_sub_cast_987 - 1));
  QGT_state_fixpt_sub_cast_988 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_842 <= QGT_state_fixpt_mul_temp_841 * nc(to_integer(QGT_state_fixpt_sub_cast_988 - 1));
  QGT_state_fixpt_add_cast_260 <= resize(QGT_state_fixpt_mul_temp_842, 84);
  QGT_state_fixpt_sub_cast_989 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_843 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_989 - 1));
  QGT_state_fixpt_sub_cast_990 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_844 <= QGT_state_fixpt_mul_temp_843 * nc(to_integer(QGT_state_fixpt_sub_cast_990 - 1));
  QGT_state_fixpt_sub_cast_991 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_845 <= QGT_state_fixpt_mul_temp_844 * nc(to_integer(QGT_state_fixpt_sub_cast_991 - 1));
  QGT_state_fixpt_sub_cast_992 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_846 <= QGT_state_fixpt_mul_temp_845 * nc(to_integer(QGT_state_fixpt_sub_cast_992 - 1));
  QGT_state_fixpt_add_cast_261 <= resize(QGT_state_fixpt_mul_temp_846 & '0', 82);
  QGT_state_fixpt_add_cast_262 <= resize(QGT_state_fixpt_add_cast_261, 84);
  QGT_state_fixpt_add_temp_96 <= QGT_state_fixpt_add_cast_260 + QGT_state_fixpt_add_cast_262;
  QGT_state_fixpt_sub_cast_993 <= resize(QGT_state_fixpt_add_temp_96, 85);
  QGT_state_fixpt_sub_cast_994 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_847 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_994 - 1));
  QGT_state_fixpt_cast_429 <= QGT_state_fixpt_mul_temp_847(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_995 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_848 <= QGT_state_fixpt_cast_429 * nc(to_integer(QGT_state_fixpt_sub_cast_995 - 1));
  QGT_state_fixpt_sub_cast_996 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_849 <= QGT_state_fixpt_mul_temp_848 * nc_0(to_integer(QGT_state_fixpt_sub_cast_996 - 1));
  QGT_state_fixpt_sub_cast_997 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_850 <= QGT_state_fixpt_mul_temp_849 * nc(to_integer(QGT_state_fixpt_sub_cast_997 - 1));
  QGT_state_fixpt_sub_cast_998 <= resize(QGT_state_fixpt_mul_temp_850, 81);
  QGT_state_fixpt_sub_cast_999 <= resize(QGT_state_fixpt_sub_cast_998, 85);
  QGT_state_fixpt_sub_temp_77 <= QGT_state_fixpt_sub_cast_993 - QGT_state_fixpt_sub_cast_999;
  QGT_state_fixpt_add_cast_263 <= resize(QGT_state_fixpt_sub_temp_77, 86);
  QGT_state_fixpt_sub_cast_1000 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_851 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1000 - 1));
  QGT_state_fixpt_cast_430 <= QGT_state_fixpt_mul_temp_851(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1001 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_852 <= QGT_state_fixpt_cast_430 * nc(to_integer(QGT_state_fixpt_sub_cast_1001 - 1));
  QGT_state_fixpt_cast_431 <= resize(QGT_state_fixpt_mul_temp_852, 50);
  QGT_state_fixpt_cast_432 <=  - (QGT_state_fixpt_cast_431);
  QGT_state_fixpt_sub_cast_1002 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_853 <= QGT_state_fixpt_cast_432 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1002 - 1));
  QGT_state_fixpt_sub_cast_1003 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_854 <= QGT_state_fixpt_mul_temp_853 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1003 - 1));
  QGT_state_fixpt_add_cast_264 <= resize(QGT_state_fixpt_mul_temp_854, 86);
  QGT_state_fixpt_add_temp_97 <= QGT_state_fixpt_add_cast_263 + QGT_state_fixpt_add_cast_264;
  QGT_state_fixpt_cast_433 <= QGT_state_fixpt_add_temp_97(73 DOWNTO 58);
  QGT_state_fixpt_sub_cast_1004 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_855 <= QGT_state_fixpt_cast_433 * nc(to_integer(QGT_state_fixpt_sub_cast_1004 - 1));
  QGT_state_fixpt_sub_cast_1005 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_856 <= QGT_state_fixpt_mul_temp_855 * nc(to_integer(QGT_state_fixpt_sub_cast_1005 - 1));
  QGT_state_fixpt_add_cast_265 <= resize(QGT_state_fixpt_mul_temp_856, 52);
  QGT_state_fixpt_add_temp_98 <= QGT_state_fixpt_add_cast_259 + QGT_state_fixpt_add_cast_265;
  QGT_state_fixpt_sub_cast_1006 <= resize(QGT_state_fixpt_add_temp_98, 53);
  QGT_state_fixpt_sub_cast_1007 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_857 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1007 - 1));
  QGT_state_fixpt_sub_cast_1008 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_858 <= QGT_state_fixpt_mul_temp_857 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1008 - 1));
  QGT_state_fixpt_sub_cast_1009 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_859 <= QGT_state_fixpt_mul_temp_858 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1009 - 1));
  QGT_state_fixpt_sub_cast_1010 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_860 <= QGT_state_fixpt_mul_temp_859 * nc(to_integer(QGT_state_fixpt_sub_cast_1010 - 1));
  QGT_state_fixpt_add_cast_266 <= resize(QGT_state_fixpt_mul_temp_860 & '0', 82);
  QGT_state_fixpt_add_cast_267 <= resize(QGT_state_fixpt_add_cast_266, 83);
  QGT_state_fixpt_sub_cast_1011 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_861 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1011 - 1));
  QGT_state_fixpt_sub_cast_1012 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_862 <= QGT_state_fixpt_mul_temp_861 * nc(to_integer(QGT_state_fixpt_sub_cast_1012 - 1));
  QGT_state_fixpt_sub_cast_1013 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_863 <= QGT_state_fixpt_mul_temp_862 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1013 - 1));
  QGT_state_fixpt_sub_cast_1014 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_864 <= QGT_state_fixpt_mul_temp_863 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1014 - 1));
  QGT_state_fixpt_add_cast_268 <= resize(QGT_state_fixpt_mul_temp_864 & '0', 82);
  QGT_state_fixpt_add_cast_269 <= resize(QGT_state_fixpt_add_cast_268, 83);
  QGT_state_fixpt_add_temp_99 <= QGT_state_fixpt_add_cast_267 + QGT_state_fixpt_add_cast_269;
  QGT_state_fixpt_add_cast_270 <= resize(QGT_state_fixpt_add_temp_99, 84);
  QGT_state_fixpt_sub_cast_1015 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_865 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_1015 - 1));
  QGT_state_fixpt_cast_434 <= QGT_state_fixpt_mul_temp_865(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1016 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_866 <= QGT_state_fixpt_cast_434 * nc(to_integer(QGT_state_fixpt_sub_cast_1016 - 1));
  QGT_state_fixpt_sub_cast_1017 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_867 <= QGT_state_fixpt_mul_temp_866 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1017 - 1));
  QGT_state_fixpt_sub_cast_1018 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_868 <= QGT_state_fixpt_mul_temp_867 * nc(to_integer(QGT_state_fixpt_sub_cast_1018 - 1));
  QGT_state_fixpt_add_cast_271 <= resize(QGT_state_fixpt_mul_temp_868, 81);
  QGT_state_fixpt_add_cast_272 <= resize(QGT_state_fixpt_add_cast_271, 84);
  QGT_state_fixpt_add_temp_100 <= QGT_state_fixpt_add_cast_270 + QGT_state_fixpt_add_cast_272;
  QGT_state_fixpt_add_cast_273 <= resize(QGT_state_fixpt_add_temp_100, 85);
  QGT_state_fixpt_sub_cast_1019 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_869 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1019 - 1));
  QGT_state_fixpt_cast_435 <= QGT_state_fixpt_mul_temp_869(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1020 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_870 <= QGT_state_fixpt_cast_435 * nc(to_integer(QGT_state_fixpt_sub_cast_1020 - 1));
  QGT_state_fixpt_cast_436 <= resize(QGT_state_fixpt_mul_temp_870, 50);
  QGT_state_fixpt_cast_437 <=  - (QGT_state_fixpt_cast_436);
  QGT_state_fixpt_sub_cast_1021 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_871 <= QGT_state_fixpt_cast_437 * nc(to_integer(QGT_state_fixpt_sub_cast_1021 - 1));
  QGT_state_fixpt_sub_cast_1022 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_872 <= QGT_state_fixpt_mul_temp_871 * nc(to_integer(QGT_state_fixpt_sub_cast_1022 - 1));
  QGT_state_fixpt_add_cast_274 <= resize(QGT_state_fixpt_mul_temp_872, 85);
  QGT_state_fixpt_add_temp_101 <= QGT_state_fixpt_add_cast_273 + QGT_state_fixpt_add_cast_274;
  QGT_state_fixpt_cast_438 <= QGT_state_fixpt_add_temp_101(73 DOWNTO 58);
  QGT_state_fixpt_sub_cast_1023 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_873 <= QGT_state_fixpt_cast_438 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1023 - 1));
  QGT_state_fixpt_sub_cast_1024 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_874 <= QGT_state_fixpt_mul_temp_873 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1024 - 1));
  QGT_state_fixpt_sub_cast_1025 <= resize(QGT_state_fixpt_mul_temp_874, 53);
  QGT_state_fixpt_sub_temp_78 <= QGT_state_fixpt_sub_cast_1006 - QGT_state_fixpt_sub_cast_1025;
  QGT_state_fixpt_sub_cast_1026 <= resize(QGT_state_fixpt_sub_temp_78, 54);
  QGT_state_fixpt_sub_cast_1027 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_875 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_1027 - 1));
  QGT_state_fixpt_cast_439 <= QGT_state_fixpt_mul_temp_875(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1028 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_876 <= QGT_state_fixpt_cast_439 * nc(to_integer(QGT_state_fixpt_sub_cast_1028 - 1));
  QGT_state_fixpt_cast_440 <= resize(QGT_state_fixpt_mul_temp_876, 50);
  QGT_state_fixpt_cast_441 <=  - (QGT_state_fixpt_cast_440);
  QGT_state_fixpt_sub_cast_1029 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_877 <= QGT_state_fixpt_cast_441 * nc(to_integer(QGT_state_fixpt_sub_cast_1029 - 1));
  QGT_state_fixpt_sub_cast_1030 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_878 <= QGT_state_fixpt_mul_temp_877 * nc(to_integer(QGT_state_fixpt_sub_cast_1030 - 1));
  QGT_state_fixpt_add_cast_275 <= resize(QGT_state_fixpt_mul_temp_878, 83);
  QGT_state_fixpt_sub_cast_1031 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_879 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1031 - 1));
  QGT_state_fixpt_cast_442 <= QGT_state_fixpt_mul_temp_879(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1032 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_880 <= QGT_state_fixpt_cast_442 * nc(to_integer(QGT_state_fixpt_sub_cast_1032 - 1));
  QGT_state_fixpt_cast_443 <= resize(QGT_state_fixpt_mul_temp_880, 50);
  QGT_state_fixpt_cast_444 <=  - (QGT_state_fixpt_cast_443);
  QGT_state_fixpt_sub_cast_1033 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_881 <= QGT_state_fixpt_cast_444 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1033 - 1));
  QGT_state_fixpt_sub_cast_1034 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_882 <= QGT_state_fixpt_mul_temp_881 * nc(to_integer(QGT_state_fixpt_sub_cast_1034 - 1));
  QGT_state_fixpt_add_cast_276 <= resize(QGT_state_fixpt_mul_temp_882, 83);
  QGT_state_fixpt_add_temp_102 <= QGT_state_fixpt_add_cast_275 + QGT_state_fixpt_add_cast_276;
  QGT_state_fixpt_sub_cast_1035 <= resize(QGT_state_fixpt_add_temp_102, 84);
  QGT_state_fixpt_sub_cast_1036 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_883 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1036 - 1));
  QGT_state_fixpt_cast_445 <= QGT_state_fixpt_mul_temp_883(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1037 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_884 <= QGT_state_fixpt_cast_445 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1037 - 1));
  QGT_state_fixpt_sub_cast_1038 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_885 <= QGT_state_fixpt_mul_temp_884 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1038 - 1));
  QGT_state_fixpt_sub_cast_1039 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_886 <= QGT_state_fixpt_mul_temp_885 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1039 - 1));
  QGT_state_fixpt_sub_cast_1040 <= resize(QGT_state_fixpt_mul_temp_886, 81);
  QGT_state_fixpt_sub_cast_1041 <= resize(QGT_state_fixpt_sub_cast_1040, 84);
  QGT_state_fixpt_sub_temp_79 <= QGT_state_fixpt_sub_cast_1035 - QGT_state_fixpt_sub_cast_1041;
  QGT_state_fixpt_sub_cast_1042 <= resize(QGT_state_fixpt_sub_temp_79, 85);
  QGT_state_fixpt_sub_cast_1043 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_887 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1043 - 1));
  QGT_state_fixpt_sub_cast_1044 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_888 <= QGT_state_fixpt_mul_temp_887 * nc(to_integer(QGT_state_fixpt_sub_cast_1044 - 1));
  QGT_state_fixpt_sub_cast_1045 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_889 <= QGT_state_fixpt_mul_temp_888 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1045 - 1));
  QGT_state_fixpt_sub_cast_1046 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_890 <= QGT_state_fixpt_mul_temp_889 * nc(to_integer(QGT_state_fixpt_sub_cast_1046 - 1));
  QGT_state_fixpt_sub_cast_1047 <= resize(QGT_state_fixpt_mul_temp_890 & '0', 82);
  QGT_state_fixpt_sub_cast_1048 <= resize(QGT_state_fixpt_sub_cast_1047, 85);
  QGT_state_fixpt_sub_temp_80 <= QGT_state_fixpt_sub_cast_1042 - QGT_state_fixpt_sub_cast_1048;
  QGT_state_fixpt_cast_446 <= QGT_state_fixpt_sub_temp_80(73 DOWNTO 58);
  QGT_state_fixpt_cast_447 <= resize(QGT_state_fixpt_cast_446, 18);
  QGT_state_fixpt_cast_448 <=  - (QGT_state_fixpt_cast_447);
  QGT_state_fixpt_sub_cast_1049 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_891 <= QGT_state_fixpt_cast_448 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1049 - 1));
  QGT_state_fixpt_sub_cast_1050 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_892 <= QGT_state_fixpt_mul_temp_891 * nc(to_integer(QGT_state_fixpt_sub_cast_1050 - 1));
  QGT_state_fixpt_sub_cast_1051 <= resize(QGT_state_fixpt_mul_temp_892, 54);
  QGT_state_fixpt_sub_temp_81 <= QGT_state_fixpt_sub_cast_1026 - QGT_state_fixpt_sub_cast_1051;
  QGT_state_fixpt_mul_temp_893 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_sub_temp_81;
  QGT_state_fixpt_add_cast_277 <= QGT_state_fixpt_mul_temp_893(69 DOWNTO 0);
  QGT_state_fixpt_add_cast_278 <= resize(QGT_state_fixpt_add_cast_277, 72);
  QGT_state_fixpt_add_temp_103 <= QGT_state_fixpt_add_cast_253 + QGT_state_fixpt_add_cast_278;
  QGT_state_fixpt_c_im_2 <= QGT_state_fixpt_add_temp_103(59 DOWNTO 44);
  QGT_state_fixpt_sub_cast_1052 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_894 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1052 - 1));
  QGT_state_fixpt_sub_cast_1053 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_895 <= QGT_state_fixpt_mul_temp_894 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1053 - 1));
  QGT_state_fixpt_sub_cast_1054 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_896 <= QGT_state_fixpt_mul_temp_895 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1054 - 1));
  QGT_state_fixpt_sub_cast_1055 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_897 <= QGT_state_fixpt_mul_temp_896 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1055 - 1));
  QGT_state_fixpt_sub_cast_1056 <= resize(QGT_state_fixpt_mul_temp_897 & '0', 82);
  QGT_state_fixpt_sub_cast_1057 <= resize(QGT_state_fixpt_sub_cast_1056, 83);
  QGT_state_fixpt_sub_cast_1058 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_898 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1058 - 1));
  QGT_state_fixpt_sub_cast_1059 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_899 <= QGT_state_fixpt_mul_temp_898 * nc(to_integer(QGT_state_fixpt_sub_cast_1059 - 1));
  QGT_state_fixpt_sub_cast_1060 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_900 <= QGT_state_fixpt_mul_temp_899 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1060 - 1));
  QGT_state_fixpt_sub_cast_1061 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_901 <= QGT_state_fixpt_mul_temp_900 * nc(to_integer(QGT_state_fixpt_sub_cast_1061 - 1));
  QGT_state_fixpt_sub_cast_1062 <= resize(QGT_state_fixpt_mul_temp_901 & '0', 82);
  QGT_state_fixpt_sub_cast_1063 <= resize(QGT_state_fixpt_sub_cast_1062, 83);
  QGT_state_fixpt_sub_temp_82 <= QGT_state_fixpt_sub_cast_1057 - QGT_state_fixpt_sub_cast_1063;
  QGT_state_fixpt_add_cast_279 <= resize(QGT_state_fixpt_sub_temp_82, 84);
  QGT_state_fixpt_sub_cast_1064 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_902 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_1064 - 1));
  QGT_state_fixpt_cast_449 <= QGT_state_fixpt_mul_temp_902(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1065 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_903 <= QGT_state_fixpt_cast_449 * nc(to_integer(QGT_state_fixpt_sub_cast_1065 - 1));
  QGT_state_fixpt_sub_cast_1066 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_904 <= QGT_state_fixpt_mul_temp_903 * nc(to_integer(QGT_state_fixpt_sub_cast_1066 - 1));
  QGT_state_fixpt_sub_cast_1067 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_905 <= QGT_state_fixpt_mul_temp_904 * nc(to_integer(QGT_state_fixpt_sub_cast_1067 - 1));
  QGT_state_fixpt_add_cast_280 <= resize(QGT_state_fixpt_mul_temp_905, 81);
  QGT_state_fixpt_add_cast_281 <= resize(QGT_state_fixpt_add_cast_280, 84);
  QGT_state_fixpt_add_temp_104 <= QGT_state_fixpt_add_cast_279 + QGT_state_fixpt_add_cast_281;
  QGT_state_fixpt_sub_cast_1068 <= resize(QGT_state_fixpt_add_temp_104, 85);
  QGT_state_fixpt_sub_cast_1069 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_906 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1069 - 1));
  QGT_state_fixpt_cast_450 <= QGT_state_fixpt_mul_temp_906(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1070 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_907 <= QGT_state_fixpt_cast_450 * nc(to_integer(QGT_state_fixpt_sub_cast_1070 - 1));
  QGT_state_fixpt_cast_451 <= resize(QGT_state_fixpt_mul_temp_907, 50);
  QGT_state_fixpt_cast_452 <=  - (QGT_state_fixpt_cast_451);
  QGT_state_fixpt_sub_cast_1071 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_908 <= QGT_state_fixpt_cast_452 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1071 - 1));
  QGT_state_fixpt_sub_cast_1072 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_909 <= QGT_state_fixpt_mul_temp_908 * nc(to_integer(QGT_state_fixpt_sub_cast_1072 - 1));
  QGT_state_fixpt_sub_cast_1073 <= resize(QGT_state_fixpt_mul_temp_909, 85);
  QGT_state_fixpt_sub_temp_83 <= QGT_state_fixpt_sub_cast_1068 - QGT_state_fixpt_sub_cast_1073;
  QGT_state_fixpt_cast_453 <= QGT_state_fixpt_sub_temp_83(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_910 <= to_signed(-16#5A83#, 16) * QGT_state_fixpt_cast_453;
  QGT_state_fixpt_sub_cast_1074 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_911 <= QGT_state_fixpt_mul_temp_910 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1074 - 1));
  QGT_state_fixpt_sub_cast_1075 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_912 <= QGT_state_fixpt_mul_temp_911 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1075 - 1));
  QGT_state_fixpt_sub_cast_1076 <= resize(QGT_state_fixpt_mul_temp_912 & '0', 66);
  QGT_state_fixpt_sub_cast_1077 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_913 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_1077 - 1));
  QGT_state_fixpt_cast_454 <= QGT_state_fixpt_mul_temp_913(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1078 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_914 <= QGT_state_fixpt_cast_454 * nc(to_integer(QGT_state_fixpt_sub_cast_1078 - 1));
  QGT_state_fixpt_cast_455 <= resize(QGT_state_fixpt_mul_temp_914, 50);
  QGT_state_fixpt_cast_456 <=  - (QGT_state_fixpt_cast_455);
  QGT_state_fixpt_cast_457 <= resize(QGT_state_fixpt_cast_456, 51);
  QGT_state_fixpt_cast_458 <= resize(QGT_state_fixpt_cast_457, 52);
  QGT_state_fixpt_cast_459 <=  - (QGT_state_fixpt_cast_458);
  QGT_state_fixpt_cast_460 <= QGT_state_fixpt_cast_459(50 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1079 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_915 <= QGT_state_fixpt_cast_460 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1079 - 1));
  QGT_state_fixpt_sub_cast_1080 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_916 <= QGT_state_fixpt_mul_temp_915 * nc(to_integer(QGT_state_fixpt_sub_cast_1080 - 1));
  QGT_state_fixpt_add_cast_282 <= resize(QGT_state_fixpt_mul_temp_916, 84);
  QGT_state_fixpt_sub_cast_1081 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_917 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1081 - 1));
  QGT_state_fixpt_cast_461 <= QGT_state_fixpt_mul_temp_917(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1082 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_918 <= QGT_state_fixpt_cast_461 * nc(to_integer(QGT_state_fixpt_sub_cast_1082 - 1));
  QGT_state_fixpt_cast_462 <= resize(QGT_state_fixpt_mul_temp_918, 50);
  QGT_state_fixpt_cast_463 <=  - (QGT_state_fixpt_cast_462);
  QGT_state_fixpt_sub_cast_1083 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_919 <= QGT_state_fixpt_cast_463 * nc(to_integer(QGT_state_fixpt_sub_cast_1083 - 1));
  QGT_state_fixpt_sub_cast_1084 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_920 <= QGT_state_fixpt_mul_temp_919 * nc(to_integer(QGT_state_fixpt_sub_cast_1084 - 1));
  QGT_state_fixpt_add_cast_283 <= resize(QGT_state_fixpt_mul_temp_920, 84);
  QGT_state_fixpt_add_temp_105 <= QGT_state_fixpt_add_cast_282 + QGT_state_fixpt_add_cast_283;
  QGT_state_fixpt_add_cast_284 <= resize(QGT_state_fixpt_add_temp_105, 85);
  QGT_state_fixpt_sub_cast_1085 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_921 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1085 - 1));
  QGT_state_fixpt_cast_464 <= QGT_state_fixpt_mul_temp_921(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1086 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_922 <= QGT_state_fixpt_cast_464 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1086 - 1));
  QGT_state_fixpt_sub_cast_1087 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_923 <= QGT_state_fixpt_mul_temp_922 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1087 - 1));
  QGT_state_fixpt_sub_cast_1088 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_924 <= QGT_state_fixpt_mul_temp_923 * nc(to_integer(QGT_state_fixpt_sub_cast_1088 - 1));
  QGT_state_fixpt_add_cast_285 <= resize(QGT_state_fixpt_mul_temp_924, 81);
  QGT_state_fixpt_add_cast_286 <= resize(QGT_state_fixpt_add_cast_285, 85);
  QGT_state_fixpt_add_temp_106 <= QGT_state_fixpt_add_cast_284 + QGT_state_fixpt_add_cast_286;
  QGT_state_fixpt_sub_cast_1089 <= resize(QGT_state_fixpt_add_temp_106, 86);
  QGT_state_fixpt_sub_cast_1090 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_925 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1090 - 1));
  QGT_state_fixpt_sub_cast_1091 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_926 <= QGT_state_fixpt_mul_temp_925 * nc(to_integer(QGT_state_fixpt_sub_cast_1091 - 1));
  QGT_state_fixpt_sub_cast_1092 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_927 <= QGT_state_fixpt_mul_temp_926 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1092 - 1));
  QGT_state_fixpt_sub_cast_1093 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_928 <= QGT_state_fixpt_mul_temp_927 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1093 - 1));
  QGT_state_fixpt_sub_cast_1094 <= resize(QGT_state_fixpt_mul_temp_928 & '0', 82);
  QGT_state_fixpt_sub_cast_1095 <= resize(QGT_state_fixpt_sub_cast_1094, 86);
  QGT_state_fixpt_sub_temp_84 <= QGT_state_fixpt_sub_cast_1089 - QGT_state_fixpt_sub_cast_1095;
  QGT_state_fixpt_cast_465 <= QGT_state_fixpt_sub_temp_84(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_929 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_465;
  QGT_state_fixpt_cast_466 <= QGT_state_fixpt_mul_temp_929(31 DOWNTO 0);
  QGT_state_fixpt_cast_467 <= resize(QGT_state_fixpt_cast_466, 33);
  QGT_state_fixpt_cast_468 <=  - (QGT_state_fixpt_cast_467);
  QGT_state_fixpt_sub_cast_1096 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_930 <= QGT_state_fixpt_cast_468 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1096 - 1));
  QGT_state_fixpt_sub_cast_1097 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_931 <= QGT_state_fixpt_mul_temp_930 * nc(to_integer(QGT_state_fixpt_sub_cast_1097 - 1));
  QGT_state_fixpt_sub_cast_1098 <= resize(QGT_state_fixpt_mul_temp_931, 66);
  QGT_state_fixpt_sub_temp_85 <= QGT_state_fixpt_sub_cast_1076 - QGT_state_fixpt_sub_cast_1098;
  QGT_state_fixpt_sub_cast_1099 <= resize(QGT_state_fixpt_sub_temp_85, 67);
  QGT_state_fixpt_sub_cast_1100 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_932 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_1100 - 1));
  QGT_state_fixpt_cast_469 <= QGT_state_fixpt_mul_temp_932(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1101 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_933 <= QGT_state_fixpt_cast_469 * nc(to_integer(QGT_state_fixpt_sub_cast_1101 - 1));
  QGT_state_fixpt_cast_470 <= resize(QGT_state_fixpt_mul_temp_933, 50);
  QGT_state_fixpt_cast_471 <=  - (QGT_state_fixpt_cast_470);
  QGT_state_fixpt_cast_472 <= resize(QGT_state_fixpt_cast_471, 51);
  QGT_state_fixpt_cast_473 <= resize(QGT_state_fixpt_cast_472, 52);
  QGT_state_fixpt_cast_474 <=  - (QGT_state_fixpt_cast_473);
  QGT_state_fixpt_cast_475 <= QGT_state_fixpt_cast_474(50 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1102 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_934 <= QGT_state_fixpt_cast_475 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1102 - 1));
  QGT_state_fixpt_sub_cast_1103 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_935 <= QGT_state_fixpt_mul_temp_934 * nc(to_integer(QGT_state_fixpt_sub_cast_1103 - 1));
  QGT_state_fixpt_sub_cast_1104 <= resize(QGT_state_fixpt_mul_temp_935, 84);
  QGT_state_fixpt_sub_cast_1105 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_936 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1105 - 1));
  QGT_state_fixpt_cast_476 <= QGT_state_fixpt_mul_temp_936(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1106 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_937 <= QGT_state_fixpt_cast_476 * nc(to_integer(QGT_state_fixpt_sub_cast_1106 - 1));
  QGT_state_fixpt_cast_477 <= resize(QGT_state_fixpt_mul_temp_937, 50);
  QGT_state_fixpt_cast_478 <=  - (QGT_state_fixpt_cast_477);
  QGT_state_fixpt_sub_cast_1107 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_938 <= QGT_state_fixpt_cast_478 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1107 - 1));
  QGT_state_fixpt_sub_cast_1108 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_939 <= QGT_state_fixpt_mul_temp_938 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1108 - 1));
  QGT_state_fixpt_sub_cast_1109 <= resize(QGT_state_fixpt_mul_temp_939, 84);
  QGT_state_fixpt_sub_temp_86 <= QGT_state_fixpt_sub_cast_1104 - QGT_state_fixpt_sub_cast_1109;
  QGT_state_fixpt_add_cast_287 <= resize(QGT_state_fixpt_sub_temp_86, 85);
  QGT_state_fixpt_sub_cast_1110 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_940 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1110 - 1));
  QGT_state_fixpt_cast_479 <= QGT_state_fixpt_mul_temp_940(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1111 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_941 <= QGT_state_fixpt_cast_479 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1111 - 1));
  QGT_state_fixpt_sub_cast_1112 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_942 <= QGT_state_fixpt_mul_temp_941 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1112 - 1));
  QGT_state_fixpt_sub_cast_1113 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_943 <= QGT_state_fixpt_mul_temp_942 * nc(to_integer(QGT_state_fixpt_sub_cast_1113 - 1));
  QGT_state_fixpt_add_cast_288 <= resize(QGT_state_fixpt_mul_temp_943, 81);
  QGT_state_fixpt_add_cast_289 <= resize(QGT_state_fixpt_add_cast_288, 85);
  QGT_state_fixpt_add_temp_107 <= QGT_state_fixpt_add_cast_287 + QGT_state_fixpt_add_cast_289;
  QGT_state_fixpt_add_cast_290 <= resize(QGT_state_fixpt_add_temp_107, 86);
  QGT_state_fixpt_sub_cast_1114 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_944 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1114 - 1));
  QGT_state_fixpt_sub_cast_1115 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_945 <= QGT_state_fixpt_mul_temp_944 * nc(to_integer(QGT_state_fixpt_sub_cast_1115 - 1));
  QGT_state_fixpt_sub_cast_1116 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_946 <= QGT_state_fixpt_mul_temp_945 * nc(to_integer(QGT_state_fixpt_sub_cast_1116 - 1));
  QGT_state_fixpt_sub_cast_1117 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_947 <= QGT_state_fixpt_mul_temp_946 * nc(to_integer(QGT_state_fixpt_sub_cast_1117 - 1));
  QGT_state_fixpt_add_cast_291 <= resize(QGT_state_fixpt_mul_temp_947 & '0', 82);
  QGT_state_fixpt_add_cast_292 <= resize(QGT_state_fixpt_add_cast_291, 86);
  QGT_state_fixpt_add_temp_108 <= QGT_state_fixpt_add_cast_290 + QGT_state_fixpt_add_cast_292;
  QGT_state_fixpt_cast_480 <= QGT_state_fixpt_add_temp_108(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_948 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_480;
  QGT_state_fixpt_cast_481 <= QGT_state_fixpt_mul_temp_948(31 DOWNTO 0);
  QGT_state_fixpt_cast_482 <= resize(QGT_state_fixpt_cast_481, 33);
  QGT_state_fixpt_cast_483 <=  - (QGT_state_fixpt_cast_482);
  QGT_state_fixpt_sub_cast_1118 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_949 <= QGT_state_fixpt_cast_483 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1118 - 1));
  QGT_state_fixpt_sub_cast_1119 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_950 <= QGT_state_fixpt_mul_temp_949 * nc(to_integer(QGT_state_fixpt_sub_cast_1119 - 1));
  QGT_state_fixpt_sub_cast_1120 <= resize(QGT_state_fixpt_mul_temp_950, 67);
  QGT_state_fixpt_sub_temp_87 <= QGT_state_fixpt_sub_cast_1099 - QGT_state_fixpt_sub_cast_1120;
  QGT_state_fixpt_add_cast_293 <= resize(QGT_state_fixpt_sub_temp_87, 68);
  QGT_state_fixpt_sub_cast_1121 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_951 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1121 - 1));
  QGT_state_fixpt_sub_cast_1122 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_952 <= QGT_state_fixpt_mul_temp_951 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1122 - 1));
  QGT_state_fixpt_sub_cast_1123 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_953 <= QGT_state_fixpt_mul_temp_952 * nc(to_integer(QGT_state_fixpt_sub_cast_1123 - 1));
  QGT_state_fixpt_sub_cast_1124 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_954 <= QGT_state_fixpt_mul_temp_953 * nc(to_integer(QGT_state_fixpt_sub_cast_1124 - 1));
  QGT_state_fixpt_add_cast_294 <= resize(QGT_state_fixpt_mul_temp_954 & '0', 82);
  QGT_state_fixpt_add_cast_295 <= resize(QGT_state_fixpt_add_cast_294, 83);
  QGT_state_fixpt_sub_cast_1125 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_955 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1125 - 1));
  QGT_state_fixpt_sub_cast_1126 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_956 <= QGT_state_fixpt_mul_temp_955 * nc(to_integer(QGT_state_fixpt_sub_cast_1126 - 1));
  QGT_state_fixpt_sub_cast_1127 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_957 <= QGT_state_fixpt_mul_temp_956 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1127 - 1));
  QGT_state_fixpt_sub_cast_1128 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_958 <= QGT_state_fixpt_mul_temp_957 * nc(to_integer(QGT_state_fixpt_sub_cast_1128 - 1));
  QGT_state_fixpt_add_cast_296 <= resize(QGT_state_fixpt_mul_temp_958 & '0', 82);
  QGT_state_fixpt_add_cast_297 <= resize(QGT_state_fixpt_add_cast_296, 83);
  QGT_state_fixpt_add_temp_109 <= QGT_state_fixpt_add_cast_295 + QGT_state_fixpt_add_cast_297;
  QGT_state_fixpt_add_cast_298 <= resize(QGT_state_fixpt_add_temp_109, 84);
  QGT_state_fixpt_sub_cast_1129 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_959 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_1129 - 1));
  QGT_state_fixpt_cast_484 <= QGT_state_fixpt_mul_temp_959(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1130 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_960 <= QGT_state_fixpt_cast_484 * nc(to_integer(QGT_state_fixpt_sub_cast_1130 - 1));
  QGT_state_fixpt_sub_cast_1131 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_961 <= QGT_state_fixpt_mul_temp_960 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1131 - 1));
  QGT_state_fixpt_sub_cast_1132 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_962 <= QGT_state_fixpt_mul_temp_961 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1132 - 1));
  QGT_state_fixpt_add_cast_299 <= resize(QGT_state_fixpt_mul_temp_962, 81);
  QGT_state_fixpt_add_cast_300 <= resize(QGT_state_fixpt_add_cast_299, 84);
  QGT_state_fixpt_add_temp_110 <= QGT_state_fixpt_add_cast_298 + QGT_state_fixpt_add_cast_300;
  QGT_state_fixpt_add_cast_301 <= resize(QGT_state_fixpt_add_temp_110, 85);
  QGT_state_fixpt_sub_cast_1133 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_963 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1133 - 1));
  QGT_state_fixpt_cast_485 <= QGT_state_fixpt_mul_temp_963(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1134 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_964 <= QGT_state_fixpt_cast_485 * nc(to_integer(QGT_state_fixpt_sub_cast_1134 - 1));
  QGT_state_fixpt_cast_486 <= resize(QGT_state_fixpt_mul_temp_964, 50);
  QGT_state_fixpt_cast_487 <=  - (QGT_state_fixpt_cast_486);
  QGT_state_fixpt_sub_cast_1135 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_965 <= QGT_state_fixpt_cast_487 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1135 - 1));
  QGT_state_fixpt_sub_cast_1136 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_966 <= QGT_state_fixpt_mul_temp_965 * nc(to_integer(QGT_state_fixpt_sub_cast_1136 - 1));
  QGT_state_fixpt_add_cast_302 <= resize(QGT_state_fixpt_mul_temp_966, 85);
  QGT_state_fixpt_add_temp_111 <= QGT_state_fixpt_add_cast_301 + QGT_state_fixpt_add_cast_302;
  QGT_state_fixpt_cast_488 <= QGT_state_fixpt_add_temp_111(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_967 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_488;
  QGT_state_fixpt_cast_489 <= QGT_state_fixpt_mul_temp_967(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1137 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_968 <= QGT_state_fixpt_cast_489 * nc(to_integer(QGT_state_fixpt_sub_cast_1137 - 1));
  QGT_state_fixpt_sub_cast_1138 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_969 <= QGT_state_fixpt_mul_temp_968 * nc(to_integer(QGT_state_fixpt_sub_cast_1138 - 1));
  QGT_state_fixpt_add_cast_303 <= resize(QGT_state_fixpt_mul_temp_969, 68);
  QGT_state_fixpt_add_temp_112 <= QGT_state_fixpt_add_cast_293 + QGT_state_fixpt_add_cast_303;
  QGT_state_fixpt_add_cast_304 <= resize(QGT_state_fixpt_add_temp_112, 71);
  QGT_state_fixpt_sub_cast_1139 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_970 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_1139 - 1));
  QGT_state_fixpt_cast_490 <= QGT_state_fixpt_mul_temp_970(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1140 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_971 <= QGT_state_fixpt_cast_490 * nc(to_integer(QGT_state_fixpt_sub_cast_1140 - 1));
  QGT_state_fixpt_cast_491 <= resize(QGT_state_fixpt_mul_temp_971, 50);
  QGT_state_fixpt_cast_492 <=  - (QGT_state_fixpt_cast_491);
  QGT_state_fixpt_sub_cast_1141 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_972 <= QGT_state_fixpt_cast_492 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1141 - 1));
  QGT_state_fixpt_sub_cast_1142 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_973 <= QGT_state_fixpt_mul_temp_972 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1142 - 1));
  QGT_state_fixpt_sub_cast_1143 <= resize(QGT_state_fixpt_mul_temp_973, 83);
  QGT_state_fixpt_sub_cast_1144 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_974 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1144 - 1));
  QGT_state_fixpt_cast_493 <= QGT_state_fixpt_mul_temp_974(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1145 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_975 <= QGT_state_fixpt_cast_493 * nc(to_integer(QGT_state_fixpt_sub_cast_1145 - 1));
  QGT_state_fixpt_cast_494 <= resize(QGT_state_fixpt_mul_temp_975, 50);
  QGT_state_fixpt_cast_495 <=  - (QGT_state_fixpt_cast_494);
  QGT_state_fixpt_sub_cast_1146 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_976 <= QGT_state_fixpt_cast_495 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1146 - 1));
  QGT_state_fixpt_sub_cast_1147 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_977 <= QGT_state_fixpt_mul_temp_976 * nc(to_integer(QGT_state_fixpt_sub_cast_1147 - 1));
  QGT_state_fixpt_sub_cast_1148 <= resize(QGT_state_fixpt_mul_temp_977, 83);
  QGT_state_fixpt_sub_temp_88 <= QGT_state_fixpt_sub_cast_1143 - QGT_state_fixpt_sub_cast_1148;
  QGT_state_fixpt_add_cast_305 <= resize(QGT_state_fixpt_sub_temp_88, 84);
  QGT_state_fixpt_sub_cast_1149 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_978 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1149 - 1));
  QGT_state_fixpt_cast_496 <= QGT_state_fixpt_mul_temp_978(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1150 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_979 <= QGT_state_fixpt_cast_496 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1150 - 1));
  QGT_state_fixpt_sub_cast_1151 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_980 <= QGT_state_fixpt_mul_temp_979 * nc(to_integer(QGT_state_fixpt_sub_cast_1151 - 1));
  QGT_state_fixpt_sub_cast_1152 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_981 <= QGT_state_fixpt_mul_temp_980 * nc(to_integer(QGT_state_fixpt_sub_cast_1152 - 1));
  QGT_state_fixpt_add_cast_306 <= resize(QGT_state_fixpt_mul_temp_981, 81);
  QGT_state_fixpt_add_cast_307 <= resize(QGT_state_fixpt_add_cast_306, 84);
  QGT_state_fixpt_add_temp_113 <= QGT_state_fixpt_add_cast_305 + QGT_state_fixpt_add_cast_307;
  QGT_state_fixpt_sub_cast_1153 <= resize(QGT_state_fixpt_add_temp_113, 85);
  QGT_state_fixpt_sub_cast_1154 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_982 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1154 - 1));
  QGT_state_fixpt_sub_cast_1155 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_983 <= QGT_state_fixpt_mul_temp_982 * nc(to_integer(QGT_state_fixpt_sub_cast_1155 - 1));
  QGT_state_fixpt_sub_cast_1156 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_984 <= QGT_state_fixpt_mul_temp_983 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1156 - 1));
  QGT_state_fixpt_sub_cast_1157 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_985 <= QGT_state_fixpt_mul_temp_984 * nc(to_integer(QGT_state_fixpt_sub_cast_1157 - 1));
  QGT_state_fixpt_sub_cast_1158 <= resize(QGT_state_fixpt_mul_temp_985 & '0', 82);
  QGT_state_fixpt_sub_cast_1159 <= resize(QGT_state_fixpt_sub_cast_1158, 85);
  QGT_state_fixpt_sub_temp_89 <= QGT_state_fixpt_sub_cast_1153 - QGT_state_fixpt_sub_cast_1159;
  QGT_state_fixpt_cast_497 <= QGT_state_fixpt_sub_temp_89(73 DOWNTO 58);
  QGT_state_fixpt_sub_cast_1160 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_986 <= QGT_state_fixpt_cast_497 * nc(to_integer(QGT_state_fixpt_sub_cast_1160 - 1));
  QGT_state_fixpt_sub_cast_1161 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_987 <= QGT_state_fixpt_mul_temp_986 * nc(to_integer(QGT_state_fixpt_sub_cast_1161 - 1));
  QGT_state_fixpt_sub_cast_1162 <= resize(QGT_state_fixpt_mul_temp_987, 51);
  QGT_state_fixpt_sub_cast_1163 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_988 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1163 - 1));
  QGT_state_fixpt_sub_cast_1164 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_989 <= QGT_state_fixpt_mul_temp_988 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1164 - 1));
  QGT_state_fixpt_cast_498 <= resize(QGT_state_fixpt_mul_temp_989 & '0', 51);
  QGT_state_fixpt_cast_499 <= resize(QGT_state_fixpt_cast_498, 52);
  QGT_state_fixpt_cast_500 <=  - (QGT_state_fixpt_cast_499);
  QGT_state_fixpt_cast_501 <= QGT_state_fixpt_cast_500(50 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1165 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_990 <= QGT_state_fixpt_cast_501 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1165 - 1));
  QGT_state_fixpt_sub_cast_1166 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_991 <= QGT_state_fixpt_mul_temp_990 * nc(to_integer(QGT_state_fixpt_sub_cast_1166 - 1));
  QGT_state_fixpt_add_cast_308 <= resize(QGT_state_fixpt_mul_temp_991, 84);
  QGT_state_fixpt_sub_cast_1167 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_992 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1167 - 1));
  QGT_state_fixpt_sub_cast_1168 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_993 <= QGT_state_fixpt_mul_temp_992 * nc(to_integer(QGT_state_fixpt_sub_cast_1168 - 1));
  QGT_state_fixpt_sub_cast_1169 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_994 <= QGT_state_fixpt_mul_temp_993 * nc(to_integer(QGT_state_fixpt_sub_cast_1169 - 1));
  QGT_state_fixpt_sub_cast_1170 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_995 <= QGT_state_fixpt_mul_temp_994 * nc(to_integer(QGT_state_fixpt_sub_cast_1170 - 1));
  QGT_state_fixpt_add_cast_309 <= resize(QGT_state_fixpt_mul_temp_995 & '0', 82);
  QGT_state_fixpt_add_cast_310 <= resize(QGT_state_fixpt_add_cast_309, 84);
  QGT_state_fixpt_add_temp_114 <= QGT_state_fixpt_add_cast_308 + QGT_state_fixpt_add_cast_310;
  QGT_state_fixpt_add_cast_311 <= resize(QGT_state_fixpt_add_temp_114, 85);
  QGT_state_fixpt_sub_cast_1171 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_996 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_1171 - 1));
  QGT_state_fixpt_cast_502 <= QGT_state_fixpt_mul_temp_996(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1172 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_997 <= QGT_state_fixpt_cast_502 * nc(to_integer(QGT_state_fixpt_sub_cast_1172 - 1));
  QGT_state_fixpt_sub_cast_1173 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_998 <= QGT_state_fixpt_mul_temp_997 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1173 - 1));
  QGT_state_fixpt_sub_cast_1174 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_999 <= QGT_state_fixpt_mul_temp_998 * nc(to_integer(QGT_state_fixpt_sub_cast_1174 - 1));
  QGT_state_fixpt_add_cast_312 <= resize(QGT_state_fixpt_mul_temp_999, 81);
  QGT_state_fixpt_add_cast_313 <= resize(QGT_state_fixpt_add_cast_312, 85);
  QGT_state_fixpt_add_temp_115 <= QGT_state_fixpt_add_cast_311 + QGT_state_fixpt_add_cast_313;
  QGT_state_fixpt_sub_cast_1175 <= resize(QGT_state_fixpt_add_temp_115, 86);
  QGT_state_fixpt_sub_cast_1176 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1000 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1176 - 1));
  QGT_state_fixpt_cast_503 <= QGT_state_fixpt_mul_temp_1000(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1177 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1001 <= QGT_state_fixpt_cast_503 * nc(to_integer(QGT_state_fixpt_sub_cast_1177 - 1));
  QGT_state_fixpt_cast_504 <= resize(QGT_state_fixpt_mul_temp_1001, 50);
  QGT_state_fixpt_cast_505 <=  - (QGT_state_fixpt_cast_504);
  QGT_state_fixpt_sub_cast_1178 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1002 <= QGT_state_fixpt_cast_505 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1178 - 1));
  QGT_state_fixpt_sub_cast_1179 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1003 <= QGT_state_fixpt_mul_temp_1002 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1179 - 1));
  QGT_state_fixpt_sub_cast_1180 <= resize(QGT_state_fixpt_mul_temp_1003, 86);
  QGT_state_fixpt_sub_temp_90 <= QGT_state_fixpt_sub_cast_1175 - QGT_state_fixpt_sub_cast_1180;
  QGT_state_fixpt_cast_506 <= QGT_state_fixpt_sub_temp_90(73 DOWNTO 58);
  QGT_state_fixpt_sub_cast_1181 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_1004 <= QGT_state_fixpt_cast_506 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1181 - 1));
  QGT_state_fixpt_sub_cast_1182 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_1005 <= QGT_state_fixpt_mul_temp_1004 * nc(to_integer(QGT_state_fixpt_sub_cast_1182 - 1));
  QGT_state_fixpt_sub_cast_1183 <= resize(QGT_state_fixpt_mul_temp_1005, 50);
  QGT_state_fixpt_sub_cast_1184 <= resize(QGT_state_fixpt_sub_cast_1183, 51);
  QGT_state_fixpt_sub_temp_91 <= QGT_state_fixpt_sub_cast_1162 - QGT_state_fixpt_sub_cast_1184;
  QGT_state_fixpt_sub_cast_1185 <= resize(QGT_state_fixpt_sub_temp_91, 52);
  QGT_state_fixpt_sub_cast_1186 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1006 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1186 - 1));
  QGT_state_fixpt_sub_cast_1187 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1007 <= QGT_state_fixpt_mul_temp_1006 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1187 - 1));
  QGT_state_fixpt_cast_507 <= resize(QGT_state_fixpt_mul_temp_1007 & '0', 51);
  QGT_state_fixpt_cast_508 <= resize(QGT_state_fixpt_cast_507, 52);
  QGT_state_fixpt_cast_509 <=  - (QGT_state_fixpt_cast_508);
  QGT_state_fixpt_cast_510 <= QGT_state_fixpt_cast_509(50 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1188 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1008 <= QGT_state_fixpt_cast_510 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1188 - 1));
  QGT_state_fixpt_sub_cast_1189 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1009 <= QGT_state_fixpt_mul_temp_1008 * nc(to_integer(QGT_state_fixpt_sub_cast_1189 - 1));
  QGT_state_fixpt_sub_cast_1190 <= resize(QGT_state_fixpt_mul_temp_1009, 84);
  QGT_state_fixpt_sub_cast_1191 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1010 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1191 - 1));
  QGT_state_fixpt_sub_cast_1192 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1011 <= QGT_state_fixpt_mul_temp_1010 * nc(to_integer(QGT_state_fixpt_sub_cast_1192 - 1));
  QGT_state_fixpt_sub_cast_1193 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1012 <= QGT_state_fixpt_mul_temp_1011 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1193 - 1));
  QGT_state_fixpt_sub_cast_1194 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1013 <= QGT_state_fixpt_mul_temp_1012 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1194 - 1));
  QGT_state_fixpt_sub_cast_1195 <= resize(QGT_state_fixpt_mul_temp_1013 & '0', 82);
  QGT_state_fixpt_sub_cast_1196 <= resize(QGT_state_fixpt_sub_cast_1195, 84);
  QGT_state_fixpt_sub_temp_92 <= QGT_state_fixpt_sub_cast_1190 - QGT_state_fixpt_sub_cast_1196;
  QGT_state_fixpt_add_cast_314 <= resize(QGT_state_fixpt_sub_temp_92, 85);
  QGT_state_fixpt_sub_cast_1197 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1014 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_1197 - 1));
  QGT_state_fixpt_cast_511 <= QGT_state_fixpt_mul_temp_1014(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1198 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1015 <= QGT_state_fixpt_cast_511 * nc(to_integer(QGT_state_fixpt_sub_cast_1198 - 1));
  QGT_state_fixpt_sub_cast_1199 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1016 <= QGT_state_fixpt_mul_temp_1015 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1199 - 1));
  QGT_state_fixpt_sub_cast_1200 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1017 <= QGT_state_fixpt_mul_temp_1016 * nc(to_integer(QGT_state_fixpt_sub_cast_1200 - 1));
  QGT_state_fixpt_add_cast_315 <= resize(QGT_state_fixpt_mul_temp_1017, 81);
  QGT_state_fixpt_add_cast_316 <= resize(QGT_state_fixpt_add_cast_315, 85);
  QGT_state_fixpt_add_temp_116 <= QGT_state_fixpt_add_cast_314 + QGT_state_fixpt_add_cast_316;
  QGT_state_fixpt_add_cast_317 <= resize(QGT_state_fixpt_add_temp_116, 86);
  QGT_state_fixpt_sub_cast_1201 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1018 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1201 - 1));
  QGT_state_fixpt_cast_512 <= QGT_state_fixpt_mul_temp_1018(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1202 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1019 <= QGT_state_fixpt_cast_512 * nc(to_integer(QGT_state_fixpt_sub_cast_1202 - 1));
  QGT_state_fixpt_cast_513 <= resize(QGT_state_fixpt_mul_temp_1019, 50);
  QGT_state_fixpt_cast_514 <=  - (QGT_state_fixpt_cast_513);
  QGT_state_fixpt_sub_cast_1203 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1020 <= QGT_state_fixpt_cast_514 * nc(to_integer(QGT_state_fixpt_sub_cast_1203 - 1));
  QGT_state_fixpt_sub_cast_1204 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1021 <= QGT_state_fixpt_mul_temp_1020 * nc(to_integer(QGT_state_fixpt_sub_cast_1204 - 1));
  QGT_state_fixpt_add_cast_318 <= resize(QGT_state_fixpt_mul_temp_1021, 86);
  QGT_state_fixpt_add_temp_117 <= QGT_state_fixpt_add_cast_317 + QGT_state_fixpt_add_cast_318;
  QGT_state_fixpt_cast_515 <= QGT_state_fixpt_add_temp_117(73 DOWNTO 58);
  QGT_state_fixpt_sub_cast_1205 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_1022 <= QGT_state_fixpt_cast_515 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1205 - 1));
  QGT_state_fixpt_sub_cast_1206 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_1023 <= QGT_state_fixpt_mul_temp_1022 * nc(to_integer(QGT_state_fixpt_sub_cast_1206 - 1));
  QGT_state_fixpt_sub_cast_1207 <= resize(QGT_state_fixpt_mul_temp_1023, 50);
  QGT_state_fixpt_sub_cast_1208 <= resize(QGT_state_fixpt_sub_cast_1207, 52);
  QGT_state_fixpt_sub_temp_93 <= QGT_state_fixpt_sub_cast_1185 - QGT_state_fixpt_sub_cast_1208;
  QGT_state_fixpt_sub_cast_1209 <= resize(QGT_state_fixpt_sub_temp_93, 53);
  QGT_state_fixpt_sub_cast_1210 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1024 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_1210 - 1));
  QGT_state_fixpt_cast_516 <= QGT_state_fixpt_mul_temp_1024(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1211 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1025 <= QGT_state_fixpt_cast_516 * nc(to_integer(QGT_state_fixpt_sub_cast_1211 - 1));
  QGT_state_fixpt_cast_517 <= resize(QGT_state_fixpt_mul_temp_1025, 50);
  QGT_state_fixpt_cast_518 <=  - (QGT_state_fixpt_cast_517);
  QGT_state_fixpt_sub_cast_1212 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1026 <= QGT_state_fixpt_cast_518 * nc(to_integer(QGT_state_fixpt_sub_cast_1212 - 1));
  QGT_state_fixpt_sub_cast_1213 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1027 <= QGT_state_fixpt_mul_temp_1026 * nc(to_integer(QGT_state_fixpt_sub_cast_1213 - 1));
  QGT_state_fixpt_add_cast_319 <= resize(QGT_state_fixpt_mul_temp_1027, 83);
  QGT_state_fixpt_sub_cast_1214 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1028 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1214 - 1));
  QGT_state_fixpt_cast_519 <= QGT_state_fixpt_mul_temp_1028(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1215 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1029 <= QGT_state_fixpt_cast_519 * nc(to_integer(QGT_state_fixpt_sub_cast_1215 - 1));
  QGT_state_fixpt_cast_520 <= resize(QGT_state_fixpt_mul_temp_1029, 50);
  QGT_state_fixpt_cast_521 <=  - (QGT_state_fixpt_cast_520);
  QGT_state_fixpt_sub_cast_1216 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1030 <= QGT_state_fixpt_cast_521 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1216 - 1));
  QGT_state_fixpt_sub_cast_1217 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1031 <= QGT_state_fixpt_mul_temp_1030 * nc(to_integer(QGT_state_fixpt_sub_cast_1217 - 1));
  QGT_state_fixpt_add_cast_320 <= resize(QGT_state_fixpt_mul_temp_1031, 83);
  QGT_state_fixpt_add_temp_118 <= QGT_state_fixpt_add_cast_319 + QGT_state_fixpt_add_cast_320;
  QGT_state_fixpt_add_cast_321 <= resize(QGT_state_fixpt_add_temp_118, 84);
  QGT_state_fixpt_sub_cast_1218 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1032 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1218 - 1));
  QGT_state_fixpt_cast_522 <= QGT_state_fixpt_mul_temp_1032(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1219 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1033 <= QGT_state_fixpt_cast_522 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1219 - 1));
  QGT_state_fixpt_sub_cast_1220 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1034 <= QGT_state_fixpt_mul_temp_1033 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1220 - 1));
  QGT_state_fixpt_sub_cast_1221 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1035 <= QGT_state_fixpt_mul_temp_1034 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1221 - 1));
  QGT_state_fixpt_add_cast_322 <= resize(QGT_state_fixpt_mul_temp_1035, 81);
  QGT_state_fixpt_add_cast_323 <= resize(QGT_state_fixpt_add_cast_322, 84);
  QGT_state_fixpt_add_temp_119 <= QGT_state_fixpt_add_cast_321 + QGT_state_fixpt_add_cast_323;
  QGT_state_fixpt_add_cast_324 <= resize(QGT_state_fixpt_add_temp_119, 85);
  QGT_state_fixpt_sub_cast_1222 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1036 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1222 - 1));
  QGT_state_fixpt_sub_cast_1223 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1037 <= QGT_state_fixpt_mul_temp_1036 * nc(to_integer(QGT_state_fixpt_sub_cast_1223 - 1));
  QGT_state_fixpt_sub_cast_1224 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1038 <= QGT_state_fixpt_mul_temp_1037 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1224 - 1));
  QGT_state_fixpt_sub_cast_1225 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1039 <= QGT_state_fixpt_mul_temp_1038 * nc(to_integer(QGT_state_fixpt_sub_cast_1225 - 1));
  QGT_state_fixpt_add_cast_325 <= resize(QGT_state_fixpt_mul_temp_1039 & '0', 82);
  QGT_state_fixpt_add_cast_326 <= resize(QGT_state_fixpt_add_cast_325, 85);
  QGT_state_fixpt_add_temp_120 <= QGT_state_fixpt_add_cast_324 + QGT_state_fixpt_add_cast_326;
  QGT_state_fixpt_cast_523 <= QGT_state_fixpt_add_temp_120(73 DOWNTO 58);
  QGT_state_fixpt_sub_cast_1226 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_1040 <= QGT_state_fixpt_cast_523 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1226 - 1));
  QGT_state_fixpt_sub_cast_1227 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_1041 <= QGT_state_fixpt_mul_temp_1040 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1227 - 1));
  QGT_state_fixpt_sub_cast_1228 <= resize(QGT_state_fixpt_mul_temp_1041, 53);
  QGT_state_fixpt_sub_temp_94 <= QGT_state_fixpt_sub_cast_1209 - QGT_state_fixpt_sub_cast_1228;
  QGT_state_fixpt_mul_temp_1042 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_sub_temp_94;
  QGT_state_fixpt_cast_524 <= QGT_state_fixpt_mul_temp_1042(68 DOWNTO 0);
  QGT_state_fixpt_cast_525 <= resize(QGT_state_fixpt_cast_524, 70);
  QGT_state_fixpt_cast_526 <=  - (QGT_state_fixpt_cast_525);
  QGT_state_fixpt_add_cast_327 <= resize(QGT_state_fixpt_cast_526, 71);
  QGT_state_fixpt_add_temp_121 <= QGT_state_fixpt_add_cast_304 + QGT_state_fixpt_add_cast_327;
  QGT_state_fixpt_c_re_3 <= QGT_state_fixpt_add_temp_121(59 DOWNTO 44);
  QGT_state_fixpt_sub_cast_1229 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1043 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_1229 - 1));
  QGT_state_fixpt_cast_527 <= QGT_state_fixpt_mul_temp_1043(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1230 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1044 <= QGT_state_fixpt_cast_527 * nc(to_integer(QGT_state_fixpt_sub_cast_1230 - 1));
  QGT_state_fixpt_cast_528 <= resize(QGT_state_fixpt_mul_temp_1044, 50);
  QGT_state_fixpt_cast_529 <=  - (QGT_state_fixpt_cast_528);
  QGT_state_fixpt_sub_cast_1231 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1045 <= QGT_state_fixpt_cast_529 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1231 - 1));
  QGT_state_fixpt_sub_cast_1232 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1046 <= QGT_state_fixpt_mul_temp_1045 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1232 - 1));
  QGT_state_fixpt_sub_cast_1233 <= resize(QGT_state_fixpt_mul_temp_1046, 83);
  QGT_state_fixpt_sub_cast_1234 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1047 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1234 - 1));
  QGT_state_fixpt_cast_530 <= QGT_state_fixpt_mul_temp_1047(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1235 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1048 <= QGT_state_fixpt_cast_530 * nc(to_integer(QGT_state_fixpt_sub_cast_1235 - 1));
  QGT_state_fixpt_cast_531 <= resize(QGT_state_fixpt_mul_temp_1048, 50);
  QGT_state_fixpt_cast_532 <=  - (QGT_state_fixpt_cast_531);
  QGT_state_fixpt_sub_cast_1236 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1049 <= QGT_state_fixpt_cast_532 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1236 - 1));
  QGT_state_fixpt_sub_cast_1237 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1050 <= QGT_state_fixpt_mul_temp_1049 * nc(to_integer(QGT_state_fixpt_sub_cast_1237 - 1));
  QGT_state_fixpt_sub_cast_1238 <= resize(QGT_state_fixpt_mul_temp_1050, 83);
  QGT_state_fixpt_sub_temp_95 <= QGT_state_fixpt_sub_cast_1233 - QGT_state_fixpt_sub_cast_1238;
  QGT_state_fixpt_add_cast_328 <= resize(QGT_state_fixpt_sub_temp_95, 84);
  QGT_state_fixpt_sub_cast_1239 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1051 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1239 - 1));
  QGT_state_fixpt_cast_533 <= QGT_state_fixpt_mul_temp_1051(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1240 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1052 <= QGT_state_fixpt_cast_533 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1240 - 1));
  QGT_state_fixpt_sub_cast_1241 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1053 <= QGT_state_fixpt_mul_temp_1052 * nc(to_integer(QGT_state_fixpt_sub_cast_1241 - 1));
  QGT_state_fixpt_sub_cast_1242 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1054 <= QGT_state_fixpt_mul_temp_1053 * nc(to_integer(QGT_state_fixpt_sub_cast_1242 - 1));
  QGT_state_fixpt_add_cast_329 <= resize(QGT_state_fixpt_mul_temp_1054, 81);
  QGT_state_fixpt_add_cast_330 <= resize(QGT_state_fixpt_add_cast_329, 84);
  QGT_state_fixpt_add_temp_122 <= QGT_state_fixpt_add_cast_328 + QGT_state_fixpt_add_cast_330;
  QGT_state_fixpt_sub_cast_1243 <= resize(QGT_state_fixpt_add_temp_122, 85);
  QGT_state_fixpt_sub_cast_1244 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1055 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1244 - 1));
  QGT_state_fixpt_sub_cast_1245 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1056 <= QGT_state_fixpt_mul_temp_1055 * nc(to_integer(QGT_state_fixpt_sub_cast_1245 - 1));
  QGT_state_fixpt_sub_cast_1246 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1057 <= QGT_state_fixpt_mul_temp_1056 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1246 - 1));
  QGT_state_fixpt_sub_cast_1247 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1058 <= QGT_state_fixpt_mul_temp_1057 * nc(to_integer(QGT_state_fixpt_sub_cast_1247 - 1));
  QGT_state_fixpt_sub_cast_1248 <= resize(QGT_state_fixpt_mul_temp_1058 & '0', 82);
  QGT_state_fixpt_sub_cast_1249 <= resize(QGT_state_fixpt_sub_cast_1248, 85);
  QGT_state_fixpt_sub_temp_96 <= QGT_state_fixpt_sub_cast_1243 - QGT_state_fixpt_sub_cast_1249;
  QGT_state_fixpt_cast_534 <= QGT_state_fixpt_sub_temp_96(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_1059 <= to_signed(-16#5A83#, 16) * QGT_state_fixpt_cast_534;
  QGT_state_fixpt_sub_cast_1250 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_1060 <= QGT_state_fixpt_mul_temp_1059 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1250 - 1));
  QGT_state_fixpt_sub_cast_1251 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_1061 <= QGT_state_fixpt_mul_temp_1060 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1251 - 1));
  QGT_state_fixpt_sub_cast_1252 <= resize(QGT_state_fixpt_mul_temp_1061 & '0', 66);
  QGT_state_fixpt_sub_cast_1253 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1062 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1253 - 1));
  QGT_state_fixpt_sub_cast_1254 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1063 <= QGT_state_fixpt_mul_temp_1062 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1254 - 1));
  QGT_state_fixpt_cast_535 <= resize(QGT_state_fixpt_mul_temp_1063 & '0', 51);
  QGT_state_fixpt_cast_536 <= resize(QGT_state_fixpt_cast_535, 52);
  QGT_state_fixpt_cast_537 <=  - (QGT_state_fixpt_cast_536);
  QGT_state_fixpt_cast_538 <= QGT_state_fixpt_cast_537(50 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1255 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1064 <= QGT_state_fixpt_cast_538 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1255 - 1));
  QGT_state_fixpt_sub_cast_1256 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1065 <= QGT_state_fixpt_mul_temp_1064 * nc(to_integer(QGT_state_fixpt_sub_cast_1256 - 1));
  QGT_state_fixpt_add_cast_331 <= resize(QGT_state_fixpt_mul_temp_1065, 84);
  QGT_state_fixpt_sub_cast_1257 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1066 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1257 - 1));
  QGT_state_fixpt_sub_cast_1258 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1067 <= QGT_state_fixpt_mul_temp_1066 * nc(to_integer(QGT_state_fixpt_sub_cast_1258 - 1));
  QGT_state_fixpt_sub_cast_1259 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1068 <= QGT_state_fixpt_mul_temp_1067 * nc(to_integer(QGT_state_fixpt_sub_cast_1259 - 1));
  QGT_state_fixpt_sub_cast_1260 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1069 <= QGT_state_fixpt_mul_temp_1068 * nc(to_integer(QGT_state_fixpt_sub_cast_1260 - 1));
  QGT_state_fixpt_add_cast_332 <= resize(QGT_state_fixpt_mul_temp_1069 & '0', 82);
  QGT_state_fixpt_add_cast_333 <= resize(QGT_state_fixpt_add_cast_332, 84);
  QGT_state_fixpt_add_temp_123 <= QGT_state_fixpt_add_cast_331 + QGT_state_fixpt_add_cast_333;
  QGT_state_fixpt_add_cast_334 <= resize(QGT_state_fixpt_add_temp_123, 85);
  QGT_state_fixpt_sub_cast_1261 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1070 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_1261 - 1));
  QGT_state_fixpt_cast_539 <= QGT_state_fixpt_mul_temp_1070(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1262 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1071 <= QGT_state_fixpt_cast_539 * nc(to_integer(QGT_state_fixpt_sub_cast_1262 - 1));
  QGT_state_fixpt_sub_cast_1263 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1072 <= QGT_state_fixpt_mul_temp_1071 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1263 - 1));
  QGT_state_fixpt_sub_cast_1264 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1073 <= QGT_state_fixpt_mul_temp_1072 * nc(to_integer(QGT_state_fixpt_sub_cast_1264 - 1));
  QGT_state_fixpt_add_cast_335 <= resize(QGT_state_fixpt_mul_temp_1073, 81);
  QGT_state_fixpt_add_cast_336 <= resize(QGT_state_fixpt_add_cast_335, 85);
  QGT_state_fixpt_add_temp_124 <= QGT_state_fixpt_add_cast_334 + QGT_state_fixpt_add_cast_336;
  QGT_state_fixpt_sub_cast_1265 <= resize(QGT_state_fixpt_add_temp_124, 86);
  QGT_state_fixpt_sub_cast_1266 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1074 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1266 - 1));
  QGT_state_fixpt_cast_540 <= QGT_state_fixpt_mul_temp_1074(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1267 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1075 <= QGT_state_fixpt_cast_540 * nc(to_integer(QGT_state_fixpt_sub_cast_1267 - 1));
  QGT_state_fixpt_cast_541 <= resize(QGT_state_fixpt_mul_temp_1075, 50);
  QGT_state_fixpt_cast_542 <=  - (QGT_state_fixpt_cast_541);
  QGT_state_fixpt_sub_cast_1268 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1076 <= QGT_state_fixpt_cast_542 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1268 - 1));
  QGT_state_fixpt_sub_cast_1269 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1077 <= QGT_state_fixpt_mul_temp_1076 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1269 - 1));
  QGT_state_fixpt_sub_cast_1270 <= resize(QGT_state_fixpt_mul_temp_1077, 86);
  QGT_state_fixpt_sub_temp_97 <= QGT_state_fixpt_sub_cast_1265 - QGT_state_fixpt_sub_cast_1270;
  QGT_state_fixpt_cast_543 <= QGT_state_fixpt_sub_temp_97(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_1078 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_543;
  QGT_state_fixpt_cast_544 <= QGT_state_fixpt_mul_temp_1078(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1271 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_1079 <= QGT_state_fixpt_cast_544 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1271 - 1));
  QGT_state_fixpt_sub_cast_1272 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_1080 <= QGT_state_fixpt_mul_temp_1079 * nc(to_integer(QGT_state_fixpt_sub_cast_1272 - 1));
  QGT_state_fixpt_sub_cast_1273 <= resize(QGT_state_fixpt_mul_temp_1080, 65);
  QGT_state_fixpt_sub_cast_1274 <= resize(QGT_state_fixpt_sub_cast_1273, 66);
  QGT_state_fixpt_sub_temp_98 <= QGT_state_fixpt_sub_cast_1252 - QGT_state_fixpt_sub_cast_1274;
  QGT_state_fixpt_sub_cast_1275 <= resize(QGT_state_fixpt_sub_temp_98, 67);
  QGT_state_fixpt_sub_cast_1276 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1081 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1276 - 1));
  QGT_state_fixpt_sub_cast_1277 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1082 <= QGT_state_fixpt_mul_temp_1081 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1277 - 1));
  QGT_state_fixpt_cast_545 <= resize(QGT_state_fixpt_mul_temp_1082 & '0', 51);
  QGT_state_fixpt_cast_546 <= resize(QGT_state_fixpt_cast_545, 52);
  QGT_state_fixpt_cast_547 <=  - (QGT_state_fixpt_cast_546);
  QGT_state_fixpt_cast_548 <= QGT_state_fixpt_cast_547(50 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1278 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1083 <= QGT_state_fixpt_cast_548 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1278 - 1));
  QGT_state_fixpt_sub_cast_1279 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1084 <= QGT_state_fixpt_mul_temp_1083 * nc(to_integer(QGT_state_fixpt_sub_cast_1279 - 1));
  QGT_state_fixpt_sub_cast_1280 <= resize(QGT_state_fixpt_mul_temp_1084, 84);
  QGT_state_fixpt_sub_cast_1281 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1085 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1281 - 1));
  QGT_state_fixpt_sub_cast_1282 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1086 <= QGT_state_fixpt_mul_temp_1085 * nc(to_integer(QGT_state_fixpt_sub_cast_1282 - 1));
  QGT_state_fixpt_sub_cast_1283 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1087 <= QGT_state_fixpt_mul_temp_1086 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1283 - 1));
  QGT_state_fixpt_sub_cast_1284 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1088 <= QGT_state_fixpt_mul_temp_1087 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1284 - 1));
  QGT_state_fixpt_sub_cast_1285 <= resize(QGT_state_fixpt_mul_temp_1088 & '0', 82);
  QGT_state_fixpt_sub_cast_1286 <= resize(QGT_state_fixpt_sub_cast_1285, 84);
  QGT_state_fixpt_sub_temp_99 <= QGT_state_fixpt_sub_cast_1280 - QGT_state_fixpt_sub_cast_1286;
  QGT_state_fixpt_add_cast_337 <= resize(QGT_state_fixpt_sub_temp_99, 85);
  QGT_state_fixpt_sub_cast_1287 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1089 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_1287 - 1));
  QGT_state_fixpt_cast_549 <= QGT_state_fixpt_mul_temp_1089(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1288 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1090 <= QGT_state_fixpt_cast_549 * nc(to_integer(QGT_state_fixpt_sub_cast_1288 - 1));
  QGT_state_fixpt_sub_cast_1289 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1091 <= QGT_state_fixpt_mul_temp_1090 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1289 - 1));
  QGT_state_fixpt_sub_cast_1290 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1092 <= QGT_state_fixpt_mul_temp_1091 * nc(to_integer(QGT_state_fixpt_sub_cast_1290 - 1));
  QGT_state_fixpt_add_cast_338 <= resize(QGT_state_fixpt_mul_temp_1092, 81);
  QGT_state_fixpt_add_cast_339 <= resize(QGT_state_fixpt_add_cast_338, 85);
  QGT_state_fixpt_add_temp_125 <= QGT_state_fixpt_add_cast_337 + QGT_state_fixpt_add_cast_339;
  QGT_state_fixpt_add_cast_340 <= resize(QGT_state_fixpt_add_temp_125, 86);
  QGT_state_fixpt_sub_cast_1291 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1093 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1291 - 1));
  QGT_state_fixpt_cast_550 <= QGT_state_fixpt_mul_temp_1093(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1292 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1094 <= QGT_state_fixpt_cast_550 * nc(to_integer(QGT_state_fixpt_sub_cast_1292 - 1));
  QGT_state_fixpt_cast_551 <= resize(QGT_state_fixpt_mul_temp_1094, 50);
  QGT_state_fixpt_cast_552 <=  - (QGT_state_fixpt_cast_551);
  QGT_state_fixpt_sub_cast_1293 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1095 <= QGT_state_fixpt_cast_552 * nc(to_integer(QGT_state_fixpt_sub_cast_1293 - 1));
  QGT_state_fixpt_sub_cast_1294 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1096 <= QGT_state_fixpt_mul_temp_1095 * nc(to_integer(QGT_state_fixpt_sub_cast_1294 - 1));
  QGT_state_fixpt_add_cast_341 <= resize(QGT_state_fixpt_mul_temp_1096, 86);
  QGT_state_fixpt_add_temp_126 <= QGT_state_fixpt_add_cast_340 + QGT_state_fixpt_add_cast_341;
  QGT_state_fixpt_cast_553 <= QGT_state_fixpt_add_temp_126(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_1097 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_553;
  QGT_state_fixpt_cast_554 <= QGT_state_fixpt_mul_temp_1097(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1295 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_1098 <= QGT_state_fixpt_cast_554 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1295 - 1));
  QGT_state_fixpt_sub_cast_1296 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_1099 <= QGT_state_fixpt_mul_temp_1098 * nc(to_integer(QGT_state_fixpt_sub_cast_1296 - 1));
  QGT_state_fixpt_sub_cast_1297 <= resize(QGT_state_fixpt_mul_temp_1099, 65);
  QGT_state_fixpt_sub_cast_1298 <= resize(QGT_state_fixpt_sub_cast_1297, 67);
  QGT_state_fixpt_sub_temp_100 <= QGT_state_fixpt_sub_cast_1275 - QGT_state_fixpt_sub_cast_1298;
  QGT_state_fixpt_add_cast_342 <= resize(QGT_state_fixpt_sub_temp_100, 68);
  QGT_state_fixpt_sub_cast_1299 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1100 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_1299 - 1));
  QGT_state_fixpt_cast_555 <= QGT_state_fixpt_mul_temp_1100(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1300 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1101 <= QGT_state_fixpt_cast_555 * nc(to_integer(QGT_state_fixpt_sub_cast_1300 - 1));
  QGT_state_fixpt_cast_556 <= resize(QGT_state_fixpt_mul_temp_1101, 50);
  QGT_state_fixpt_cast_557 <=  - (QGT_state_fixpt_cast_556);
  QGT_state_fixpt_sub_cast_1301 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1102 <= QGT_state_fixpt_cast_557 * nc(to_integer(QGT_state_fixpt_sub_cast_1301 - 1));
  QGT_state_fixpt_sub_cast_1302 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1103 <= QGT_state_fixpt_mul_temp_1102 * nc(to_integer(QGT_state_fixpt_sub_cast_1302 - 1));
  QGT_state_fixpt_add_cast_343 <= resize(QGT_state_fixpt_mul_temp_1103, 83);
  QGT_state_fixpt_sub_cast_1303 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1104 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1303 - 1));
  QGT_state_fixpt_cast_558 <= QGT_state_fixpt_mul_temp_1104(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1304 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1105 <= QGT_state_fixpt_cast_558 * nc(to_integer(QGT_state_fixpt_sub_cast_1304 - 1));
  QGT_state_fixpt_cast_559 <= resize(QGT_state_fixpt_mul_temp_1105, 50);
  QGT_state_fixpt_cast_560 <=  - (QGT_state_fixpt_cast_559);
  QGT_state_fixpt_sub_cast_1305 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1106 <= QGT_state_fixpt_cast_560 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1305 - 1));
  QGT_state_fixpt_sub_cast_1306 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1107 <= QGT_state_fixpt_mul_temp_1106 * nc(to_integer(QGT_state_fixpt_sub_cast_1306 - 1));
  QGT_state_fixpt_add_cast_344 <= resize(QGT_state_fixpt_mul_temp_1107, 83);
  QGT_state_fixpt_add_temp_127 <= QGT_state_fixpt_add_cast_343 + QGT_state_fixpt_add_cast_344;
  QGT_state_fixpt_add_cast_345 <= resize(QGT_state_fixpt_add_temp_127, 84);
  QGT_state_fixpt_sub_cast_1307 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1108 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1307 - 1));
  QGT_state_fixpt_cast_561 <= QGT_state_fixpt_mul_temp_1108(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1308 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1109 <= QGT_state_fixpt_cast_561 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1308 - 1));
  QGT_state_fixpt_sub_cast_1309 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1110 <= QGT_state_fixpt_mul_temp_1109 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1309 - 1));
  QGT_state_fixpt_sub_cast_1310 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1111 <= QGT_state_fixpt_mul_temp_1110 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1310 - 1));
  QGT_state_fixpt_add_cast_346 <= resize(QGT_state_fixpt_mul_temp_1111, 81);
  QGT_state_fixpt_add_cast_347 <= resize(QGT_state_fixpt_add_cast_346, 84);
  QGT_state_fixpt_add_temp_128 <= QGT_state_fixpt_add_cast_345 + QGT_state_fixpt_add_cast_347;
  QGT_state_fixpt_add_cast_348 <= resize(QGT_state_fixpt_add_temp_128, 85);
  QGT_state_fixpt_sub_cast_1311 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1112 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1311 - 1));
  QGT_state_fixpt_sub_cast_1312 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1113 <= QGT_state_fixpt_mul_temp_1112 * nc(to_integer(QGT_state_fixpt_sub_cast_1312 - 1));
  QGT_state_fixpt_sub_cast_1313 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1114 <= QGT_state_fixpt_mul_temp_1113 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1313 - 1));
  QGT_state_fixpt_sub_cast_1314 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1115 <= QGT_state_fixpt_mul_temp_1114 * nc(to_integer(QGT_state_fixpt_sub_cast_1314 - 1));
  QGT_state_fixpt_add_cast_349 <= resize(QGT_state_fixpt_mul_temp_1115 & '0', 82);
  QGT_state_fixpt_add_cast_350 <= resize(QGT_state_fixpt_add_cast_349, 85);
  QGT_state_fixpt_add_temp_129 <= QGT_state_fixpt_add_cast_348 + QGT_state_fixpt_add_cast_350;
  QGT_state_fixpt_cast_562 <= QGT_state_fixpt_add_temp_129(73 DOWNTO 58);
  QGT_state_fixpt_mul_temp_1116 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_cast_562;
  QGT_state_fixpt_cast_563 <= QGT_state_fixpt_mul_temp_1116(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1315 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_1117 <= QGT_state_fixpt_cast_563 * nc(to_integer(QGT_state_fixpt_sub_cast_1315 - 1));
  QGT_state_fixpt_sub_cast_1316 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_1118 <= QGT_state_fixpt_mul_temp_1117 * nc(to_integer(QGT_state_fixpt_sub_cast_1316 - 1));
  QGT_state_fixpt_add_cast_351 <= resize(QGT_state_fixpt_mul_temp_1118, 68);
  QGT_state_fixpt_add_temp_130 <= QGT_state_fixpt_add_cast_342 + QGT_state_fixpt_add_cast_351;
  QGT_state_fixpt_add_cast_352 <= resize(QGT_state_fixpt_add_temp_130, 71);
  QGT_state_fixpt_sub_cast_1317 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1119 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1317 - 1));
  QGT_state_fixpt_sub_cast_1318 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1120 <= QGT_state_fixpt_mul_temp_1119 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1318 - 1));
  QGT_state_fixpt_sub_cast_1319 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1121 <= QGT_state_fixpt_mul_temp_1120 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1319 - 1));
  QGT_state_fixpt_sub_cast_1320 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1122 <= QGT_state_fixpt_mul_temp_1121 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1320 - 1));
  QGT_state_fixpt_sub_cast_1321 <= resize(QGT_state_fixpt_mul_temp_1122 & '0', 82);
  QGT_state_fixpt_sub_cast_1322 <= resize(QGT_state_fixpt_sub_cast_1321, 83);
  QGT_state_fixpt_sub_cast_1323 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1123 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1323 - 1));
  QGT_state_fixpt_sub_cast_1324 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1124 <= QGT_state_fixpt_mul_temp_1123 * nc(to_integer(QGT_state_fixpt_sub_cast_1324 - 1));
  QGT_state_fixpt_sub_cast_1325 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1125 <= QGT_state_fixpt_mul_temp_1124 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1325 - 1));
  QGT_state_fixpt_sub_cast_1326 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1126 <= QGT_state_fixpt_mul_temp_1125 * nc(to_integer(QGT_state_fixpt_sub_cast_1326 - 1));
  QGT_state_fixpt_sub_cast_1327 <= resize(QGT_state_fixpt_mul_temp_1126 & '0', 82);
  QGT_state_fixpt_sub_cast_1328 <= resize(QGT_state_fixpt_sub_cast_1327, 83);
  QGT_state_fixpt_sub_temp_101 <= QGT_state_fixpt_sub_cast_1322 - QGT_state_fixpt_sub_cast_1328;
  QGT_state_fixpt_add_cast_353 <= resize(QGT_state_fixpt_sub_temp_101, 84);
  QGT_state_fixpt_sub_cast_1329 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1127 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_1329 - 1));
  QGT_state_fixpt_cast_564 <= QGT_state_fixpt_mul_temp_1127(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1330 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1128 <= QGT_state_fixpt_cast_564 * nc(to_integer(QGT_state_fixpt_sub_cast_1330 - 1));
  QGT_state_fixpt_sub_cast_1331 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1129 <= QGT_state_fixpt_mul_temp_1128 * nc(to_integer(QGT_state_fixpt_sub_cast_1331 - 1));
  QGT_state_fixpt_sub_cast_1332 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1130 <= QGT_state_fixpt_mul_temp_1129 * nc(to_integer(QGT_state_fixpt_sub_cast_1332 - 1));
  QGT_state_fixpt_add_cast_354 <= resize(QGT_state_fixpt_mul_temp_1130, 81);
  QGT_state_fixpt_add_cast_355 <= resize(QGT_state_fixpt_add_cast_354, 84);
  QGT_state_fixpt_add_temp_131 <= QGT_state_fixpt_add_cast_353 + QGT_state_fixpt_add_cast_355;
  QGT_state_fixpt_sub_cast_1333 <= resize(QGT_state_fixpt_add_temp_131, 85);
  QGT_state_fixpt_sub_cast_1334 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1131 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1334 - 1));
  QGT_state_fixpt_cast_565 <= QGT_state_fixpt_mul_temp_1131(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1335 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1132 <= QGT_state_fixpt_cast_565 * nc(to_integer(QGT_state_fixpt_sub_cast_1335 - 1));
  QGT_state_fixpt_cast_566 <= resize(QGT_state_fixpt_mul_temp_1132, 50);
  QGT_state_fixpt_cast_567 <=  - (QGT_state_fixpt_cast_566);
  QGT_state_fixpt_sub_cast_1336 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1133 <= QGT_state_fixpt_cast_567 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1336 - 1));
  QGT_state_fixpt_sub_cast_1337 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1134 <= QGT_state_fixpt_mul_temp_1133 * nc(to_integer(QGT_state_fixpt_sub_cast_1337 - 1));
  QGT_state_fixpt_sub_cast_1338 <= resize(QGT_state_fixpt_mul_temp_1134, 85);
  QGT_state_fixpt_sub_temp_102 <= QGT_state_fixpt_sub_cast_1333 - QGT_state_fixpt_sub_cast_1338;
  QGT_state_fixpt_cast_568 <= QGT_state_fixpt_sub_temp_102(73 DOWNTO 58);
  QGT_state_fixpt_sub_cast_1339 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_1135 <= QGT_state_fixpt_cast_568 * nc(to_integer(QGT_state_fixpt_sub_cast_1339 - 1));
  QGT_state_fixpt_sub_cast_1340 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_1136 <= QGT_state_fixpt_mul_temp_1135 * nc(to_integer(QGT_state_fixpt_sub_cast_1340 - 1));
  QGT_state_fixpt_sub_cast_1341 <= resize(QGT_state_fixpt_mul_temp_1136, 51);
  QGT_state_fixpt_sub_cast_1342 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1137 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_1342 - 1));
  QGT_state_fixpt_cast_569 <= QGT_state_fixpt_mul_temp_1137(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1343 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1138 <= QGT_state_fixpt_cast_569 * nc(to_integer(QGT_state_fixpt_sub_cast_1343 - 1));
  QGT_state_fixpt_cast_570 <= resize(QGT_state_fixpt_mul_temp_1138, 50);
  QGT_state_fixpt_cast_571 <=  - (QGT_state_fixpt_cast_570);
  QGT_state_fixpt_cast_572 <= resize(QGT_state_fixpt_cast_571, 51);
  QGT_state_fixpt_cast_573 <= resize(QGT_state_fixpt_cast_572, 52);
  QGT_state_fixpt_cast_574 <=  - (QGT_state_fixpt_cast_573);
  QGT_state_fixpt_cast_575 <= QGT_state_fixpt_cast_574(50 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1344 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1139 <= QGT_state_fixpt_cast_575 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1344 - 1));
  QGT_state_fixpt_sub_cast_1345 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1140 <= QGT_state_fixpt_mul_temp_1139 * nc(to_integer(QGT_state_fixpt_sub_cast_1345 - 1));
  QGT_state_fixpt_add_cast_356 <= resize(QGT_state_fixpt_mul_temp_1140, 84);
  QGT_state_fixpt_sub_cast_1346 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1141 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1346 - 1));
  QGT_state_fixpt_cast_576 <= QGT_state_fixpt_mul_temp_1141(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1347 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1142 <= QGT_state_fixpt_cast_576 * nc(to_integer(QGT_state_fixpt_sub_cast_1347 - 1));
  QGT_state_fixpt_cast_577 <= resize(QGT_state_fixpt_mul_temp_1142, 50);
  QGT_state_fixpt_cast_578 <=  - (QGT_state_fixpt_cast_577);
  QGT_state_fixpt_sub_cast_1348 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1143 <= QGT_state_fixpt_cast_578 * nc(to_integer(QGT_state_fixpt_sub_cast_1348 - 1));
  QGT_state_fixpt_sub_cast_1349 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1144 <= QGT_state_fixpt_mul_temp_1143 * nc(to_integer(QGT_state_fixpt_sub_cast_1349 - 1));
  QGT_state_fixpt_add_cast_357 <= resize(QGT_state_fixpt_mul_temp_1144, 84);
  QGT_state_fixpt_add_temp_132 <= QGT_state_fixpt_add_cast_356 + QGT_state_fixpt_add_cast_357;
  QGT_state_fixpt_add_cast_358 <= resize(QGT_state_fixpt_add_temp_132, 85);
  QGT_state_fixpt_sub_cast_1350 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1145 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1350 - 1));
  QGT_state_fixpt_cast_579 <= QGT_state_fixpt_mul_temp_1145(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1351 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1146 <= QGT_state_fixpt_cast_579 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1351 - 1));
  QGT_state_fixpt_sub_cast_1352 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1147 <= QGT_state_fixpt_mul_temp_1146 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1352 - 1));
  QGT_state_fixpt_sub_cast_1353 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1148 <= QGT_state_fixpt_mul_temp_1147 * nc(to_integer(QGT_state_fixpt_sub_cast_1353 - 1));
  QGT_state_fixpt_add_cast_359 <= resize(QGT_state_fixpt_mul_temp_1148, 81);
  QGT_state_fixpt_add_cast_360 <= resize(QGT_state_fixpt_add_cast_359, 85);
  QGT_state_fixpt_add_temp_133 <= QGT_state_fixpt_add_cast_358 + QGT_state_fixpt_add_cast_360;
  QGT_state_fixpt_sub_cast_1354 <= resize(QGT_state_fixpt_add_temp_133, 86);
  QGT_state_fixpt_sub_cast_1355 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1149 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1355 - 1));
  QGT_state_fixpt_sub_cast_1356 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1150 <= QGT_state_fixpt_mul_temp_1149 * nc(to_integer(QGT_state_fixpt_sub_cast_1356 - 1));
  QGT_state_fixpt_sub_cast_1357 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1151 <= QGT_state_fixpt_mul_temp_1150 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1357 - 1));
  QGT_state_fixpt_sub_cast_1358 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1152 <= QGT_state_fixpt_mul_temp_1151 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1358 - 1));
  QGT_state_fixpt_sub_cast_1359 <= resize(QGT_state_fixpt_mul_temp_1152 & '0', 82);
  QGT_state_fixpt_sub_cast_1360 <= resize(QGT_state_fixpt_sub_cast_1359, 86);
  QGT_state_fixpt_sub_temp_103 <= QGT_state_fixpt_sub_cast_1354 - QGT_state_fixpt_sub_cast_1360;
  QGT_state_fixpt_cast_580 <= QGT_state_fixpt_sub_temp_103(73 DOWNTO 58);
  QGT_state_fixpt_cast_581 <= resize(QGT_state_fixpt_cast_580, 18);
  QGT_state_fixpt_cast_582 <=  - (QGT_state_fixpt_cast_581);
  QGT_state_fixpt_sub_cast_1361 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_1153 <= QGT_state_fixpt_cast_582 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1361 - 1));
  QGT_state_fixpt_sub_cast_1362 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_1154 <= QGT_state_fixpt_mul_temp_1153 * nc(to_integer(QGT_state_fixpt_sub_cast_1362 - 1));
  QGT_state_fixpt_sub_cast_1363 <= resize(QGT_state_fixpt_mul_temp_1154, 51);
  QGT_state_fixpt_sub_temp_104 <= QGT_state_fixpt_sub_cast_1341 - QGT_state_fixpt_sub_cast_1363;
  QGT_state_fixpt_sub_cast_1364 <= resize(QGT_state_fixpt_sub_temp_104, 52);
  QGT_state_fixpt_sub_cast_1365 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1155 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_1365 - 1));
  QGT_state_fixpt_cast_583 <= QGT_state_fixpt_mul_temp_1155(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1366 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1156 <= QGT_state_fixpt_cast_583 * nc(to_integer(QGT_state_fixpt_sub_cast_1366 - 1));
  QGT_state_fixpt_cast_584 <= resize(QGT_state_fixpt_mul_temp_1156, 50);
  QGT_state_fixpt_cast_585 <=  - (QGT_state_fixpt_cast_584);
  QGT_state_fixpt_cast_586 <= resize(QGT_state_fixpt_cast_585, 51);
  QGT_state_fixpt_cast_587 <= resize(QGT_state_fixpt_cast_586, 52);
  QGT_state_fixpt_cast_588 <=  - (QGT_state_fixpt_cast_587);
  QGT_state_fixpt_cast_589 <= QGT_state_fixpt_cast_588(50 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1367 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1157 <= QGT_state_fixpt_cast_589 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1367 - 1));
  QGT_state_fixpt_sub_cast_1368 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1158 <= QGT_state_fixpt_mul_temp_1157 * nc(to_integer(QGT_state_fixpt_sub_cast_1368 - 1));
  QGT_state_fixpt_sub_cast_1369 <= resize(QGT_state_fixpt_mul_temp_1158, 84);
  QGT_state_fixpt_sub_cast_1370 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1159 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1370 - 1));
  QGT_state_fixpt_cast_590 <= QGT_state_fixpt_mul_temp_1159(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1371 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1160 <= QGT_state_fixpt_cast_590 * nc(to_integer(QGT_state_fixpt_sub_cast_1371 - 1));
  QGT_state_fixpt_cast_591 <= resize(QGT_state_fixpt_mul_temp_1160, 50);
  QGT_state_fixpt_cast_592 <=  - (QGT_state_fixpt_cast_591);
  QGT_state_fixpt_sub_cast_1372 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1161 <= QGT_state_fixpt_cast_592 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1372 - 1));
  QGT_state_fixpt_sub_cast_1373 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1162 <= QGT_state_fixpt_mul_temp_1161 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1373 - 1));
  QGT_state_fixpt_sub_cast_1374 <= resize(QGT_state_fixpt_mul_temp_1162, 84);
  QGT_state_fixpt_sub_temp_105 <= QGT_state_fixpt_sub_cast_1369 - QGT_state_fixpt_sub_cast_1374;
  QGT_state_fixpt_add_cast_361 <= resize(QGT_state_fixpt_sub_temp_105, 85);
  QGT_state_fixpt_sub_cast_1375 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1163 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1375 - 1));
  QGT_state_fixpt_cast_593 <= QGT_state_fixpt_mul_temp_1163(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1376 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1164 <= QGT_state_fixpt_cast_593 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1376 - 1));
  QGT_state_fixpt_sub_cast_1377 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1165 <= QGT_state_fixpt_mul_temp_1164 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1377 - 1));
  QGT_state_fixpt_sub_cast_1378 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1166 <= QGT_state_fixpt_mul_temp_1165 * nc(to_integer(QGT_state_fixpt_sub_cast_1378 - 1));
  QGT_state_fixpt_add_cast_362 <= resize(QGT_state_fixpt_mul_temp_1166, 81);
  QGT_state_fixpt_add_cast_363 <= resize(QGT_state_fixpt_add_cast_362, 85);
  QGT_state_fixpt_add_temp_134 <= QGT_state_fixpt_add_cast_361 + QGT_state_fixpt_add_cast_363;
  QGT_state_fixpt_add_cast_364 <= resize(QGT_state_fixpt_add_temp_134, 86);
  QGT_state_fixpt_sub_cast_1379 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1167 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1379 - 1));
  QGT_state_fixpt_sub_cast_1380 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1168 <= QGT_state_fixpt_mul_temp_1167 * nc(to_integer(QGT_state_fixpt_sub_cast_1380 - 1));
  QGT_state_fixpt_sub_cast_1381 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1169 <= QGT_state_fixpt_mul_temp_1168 * nc(to_integer(QGT_state_fixpt_sub_cast_1381 - 1));
  QGT_state_fixpt_sub_cast_1382 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1170 <= QGT_state_fixpt_mul_temp_1169 * nc(to_integer(QGT_state_fixpt_sub_cast_1382 - 1));
  QGT_state_fixpt_add_cast_365 <= resize(QGT_state_fixpt_mul_temp_1170 & '0', 82);
  QGT_state_fixpt_add_cast_366 <= resize(QGT_state_fixpt_add_cast_365, 86);
  QGT_state_fixpt_add_temp_135 <= QGT_state_fixpt_add_cast_364 + QGT_state_fixpt_add_cast_366;
  QGT_state_fixpt_cast_594 <= QGT_state_fixpt_add_temp_135(73 DOWNTO 58);
  QGT_state_fixpt_cast_595 <= resize(QGT_state_fixpt_cast_594, 18);
  QGT_state_fixpt_cast_596 <=  - (QGT_state_fixpt_cast_595);
  QGT_state_fixpt_sub_cast_1383 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_1171 <= QGT_state_fixpt_cast_596 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1383 - 1));
  QGT_state_fixpt_sub_cast_1384 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_1172 <= QGT_state_fixpt_mul_temp_1171 * nc(to_integer(QGT_state_fixpt_sub_cast_1384 - 1));
  QGT_state_fixpt_sub_cast_1385 <= resize(QGT_state_fixpt_mul_temp_1172, 52);
  QGT_state_fixpt_sub_temp_106 <= QGT_state_fixpt_sub_cast_1364 - QGT_state_fixpt_sub_cast_1385;
  QGT_state_fixpt_sub_cast_1386 <= resize(QGT_state_fixpt_sub_temp_106, 53);
  QGT_state_fixpt_sub_cast_1387 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1173 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1387 - 1));
  QGT_state_fixpt_sub_cast_1388 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1174 <= QGT_state_fixpt_mul_temp_1173 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1388 - 1));
  QGT_state_fixpt_sub_cast_1389 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1175 <= QGT_state_fixpt_mul_temp_1174 * nc(to_integer(QGT_state_fixpt_sub_cast_1389 - 1));
  QGT_state_fixpt_sub_cast_1390 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1176 <= QGT_state_fixpt_mul_temp_1175 * nc(to_integer(QGT_state_fixpt_sub_cast_1390 - 1));
  QGT_state_fixpt_add_cast_367 <= resize(QGT_state_fixpt_mul_temp_1176 & '0', 82);
  QGT_state_fixpt_add_cast_368 <= resize(QGT_state_fixpt_add_cast_367, 83);
  QGT_state_fixpt_sub_cast_1391 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1177 <= to_signed(-16#5A83#, 16) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1391 - 1));
  QGT_state_fixpt_sub_cast_1392 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1178 <= QGT_state_fixpt_mul_temp_1177 * nc(to_integer(QGT_state_fixpt_sub_cast_1392 - 1));
  QGT_state_fixpt_sub_cast_1393 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1179 <= QGT_state_fixpt_mul_temp_1178 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1393 - 1));
  QGT_state_fixpt_sub_cast_1394 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1180 <= QGT_state_fixpt_mul_temp_1179 * nc(to_integer(QGT_state_fixpt_sub_cast_1394 - 1));
  QGT_state_fixpt_add_cast_369 <= resize(QGT_state_fixpt_mul_temp_1180 & '0', 82);
  QGT_state_fixpt_add_cast_370 <= resize(QGT_state_fixpt_add_cast_369, 83);
  QGT_state_fixpt_add_temp_136 <= QGT_state_fixpt_add_cast_368 + QGT_state_fixpt_add_cast_370;
  QGT_state_fixpt_add_cast_371 <= resize(QGT_state_fixpt_add_temp_136, 84);
  QGT_state_fixpt_sub_cast_1395 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1181 <= to_signed(16#0B504#, 17) * nc(to_integer(QGT_state_fixpt_sub_cast_1395 - 1));
  QGT_state_fixpt_cast_597 <= QGT_state_fixpt_mul_temp_1181(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1396 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1182 <= QGT_state_fixpt_cast_597 * nc(to_integer(QGT_state_fixpt_sub_cast_1396 - 1));
  QGT_state_fixpt_sub_cast_1397 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1183 <= QGT_state_fixpt_mul_temp_1182 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1397 - 1));
  QGT_state_fixpt_sub_cast_1398 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1184 <= QGT_state_fixpt_mul_temp_1183 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1398 - 1));
  QGT_state_fixpt_add_cast_372 <= resize(QGT_state_fixpt_mul_temp_1184, 81);
  QGT_state_fixpt_add_cast_373 <= resize(QGT_state_fixpt_add_cast_372, 84);
  QGT_state_fixpt_add_temp_137 <= QGT_state_fixpt_add_cast_371 + QGT_state_fixpt_add_cast_373;
  QGT_state_fixpt_add_cast_374 <= resize(QGT_state_fixpt_add_temp_137, 85);
  QGT_state_fixpt_sub_cast_1399 <= signed(resize(QGT_state_fixpt_auxBx3, 32));
  QGT_state_fixpt_mul_temp_1185 <= to_signed(16#0B504#, 17) * nc_0(to_integer(QGT_state_fixpt_sub_cast_1399 - 1));
  QGT_state_fixpt_cast_598 <= QGT_state_fixpt_mul_temp_1185(31 DOWNTO 0);
  QGT_state_fixpt_sub_cast_1400 <= signed(resize(QGT_state_fixpt_auxAx3, 32));
  QGT_state_fixpt_mul_temp_1186 <= QGT_state_fixpt_cast_598 * nc(to_integer(QGT_state_fixpt_sub_cast_1400 - 1));
  QGT_state_fixpt_cast_599 <= resize(QGT_state_fixpt_mul_temp_1186, 50);
  QGT_state_fixpt_cast_600 <=  - (QGT_state_fixpt_cast_599);
  QGT_state_fixpt_sub_cast_1401 <= signed(resize(QGT_state_fixpt_auxBy2, 32));
  QGT_state_fixpt_mul_temp_1187 <= QGT_state_fixpt_cast_600 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1401 - 1));
  QGT_state_fixpt_sub_cast_1402 <= signed(resize(QGT_state_fixpt_auxAy2, 32));
  QGT_state_fixpt_mul_temp_1188 <= QGT_state_fixpt_mul_temp_1187 * nc(to_integer(QGT_state_fixpt_sub_cast_1402 - 1));
  QGT_state_fixpt_add_cast_375 <= resize(QGT_state_fixpt_mul_temp_1188, 85);
  QGT_state_fixpt_add_temp_138 <= QGT_state_fixpt_add_cast_374 + QGT_state_fixpt_add_cast_375;
  QGT_state_fixpt_cast_601 <= QGT_state_fixpt_add_temp_138(73 DOWNTO 58);
  QGT_state_fixpt_sub_cast_1403 <= signed(resize(QGT_state_fixpt_auxAx1, 32));
  QGT_state_fixpt_mul_temp_1189 <= QGT_state_fixpt_cast_601 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1403 - 1));
  QGT_state_fixpt_sub_cast_1404 <= signed(resize(QGT_state_fixpt_auxBx1, 32));
  QGT_state_fixpt_mul_temp_1190 <= QGT_state_fixpt_mul_temp_1189 * nc_0(to_integer(QGT_state_fixpt_sub_cast_1404 - 1));
  QGT_state_fixpt_sub_cast_1405 <= resize(QGT_state_fixpt_mul_temp_1190, 53);
  QGT_state_fixpt_sub_temp_107 <= QGT_state_fixpt_sub_cast_1386 - QGT_state_fixpt_sub_cast_1405;
  QGT_state_fixpt_mul_temp_1191 <= to_signed(16#0B504#, 17) * QGT_state_fixpt_sub_temp_107;
  QGT_state_fixpt_add_cast_376 <= QGT_state_fixpt_mul_temp_1191(68 DOWNTO 0);
  QGT_state_fixpt_add_cast_377 <= resize(QGT_state_fixpt_add_cast_376, 71);
  QGT_state_fixpt_add_temp_139 <= QGT_state_fixpt_add_cast_352 + QGT_state_fixpt_add_cast_377;
  QGT_state_fixpt_c_im_3 <= QGT_state_fixpt_add_temp_139(59 DOWNTO 44);
  QGT_state_fixpt_mul_temp_1192 <= QGT_state_fixpt_c_re * QGT_state_fixpt_c_re;
  QGT_state_fixpt_add_cast_378 <= resize(QGT_state_fixpt_mul_temp_1192, 33);
  QGT_state_fixpt_mul_temp_1193 <= QGT_state_fixpt_c_im * QGT_state_fixpt_c_im;
  QGT_state_fixpt_add_cast_379 <= resize(QGT_state_fixpt_mul_temp_1193, 33);
  QGT_state_fixpt_add_temp_140 <= QGT_state_fixpt_add_cast_378 + QGT_state_fixpt_add_cast_379;
  p00_tmp <= unsigned(QGT_state_fixpt_add_temp_140(28 DOWNTO 13));
  QGT_state_fixpt_mul_temp_1194 <= QGT_state_fixpt_c_re_1 * QGT_state_fixpt_c_re_1;
  QGT_state_fixpt_add_cast_380 <= resize(QGT_state_fixpt_mul_temp_1194, 33);
  QGT_state_fixpt_mul_temp_1195 <= QGT_state_fixpt_c_im_1 * QGT_state_fixpt_c_im_1;
  QGT_state_fixpt_add_cast_381 <= resize(QGT_state_fixpt_mul_temp_1195, 33);
  QGT_state_fixpt_add_temp_141 <= QGT_state_fixpt_add_cast_380 + QGT_state_fixpt_add_cast_381;
  p01_tmp <= unsigned(QGT_state_fixpt_add_temp_141(28 DOWNTO 13));
  QGT_state_fixpt_mul_temp_1196 <= QGT_state_fixpt_c_re_2 * QGT_state_fixpt_c_re_2;
  QGT_state_fixpt_add_cast_382 <= resize(QGT_state_fixpt_mul_temp_1196, 33);
  QGT_state_fixpt_mul_temp_1197 <= QGT_state_fixpt_c_im_2 * QGT_state_fixpt_c_im_2;
  QGT_state_fixpt_add_cast_383 <= resize(QGT_state_fixpt_mul_temp_1197, 33);
  QGT_state_fixpt_add_temp_142 <= QGT_state_fixpt_add_cast_382 + QGT_state_fixpt_add_cast_383;
  p10_tmp <= unsigned(QGT_state_fixpt_add_temp_142(28 DOWNTO 13));
  QGT_state_fixpt_mul_temp_1198 <= QGT_state_fixpt_c_re_3 * QGT_state_fixpt_c_re_3;
  QGT_state_fixpt_add_cast_384 <= resize(QGT_state_fixpt_mul_temp_1198, 33);
  QGT_state_fixpt_mul_temp_1199 <= QGT_state_fixpt_c_im_3 * QGT_state_fixpt_c_im_3;
  QGT_state_fixpt_add_cast_385 <= resize(QGT_state_fixpt_mul_temp_1199, 33);
  QGT_state_fixpt_add_temp_143 <= QGT_state_fixpt_add_cast_384 + QGT_state_fixpt_add_cast_385;
  p11_tmp <= unsigned(QGT_state_fixpt_add_temp_143(28 DOWNTO 13));

  p00 <= std_logic_vector(p00_tmp);
  p01 <= std_logic_vector(p01_tmp);
  p10 <= std_logic_vector(p10_tmp);
  p11 <= std_logic_vector(p11_tmp);

END rtl;