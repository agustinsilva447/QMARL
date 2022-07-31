LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.fixed_pkg.all;

ENTITY QGT_state_fixpt IS
  PORT( rotAx1                            :   IN    std_logic_vector(3 DOWNTO 0); 
        rotAy2                            :   IN    std_logic_vector(3 DOWNTO 0); 
        rotAx3                            :   IN    std_logic_vector(3 DOWNTO 0); 
        rotBx1                            :   IN    std_logic_vector(3 DOWNTO 0); 
        rotBy2                            :   IN    std_logic_vector(3 DOWNTO 0); 
        rotBx3                            :   IN    std_logic_vector(3 DOWNTO 0); 
        p00                               :   OUT   std_logic_vector(15 DOWNTO 0);
        p01                               :   OUT   std_logic_vector(15 DOWNTO 0);
        p10                               :   OUT   std_logic_vector(15 DOWNTO 0);
        p11                               :   OUT   std_logic_vector(15 DOWNTO 0) 
        );
END QGT_state_fixpt;


ARCHITECTURE rtl OF QGT_state_fixpt IS

    TYPE vector_of_signed16 IS ARRAY (NATURAL RANGE <>) OF sfixed(0 DOWNTO -15);    
    CONSTANT cos_rot : vector_of_signed16(0 TO 15) := 
    (to_sfixed( 1 ,0,-15), to_sfixed( 0.92388  ,0,-15), to_sfixed( 0.707107 ,0,-15), to_sfixed( 0.382683 ,0,-15),
     to_sfixed( 0 ,0,-15), to_sfixed(-0.382683 ,0,-15), to_sfixed(-0.707107 ,0,-15), to_sfixed(-0.92388  ,0,-15),
     to_sfixed(-1 ,0,-15), to_sfixed(-0.92388  ,0,-15), to_sfixed(-0.707107 ,0,-15), to_sfixed(-0.382683 ,0,-15),
     to_sfixed( 0 ,0,-15), to_sfixed( 0.382683 ,0,-15), to_sfixed( 0.707107 ,0,-15), to_sfixed( 0.92388  ,0,-15));
    CONSTANT sin_rot : vector_of_signed16(0 TO 15) := 
    (to_sfixed( 0 ,0,-15), to_sfixed( 0.382683 ,0,-15), to_sfixed( 0.707107 ,0,-15), to_sfixed( 0.92388  ,0,-15),
     to_sfixed( 1 ,0,-15), to_sfixed( 0.92388  ,0,-15), to_sfixed( 0.707107 ,0,-15), to_sfixed( 0.382683 ,0,-15),
     to_sfixed( 0 ,0,-15), to_sfixed(-0.382683 ,0,-15), to_sfixed(-0.707107 ,0,-15), to_sfixed(-0.92388  ,0,-15),
     to_sfixed(-1 ,0,-15), to_sfixed(-0.92388  ,0,-15), to_sfixed(-0.707107 ,0,-15), to_sfixed(-0.382683 ,0,-15));     
    CONSTANT factor_p : sfixed(0 DOWNTO -15) := to_sfixed(0.015625 ,0,-15); 
    
    SIGNAL rotAx1_signed                    : unsigned(3 DOWNTO 0);
    SIGNAL rotAy2_signed                    : unsigned(3 DOWNTO 0);
    SIGNAL rotAx3_signed                    : unsigned(3 DOWNTO 0);
    SIGNAL rotBx1_signed                    : unsigned(3 DOWNTO 0);
    SIGNAL rotBy2_signed                    : unsigned(3 DOWNTO 0);
    SIGNAL rotBx3_signed                    : unsigned(3 DOWNTO 0);
    
    SIGNAL aux01                            : unsigned(3 DOWNTO 0);
    SIGNAL aux02                            : unsigned(3 DOWNTO 0);
    SIGNAL aux03                            : unsigned(3 DOWNTO 0);
    SIGNAL aux04                            : unsigned(3 DOWNTO 0);
    SIGNAL aux05                            : unsigned(3 DOWNTO 0);
    SIGNAL aux06                            : unsigned(3 DOWNTO 0);
    SIGNAL aux07                            : unsigned(3 DOWNTO 0);
    SIGNAL aux08                            : unsigned(3 DOWNTO 0);    
    SIGNAL aux09                            : unsigned(3 DOWNTO 0);
    SIGNAL aux10                            : unsigned(3 DOWNTO 0);
    SIGNAL aux11                            : unsigned(3 DOWNTO 0);
    SIGNAL aux12                            : unsigned(3 DOWNTO 0);
    SIGNAL aux13                            : unsigned(3 DOWNTO 0);
    SIGNAL aux14                            : unsigned(3 DOWNTO 0);
    SIGNAL aux15                            : unsigned(3 DOWNTO 0);
    SIGNAL aux16                            : unsigned(3 DOWNTO 0);
    SIGNAL aux17                            : unsigned(3 DOWNTO 0);
    SIGNAL aux18                            : unsigned(3 DOWNTO 0);    
    SIGNAL aux19                            : unsigned(3 DOWNTO 0);
    SIGNAL aux20                            : unsigned(3 DOWNTO 0);
    SIGNAL aux21                            : unsigned(3 DOWNTO 0);
    SIGNAL aux22                            : unsigned(3 DOWNTO 0);
    SIGNAL aux23                            : unsigned(3 DOWNTO 0);
    SIGNAL aux24                            : unsigned(3 DOWNTO 0);
    SIGNAL aux25                            : unsigned(3 DOWNTO 0);
    SIGNAL aux26                            : unsigned(3 DOWNTO 0);
    SIGNAL aux27                            : unsigned(3 DOWNTO 0);
    SIGNAL aux28                            : unsigned(3 DOWNTO 0);    
    SIGNAL aux29                            : unsigned(3 DOWNTO 0);
    SIGNAL aux30                            : unsigned(3 DOWNTO 0);
    SIGNAL aux31                            : unsigned(3 DOWNTO 0);
    SIGNAL aux32                            : unsigned(3 DOWNTO 0);
    
    SIGNAL aux1                             : unsigned(3 DOWNTO 0);
    SIGNAL aux2                             : unsigned(3 DOWNTO 0);
    SIGNAL aux3                             : unsigned(3 DOWNTO 0);
    SIGNAL aux4                             : unsigned(3 DOWNTO 0);
    SIGNAL aux5                             : unsigned(3 DOWNTO 0);
    SIGNAL aux6                             : unsigned(3 DOWNTO 0);
    SIGNAL aux7                             : unsigned(3 DOWNTO 0);
        
    SIGNAL p00_tmp1                         : sfixed(7 DOWNTO -15);
    SIGNAL p00_tmp2                         : sfixed(7 DOWNTO -15);
    SIGNAL p00_tmp3                         : sfixed(7 DOWNTO -15);
    SIGNAL p00_tmp4                         : sfixed(7 DOWNTO -15);
    SIGNAL p00_tmp0                         : sfixed(10 DOWNTO -15);
    SIGNAL p00_tmp                          : sfixed(8 DOWNTO -45);
    
    SIGNAL p01_tmp1                         : sfixed(7 DOWNTO -15);
    SIGNAL p01_tmp2                         : sfixed(7 DOWNTO -15);
    SIGNAL p01_tmp3                         : sfixed(7 DOWNTO -15);
    SIGNAL p01_tmp4                         : sfixed(7 DOWNTO -15);
    SIGNAL p01_tmp0                         : sfixed(10 DOWNTO -15);
    SIGNAL p01_tmp                          : sfixed(8 DOWNTO -45);
    
    SIGNAL p10_tmp1                         : sfixed(7 DOWNTO -15);
    SIGNAL p10_tmp2                         : sfixed(7 DOWNTO -15);
    SIGNAL p10_tmp3                         : sfixed(7 DOWNTO -15);
    SIGNAL p10_tmp4                         : sfixed(7 DOWNTO -15);
    SIGNAL p10_tmp0                         : sfixed(10 DOWNTO -15);
    SIGNAL p10_tmp                          : sfixed(8 DOWNTO -45);
    
    SIGNAL p11_tmp1                         : sfixed(3 DOWNTO -60);
    SIGNAL p11_tmp2                         : sfixed(4 DOWNTO -75);
    SIGNAL p11_tmp3                         : sfixed(4 DOWNTO -75);
    SIGNAL p11_tmp4                         : sfixed(4 DOWNTO -75);
    SIGNAL p11_tmp5                         : sfixed(4 DOWNTO -75);
    SIGNAL p11_tmp6                         : sfixed(3 DOWNTO -60);        
    SIGNAL p11_tmp0                         : sfixed(9 DOWNTO -75);
    SIGNAL p11_tmp                          : sfixed(1 DOWNTO -40);

BEGIN
    
    rotAx1_signed <= unsigned(rotAx1);
    rotAy2_signed <= unsigned(rotAy2);
    rotAx3_signed <= unsigned(rotAx3);
    rotBx1_signed <= unsigned(rotBx1);
    rotBy2_signed <= unsigned(rotBy2);
    rotBx3_signed <= unsigned(rotBx3);
    
    aux01 <= (rotBy2_signed - rotAx1_signed - rotAx3_signed + rotAy2_signed + rotBx1_signed + rotBx3_signed);
    aux02 <= (rotBy2_signed - rotAx1_signed + rotAx3_signed - rotAy2_signed + rotBx1_signed + rotBx3_signed);
    aux03 <= (rotBy2_signed - rotAx1_signed + rotAx3_signed + rotAy2_signed - rotBx1_signed + rotBx3_signed);
    aux04 <= (rotBy2_signed - rotAx1_signed + rotAx3_signed + rotAy2_signed + rotBx1_signed - rotBx3_signed);
    aux05 <= (rotBx3_signed - rotAx1_signed + rotAx3_signed + rotAy2_signed + rotBx1_signed - rotBy2_signed);
    aux06 <= (rotBx3_signed - rotAx1_signed + rotAx3_signed + rotAy2_signed + rotBx1_signed + rotBy2_signed);    
    aux07 <= (rotAx1_signed - rotAx3_signed - rotAy2_signed - rotBx1_signed + rotBx3_signed + rotBy2_signed);
    aux08 <= (rotAx1_signed - rotAx3_signed - rotAy2_signed + rotBx1_signed - rotBx3_signed + rotBy2_signed);
    aux09 <= (rotAx1_signed - rotAx3_signed - rotAy2_signed + rotBx1_signed + rotBx3_signed - rotBy2_signed);
    aux10 <= (rotAx1_signed - rotAx3_signed - rotAy2_signed + rotBx1_signed + rotBx3_signed + rotBy2_signed);
    aux11 <= (rotAx1_signed - rotAx3_signed + rotAy2_signed - rotBx1_signed - rotBx3_signed + rotBy2_signed);
    aux12 <= (rotAx1_signed - rotAx3_signed + rotAy2_signed - rotBx1_signed + rotBx3_signed - rotBy2_signed);    
    aux13 <= (rotAx1_signed - rotAx3_signed + rotAy2_signed - rotBx1_signed + rotBx3_signed + rotBy2_signed);
    aux14 <= (rotAx1_signed - rotAx3_signed + rotAy2_signed + rotBx1_signed - rotBx3_signed - rotBy2_signed);
    aux15 <= (rotAx1_signed - rotAx3_signed + rotAy2_signed + rotBx1_signed - rotBx3_signed + rotBy2_signed);
    aux16 <= (rotAx1_signed - rotAx3_signed + rotAy2_signed + rotBx1_signed + rotBx3_signed - rotBy2_signed);
    aux17 <= (rotAx1_signed - rotAx3_signed + rotAy2_signed + rotBx1_signed + rotBx3_signed + rotBy2_signed);
    aux18 <= (rotAx1_signed + rotAx3_signed - rotAy2_signed - rotBx1_signed - rotBx3_signed + rotBy2_signed);    
    aux19 <= (rotAx1_signed + rotAx3_signed - rotAy2_signed - rotBx1_signed + rotBx3_signed - rotBy2_signed);
    aux20 <= (rotAx1_signed + rotAx3_signed - rotAy2_signed - rotBx1_signed + rotBx3_signed + rotBy2_signed);
    aux21 <= (rotAx1_signed + rotAx3_signed - rotAy2_signed + rotBx1_signed - rotBx3_signed - rotBy2_signed);
    aux22 <= (rotAx1_signed + rotAx3_signed - rotAy2_signed + rotBx1_signed - rotBx3_signed + rotBy2_signed);
    aux23 <= (rotAx1_signed + rotAx3_signed - rotAy2_signed + rotBx1_signed + rotBx3_signed - rotBy2_signed);
    aux24 <= (rotAx1_signed + rotAx3_signed - rotAy2_signed + rotBx1_signed + rotBx3_signed + rotBy2_signed);    
    aux25 <= (rotAx1_signed + rotAx3_signed + rotAy2_signed - rotBx1_signed - rotBx3_signed - rotBy2_signed);
    aux26 <= (rotAx1_signed + rotAx3_signed + rotAy2_signed - rotBx1_signed - rotBx3_signed + rotBy2_signed);
    aux27 <= (rotAx1_signed + rotAx3_signed + rotAy2_signed - rotBx1_signed + rotBx3_signed - rotBy2_signed);
    aux28 <= (rotAx1_signed + rotAx3_signed + rotAy2_signed - rotBx1_signed + rotBx3_signed + rotBy2_signed);
    aux29 <= (rotAx1_signed + rotAx3_signed + rotAy2_signed + rotBx1_signed - rotBx3_signed - rotBy2_signed);
    aux30 <= (rotAx1_signed + rotAx3_signed + rotAy2_signed + rotBx1_signed - rotBx3_signed + rotBy2_signed);
    aux31 <= (rotAx1_signed + rotAx3_signed + rotAy2_signed + rotBx1_signed + rotBx3_signed - rotBy2_signed);
    aux32 <= (rotAx1_signed + rotAx3_signed + rotAy2_signed + rotBx1_signed + rotBx3_signed + rotBy2_signed);
    
    aux1 <= (rotAy2_signed - rotBx1_signed + rotBx3_signed);
    aux2 <= (rotAy2_signed - rotBx1_signed);
    aux3 <= (rotAy2_signed + rotBx1_signed);
    aux4 <= (rotAx1_signed + rotBy2_signed);
    aux5 <= (rotAx1_signed - rotBy2_signed);
    aux6 <= (rotAx3_signed + rotBy2_signed);
    aux7 <= (rotAy2_signed + rotBx1_signed);
    
    p00_tmp1 <= cos_rot(to_integer(aux01)) - cos_rot(to_integer(aux02)) - cos_rot(to_integer(aux03)) + cos_rot(to_integer(aux04)) + cos_rot(to_integer(aux05)) + cos_rot(to_integer(aux06)) - cos_rot(to_integer(aux07)) + cos_rot(to_integer(aux08));    
    p00_tmp2 <= cos_rot(to_integer(aux16)) - cos_rot(to_integer(aux09)) - cos_rot(to_integer(aux10)) - cos_rot(to_integer(aux11)) - cos_rot(to_integer(aux12)) + cos_rot(to_integer(aux13)) + cos_rot(to_integer(aux14)) - cos_rot(to_integer(aux15));    
    p00_tmp3 <= cos_rot(to_integer(aux17)) + cos_rot(to_integer(aux18)) - cos_rot(to_integer(aux19)) + cos_rot(to_integer(aux20)) - cos_rot(to_integer(aux21)) + cos_rot(to_integer(aux22)) + cos_rot(to_integer(aux23)) + cos_rot(to_integer(aux24));
    p00_tmp4 <= cos_rot(to_integer(aux25)) + cos_rot(to_integer(aux26)) - cos_rot(to_integer(aux27)) + cos_rot(to_integer(aux28)) - cos_rot(to_integer(aux29)) + cos_rot(to_integer(aux30)) + cos_rot(to_integer(aux31)) + cos_rot(to_integer(aux32));
    p00_tmp0 <= p00_tmp1 + p00_tmp2 + p00_tmp3 + p00_tmp4;
    p00_tmp  <= factor_p * p00_tmp0(3 downto -15) * p00_tmp0(3 downto -15); 
    
    p01_tmp1 <= sin_rot(to_integer(aux08)) - sin_rot(to_integer(aux01)) + sin_rot(to_integer(aux02)) + sin_rot(to_integer(aux03)) + sin_rot(to_integer(aux04)) - sin_rot(to_integer(aux05)) - sin_rot(to_integer(aux06)) + sin_rot(to_integer(aux07));    
    p01_tmp2 <= sin_rot(to_integer(aux09)) + sin_rot(to_integer(aux10)) - sin_rot(to_integer(aux11)) + sin_rot(to_integer(aux12)) - sin_rot(to_integer(aux13)) + sin_rot(to_integer(aux14)) - sin_rot(to_integer(aux15)) - sin_rot(to_integer(aux16));    
    p01_tmp3 <= sin_rot(to_integer(aux22)) - sin_rot(to_integer(aux17)) + sin_rot(to_integer(aux18)) + sin_rot(to_integer(aux19)) - sin_rot(to_integer(aux20)) - sin_rot(to_integer(aux21)) - sin_rot(to_integer(aux23)) - sin_rot(to_integer(aux24));
    p01_tmp4 <= sin_rot(to_integer(aux25)) + sin_rot(to_integer(aux26)) + sin_rot(to_integer(aux27)) - sin_rot(to_integer(aux28)) - sin_rot(to_integer(aux29)) + sin_rot(to_integer(aux30)) - sin_rot(to_integer(aux31)) - sin_rot(to_integer(aux32));
    p01_tmp0 <= p01_tmp1 + p01_tmp2 + p01_tmp3 + p01_tmp4;
    p01_tmp  <= factor_p * p01_tmp0(3 downto -15) * p01_tmp0(3 downto -15); 
    
    p10_tmp1 <= sin_rot(to_integer(aux01)) + sin_rot(to_integer(aux02)) + sin_rot(to_integer(aux03)) - sin_rot(to_integer(aux04)) - sin_rot(to_integer(aux05)) - sin_rot(to_integer(aux06)) - sin_rot(to_integer(aux07)) + sin_rot(to_integer(aux08));
    p10_tmp2 <= sin_rot(to_integer(aux16)) - sin_rot(to_integer(aux09)) - sin_rot(to_integer(aux10)) - sin_rot(to_integer(aux11)) - sin_rot(to_integer(aux12)) + sin_rot(to_integer(aux13)) + sin_rot(to_integer(aux14)) - sin_rot(to_integer(aux15));
    p10_tmp3 <= sin_rot(to_integer(aux17)) - sin_rot(to_integer(aux18)) + sin_rot(to_integer(aux19)) - sin_rot(to_integer(aux20)) + sin_rot(to_integer(aux21)) - sin_rot(to_integer(aux22)) - sin_rot(to_integer(aux23)) - sin_rot(to_integer(aux24));
    p10_tmp4 <= sin_rot(to_integer(aux29)) - sin_rot(to_integer(aux25)) - sin_rot(to_integer(aux26)) + sin_rot(to_integer(aux27)) - sin_rot(to_integer(aux28)) - sin_rot(to_integer(aux30)) - sin_rot(to_integer(aux31)) - sin_rot(to_integer(aux32));
    p10_tmp0 <= p10_tmp1 + p10_tmp2 + p10_tmp3 + p10_tmp4;
    p10_tmp  <= factor_p * p10_tmp0(3 downto -15) * p10_tmp0(3 downto -15); 
   
    p11_tmp1 <= sin_rot(to_integer(rotAx1_signed)) * sin_rot(to_integer(rotAx3_signed)) * sin_rot(to_integer(rotBy2_signed)) * sin_rot(to_integer(aux1));
    p11_tmp2 <= sin_rot(to_integer(rotAx1_signed)) * sin_rot(to_integer(rotBx3_signed)) * cos_rot(to_integer(rotAx3_signed)) * cos_rot(to_integer(rotBy2_signed)) * cos_rot(to_integer(aux2));
    p11_tmp3 <= sin_rot(to_integer(rotAx3_signed)) * cos_rot(to_integer(rotAx1_signed)) * cos_rot(to_integer(rotBx3_signed)) * cos_rot(to_integer(rotBy2_signed)) * sin_rot(to_integer(aux3));
    p11_tmp4 <= sin_rot(to_integer(rotAy2_signed)) * cos_rot(to_integer(rotAx3_signed)) * cos_rot(to_integer(rotBx1_signed)) * cos_rot(to_integer(rotBx3_signed)) * sin_rot(to_integer(aux4));
    p11_tmp5 <= sin_rot(to_integer(rotBx1_signed)) * cos_rot(to_integer(rotAx3_signed)) * cos_rot(to_integer(rotAy2_signed)) * cos_rot(to_integer(rotBx3_signed)) * sin_rot(to_integer(aux5));
    p11_tmp6 <= sin_rot(to_integer(rotBx3_signed)) * cos_rot(to_integer(rotAx1_signed)) * sin_rot(to_integer(aux6)) * cos_rot(to_integer(aux7));
    p11_tmp0 <= p11_tmp1 - p11_tmp2 - p11_tmp3 + p11_tmp4 - p11_tmp5 - p11_tmp6;
    p11_tmp  <= p11_tmp0(0 downto -20) * p11_tmp0(0 downto -20); 
    
    p00 <= std_logic_vector(p00_tmp(0 downto -15));
    p01 <= std_logic_vector(p01_tmp(0 downto -15));
    p10 <= std_logic_vector(p10_tmp(0 downto -15));
    p11 <= std_logic_vector(p11_tmp(0 downto -15));
  
END rtl;